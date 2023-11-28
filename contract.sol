// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Voting {
    // admin that will be only able to add candidates
    address public admin; 
    
    // Voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        string details; // Additional details about the voter
    }
    // voters
    mapping(address => Voter) public voters;

    // candidate
    struct Candidate {
      string name;
      uint256 votes;
      bytes32 hash;
    }
    // list of candidates
    Candidate[] public candidateList;
    
    // to see address of the winner
    address public winner;

    // voting
    // number of all votes
    mapping (address=> uint256) public allVotesReceived;
    // number of winner votes 
    uint public winnerVotes;
  
    // Modifiers
    // modifier so only admin can call this function
    modifier onlyAdmin{
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    // modifier so only voters can call this function
    modifier onlyVoter() {
        require(voters[msg.sender].isRegistered, "Only registered voters can call this function");
        _;
    }

    // modifier for voters that has not voted
     modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        _;
    }

    // Constructor
    constructor () {
      // store admin address at the time of deployment
      admin = msg.sender;
    }
    // VOTERS
    // Register voter -- only admin can register voter
    function registerVoter(address _voter, string memory _details) external onlyAdmin {
        require(_voter != address(0), "Invalid voter address");
        voters[_voter] = Voter(true, false, _details, bytes32(0));
    }

    // Get voter details, is he registered and his details  
    function getVoterDetails(address _voter) external view returns (string memory) {
        require(voters[_voter].isRegistered, "Voter not registered");
        return voters[_voter].details;
    }

    // Check did voter voted (based on hasVoted property)
    function hasVoterVoted(address _voter) external view returns (bool) {
        return voters[_voter].hasVoted;
    }
    
    // CANDIDATES
    // Add a candidate -- only admin can add a candidate
    function addCandidate(string memory _name) external onlyAdmin {
        require(bytes(_name).length > 0, "Candidate name cannot be empty");
        bytes32 hash = keccak256(bytes(_name));
        candidateList.push(Candidate(_name, 0, hash));
    }

    // return a list of all candidates
    function getCandidateList() external view returns (Candidate[] memory) {
        return candidateList;
    }
    

}
