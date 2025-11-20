// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/beacon/MyLogicV1.sol";
import "../src/beacon/MyLogicV2.sol";
import "../src/beacon/MyBeacon.sol";

contract UpgradeBeaconProxy is Script {
    address beaconAddress = address(0xAAA); // beacon合约地址

    function run() external {
        vm.startBroadcast();

        // 1. 部署 V2
        MyLogicV2 logicV2 = new MyLogicV2();

        // 2. 升级 Beacon
        MyBeacon(beaconAddress).upgradeTo(address(logicV2));

        vm.stopBroadcast();

    }
}
