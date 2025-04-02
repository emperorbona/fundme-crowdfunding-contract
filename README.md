# Crowdfunding Smart Contract

This project is a decentralized crowdfunding smart contract built using Solidity and Foundry. It allows users to create and contribute to crowdfunding campaigns on the Ethereum network. The contract includes deployment scripts and a helper configuration to facilitate deployment on multiple Ethereum chains.

## Features
- Chainlink Price Feeds for real-time ETH/USD conversion
- Minimum contribution threshold (5 USD equivalent in ETH)
- Secure withdrawal functionality for contract owner
- Optimized gas usage with cheaper withdrawal function
- Comprehensive test suite (unit + integration tests)
- Multi-chain deployment support

## Tech Stack
- **Solidity**: Smart contract language
- **Foundry**: Smart contract development framework
- **Ethereum**: Blockchain network
- **Chainlink Oracles**: For price feed integration

## Setup & Installation

### Prerequisites
Ensure you have Foundry installed. If not, install it with:
```sh
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Clone the Repository
```sh
git clone https://github.com/emperorbona/fundme-crowdfunding-contract.git
cd crowdfunding-contract
```

### Install Dependencies
```sh
forge install
```

## Running Tests
This project includes both **unit tests** and **integration tests** to ensure contract reliability.

Run all tests with:
```sh
forge test
```

Run a specific test:
```sh
forge test --match-test testFunctionName
```

## Deployment
### Local Deployment
```sh
forge script script/Deploy.s.sol --fork-url http://127.0.0.1:8545 --broadcast
```

### Deploying to a Live Network
Modify the `helper-config.s.sol` file with the target network configuration, then deploy:
```sh
forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```
Replace `$RPC_URL` and `$PRIVATE_KEY` with your actual RPC endpoint and private key.

## Smart Contract Overview
### FundMe.sol
This contract allows users to fund campaigns using ETH. Key functionalities:
- Accepts ETH contributions
- Converts ETH to USD using Chainlink price feeds
- Only allows the owner to withdraw funds
- Includes `fallback` and `receive` functions to handle direct ETH transfers

## License
This project is licensed under the MIT License.

## Contributing
Feel free to open an issue or submit a pull request!

## Contact
For any inquiries, reach out via [your contact email or social handle].

