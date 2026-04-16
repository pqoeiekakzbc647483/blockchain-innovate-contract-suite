// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedOracle {
    struct DataRequest {
        string query;
        uint256 result;
        bool fulfilled;
    }

    mapping(uint256 => DataRequest) public requests;
    uint256 public requestCounter;

    event RequestCreated(uint256 indexed reqId, string query);
    event RequestFulfilled(uint256 indexed reqId, uint256 result);

    function createRequest(string calldata query) external returns (uint256) {
        requestCounter++;
        requests[requestCounter] = DataRequest({
            query: query,
            result: 0,
            fulfilled: false
        });
        emit RequestCreated(requestCounter, query);
        return requestCounter;
    }

    function fulfillRequest(uint256 reqId, uint256 result) external {
        require(!requests[reqId].fulfilled, "Already fulfilled");
        requests[reqId].result = result;
        requests[reqId].fulfilled = true;
        emit RequestFulfilled(reqId, result);
    }
}
