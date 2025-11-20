// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyTokenV1 is 
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();  // 防止逻辑合约被攻击者初始化
    }

    // 初始化函数（代替 constructor）
    function initialize(string memory name_, string memory symbol_) 
        public initializer 
    {
        __ERC20_init(name_, symbol_);
        __Ownable_init(msg.sender); // 设置 owner
        __UUPSUpgradeable_init();

        _mint(msg.sender, 1_000_000 ether);
    }

    // UUPS授权函数（必须实现）：不需要执行额外逻辑，真正的安全逻辑由修饰器onlyOwner控制，防止恶意升级
    function _authorizeUpgrade(address newImplementation) 
        internal override onlyOwner {}

    function version() public pure virtual returns (string memory) {
        return "V1";
    }
}
