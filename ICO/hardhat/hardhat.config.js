require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      url: process.env.RPC_URL, // JSON PRC server address
      accounts: [process.env.PRIVATE_KEY] // insert whitelisted addresses here
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  },
};
