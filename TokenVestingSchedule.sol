// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenVestingSchedule {
    struct Vesting {
        uint256 totalAmount;
        uint256 releasedAmount;
        uint256 startTime;
        uint256 duration;
    }

    mapping(address => Vesting) public vestings;

    event VestingCreated(address indexed user, uint256 amount, uint256 duration);
    event TokensReleased(address indexed user, uint256 amount);

    function createVesting(address user, uint256 duration) external payable {
        require(msg.value > 0, "Zero amount");
        vestings[user] = Vesting({
            totalAmount: msg.value,
            releasedAmount: 0,
            startTime: block.timestamp,
            duration: duration
        });
        emit VestingCreated(user, msg.value, duration);
    }

    function releaseTokens() external {
        Vesting storage vest = vestings[msg.sender];
        require(vest.totalAmount > 0, "No vesting");
        uint256 elapsed = block.timestamp - vest.startTime;
        uint256 releasable = (vest.totalAmount * elapsed) / vest.duration - vest.releasedAmount;
        require(releasable > 0, "No tokens to release");
        vest.releasedAmount += releasable;
        payable(msg.sender).transfer(releasable);
        emit TokensReleased(msg.sender, releasable);
    }
}
