// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../contracts/Vault.sol";
import {IAddressesProvider} from "../interfaces/IAddressProvider.sol";

contract DeployVault is Script {
    address _aaveGoerliLendingPool =
        address(0x4bd5643ac6f66a5237E18bfA7d47cF22f1c9F210);

    address _aaveGoerliAddressProvider =
        address(0x5E52dEc931FFb32f609681B8438A51c675cc232d);

    address _incentivesController =
        IAddressesProvider(_aaveGoerliAddressProvider)
            .getIncentivesController();

    address _usdtGoerliLendingToken =
        address(0x2f3A40A3db8a7e3D09B0adfEfbCe4f6F81927557);

    address _aaveGoerliDataProvider =
        address(0x927F584d4321C1dCcBf5e2902368124b02419a1E);

    address _aaveNative = address(0x4da27a545c0c5B758a6BA100e3a049001de870f5);

    function run() external returns (Vault) {
        Vault vault = new Vault(
            "Farmer Token",
            "$Farmer",
            _usdtGoerliLendingToken,
            _aaveNative,
            _usdtGoerliLendingToken,
            _aaveGoerliLendingPool,
            _aaveGoerliDataProvider,
            _incentivesController
        );

        return vault;
    }
}
