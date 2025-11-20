// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/uups/MyTokenV1.sol";

contract Deploy is Script {

    function run() external {
        vm.startBroadcast();

        // 部署逻辑合约
        MyTokenV1 impl = new MyTokenV1();

        // 生成初始化数据
        bytes memory data = abi.encodeWithSelector(
            MyTokenV1.initialize.selector, 
            "MyToken",
            "MTK"
        );

        // 部署 proxy
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), data);

        console.log("Proxy deployed at: ", address(proxy));
        console.log("Implementation at: ", address(impl));

        vm.stopBroadcast();
    }
}
