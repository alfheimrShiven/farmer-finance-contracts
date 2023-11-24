// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IStrategy {
    event Deposit(uint256 indexed lendingTokenDeposited);
    event Withdraw(uint256 indexed lendingTokenBal);
    event Harvested(address indexed user, uint256 indexed amount);

    function getLendingToken() external view returns (IERC20);

    function deposit() external;

    function withdraw(uint256) external;

    function balanceOfLendingToken() external view returns (uint256);

    function balanceOfPool() external view returns (uint256);

    function harvest() external;
}
