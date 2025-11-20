// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "src/transparent/MyTransparentLogicV1.sol";
import "src/transparent/MyTransparentLogicV2.sol";
import "src/transparent/MyTransparentProxy.sol";

contract TransparentProxyTest is Test {
    MyTransparentLogicV1 internal logicV1;
    MyTransparentLogicV2 internal logicV2;
    MyTransparentProxy internal proxy;
    ProxyAdmin internal proxyAdmin;

    uint256 internal constant INIT_VALUE = 10;
    address internal owner = address(this);

    function setUp() public {
        logicV1 = new MyTransparentLogicV1();

        proxy = new MyTransparentProxy(
            address(logicV1),
            owner,
            abi.encodeCall(MyTransparentLogicV1.initialize, (INIT_VALUE, owner))
        );

        proxyAdmin = ProxyAdmin(proxy.proxyAdminAddress());
    }

    function testTransparentProxyBasicFlow() public {
        MyTransparentLogicV1 proxied = MyTransparentLogicV1(address(proxy));

        assertEq(proxied.value(), INIT_VALUE, "initial value mismatch");

        proxied.increment();

        assertEq(proxied.value(), INIT_VALUE + 1, "increment should work via proxy");
    }

    function testTransparentProxyUpgrade() public {
        logicV2 = new MyTransparentLogicV2();

        proxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(address(proxy)),
            address(logicV2),
            ""
        );

        MyTransparentLogicV2 proxied = MyTransparentLogicV2(address(proxy));

        proxied.decrement();

        assertEq(proxied.value(), INIT_VALUE - 1, "decrement should use V2 logic");
    }

    function testAdminCannotCallImplementation() public {
        vm.prank(proxy.proxyAdminAddress());
        vm.expectRevert(TransparentUpgradeableProxy.ProxyDeniedAdminAccess.selector);
        MyTransparentLogicV1(address(proxy)).increment();
    }
}

