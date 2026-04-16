// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainCertificate {
    struct Certificate {
        string certId;
        string holderName;
        uint256 issueTime;
        bool valid;
    }

    mapping(string => Certificate) public certificates;

    event CertificateIssued(string indexed certId, string holderName);
    event CertificateRevoked(string indexed certId);

    function issueCertificate(string calldata certId, string calldata holderName) external {
        certificates[certId] = Certificate({
            certId: certId,
            holderName: holderName,
            issueTime: block.timestamp,
            valid: true
        });
        emit CertificateIssued(certId, holderName);
    }

    function revokeCertificate(string calldata certId) external {
        certificates[certId].valid = false;
        emit CertificateRevoked(certId);
    }
}
