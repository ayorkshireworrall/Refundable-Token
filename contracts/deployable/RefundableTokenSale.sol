// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../RefundableCrowdsale.sol";

/**
 * @title RefundableTokenSale
 * @dev A deployable refundable crowdsale
 */
contract RefundableTokenSale is RefundableCrowdsale {

    constructor (
        uint256 rate,    // rate in TKNbits
        IERC20 token,
        address payable wallet, 
        uint256 refundRate // the percentage of investment that can be reclaimed (needs to be a value between 0 and 100)
    )
        RefundableCrowdsale(rate, wallet, token, refundRate)
        public
    {
        
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view override {
        super._preValidatePurchase(beneficiary, weiAmount);
    }
}