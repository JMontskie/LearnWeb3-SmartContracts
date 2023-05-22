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

//DEPLOYED TO : 0xDA4274BA20Bb178ef5f4551142918C37df96344D
