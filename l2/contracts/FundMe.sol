// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.6 < 0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/srv/v0.6/vendor/SafeMathChainLink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
     
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable { // payable para que acepte payments
        uint256 minUSD = 50 * 10 ** 18; // min 50 USD
        require(getConversionRate(msg.value) >= minUSD, "Transacción no llega al mínimo de 50 USD"); // estilo assert
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); // address ETH-USD en Rinkeby
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); // address ETH-USD en Rinkeby
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice *ethAmount) / 1000000000000000000;

        return ethAmountInUsd;
    }

    modifier onlyOwner { // permite modificar otros métodos del contrato
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public { 
        msg.sender.transfer(address(this).balance);
        
        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        } // reset de balance de senders

        funders = new address[](0);
    }
}