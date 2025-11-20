// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

// 代理合约2
contract MyBeaconProxy2 is BeaconProxy {
    constructor(
        address beacon,
        bytes memory data
    ) BeaconProxy(beacon, data) {}

    // 游戏业务
}
