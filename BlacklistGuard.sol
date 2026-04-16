// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BlacklistGuard {
    mapping(address => bool) public blacklisted;
    address public admin;

    event Blacklisted(address indexed addr);
    event UnBlacklisted(address indexed addr);

    constructor() {
        admin = msg.sender;
    }

    function addToBlacklist(address addr) external {
        require(msg.sender == admin, "Only admin");
        blacklisted[addr] = true;
        emit Blacklisted(addr);
    }

    function removeFromBlacklist(address addr) external {
        require(msg.sender == admin, "Only admin");
        blacklisted[addr] = false;
        emit UnBlacklisted(addr);
    }
}
