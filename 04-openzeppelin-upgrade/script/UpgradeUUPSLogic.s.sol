// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/uups/MyLogicV1.sol";
import "../src/uups/MyLogicV2.sol";

contract UpgradeLogicUUPS is Script {
    function run() external returns (address newLogicAddr) {
        // 代理合约地址（部署后替换）
        address proxyAddr = address(0);

        vm.startBroadcast();

        // 部署新合约MyLogicV2
        MyLogicV2 impl = new MyLogicV2();

        // 获取代理合约地址
        MyLogicV1 proxyAsV1 = MyLogicV1(proxyAddr);
        // 升级代理合约到MyLogicV2，不调用任何函数
        proxyAsV1.upgradeToAndCall(address(impl), "");

        newLogicAddr = address(impl);

        vm.stopBroadcast();
    }
}
