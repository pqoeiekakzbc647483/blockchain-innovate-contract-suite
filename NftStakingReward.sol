// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftStakingReward {
    struct StakedNft {
        uint256 tokenId;
        uint256 stakeTime;
        address owner;
    }

    mapping(uint256 => StakedNft) public stakedNfts;
    mapping(address => uint256[]) public userStaked;
    uint256 public rewardPerNft = 10;

    event NftStaked(uint256 indexed tokenId, address indexed owner);
    event RewardClaimed(address indexed owner, uint256 reward);

    function stakeNft(uint256 tokenId) external {
        stakedNfts[tokenId] = StakedNft({
            tokenId: tokenId,
            stakeTime: block.timestamp,
            owner: msg.sender
        });
        userStaked[msg.sender].push(tokenId);
        emit NftStaked(tokenId, msg.sender);
    }

    function claimStakeReward() external {
        uint256 count = userStaked[msg.sender].length;
        uint256 reward = count * rewardPerNft;
        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }
}
