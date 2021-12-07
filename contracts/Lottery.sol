// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; // uses the brownie-config file to define where @chainlink is
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; // uses the brownie-config file to define where @chainlink is

contract Lottery {
    using SafeMathChainlink for uint256; //inherits safemath for uint256 so functions do not have to be uses explicitly

    uint256 public usdEntryFee;
    address public owner; // address of the owner
    address payable[] public players;
    AggregatorV3Interface internal ethUsdPriceFeed; // sets the chainlink interface to ethUsdPriceFeed
    enum LOTTERY_STATE {
        OPEN, 
        CLOSED, 
        CALCULATING_WINNER
    } // 0 = Open, 1=Closed, 2=Calculating winner
    LOTTERY_STATE public lottery_state

    // constructor initialises as soon as the contract is deployed
    constructor(address _ethUsdPriceFeed) public {
        usdEntryFee = 50 * (10**18); // sets the entry fee to $50USD
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed); // sets the priceFeed to the address set in the deploy.py, defined in the brownie-config file
        owner = msg.sender; // sets the deploying wallet as the owner
        lottery_state = LOTTERY_STATE.CLOSED;
    }

    // Function to enter the lottery
    function enter() public payable {
        // $50 min buy in
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value >= getEntranceFee(), "Not enough ETH");
        players.push(msg.sender);
    }

    // Function to get the required entrance fee in USD
    function getEntranceFee() public view returns (uint256) {
        (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData(); // calls the AggregatorV3Interface latestRoundData function, which returns 5 variablesm only need the second variable
        uint256 adjustedPrice = uint256(price) * (10**10); // converts int256 to uint256
        uint256 costToEnter = (usdEntryFee * (10**18)) / adjustedPrice;
        return costToEnter;
    }

    // creates modifier for owner only functions ****update this to openzepplin version
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // onlyOwner functions below
    // an owner only requirement to start the lottery
    function startLottery() public onlyOwner {
        require(lottery_state == LOTTERY_STATE.CLOSED, "Lottery is already open");
        lottery_state = LOTTERY_STATE.OPEN;
    }

    // an owner only function to end the lottery
    function endLottery() public payable onlyOwner {}

    // Function to update the entry fee minimum
    function updateEntryFee(uint256 _usdEntryFee) public onlyOwner {
        usdEntryFee = _usdEntryFee * (10**18);
    }
}
