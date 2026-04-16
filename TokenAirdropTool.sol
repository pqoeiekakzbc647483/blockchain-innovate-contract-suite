// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenAirdropTool {
    address public immutable token;
    address public admin;

    event AirdropSent(address indexed to, uint256 amount);

    constructor(address _token) {
        token = _token;
        admin = msg.sender;
    }

    function batchAirdrop(address[] calldata recipients, uint256 amountPerUser) external {
        require(msg.sender == admin, "Only admin");
        uint256 total = recipients.length * amountPerUser;
        require(IERC20(token).balanceOf(address(this)) >= total, "Insufficient balance");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(token).transfer(recipients[i], amountPerUser);
            emit AirdropSent(recipients[i], amountPerUser);
        }
    }

    function withdrawToken() external {
        require(msg.sender == admin, "Only admin");
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(admin, balance);
    }
}
