
require 'eth'
require 'ethereum.rb'
require 'pry-rails'
require 'json'
require './src/eth_caller.rb'
# include EthCaller

LOCAL_ETHEREUM_NODE_URL="HTTP://127.0.0.1:7545"
NFT_ABI_PATH="./build/contracts/NFT.json"
PRIVATE_KEY=""
CONTRACT_ADDRESS=""
CONTRACT_NAME="NFT"

# MUMBAI_NODE_URL='https://matic-mumbai.chainstacklabs.com'

def init_contract
    @client = Ethereum::HttpClient.new(LOCAL_ETHEREUM_NODE_URL)
    @abi = JSON.parse(File.read(NFT_ABI_PATH))['abi']
    @key = Eth::Key.new(priv: PRIVATE_KEY)
    @code = @client.eth_get_code(@key.address)["result"]
end

def get_contract
    @contract = EthCaller.create_contract_from_address(CONTRACT_NAME, CONTRACT_ADDRESS, @client)
end

def contract_method_call
    address = @client.default_account
    @contract.call.mint(from: CONTRACT_ADDRESS, value: 10, gas: @client.gas_limit )
end

init_contract
get_contract
contract_method_call
