// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalAssetOwnership {
    struct Asset {
        string assetName;
        address owner;
        uint256 createTime;
        bool isActive;
    }

    mapping(uint256 => Asset) private _assets;
    uint256 private _assetCounter;
    address public immutable admin;

    event AssetCreated(uint256 indexed assetId, string assetName, address owner);
    event AssetTransferred(uint256 indexed assetId, address indexed from, address indexed to);

    constructor() {
        admin = msg.sender;
    }

    function createAsset(string calldata assetName) external returns (uint256) {
        _assetCounter++;
        _assets[_assetCounter] = Asset({
            assetName: assetName,
            owner: msg.sender,
            createTime: block.timestamp,
            isActive: true
        });
        emit AssetCreated(_assetCounter, assetName, msg.sender);
        return _assetCounter;
    }

    function transferAsset(uint256 assetId, address newOwner) external {
        require(_assets[assetId].owner == msg.sender, "Not asset owner");
        require(_assets[assetId].isActive, "Asset inactive");
        address oldOwner = _assets[assetId].owner;
        _assets[assetId].owner = newOwner;
        emit AssetTransferred(assetId, oldOwner, newOwner);
    }

    function getAssetInfo(uint256 assetId) external view returns (Asset memory) {
        return _assets[assetId];
    }
}
