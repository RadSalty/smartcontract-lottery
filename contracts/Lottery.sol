// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; // uses the brownie-config file to define where @chainlink is

contract Lottery {
    using SafeMathChainlink for uint256; //inherits safemath for uint256 so functions do not have to be uses explicitly
    
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

    // onlyOwner functions below
    // an owner only requirement to start the lottery
    function startLottery() public onlyOwner {

    }

    // an owner only function to end the lottery
    function endLottery() public payable onlyOwner {

    }

}