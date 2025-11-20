// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/uups/MyLogicV1.sol";

contract DeployLogicUUPS is Script {
    function run() external returns (address proxyAddr, address logicAddr) {
        vm.startBroadcast();

        MyLogicV1 impl = new MyLogicV1();

        // 调用 initialize (ABI 编码)
        bytes memory data =
            abi.encodeWithSelector(MyLogicV1.initialize.selector);

        ERC1967Proxy proxy = new ERC1967Proxy(
            address(impl),
            data
        );

         vm.stopBroadcast();

        proxyAddr = address(proxy);
        logicAddr = address(impl);
    }
}
