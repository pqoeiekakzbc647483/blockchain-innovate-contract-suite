// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BlockchainTimelock {
    struct LockedFunds {
        uint256 amount;
        uint256 releaseTime;
        address owner;
    }

    mapping(address => LockedFunds) public locked;

    event FundsLocked(address indexed owner, uint256 amount, uint256 releaseTime);
    event FundsReleased(address indexed owner, uint256 amount);

    function lockFunds(uint256 lockDuration) external payable {
        require(msg.value > 0, "Zero amount");
        uint256 releaseTime = block.timestamp + lockDuration;
        locked[msg.sender] = LockedFunds({
            amount: msg.value,
            releaseTime: releaseTime,
            owner: msg.sender
        });
        emit FundsLocked(msg.sender, msg.value, releaseTime);
    }

    function releaseFunds() external {
        LockedFunds storage fund = locked[msg.sender];
        require(block.timestamp >= fund.releaseTime, "Not unlocked");
        require(fund.amount > 0, "No funds");
        uint256 amount = fund.amount;
        fund.amount = 0;
        payable(msg.sender).transfer(amount);
        emit FundsReleased(msg.sender, amount);
    }
}
