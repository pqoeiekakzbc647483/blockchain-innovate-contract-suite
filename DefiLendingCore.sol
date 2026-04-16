// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefiLendingCore {
    struct Loan {
        uint256 amount;
        uint256 collateral;
        uint256 repayTime;
        bool active;
    }

    mapping(address => Loan) public userLoans;
    uint256 public interestRate = 5;

    event LoanTaken(address indexed user, uint256 amount, uint256 collateral);
    event LoanRepaid(address indexed user, uint256 amount);

    function takeLoan() external payable {
        require(userLoans[msg.sender].active == false, "Existing loan");
        uint256 collateral = msg.value;
        uint256 loanAmount = collateral * 2;
        userLoans[msg.sender] = Loan({
            amount: loanAmount,
            collateral: collateral,
            repayTime: block.timestamp + 7 days,
            active: true
        });
        payable(msg.sender).transfer(loanAmount);
        emit LoanTaken(msg.sender, loanAmount, collateral);
    }

    function repayLoan() external payable {
        Loan storage loan = userLoans[msg.sender];
        require(loan.active, "No active loan");
        uint256 totalRepay = loan.amount + (loan.amount * interestRate / 100);
        require(msg.value >= totalRepay, "Insufficient repayment");
        loan.active = false;
        payable(address(this)).transfer(msg.value);
        emit LoanRepaid(msg.sender, totalRepay);
    }
}
