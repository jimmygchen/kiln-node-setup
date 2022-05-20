# kiln-node-setup (for MacOS)

Script to set up a Ethereum validator (Kiln) on MacOS 12.3+. Goal is to quickly set up a minority client pair for #TestingTheMerge.

The script assumes that no dependencies have been installed (includig brew, git etc) and will install and build from scratch. The steps are based on the [Ethereum Community's guide](https://notes.ethereum.org/@launchpad/kiln#EthereumJS).

High level steps
- Install dependencies (brew, git, node.js)
- Install Ethereum clients (Lodestar & EthereumJS)
- Generate validator keys
- Start Ethereum clients

## Usage

1. Review the parameters section in the script, and add eth1 withdraw address
2. Run `./setup.sh`

## TODO

- Run validator client

## References

https://notes.ethereum.org/@launchpad/kiln#EthereumJS
