// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol"; // uses the brownie-config file to define where @chainlink is
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; // uses the brownie-config file to define where @chainlink is
import "@openzeppelin/contracts/access/Ownable.sol"; // Uses open zeppelin ownable versions
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; // uses chainlink random number

// inherit ownable & VRFConsumerBase
contract Lottery is Ownable, VRFConsumerBase {
    using SafeMathChainlink for uint256; // using safemath for uint256 so functions do not have to be uses explicitly

    uint256 public usdEntryFee;
    address payable[] public players;
    address payable public recentWinner;
    uint256 public randomness;
    AggregatorV3Interface internal ethUsdPriceFeed; // sets the chainlink interface to ethUsdPriceFeed
    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    } // 0 = Open, 1=Closed, 2=Calculating winner
    LOTTERY_STATE public lottery_state;
    uint256 public fee; // fee payable for link random number generator
    bytes32 public keyhash;

    // constructor initialises as soon as the contract is deployed
    constructor(
        address _ethUsdPriceFeed,
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) public VRFConsumerBase(_vrfCoordinator, _link) {
        usdEntryFee = 50 * (10**18); // sets the entry fee to $50USD
        ethUsdPriceFeed = AggregatorV3Interface(_ethUsdPriceFeed); // sets the priceFeed to the address set in the deploy.py, defined in the brownie-config file
        lottery_state = LOTTERY_STATE.CLOSED;
        fee = _fee;
        keyhash = _keyhash;
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

    // onlyOwner functions below

    // an owner only requirement to start the lottery
    function startLottery() public onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "Lottery is already open"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    // an owner only function to end the lottery
    function endLottery() public payable onlyOwner {
        lottery_state == LOTTERY_STATE.CALCULATING_WINNER; // STOPS OTHER FUNCTIONS BEING CALLED
        bytes32 requestId = requestRandomness(keyhash, fee);
    }

    // Receives the chainlink random number, set to internal so only VRF co-ordinator can call, override function called to overrise the inherited function
    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        require(
            lottery_state == LOTTERY_STATE.CALCULATING_WINNER,
            "You aren't there yet!"
        ); // ensures lotter in the correct state
        require(_randomness > 0, "random-not-found"); // ensures random number works
        uint256 indexOfWinner = _randomness % players.length;
        recentWinner = players[indexOfWinner];
        recentWinner.transfer(address(this).balance);
        // Reset lottery
        players = new address payable[](0);
        lottery_state = LOTTERY_STATE.CLOSED;
        randomness = _randomness;
    }

    // Function to update the entry fee minimum
    function updateEntryFee(uint256 _usdEntryFee) public onlyOwner {
        usdEntryFee = _usdEntryFee * (10**18);
    }
}
