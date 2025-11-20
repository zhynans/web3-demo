// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MyTransparentLogicV1.sol";

contract MyTransparentLogicV2 is MyTransparentLogicV1 {
    function decrement() public {
        value -= 1;
        emit ValueChanged(value, msg.sender);
    }
}

