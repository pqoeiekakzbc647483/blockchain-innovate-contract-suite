// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainAnalyticsTracker {
    uint256 public totalTransactions;
    mapping(address => uint256) public userTxCount;

    event TransactionTracked(address indexed user);

    function trackTransaction() external {
        totalTransactions++;
        userTxCount[msg.sender]++;
        emit TransactionTracked(msg.sender);
    }

    function getUserTxCount(address user) external view returns (uint256) {
        return userTxCount[user];
    }
}
