// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Voting {
    // admin that will be only able to add candidates
    address public admin; 
    // voters
    mapping(address => bool) public voters;

    // list of candidates
    address[] public candidates;
  
    // to see address of the winner
    address public winner;

    // voting
    // number of all votes
    mapping (address=> uint256) public allVotesReceived;
    // number of winner votes 
    uint public winnerVotes;
  
    constructor () {
      // store admin address at the time of deployment
      admin = msg.sender;
    }

    // added modifier so only admin can call this function
    modifier onlyAdmin{
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // added modifier so only registered voter can call this function
    modifier onlyRegistredVoter{
        require(voters[msg.sender], "Only registered voters can call this function");
        _;
    }

}
