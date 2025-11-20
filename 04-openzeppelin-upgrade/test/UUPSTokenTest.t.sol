// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "src/uups/MyTokenV1.sol";
import "src/uups/MyTokenV2.sol";

contract UUPSTokenTest is Test {
    MyTokenV1 internal tokenProxy;
    ERC1967Proxy internal proxy;

    string internal constant NAME = "MyToken";
    string internal constant SYMBOL = "MTK";
    uint256 internal constant INITIAL_SUPPLY = 1_000_000 ether;

    address internal owner = address(this);
    address internal bob = address(0xB0B);

    function setUp() public {
        MyTokenV1 logicV1 = new MyTokenV1();

        proxy = new ERC1967Proxy(
            address(logicV1),
            abi.encodeCall(MyTokenV1.initialize, (NAME, SYMBOL))
        );

        tokenProxy = MyTokenV1(address(proxy));
    }

    function testInitialize() public {
        assertEq(tokenProxy.name(), NAME, "name should match");
        assertEq(tokenProxy.symbol(), SYMBOL, "symbol should match");
        assertEq(tokenProxy.version(), "V1", "version should be V1");

        assertEq(tokenProxy.totalSupply(), INITIAL_SUPPLY, "total supply mismatch");
        assertEq(tokenProxy.balanceOf(owner), INITIAL_SUPPLY, "owner should receive initial supply");
    }

    function testTransferAfterInitialize() public {
        uint256 transferAmount = 1_000 ether;

        tokenProxy.transfer(bob, transferAmount);

        assertEq(tokenProxy.balanceOf(owner), INITIAL_SUPPLY - transferAmount, "owner balance mismatch");
        assertEq(tokenProxy.balanceOf(bob), transferAmount, "bob balance mismatch");
    }

    function testApproveAndTransferFrom() public {
        uint256 allowanceAmount = 2_000 ether;
        tokenProxy.approve(bob, allowanceAmount);

        vm.prank(bob);
        tokenProxy.transferFrom(owner, bob, allowanceAmount);

        assertEq(tokenProxy.allowance(owner, bob), 0, "allowance should be consumed");
        assertEq(tokenProxy.balanceOf(bob), allowanceAmount, "bob should receive tokens");
        assertEq(tokenProxy.balanceOf(owner), INITIAL_SUPPLY - allowanceAmount, "owner should lose tokens");
    }

    function testInitializeCannotRunTwice() public {
        vm.expectRevert(abi.encodeWithSignature("InvalidInitialization()"));
        tokenProxy.initialize("Other", "OTHER");
    }

    function testUpgradeToV2KeepsState() public {
        uint256 transferAmount = 500 ether;
        tokenProxy.transfer(bob, transferAmount);

        MyTokenV2 logicV2 = new MyTokenV2();

        tokenProxy.upgradeToAndCall(address(logicV2), "");

        MyTokenV2 upgraded = MyTokenV2(address(tokenProxy));

        assertEq(upgraded.version(), "V2", "version should be V2 after upgrade");
        assertEq(upgraded.totalSupply(), INITIAL_SUPPLY, "supply should stay the same");
        assertEq(upgraded.balanceOf(owner), INITIAL_SUPPLY - transferAmount, "owner balance should persist");
        assertEq(upgraded.balanceOf(bob), transferAmount, "bob balance should persist");
    }

    function testUpgradeKeepsAllowanceAndOwner() public {
        uint256 allowanceAmount = 3_000 ether;
        tokenProxy.approve(bob, allowanceAmount);

        MyTokenV2 logicV2 = new MyTokenV2();
        tokenProxy.upgradeToAndCall(address(logicV2), "");

        MyTokenV2 upgraded = MyTokenV2(address(tokenProxy));

        assertEq(upgraded.allowance(owner, bob), allowanceAmount, "allowance should survive upgrade");
        assertEq(upgraded.owner(), owner, "owner should remain the same");

        vm.prank(bob);
        upgraded.transferFrom(owner, bob, allowanceAmount);

        assertEq(upgraded.balanceOf(bob), allowanceAmount, "bob should receive allowance amount");
    }

    function testNonOwnerCannotUpgrade() public {
        MyTokenV2 logicV2 = new MyTokenV2();
        address attacker = address(0xCAFE);

        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", attacker));
        tokenProxy.upgradeToAndCall(address(logicV2), "");
    }
}

