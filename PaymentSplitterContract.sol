// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PaymentSplitterContract {
    address[] public payees;
    uint256[] public shares;
    uint256 public totalShares;

    event FundsSplit(address indexed payee, uint256 amount);

    constructor(address[] memory _payees, uint256[] memory _shares) {
        require(_payees.length == _shares.length, "Invalid input");
        payees = _payees;
        shares = _shares;
        for (uint256 i = 0; i < _shares.length; i++) {
            totalShares += _shares[i];
        }
    }

    function splitFunds() external payable {
        require(msg.value > 0, "Zero value");
        for (uint256 i = 0; i < payees.length; i++) {
            uint256 amount = (msg.value * shares[i]) / totalShares;
            payable(payees[i]).transfer(amount);
            emit FundsSplit(payees[i], amount);
        }
    }
}
