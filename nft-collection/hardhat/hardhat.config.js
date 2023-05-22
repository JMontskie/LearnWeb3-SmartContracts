require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai: {      
      url: process.env.RPC_URL,// the url or rpc of the network
      accounts: [process.env.PRIVATE_KEY]// array of private keys for the account
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  },
};

//DEPLOYED TO : 0x0DE44Eb1fa8E83A9e3AcF4E70e8b09E58D4e69a9