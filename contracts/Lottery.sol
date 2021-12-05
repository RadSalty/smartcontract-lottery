// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

contract Lottery {

    address public owner; // address of the owner

    // constructor initialises as soon as the contract is deployed
    constructor() public {
        owner = msg.sender; // sets the deploying wallet as the owner
    }

    // Function to enter the lottery
    function enter() public {

    }
    // Function to get the required entrance fee in USD
    function getEntranceFee public {

    }

    // creates modifier for owner only functions
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // an owner only requirement to start the lottery
    function startLottery() public onlyOwner {

    }

    // an owner only function to end the lottery
    function endLottery() public onlyOwner {

    }

}