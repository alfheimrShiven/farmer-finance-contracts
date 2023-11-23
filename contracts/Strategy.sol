// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IStrategy} from "../interfaces/IStrategy.sol";

abstract contract Strategy is IStrategy {
    address public lendingToken;

    constructor(address _lendingToken) {
        lendingToken = _lendingToken;
    }

    function getLendingToken() public view returns (IERC20) {
        return IERC20(lendingToken);
    }

    // puts the funds to work
    function deposit() public {
        uint256 lendingTokenBal = getLendingToken.balanceOf(address(this));

        if (lendingTokenBal > 0) {
            // TODO: Import ILendingPool
            ILendingPool(lendingPool).deposit(
                lendingToken,
                lendingTokenBal,
                address(this),
                0
            );

            emit IStrategy.Deposit(lendingTokenBal);
        }
    }
}
