// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import "../src/transparent/MyTransparentLogicV2.sol";

contract UpgradeTransparentProxy is Script {
    address proxyAddress = address(0xBEEF);    // Transparent proxy 地址
    address proxyAdminAddress = address(0xCAFE); // ProxyAdmin 地址

    function run() external {
        vm.startBroadcast();

        MyTransparentLogicV2 logicV2 = new MyTransparentLogicV2();

        ProxyAdmin(proxyAdminAddress).upgradeAndCall(
            ITransparentUpgradeableProxy(payable(proxyAddress)),
            address(logicV2),
            ""
        );

        vm.stopBroadcast();
    }
}

