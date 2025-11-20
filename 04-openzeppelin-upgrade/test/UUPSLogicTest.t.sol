// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/uups/MyLogicV1.sol";
import "src/uups/MyLogicV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UUPSLogicTest is Test {
    MyLogicV1 public logicV1;
    MyLogicV2 public logicV2;
    MyLogicV1 public proxyAsV1;

    function setUp() public {
        // 部署逻辑合约 v1
        logicV1 = new MyLogicV1();


        // 通过 ERC1967Proxy 部署代理并调用 initialize()
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(logicV1),
            abi.encodeCall(MyLogicV1.initialize, (10))   // 初始化 value = 10
        );

        // proxy合约地址转换为 MyLogicV1 类型实例，方便调用
        proxyAsV1 = MyLogicV1(address(proxy));
    }

    function testBasic() public {
        assertEq(proxyAsV1.value(), 10);

        proxyAsV1.increment();
        assertEq(proxyAsV1.value(), 11);
    }

    function testUpgrade() public {

        // 部署新的逻辑合约 MyLogicV2
        logicV2 = new MyLogicV2();

        // 使用 UUPS 的 upgradeTo()
        proxyAsV1.upgradeToAndCall(address(logicV2), "");

        // 升级后，用新接口调用 decrement()
        MyLogicV2 proxyAsV2 = MyLogicV2(address(proxyAsV1));

        proxyAsV2.decrement();  // value = 10 -> 9

        assertEq(proxyAsV2.value(), 9);
    }
}
