let HDWalletProvider = require("truffle-hdwallet-provider");
let mnemonic = "i don't know what it should be.... ";
//address will be: 0x2273066ac87d87ebd4cefd9f7b2c30152a474c5b
let provider = new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/faF0xSQUt0ezsDFYglOe")

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {    
    development: {
      host: "127.0.0.1",
      port: 8545,
      gas: 4500000,
      // gasLimit: 6721975,
		  gasPrice: 40000000000,
      // from: "0x438cb5211D33684d2261877947E2E71913FB255E",
      network_id: "*" // Match any network id
    },
    ganache: {
      host: "127.0.0.1",
      port: 7545,
      gas: 4500000,
		  gasPrice: 40000000000,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: function() {
        return provider
      },
      network_id: 3,
      gas: 4800000,
      gasPrice: 4000000000,
    }
  }
};
