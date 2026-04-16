// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefiFlashLoanCore {
    uint256 public loanFee = 1;
    address public owner;

    event FlashLoanExecuted(uint256 amount, uint256 fee);

    constructor() {
        owner = msg.sender;
    }

    function flashLoan(uint256 amount) external payable {
        uint256 fee = (amount * loanFee) / 100;
        require(msg.value >= fee, "Insufficient fee");
        payable(msg.sender).transfer(amount);
        emit FlashLoanExecuted(amount, fee);
    }

    function withdrawFees() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }
}
