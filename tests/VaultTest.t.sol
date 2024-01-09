// // SPDX-License-Identifier: MIT

// pragma solidity 0.8.18;

// import {Test} from "forge-std/Test.sol";

// // Interfaces
// import {IVault} from "../interfaces/IVault.sol";
// import {IStrategy} from "../interfaces/IStrategy.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract ProdVaultTest is BaseTestHarness {
//     // Input your vault to test here.
//     IVault constant vault = IVault(0x17dEc2AF8018f2F940D34787399eA123Ff292963);
//     IStrategy strategy;

//     // Users
//     VaultUser user = makeAddr("vaultUser");
//     address constant keeper = 0x4fED5491693007f0CD49f4614FFC38Ab6A04B619;
//     address constant vaultOwner = 0x5B6C5363851EC9ED29CB7220C39B44E1dd443992; // fantom
//     address constant strategyOwner = 0x1c9270ac5C42E51611d7b97b1004313D52c80293; // fantom

//     IERC20Like lendingToken;
//     uint256 slot; // Storage slot that holds `balanceOf` mapping.
//     bool slotSet;
//     // Input amount of test lendingToken.
//     uint256 lendingTokenStartingAmount = 50 ether;
//     uint256 delay = 1000 seconds; // Time to wait after depositing before harvesting.

//     function setUp() public {
//         lendingToken = IERC20(vault.lendingToken());
//         strategy = IStrategy(vault.strategy());
//     }

//     function test_depositAndWithdraw() external {
//         _depositIntoVault(user);

//         shift(100 seconds);

//         console.log("Withdrawing all lendingToken from vault");
//         vm.startPrank(user);
//         vault.withdrawAll();

//         uint256 lendingTokenBalanceFinal = lendingToken.balanceOf(
//             address(user)
//         );
//         console.log("Final user want balance", lendingTokenBalanceFinal);
//         assertLe(
//             lendingTokenBalanceFinal,
//             lendingTokenStartingAmount,
//             "Expected wantBalanceFinal <= lendingTokenStartingAmount"
//         );
//         assertGt(
//             lendingTokenBalanceFinal,
//             (lendingTokenStartingAmount * 99) / 100,
//             "Expected wantBalanceFinal > lendingTokenStartingAmount * 99 / 100"
//         );
//     }
// }
