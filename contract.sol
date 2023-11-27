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

    // Helper function to convert string to bytes32
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
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
