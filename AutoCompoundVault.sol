// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AutoCompoundVault {
    mapping(address => uint256) public deposits;
    uint256 public compoundRate = 2;

    event Deposited(address indexed user, uint256 amount);
    event Compounded(address indexed user, uint256 newAmount);

    function deposit() external payable {
        deposits[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function compound() external {
        uint256 current = deposits[msg.sender];
        uint256 reward = current * compoundRate / 100;
        deposits[msg.sender] = current + reward;
        emit Compounded(msg.sender, deposits[msg.sender]);
    }
}
