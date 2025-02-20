pragma solidity ^0.8.0;

contract SentimentVoting {
    struct Proposal {
        uint256 id;
        string description;
        uint256 positiveVotes;
        uint256 negativeVotes;
    }

    uint256 private proposalCount;
    mapping(uint256 => Proposal) private proposals;

    event ProposalCreated(uint256 id, string description);
    event VoteCast(uint256 proposalId, bool sentiment, address voter);

    function createProposal(string memory _description) public returns (uint256) {
        proposalCount++;
        uint256 proposalId = proposalCount;
        proposals[proposalId] = Proposal({
            id: proposalId,
            description: _description,
            positiveVotes: 0,
            negativeVotes: 0
        });

        emit ProposalCreated(proposalId, _description);
        return proposalId;
    }

    function vote(uint256 _proposalId, bool _sentiment) public {
        Proposal storage proposal = proposals[_proposalId];
        require(bytes(proposal.description).length > 0, "Proposal does not exist");

        if (_sentiment) {
            proposal.positiveVotes++;
        } else {
            proposal.negativeVotes++;
        }

        emit VoteCast(_proposalId, _sentiment, msg.sender);
    }

    function getProposal(uint256 _proposalId)
        public
        view
        returns (
            uint256,
            string memory,
            uint256,
            uint256
        )
    {
        Proposal memory proposal = proposals[_proposalId];
        return (
            proposal.id,
            proposal.description,
            proposal.positiveVotes,
            proposal.negativeVotes
        );
    }

    function getOverallSentiment(uint256 _proposalId) public view returns (string memory) {
        Proposal memory proposal = proposals[_proposalId];
        require(bytes(proposal.description).length > 0, "Proposal does not exist");

        if (proposal.positiveVotes > proposal.negativeVotes) {
            return "Positive";
        } else if (proposal.positiveVotes < proposal.negativeVotes) {
            return "Negative";
        } else {
            return "Neutral";
        }
    }

    function getTotalProposals() public view returns (uint256) {
        return proposalCount;
    }
}
