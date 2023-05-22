// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {ICO_CONTRACT_ADDRESS} = require ("../constants");

async function main() {
  const exchangeContract = await hre.ethers.getContractFactory("Exchange");
  const deployedExchangeContract = await exchangeContract.deploy(
    ICO_CONTRACT_ADDRESS
  );

  await deployedExchangeContract.deployed();
  console.log(`Deployed to ${deployedExchangeContract.address}`);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// DEPLOYED TO: 0x690Af31eb7B052F5816Ae63Cf0eB06729eCbd408