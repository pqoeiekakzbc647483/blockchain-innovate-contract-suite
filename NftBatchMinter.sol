// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftBatchMinter {
    uint256 public tokenCounter;
    address public admin;

    event BatchMinted(uint256 startToken, uint256 endToken, address indexed to);

    constructor() {
        admin = msg.sender;
    }

    function batchMint(address to, uint256 quantity) external {
        require(msg.sender == admin, "Only admin");
        uint256 start = tokenCounter + 1;
        tokenCounter += quantity;
        emit BatchMinted(start, tokenCounter, to);
    }

    function getTotalSupply() external view returns (uint256) {
        return tokenCounter;
    }
}
