// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyLogicV1 is Initializable {
    uint256 public value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); // 把 initialized 状态设置为 true，防止逻辑合约被攻击者初始化
    }

    function initialize(uint256 initValue) public initializer {
        value = initValue;
    }

    function increment() public {
        value += 1;
    }
}
