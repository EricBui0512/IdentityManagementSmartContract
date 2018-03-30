let HDWalletProvider = require("truffle-hdwallet-provider");
let mnemonic = "i don't know what it should be.... ";
//address will be: 0x2273066ac87d87ebd4cefd9f7b2c30152a474c5b
let provider = new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/faF0xSQUt0ezsDFYglOe")


console.log(provider.wallet._privKey.toString("hex"));