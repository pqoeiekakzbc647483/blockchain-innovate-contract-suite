// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefiStakingPool {
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 rewardDebt;
    }

    mapping(address => Stake) public userStakes;
    uint256 public totalStaked;
    uint256 public rewardRate = 100;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);

    modifier updateReward() {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        _;
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) return rewardPerTokenStored;
        return rewardPerTokenStored + ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / totalStaked;
    }

    function stake() external payable updateReward {
        Stake storage stake = userStakes[msg.sender];
        stake.amount += msg.value;
        stake.rewardDebt = (stake.amount * rewardPerToken()) / 1e18;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function unstake(uint256 amount) external updateReward {
        Stake storage stake = userStakes[msg.sender];
        require(stake.amount >= amount, "Insufficient staked");
        stake.amount -= amount;
        stake.rewardDebt = (stake.amount * rewardPerToken()) / 1e18;
        totalStaked -= amount;
        payable(msg.sender).transfer(amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() external updateReward {
        Stake storage stake = userStakes[msg.sender];
        uint256 reward = (stake.amount * rewardPerToken()) / 1e18 - stake.rewardDebt;
        require(reward > 0, "No reward");
        stake.rewardDebt = (stake.amount * rewardPerToken()) / 1e18;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }
}
