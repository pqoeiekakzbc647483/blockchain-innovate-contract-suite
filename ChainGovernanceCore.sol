// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainGovernanceCore {
    struct Proposal {
        string title;
        string description;
        uint256 voteFor;
        uint256 voteAgainst;
        uint256 endTime;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    uint256 public votingDuration = 3 days;

    event ProposalCreated(uint256 indexed proposalId, string title);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);

    function createProposal(string calldata title, string calldata description) external returns (uint256) {
        proposals.push(Proposal({
            title: title,
            description: description,
            voteFor: 0,
            voteAgainst: 0,
            endTime: block.timestamp + votingDuration,
            executed: false
        }));
        emit ProposalCreated(proposals.length - 1, title);
        return proposals.length - 1;
    }

    function vote(uint256 proposalId, bool support) external {
        require(proposalId < proposals.length, "Invalid proposal");
        require(block.timestamp < proposals[proposalId].endTime, "Voting ended");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        hasVoted[msg.sender][proposalId] = true;
        if (support) proposals[proposalId].voteFor++;
        else proposals[proposalId].voteAgainst++;

        emit Voted(proposalId, msg.sender, support);
    }

    function getProposalCount() external view returns (uint256) {
        return proposals.length;
    }
}
