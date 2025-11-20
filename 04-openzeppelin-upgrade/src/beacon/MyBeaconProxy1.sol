// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

// 代理合约1
contract MyBeaconProxy1 is BeaconProxy {
    constructor(
        address beacon,
        bytes memory data
    ) BeaconProxy(beacon, data) {}

    // 用户业务
}
