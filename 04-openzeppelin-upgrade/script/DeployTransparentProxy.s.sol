// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/transparent/MyTransparentLogicV1.sol";
import "../src/transparent/MyTransparentProxy.sol";

contract DeployTransparentProxy is Script {
    function run() external {
        vm.startBroadcast();

        MyTransparentLogicV1 logicV1 = new MyTransparentLogicV1();

        MyTransparentProxy proxy = new MyTransparentProxy(
            address(logicV1),
            msg.sender,
            abi.encodeCall(MyTransparentLogicV1.initialize, (10, msg.sender))
        );

        console2.log("Transparent proxy deployed at", address(proxy));
        console2.log("Proxy admin at", proxy.proxyAdminAddress());

        vm.stopBroadcast();
    }
}

