// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Voting {
    // Voter
    struct Voter {
        string name; // Voter name
        bool isRegistered; // is Registered for voting
        bool hasVoted; // did voter already voted
        address voterAddress; // address of the voter
        address candidateAddress; // index of candidate voted for
    }

    // Candidate
    struct Candidate {
      string name;
      uint256 voteCount;
      address candidateAddress;
    }
    // admin that will be only able to add candidates
    address public admin; // will use to on modifier 
    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters; // will use on modifier
    
    // List of voters
    Voter[] public votersList;
    // list of candidates
    Candidate[] public candidateList;
     // number of all votes
    uint256 allVotesReceived;
    
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
    function registerVoter(string memory _name, address _address) external onlyAdmin {
        require(_address != address(0), "Invalid voter address");
        require(!voters[_address].isRegistered, "Voter is already registred");
        voters[_address] = Voter(_name, true, false, _address, -1);
        votersList.push(voters[_address]);
    }

    // Get voter details, is he registered and his details  
    function getVoterName(address _address) external view returns (string memory) {
        require(voters[_address].isRegistered, "Voter not registered");
        return voters[_address].name;
    }

    // Get all registred voters
    function getVotersList() external view returns(Voter[] memory){
         return votersList;
    }
    
    // CANDIDATES
    // Add a candidate -- only admin can add a candidate
    function addCandidate(string memory _name, address _address) external onlyAdmin {
        require(bytes(_name).length > 0, "Candidate name cannot be empty");
        require(_address != address(0), "Invalid candidate address");
        require(!candidateExists(_address), "Candidate already exists");
        candidateList.push(Candidate(_name, 0, _address));
    }
    
    // return a list of all candidates
    function getCandidateList() external view returns (Candidate[] memory) {
        return candidateList;
    }

    // VOTE
    // Cast a vote. 
    // Rules:
    //  - Only voter that didn't vote can vote
    //  - We can vote only for valid candidate
    // After successful voting Add those votes to received votes and set voter status to has voted
    function vote(address _candidateAddress) external onlyVoter hasNotVoted {
        require(candidateExists(_candidateAddress), "Invalid candidate");
        // increase number of votes
        allVotesReceived++;
        updateCandidateVotes(_candidateAddress); // update votes for candidate
        voters[msg.sender].hasVoted = true; // set voter hasVoted attribute to true
        voters[msg.sender].candidateAddress = _candidateAddress; // save candidate address to voter
    }  

    // check if is valid candidate for voting by checking a candidate list
    function candidateExists(address _candidateAddress) internal view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i].candidateAddress == _candidateAddress) {
                return true;
            }
        }
        return false;
    }

    // get vote count for candidate
    function getVoteCountForCandidate(address _candidateAddress) external view returns (uint256) {
        require(candidateExists(_candidateAddress), "Invalid candidate");
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i].candidateAddress == _candidateAddress) {
                return candidateList[i].voteCount;
            }
        }
        return 0;
    }
    // helper function to update candidate votes
    function updateCandidateVotes(address _candidateAddress) internal {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i].candidateAddress == _candidateAddress) {
                candidateList[i].voteCount++;
                break;
            }
        }
    }

    // how many people voted
    function getAllRecievedVotes() external view returns(uint256){
        return allVotesReceived;
    }

    // WINNER
    // return as winner candidate with most votes
    function getWinner() external view returns (Candidate memory winner) {
        require(candidateList.length > 0, "No candidates available");

        winner = candidateList[0]; // Initialize with the first candidate
        uint256 maxVotes = winner.voteCount;

        for (uint256 i = 1; i < candidateList.length; i++) {
            if (candidateList[i].voteCount > maxVotes) {
                winner = candidateList[i];
                maxVotes = winner.voteCount;
            }
        }
    }

    

}
