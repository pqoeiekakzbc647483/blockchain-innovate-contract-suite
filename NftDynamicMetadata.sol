// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftDynamicMetadata {
    struct NftItem {
        string baseUri;
        uint256 level;
        uint256 createTime;
    }

    mapping(uint256 => NftItem) public nfts;
    uint256 public nftCounter;
    address public admin;

    event NftMinted(uint256 indexed tokenId, string baseUri);
    event NftLevelUpgraded(uint256 indexed tokenId, uint256 newLevel);

    constructor() {
        admin = msg.sender;
    }

    function mintNft(string calldata baseUri) external returns (uint256) {
        nftCounter++;
        nfts[nftCounter] = NftItem({
            baseUri: baseUri,
            level: 1,
            createTime: block.timestamp
        });
        emit NftMinted(nftCounter, baseUri);
        return nftCounter;
    }

    function upgradeLevel(uint256 tokenId) external {
        require(msg.sender == admin, "Only admin");
        nfts[tokenId].level++;
        emit NftLevelUpgraded(tokenId, nfts[tokenId].level);
    }

    function getNftMetadata(uint256 tokenId) external view returns (NftItem memory) {
        return nfts[tokenId];
    }
}
