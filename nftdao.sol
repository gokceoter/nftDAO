pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTDAO is ERC721 {
    // Mapping to store proposal information
    mapping (uint => Proposal) public proposals;
    // Array to store the NFT token IDs of valid voters
    uint[] public validVoters;

    // Struct to store information about a proposal
    struct Proposal {
        address creator;
        string statement;
        uint voteCount;
    }

    // Event to notify when a proposal is added
    event ProposalAdded(address proposer, uint proposalId);
    // Event to notify when a vote is cast
    event VoteCast(address voter, uint proposalId);

    // Modifier to check if the caller is a valid voter
    modifier onlyValidVoters {
        require(validVoters.indexOf(ERC721.tokenOfOwnerByIndex(msg.sender, 0)) != -1, "Sender is not a valid voter.");
        _;
    }

    // Constructor function to initialize the contract
    constructor() public ERC721("NFTDAO", "NFTDAO") {
        // Add the contract creator's first NFT token as a valid voter
        validVoters.push(tokenOfOwnerByIndex(msg.sender, 0));
    }

    // Function to propose a new statement
    function propose(string memory statement) public onlyValidVoters {
        require(ownerOf(validVoters[0]) == msg.sender, "Sender is not a valid voter.");
        proposals[proposals.length].creator = msg.sender;
        proposals[proposals.length].statement = statement;
        emit ProposalAdded(msg.sender, proposals.length - 1);
    }

    // Function to cast a vote for a proposal
    function vote(uint proposalId) public onlyValidVoters {
        proposals[proposalId].voteCount++;
        emit VoteCast(msg.sender, proposalId);
    }
}
