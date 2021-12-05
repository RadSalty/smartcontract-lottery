// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; // uses the brownie-config file to define where @chainlink is
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; // uses the brownie-config file to define where @chainlink is


contract Lottery {
    using SafeMathChainlink for uint256; //inherits safemath for uint256 so functions do not have to be uses explicitly
    
    address public owner; // address of the owner
    address payable[] public players;
    AggregatorV3Interface public priceFeed; // sets the chainlink interface to pricefeed

    // constructor initialises as soon as the contract is deployed
    constructor() public {
        priceFeed = AggregatorV3Interface(_priceFeed); // sets the priceFeed to the address set in the deploy.py, defined in the brownie-config file
        owner = msg.sender; // sets the deploying wallet as the owner
    }

    // Function to enter the lottery
    function enter() public payable {
        // $50 min buy in
        getEntranceFee()
        players.push(msg.sender);
    }

    // Function to get the required entrance fee in USD
    function getEntranceFee public view return(uint256) {

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