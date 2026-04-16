// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainRandomGenerator {
    event RandomNumberGenerated(uint256 indexed randomNum, address indexed requester);

    function generateRandomNumber() external returns (uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender)));
        emit RandomNumberGenerated(randomNum, msg.sender);
        return randomNum;
    }

    function generateRandomInRange(uint256 min, uint256 max) external returns (uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender)));
        return min + (randomNum % (max - min + 1));
    }
}
