// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Voting {
    // admin that will be only able to add candidates
    address public admin; 
    
    // add Voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        string details; // Additional details about the voter
    }
    // voters
    mapping(address => Voter) public voters;

    // list of candidates
    bytes32[] public candidateList;
    
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

    // CANDIDATES
    // Add a candidate -- only admin can add a candidate
    function addCandidate(bytes32 _candidate) external onlyAdmin {
        require(_candidate != bytes32(0), "Candidate name cannot be empty");
        candidateList.push(_candidate);
    }

    // return a list of all candidates
    function getCandidateList() external view returns (bytes32[] memory) {
        return candidateList;
    }

}
