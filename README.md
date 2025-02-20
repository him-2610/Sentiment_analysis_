// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SentimentVoting {
    // Struct to represent a proposal
    struct Proposal {
        string description;
        uint positiveVotes;
        uint negativeVotes;
    }

    // List of proposals
    Proposal[] public proposals;

    // Mapping to track whether an address has voted on a proposal
    mapping(uint => mapping(address => bool)) public hasVoted;

    // Sentiment analysis keywords (hardcoded for simplicity)
    string[] positiveKeywords = ["good", "excellent", "amazing", "great", "positive"];
    string[] negativeKeywords = ["bad", "terrible", "poor", "negative", "awful"];

    // Function to create a new proposal
    function createProposal(string memory description) public {
        proposals.push(Proposal(description, 0, 0));
    }

    // Function to analyze sentiment and vote accordingly
    function vote(uint proposalId, string memory feedback) public {
        require(proposalId < proposals.length, "Proposal does not exist");
        require(!hasVoted[proposalId][msg.sender], "You have already voted on this proposal");

        // Perform sentiment analysis
        int score = analyzeSentiment(feedback);

        // Register the vote
        if (score > 0) {
            proposals[proposalId].positiveVotes++;
        } else if (score < 0) {
            proposals[proposalId].negativeVotes++;
        }

        // Mark voter as having voted
        hasVoted[proposalId][msg.sender] = true;
    }

    // Internal function to analyze sentiment based on keywords
    function analyzeSentiment(string memory feedback) internal view returns (int) {
        int score = 0;

        // Check for positive keywords
        for (uint i = 0; i < positiveKeywords.length; i++) {
            if (contains(feedback, positiveKeywords[i])) {
                score++;
            }
        }

        // Check for negative keywords
        for (uint i = 0; i < negativeKeywords.length; i++) {
            if (contains(feedback, negativeKeywords[i])) {
                score--;
            }
        }

        return score;
    }

    // Internal helper function to check if a string contains a substring
    function contains(string memory str, string memory substr) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);

        if (substrBytes.length > strBytes.length) {
            return false;
        }

        for (uint i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool match = true;
            for (uint j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    match = false;
                    break;
                }
            }
            if (match) {
                return true;
            }
        }
        return false;
    }

    // Function to get proposal details
    function getProposal(uint proposalId) public view returns (string memory, uint, uint) {
        require(proposalId < proposals.length, "Proposal does not exist");
        Proposal memory proposal = proposals[proposalId];
        return (proposal.description, proposal.positiveVotes, proposal.negativeVotes);
    }
}
