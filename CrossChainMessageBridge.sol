// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrossChainMessageBridge {
    struct CrossChainMessage {
        string message;
        uint256 sourceChainId;
        uint256 targetChainId;
        address sender;
        bool processed;
    }

    mapping(uint256 => CrossChainMessage) public messages;
    uint256 public messageCounter;

    event MessageSent(uint256 indexed msgId, uint256 targetChainId);
    event MessageProcessed(uint256 indexed msgId);

    function sendCrossChainMessage(string calldata message, uint256 sourceChain, uint256 targetChain) external returns (uint256) {
        messageCounter++;
        messages[messageCounter] = CrossChainMessage({
            message: message,
            sourceChainId: sourceChain,
            targetChainId: targetChain,
            sender: msg.sender,
            processed: false
        });
        emit MessageSent(messageCounter, targetChain);
        return messageCounter;
    }

    function processMessage(uint256 msgId) external {
        require(!messages[msgId].processed, "Already processed");
        messages[msgId].processed = true;
        emit MessageProcessed(msgId);
    }
}
