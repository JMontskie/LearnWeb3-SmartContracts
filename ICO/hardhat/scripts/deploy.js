// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {NFT_CONTRACT_ADDRESS} = require ("../constants");

async function main() {
  const cryptoDevsTokenContract = await hre.ethers.getContractFactory("CryptoDevsToken");
  const deployedCryptoDevsTokenContract = await cryptoDevsTokenContract.deploy(
    NFT_CONTRACT_ADDRESS
  );

  await deployedCryptoDevsTokenContract.deployed();
  console.log(`Deployed to ${deployedCryptoDevsTokenContract.address}`);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// DEPLOYED TO: 0xBFE97c0CFaFCDc73574dAdf9098f34Fd14E05041