//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
//@authur: BalckAdam.
//@ the deployer of the contract sets the lucky number;
//each user is allowed to play once and there is a timeframe of 1minute for users to play 
//after the deadline, the deployer of the owner release the luckynumber(getLuckyNUmber);
//and he publish the list of winners.

contract lottery{
    address owner;

    //the luckynumber is declared here
    uint luckyNumber;
   
   //this array keep tracks of addresses that got the number right
    address[] luckyWinner;

    // the deadline for the lottery is one minute
    uint deadline = block.timestamp + 60 seconds;

    //this mapping keep tracks of players(addresses) and the number they entered(luckynumber)
    mapping(address => uint) playerDetails;

    //this mapping is keeping tracks of players(addresses) that i've played(enter a number)
    mapping(address => bool) playbefore;

    //this is used to restrict some certain functions to the owner alone
    modifier onlyOwner{
        require(msg.sender == owner, "Access denied");
        _;
    }

    //this mapping restrict a player(address) to only play once
    modifier played{
        require(playbefore[msg.sender] == false, "already play");
        _;
    }

    //This mapping keep tracks of time
    modifier elapsed{
        require(deadline >= block.timestamp, "time has elapsed");
        _;
    }

    //set the msg.sender to the owner of the contracts
    constructor(){
        owner = msg.sender;
    }

    //The lucky number is set here by the owner(deployer of the contract)
    function setLuckyNumber(uint _num) external onlyOwner{
        luckyNumber = _num;
    }

    //the user/players enters there lucky number here
    function playLottery(uint _luckynum) external played elapsed{
        //here, i'm verifying that the lucky number has been set, the default number is 0.
        //i'm making sure that the owner has set the number to any number above 0
        //With this players will know that the lucky number has been set
        require(luckyNumber > 0, "number hasn't been set");

        //here we set the players to true to avoid them playing twice
        playbefore[msg.sender] = true;
        //we keep track of the number entered by the player here
        playerDetails[msg.sender] = _luckynum;

        //we assigned the number entered to res
        uint res =  playerDetails[msg.sender];

        //i checked if the number enetered(res) by the player is the same as the lucky number set by the owner
          if(res == luckyNumber){

        //if it's true i pushed the address to the array(luckyWinner) that i declared up
              luckyWinner.push(msg.sender);   
          }
    }

    //this function returns the array of players(addresses) that got the answer right
    //it also makes sure that the time has elapsed before the addressess can be displayed
    function getWinner() public view elapsed returns(address[] memory){
        return luckyWinner;
    }

    //this function returns the luckyNumbee that was set by the owner
    //it also makes sure that the time has elapsed before the number is revealed
    //it restrict this function to only the owner of the contracts
    function getLuckyNumber() external view onlyOwner elapsed returns(uint){
        return luckyNumber;
    }

}