from brownie import Lottery, accounts, config, network
from web3 import Web3

test_entrance_fee():
    account = accounts[0]
    lottery = Lottery.deploy(config['networks'][network.show_active()]['eth_usd_price_feed'], {'from':account})
    
    assert lotter.getEntranceFee() > Web3.toWei(0.010,'ether')
    assert lotter.getEntranceFee() < Web3.toWei(0.015,'ether')