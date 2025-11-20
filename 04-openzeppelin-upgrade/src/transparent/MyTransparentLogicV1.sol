// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyTransparentLogicV1 is Initializable {
    uint256 public value;
    address public owner;

    event ValueChanged(uint256 newValue, address indexed caller);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 initValue, address owner_) public initializer {
        value = initValue;
        owner = owner_;

        emit ValueChanged(initValue, msg.sender);
    }

    function increment() public {
        value += 1;
        emit ValueChanged(value, msg.sender);
    }
}

