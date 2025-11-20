// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/beacon/MyLogicV1.sol";
import "../src/beacon/MyLogicV2.sol";
import "../src/beacon/MyBeacon.sol";
import "../src/beacon/MyBeaconProxy1.sol";
import "../src/beacon/MyBeaconProxy2.sol";

contract DeployBeaconProxy is Script {
    function run() external {
        vm.startBroadcast();

        // 1. 部署 V1
        MyLogicV1 logicV1 = new MyLogicV1();

        // 2. 部署 Beacon
        MyBeacon beacon = new MyBeacon(address(logicV1));

        // 3. 生成初始化 calldata
        bytes memory initA =
            abi.encodeWithSelector(MyLogicV1.initialize.selector, 10);
        bytes memory initB =
            abi.encodeWithSelector(MyLogicV1.initialize.selector, 100);

        // 4. 部署两个 Proxy，共享同一 Beacon
        new MyBeaconProxy1(address(beacon), initA);
        new MyBeaconProxy2(address(beacon), initB);

        vm.stopBroadcast();
    }
}
