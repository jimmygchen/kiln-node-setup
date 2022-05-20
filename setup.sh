#!/bin/sh

# Script to set up a Ethereum validator (Kiln) on MacOS 12.3+
#
# Assumptions
# - zsh is default shell
#
# Manual steps:
# - if python is not on path, add symlink: https://dev.to/malwarebo/how-to-set-python3-as-a-default-python-version-on-mac-4jjf

# Parameters
NUM_VALIDATORS=1
ETH_WITHDRAW_ADDRESS=0x
ETH_ROOT_DIR=$HOME/eth
SHELL_RC=$HOME/.zshrc
RUN_SETUP=${1:false}

# Constants - avoid modifying
EL_DATA_DIR=$ETH_ROOT_DIR/el-data
CL_DATA_DIR=$ETH_ROOT_DIR/cl-data
CONFIG_DIR=$ETH_ROOT_DIR/merge-testnets/kiln
JWT_SECRET_PATH=$ETH_ROOT_DIR/jwtsecret

function run_in_new_terminal() {
	osascript -e "tell application \"Terminal\" to do script \"$1\""
}

function start_el_client() {
	mkdir -p $EL_DATA_DIR
	run_in_new_terminal "cd $ETH_ROOT_DIR/ethereumjs-monorepo/packages/client && \
npm run client:start -- --datadir $EL_DATA_DIR \
--gethGenesis $CONFIG_DIR/genesis.json --saveReceipts --rpc --rpcport=8545 \
--ws --rpcEngine --rpcEnginePort=8551 --bootnodes=165.232.180.230:30303 --jwt-secret=$JWT_SECRET_PATH" 
}

function start_cl_client() {
	mkdir -p $CL_DATA_DIR
	run_in_new_terminal "cd $ETH_ROOT_DIR/lodestar && ./lodestar beacon \
--rootDir=$CL_DATA_DIR --paramsFile=$CONFIG_DIR/config.yaml \
--genesisStateFile=$CONFIG_DIR/genesis.ssz --eth1.enabled=true \
--execution.urls=http://127.0.0.1:8551 --network.connectToDiscv5Bootnodes --network.discv5.enabled=true \
--eth1.depositContractDeployBlock=0 \
--jwt-secret=$JWT_SECRET_PATH --network.discv5.bootEnrs=enr:-Iq4QMCTfIMXnow27baRUb35Q8iiFHSIDBJh6hQM5Axohhf4b6Kr_cOCu0htQ5WvVqKvFgY28893DHAg8gnBAXsAVqmGAX53x8JggmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk"
}

function start_val_client() {
	echo "Starting validator client..."
}

function initial_setup() {
	# Install brew (requires password)
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Install git, nvm
	brew install git nvm

	# NVM, Node.js & Yarn setup
	echo 'export NVM_DIR="$HOME/.nvm"
	  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
	  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> $SHELL_RC

	source $SHELL_RC

	# Node.js & Yarn
	nvm install --lts
	corepack enable

	# Set up directories
	mkdir -p $ETH_ROOT_DIR

	# Download kiln config
	cd $ETH_ROOT_DIR && git clone https://github.com/eth-clients/merge-testnets.git

	# Generate JWT secret
	openssl rand -hex 32 | tr -d "\n" > "$JWT_SECRET_PATH"

	# Set up EL client - EthereumJS
	cd $ETH_ROOT_DIR && git clone --depth 1 --branch master https://github.com/ethereumjs/ethereumjs-monorepo.git
	cd ethereumjs-monorepo
	npm i

	# Start CL client - Lodestar
	cd $ETH_ROOT_DIR && git clone https://github.com/chainsafe/lodestar.git
	cd lodestar
	yarn install --ignore-optional
	yarn run build

	# Generate validator keys
	cd $ETH_ROOT_DIR
	curl -LO https://github.com/ethereum/staking-deposit-cli/releases/download/v2.1.0/staking_deposit-cli-ce8cbb6-darwin-amd64.tar.gz
	tar -xzf staking_deposit-cli-ce8cbb6-darwin-amd64.tar.gz --strip-components=2

	./deposit --language English new-mnemonic --num_validators "$NUM_VALIDATORS" --mnemonic_language=English \
		--chain kiln --eth1_withdrawal_address "$ETH_WITHDRAW_ADDRESS"
}

if [[ "$RUN_SETUP" == "true" ]]; then
	initial_setup
fi

# Start eth clients
start_el_client
start_cl_client
start_val_client

echo "Completed"
