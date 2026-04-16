// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainSignatureVerifier {
    function verifySignature(address signer, bytes32 hash, bytes memory signature) external pure returns (bool) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        if (v < 27) v += 27;
        return signer == ecrecover(hash, v, r, s);
    }
}
