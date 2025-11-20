// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import './MyLogicV1.sol';

contract MyLogicV2 is MyLogicV1 {

   function decrement() public {
        value -= 1;
    }
    
}