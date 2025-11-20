// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import "../src/beacon/MyLogicV1.sol";
import "../src/beacon/MyLogicV2.sol";
import "../src/beacon/MyBeacon.sol";
import "../src/beacon/MyBeaconProxy1.sol";
import "../src/beacon/MyBeaconProxy2.sol";

contract BeaconProxyTest is Test {
    MyLogicV1 internal logicV1;
    MyLogicV2 internal logicV2;
    MyBeacon internal beacon;
    MyBeaconProxy1 internal proxyA;
    MyBeaconProxy2 internal proxyB;

    uint256 internal constant INIT_A = 10;
    uint256 internal constant INIT_B = 100;
    address internal constant ATTACKER = address(0xDEAD);

    function setUp() public {
        logicV1 = new MyLogicV1();
        beacon = new MyBeacon(address(logicV1));

        proxyA = new MyBeaconProxy1(
            address(beacon),
            abi.encodeCall(MyLogicV1.initialize, (INIT_A))
        );

        proxyB = new MyBeaconProxy2(
            address(beacon),
            abi.encodeCall(MyLogicV1.initialize, (INIT_B))
        );
    }

    function testIndependentProxyState() public {
        MyLogicV1 instanceA = MyLogicV1(address(proxyA));
        MyLogicV1 instanceB = MyLogicV1(address(proxyB));

        assertEq(instanceA.value(), INIT_A, "proxy A should keep its init value");
        assertEq(instanceB.value(), INIT_B, "proxy B should keep its init value");

        instanceA.increment();

        assertEq(instanceA.value(), INIT_A + 1, "proxy A should increment");
        assertEq(instanceB.value(), INIT_B, "proxy B should be isolated");
    }

    function testBeaconUpgradeUpdatesAllProxies() public {
        MyLogicV1 instanceA = MyLogicV1(address(proxyA));
        instanceA.increment(); // value becomes INIT_A + 1

        logicV2 = new MyLogicV2();
        beacon.upgradeTo(address(logicV2));

        MyLogicV2 upgradedA = MyLogicV2(address(proxyA));
        MyLogicV2 upgradedB = MyLogicV2(address(proxyB));

        upgradedA.decrement(); // should go back to INIT_A
        upgradedB.decrement(); // INIT_B - 1

        assertEq(upgradedA.value(), INIT_A, "proxy A keeps storage after upgrade");
        assertEq(upgradedB.value(), INIT_B - 1, "proxy B also shares new logic");
    }

    function testOnlyOwnerCanUpgradeBeacon() public {
        logicV2 = new MyLogicV2();

        vm.prank(ATTACKER);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", ATTACKER));
        beacon.upgradeTo(address(logicV2));
    }
}