// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Web3AuthGate {
    mapping(address => bool) public authenticated;
    address public admin;

    event UserAuthenticated(address indexed user);
    function constructor() {
        admin = msg.sender;
    }

    function authenticate() external {
        authenticated[msg.sender] = true;
        emit UserAuthenticated(msg.sender);
    }

    function revokeAuth(address user) external {
        require(msg.sender == admin, "Only admin");
        authenticated[user] = false;
    }
}
