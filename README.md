# NextId Project

## developing

starting install all node module

```bash
npm install
```


compile contracts:

```bash
truffle compile
```

Migration:

```bash
truffle migrate
```

## Local Testing

starting test contracts on ganache

```bash
truffle test
```

## Rinkeby Testing

Install geth

```bash
brew install geth
```

Start rinkeby

```bash
geth --rinkeby -rpc
```

Open console to unlock account

```bash
geth --datadir=$HOME/.rinkeby attach ipc:$HOME/Library/Ethereum/rinkeby/geth.ipc console
```

Unlock account with expired time

```bash
personal.unlockAccount(eth.accounts[0],"password", 15000)
personal.unlockAccount(eth.accounts[1],"password", 15000)
```

Starting test contracts on Rinkeby

```bash
truffle test --network rinkeby
```

