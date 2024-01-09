// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IStrategy} from "../interfaces/IStrategy.sol";
import {ILendingPool} from "../interfaces/ILendingPool.sol";
import {IDataProvider} from "../interfaces/IDataProvider.sol";
import {IAaveV3Incentives} from "../interfaces/IAaveV3Incentives.sol";

contract Strategy is IStrategy {
    using SafeERC20 for IERC20;
    address public vault;
    // tokens
    address public lendingToken;
    address public aToken;
    address public nativeToken;
    address public outputToken;

    // third party contracts
    address public lendingPool;
    address public dataProvider;
    address public incentivesController;

    uint256 public lastHarvest;

    constructor(
        address _vault,
        address _lendingToken,
        address _native,
        address _output,
        address _lendingPool,
        address _incentivesController,
        address _dataProvider
    ) {
        vault = _vault;
        lendingToken = _lendingToken;
        nativeToken = _native;
        outputToken = _output;
        (aToken, , ) = IDataProvider(dataProvider).getReserveTokensAddresses(
            lendingToken
        );
        nativeToken = _native;
        outputToken = _output;
        lendingPool = _lendingPool;
        dataProvider = _dataProvider;
        incentivesController = _incentivesController;
    }

    function getLendingToken() public view returns (IERC20) {
        return IERC20(lendingToken);
    }

    // puts the funds to work
    function deposit() public {
        uint256 lendingTokenBal = balanceOfLendingToken();

        if (lendingTokenBal > 0) {
            ILendingPool(lendingPool).deposit(
                lendingToken,
                lendingTokenBal,
                address(this),
                0
            );

            emit Deposit(lendingTokenBal);
        }
    }

    function withdraw(uint256 _amount) external {
        require(msg.sender == vault, "!vault");

        uint256 lendingTokenBal = balanceOfLendingToken();
        if (lendingTokenBal < _amount) {
            ILendingPool(lendingPool).withdraw(
                lendingToken,
                _amount - lendingTokenBal,
                address(this)
            );

            lendingTokenBal = balanceOfLendingToken();
        }

        if (lendingTokenBal > _amount) {
            lendingTokenBal = _amount;
        }

        getLendingToken().safeTransfer(vault, lendingTokenBal);

        emit Withdraw(lendingTokenBal);
    }

    // it calculates how much 'lendingToken' this contract holds.
    function balanceOfLendingToken() public view returns (uint256) {
        return getLendingToken().balanceOf(address(this));
    }

    function harvest() external virtual {
        _harvest(tx.origin);
    }

    // compounds earnings and charges performance fee
    function _harvest(address callFeeRecipient) internal {
        address[] memory assets = new address[](1);
        assets[0] = aToken;

        IAaveV3Incentives(incentivesController).claimRewards(
            assets,
            type(uint).max,
            address(this),
            outputToken
        );

        uint256 outputTokenBal = IERC20(outputToken).balanceOf(address(this));

        if (outputTokenBal > 0) {
            chargeFees(callFeeRecipient, outputTokenBal);
            //TODO swapRewards();

            uint256 lendingTokenHarvested = balanceOfLendingToken();

            deposit();

            lastHarvest = block.timestamp;
            emit Harvested(msg.sender, lendingTokenHarvested);
        }
    }

    // it calculates how much 'want' the strategy has working in the farm.
    function balanceOfPool() public view returns (uint256) {
        (uint256 supplyBal, uint256 borrowBal) = userReserves();
        return supplyBal - borrowBal;
    }

    // return supply and borrow balance
    function userReserves() public view returns (uint256, uint256) {
        (uint256 supplyBal, , uint256 borrowBal, , , , , , ) = IDataProvider(
            dataProvider
        ).getUserReserveData(lendingToken, address(this));
        return (supplyBal, borrowBal);
    }

    // TODO
    function beforeDeposit() external {}

    //TODO: performance fees
    function chargeFees(
        address callFeeRecipient,
        uint256 outputTokenBal
    ) internal {
        uint256 callFeeAmount = outputTokenBal * (2e18 / 100);
        IERC20(nativeToken).safeTransfer(callFeeRecipient, callFeeAmount);
    }
}
