// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RewardDistributionSystem {
    address[] public participants;
    uint256 public totalReward;

    event RewardAdded(uint256 amount);
    event RewardDistributed(address indexed user, uint256 amount);

    function addReward() external payable {
        totalReward += msg.value;
        emit RewardAdded(msg.value);
    }

    function addParticipant(address user) external {
        participants.push(user);
    }

    function distributeRewards() external {
        require(totalReward > 0 && participants.length > 0, "No reward or user");
        uint256 rewardPerUser = totalReward / participants.length;
        for (uint256 i = 0; i < participants.length; i++) {
            payable(participants[i]).transfer(rewardPerUser);
            emit RewardDistributed(participants[i], rewardPerUser);
        }
        totalReward = 0;
    }
}
