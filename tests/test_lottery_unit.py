from brownie import Lottery, accounts, config, network
from scripts.deploy import deploy_lottery
from web3 import Web3
import pytest
from scripts.scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS


def test_get_entrance_fee():

    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # arrange
    lottery = deploy_lottery()
    # act
    entrance_fee = lottery.getEntranceFee()
    expected_fee = Web3.toWei(0.025, "ether")
    # assert
    # script assume $2,000 USD eth

    # control + k +c to comment highlighted text
    # assert lottery.getEntranceFee() > Web3.toWei(0.010, "ether")
    # assert lottery.getEntranceFee() < Web3.toWei(0.015, "ether")
    assert expected_fee == entrance_fee


def test_enter_lottery():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    # arrange
    lottery = deploy_lottery()
    # act
    # assert
