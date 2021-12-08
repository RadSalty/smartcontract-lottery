from brownie import network, config, accounts, MockV3Aggregator
from brownie.network import account, contract
from web3 import Web3

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load[id]

    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]

    return accounts.add(config["wallets"]["from_key"])


contract_to_mock = {"eth_usd_price_feed": MockV3Aggregator}


def get_contract(contract_name):
    """This function will grab the contract addresses from the brownie config if defined,
    otherwise it will deploy a mock version of that contract
    returning that mock contract.

        args:
            contract_name (string)
        retruns:
            brownie.network.contract.ProjectContract: most recently deployed version of this contracts
    """
    contract_type = contract_to_mock[contract_name]
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        if len(contract_type) <= 0:
            deploy_mocks()


def deploy_mocks(decimals=DECIMALS, initial_value=INITIAL_VALUE):
    account = get_account()
    mock_price_feed = MockV3Aggregator.deploy()
