// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils//escrow/RefundEscrow.sol";
import "./Crowdsale.sol";

/**
 * @title RefundableCrowdsale
 * @dev Based on the deprecated OpenZeppelin RefundableCrowdsale but with a refund rate.
 * The aim is that users should be able to buy tokens and if they are not happy, resell them
 * back to the crowdsale so they can partially recoup their original investment as determined
 * by the refund rate. This differs from the OpenZeppelin use case where if a crowdsale was 
 * stopped and the target sales hadn't been achieved, all users would be refunded. This is 
 * safer to implement because it provided more control over invariants.
 */
contract RefundableCrowdsale is Crowdsale, Ownable {
    RefundEscrow private _escrow;
    uint256 private _refundRate;

    constructor (
        uint256 r, // conversion rate from wei to token
        address payable w, // wallet to be paid
        IERC20 t, // the deployed token
        uint256 refundRate // the percentage of the investment that will be recouped on refund
    )
        public 
        Crowdsale(r, w, t)
    {
        _refundRate = refundRate;
        _escrow = new RefundEscrow(wallet());
    }

    function _forwardFunds() internal override {
        uint256 refundableAmount = (msg.value * _refundRate)/100;
        uint256 nonRefundableAmount = msg.value - refundableAmount;
        _escrow.deposit{value: refundableAmount}(msg.sender);
        _wallet.transfer(nonRefundableAmount);
    }

    function claimRefund(address payable refundee) public {
        _escrow.withdraw(refundee);
    }

    function checkEscrowAddress() public view returns (address) {
        return address(_escrow);
    }

    function enableRefunds() onlyOwner public {
        address(_escrow).call(abi.encodeWithSignature("enableRefunds()"));
    }
}