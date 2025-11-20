// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

/**
 * @dev 轻量封装 TransparentUpgradeableProxy，暴露 admin 查询接口，方便脚本与测试演示
 */
contract MyTransparentProxy is TransparentUpgradeableProxy {
    constructor(
        address implementation_,
        address initialOwner,
        bytes memory data
    ) TransparentUpgradeableProxy(implementation_, initialOwner, data) {}

    function proxyAdminAddress() external view returns (address) {
        return _proxyAdmin();
    }
}

