// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSignatureWallet {
    address[] public owners;
    uint256 public requiredConfirmations;
    mapping(uint256 => mapping(address => bool)) public confirmations;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
    }

    Transaction[] public transactions;

    event TransactionSubmitted(uint256 indexed txId, address indexed to);
    event TransactionConfirmed(uint256 indexed txId, address indexed owner);
    event TransactionExecuted(uint256 indexed txId);

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "No owners");
        require(_required > 0 && _required <= _owners.length, "Invalid required");
        owners = _owners;
        requiredConfirmations = _required;
    }

    function submitTransaction(address to) external payable returns (uint256) {
        uint256 txId = transactions.length;
        transactions.push(Transaction({
            to: to,
            value: msg.value,
            executed: false
        }));
        emit TransactionSubmitted(txId, to);
        return txId;
    }

    function confirmTransaction(uint256 txId) external {
        require(isOwner(msg.sender), "Not owner");
        require(!confirmations[txId][msg.sender], "Already confirmed");
        confirmations[txId][msg.sender] = true;
        emit TransactionConfirmed(txId, msg.sender);
    }

    function executeTransaction(uint256 txId) external {
        require(!transactions[txId].executed, "Already executed");
        require(getConfirmationCount(txId) >= requiredConfirmations, "Not enough confirmations");
        transactions[txId].executed = true;
        payable(transactions[txId].to).transfer(transactions[txId].value);
        emit TransactionExecuted(txId);
    }

    function isOwner(address addr) private view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == addr) return true;
        }
        return false;
    }

    function getConfirmationCount(uint256 txId) private view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < owners.length; i++) {
            if (confirmations[txId][owners[i]]) count++;
        }
        return count;
    }
}
