// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainDataStorage {
    struct DataRecord {
        string dataHash;
        uint256 timestamp;
        address creator;
    }

    mapping(uint256 => DataRecord) private records;
    uint256 private recordCounter;

    event DataStored(uint256 indexed recordId, string dataHash, address creator);

    function storeData(string calldata dataHash) external returns (uint256) {
        recordCounter++;
        records[recordCounter] = DataRecord({
            dataHash: dataHash,
            timestamp: block.timestamp,
            creator: msg.sender
        });
        emit DataStored(recordCounter, dataHash, msg.sender);
        return recordCounter;
    }

    function getData(uint256 recordId) external view returns (DataRecord memory) {
        return records[recordId];
    }

    function getTotalRecords() external view returns (uint256) {
        return recordCounter;
    }
}
