require 'eth'
require 'ethereum.rb'
require 'pry-rails'
require 'json'
# require 'web3ethereum'

LOCAL_ETHEREUM_NODE_URL="HTTP://127.0.0.1:7545"
NFT_ABI_PATH="./build/contracts/NFT.json"

NFT_PATH="./contracts/NFT.sol"
PRIVATE_KEY=""

# MUMBAI_NODE_URL='https://matic-mumbai.chainstacklabs.com'

def init_contract
    @client = Ethereum::HttpClient.new(LOCAL_ETHEREUM_NODE_URL)
    abi = JSON.parse(File.read(NFT_ABI_PATH))['abi']
    @key = Eth::Key.new(priv: @private_key)
    code = @client.eth_get_code(@key.address)["result"]

    @contract = Ethereum::Contract.create(name: "NFT", abi: abi, client: @client, code: code)
    @client.get_nonce(@key.address)
    @contract.key = @key
    @contract.nonce = @client.get_nonce(@key.address)
end

def contract_deploy
    @contract.key = @key
    amount=5000000
    contract_address = @contract.deploy_and_wait(amount)

    puts "contract_address ---------"
    puts contract_address
end

def contract_call_method
    puts "contract_call_method ------"
    puts @contract.call.hello
end

binding.pry
init_contract
contract_deploy
contract_call_method


@contract = Ethereum::Contract.create(file: NFT_PATH)