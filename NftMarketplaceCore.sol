// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NftMarketplaceCore {
    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;

    event NftListed(uint256 indexed tokenId, uint256 price);
    event NftSold(uint256 indexed tokenId, address indexed buyer);

    function listNft(uint256 tokenId, uint256 price) external {
        require(price > 0, "Invalid price");
        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            active: true
        });
        emit NftListed(tokenId, price);
    }

    function buyNft(uint256 tokenId) external payable {
        Listing storage listing = listings[tokenId];
        require(listing.active, "Not listed");
        require(msg.value >= listing.price, "Insufficient payment");
        listing.active = false;
        payable(listing.seller).transfer(msg.value);
        emit NftSold(tokenId, msg.sender);
    }
}
