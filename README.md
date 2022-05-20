# kiln-node-setup (for MacOS)

A script to set up a Ethereum node on the Kiln merge testnet. Goal is to quickly set up a minority client (Lodestar + EthereumJS) pair for #TestingTheMerge. Tested on MacOS 12.3 only. 

NOTE: This script is intended for myself to quickly setting up a node on an old laptop with minimal dependencies (e.g. no docker due to resource constraints), but may be useful for someone that wants to quickly start a node pair on MacOS. There are many amazing guides out there to better set this up, e.g.
- [EthStaker guide](https://github.com/remyroy/ethstaker/blob/main/merge-devnet.md)
- [Eth Docker](https://github.com/eth-educators/eth-docker/blob/merge/KILN.md)
- [Ethereum Community](https://notes.ethereum.org/@launchpad/kiln)

The script assumes that minimal dependencies installed (includig brew, git, node.js etc) and will install and build from scratch. The steps are based on the [Ethereum Community's guide](https://notes.ethereum.org/@launchpad/kiln#EthereumJS).

High level steps:
1. Install dependencies (brew, git, node.js)
2. Install and build Ethereum clients (Lodestar & EthereumJS)
3. (Optional) Generate validator keys
4. Start Ethereum clients
5. Manual: make deposit with [Kiln Launchpad](https://kiln.launchpad.ethereum.org/en/)

## Usage

1. Review the parameters section in [setup.sh](./setup.sh), and add eth1 withdraw address
2. For initial setup, run `./setup.sh`
3. For subsequent restarts (skips installation), run `./setup.sh false` 

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
