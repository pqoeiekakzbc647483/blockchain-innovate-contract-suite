// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhitelistManager {
    mapping(address => bool) public whitelist;
    address public admin;

    event AddressWhitelisted(address indexed addr);
    event AddressRemoved(address indexed addr);

    constructor() {
        admin = msg.sender;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == admin, "Only admin");
        whitelist[addr] = true;
        emit AddressWhitelisted(addr);
    }

    function removeFromWhitelist(address addr) external {
        require(msg.sender == admin, "Only admin");
        whitelist[addr] = false;
        emit AddressRemoved(addr);
    }

    function isWhitelisted(address addr) external view returns (bool) {
        return whitelist[addr];
    }
}
