// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyLogicV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); // 把 initialized 状态设置为 true，防止逻辑合约被攻击者初始化
    }

    function initialize(uint256 _v) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        value = _v;
    }

    function increment() public {
        value += 1;
    }

    // UUPS授权函数（必须实现）：不需要执行额外逻辑，真正的安全逻辑由修饰器onlyOwner控制，防止恶意升级
    function _authorizeUpgrade(address newImplementation)
        internal override onlyOwner {}
}
