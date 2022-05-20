# kiln-node-setup (for MacOS)

Script to set up a Ethereum node on the Kiln merge testnet. Tested on MacOS 12.3+ only. Goal is to quickly set up a minority client (Lodestar + EthereumJS) pair for #TestingTheMerge.

The script assumes that no dependencies have been installed (includig brew, git, node.js etc) and will install and build from scratch. The steps are based on the [Ethereum Community's guide](https://notes.ethereum.org/@launchpad/kiln#EthereumJS).

High level steps
1. Install dependencies (brew, git, node.js)
2. Install Ethereum clients (Lodestar & EthereumJS)
3. Generate validator keys
4. Start Ethereum clients
5. Manual: make deposit with [Kiln Launchpad](https://kiln.launchpad.ethereum.org/en/)

## Usage

1. Review the parameters section in [setup.sh](./setup.sh), and add eth1 withdraw address
2. For initial setup, run `./setup.sh`
3. For subsequent restarts, run `./setup.sh false`

### Script Usage

```
# RUN_SETUP: boolean flag, for first run, set this to true to install
# RUN_VALIDATOR: boolean flag, whether to generate validator keys and run validators
./setup.sh [RUN_SETUP] [RUN_VALIDATOR]

# Examples
./setup.sh true true # run installation + validator key gen + eth nodes + validator
./setup.sh false true # run eth nodes + validator
./setup.sh true false # run installation + eth nodes only
./setup.sh false false # run eth nodes only
```

## References

https://notes.ethereum.org/@launchpad/kiln#EthereumJS
https://kiln.themerge.dev
