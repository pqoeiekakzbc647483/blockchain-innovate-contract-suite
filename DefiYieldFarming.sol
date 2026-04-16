// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefiYieldFarming {
    struct Farm {
        uint256 stakedAmount;
        uint256 rewardDebt;
    }

    mapping(address => Farm) public farms;
    uint256 public rewardPerBlock = 50;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256 amount);
    event Harvested(address indexed user, uint256 reward);

    function stake(uint256 amount) external {
        Farm storage f = farms[msg.sender];
        f.stakedAmount += amount;
        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function harvest() external {
        Farm storage f = farms[msg.sender];
        uint256 reward = f.stakedAmount * rewardPerBlock - f.rewardDebt;
        f.rewardDebt = f.stakedAmount * rewardPerBlock;
        payable(msg.sender).transfer(reward);
        emit Harvested(msg.sender, reward);
    }
}
