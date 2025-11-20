// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyBeacon is UpgradeableBeacon {
    constructor(address implementation_)
        UpgradeableBeacon(implementation_, msg.sender)
    {}
}
