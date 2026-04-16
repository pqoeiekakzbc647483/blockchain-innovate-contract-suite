// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureAccessControl {
    mapping(address => bool) public authorized;
    mapping(address => uint8) public userRole;
    address public owner;

    event RoleGranted(address indexed user, uint8 role);
    event AccessAuthorized(address indexed user);

    constructor() {
        owner = msg.sender;
    }

    function grantRole(address user, uint8 role) external {
        require(msg.sender == owner, "Only owner");
        userRole[user] = role;
        authorized[user] = true;
        emit RoleGranted(user, role);
    }

    function checkAccess(address user) external view returns (bool) {
        return authorized[user];
    }
}
