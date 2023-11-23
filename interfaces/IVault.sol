// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IVault {
    /**
     * @dev Returns the IERC20 instance of the lending token
     */
    function getLendingToken() external view returns (IERC20);

    /**
     * @dev
     * It takes into account the vault contract balance, the strategy contract balance
     *  and the balance deployed in other contracts as part of the strategy.
     */
    function balance() external returns (uint);

    /**
     * @dev Returns the balance of lendingToken the vault allows to put at work. We return 100% of tokens for now. Under certain conditions we might
     * getLendingToken to keep some of the system funds at hand in the vault, instead
     * of putting them to work.
     */
    function available() external returns (uint256);

    /**
     * @dev A helper function to call deposit() with all the sender's funds.
     */
    function depositAll() external;

    /**
     * @dev The entrypoint of funds into the system. People deposit with this function or the depositAll()
     * into the vault. The vault is then in charge of sending funds into the strategy.
     */
    function deposit(uint _amount) external;

    /**
     * @dev Function to send funds into the strategy and put them to work. It's primarily called
     * by the vault's deposit() function.
     */
    function earn() external;

    /**
     * @dev A helper function to call withdraw() with all the sender's funds.
     */
    function withdrawAll() external;

    /**
     * @dev Function to exit the system. The vault will withdraw the required tokens
     * from the strategy and pay up the token holder. A proportional number of IOU
     * tokens are burned in the process.
     */
    function withdraw(uint256 _shares) external;
}
