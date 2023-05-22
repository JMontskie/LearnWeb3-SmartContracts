// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {CRYPTO_DEV_ADDRESS} = require ("../constants");

async function main() {

  const fakeNFTMarketplaceContract = await hre.ethers.getContractFactory("FakeNFTMarketplace");
  const deployedfakeNFTMarketplaceContract = await fakeNFTMarketplaceContract.deploy();
  await deployedfakeNFTMarketplaceContract.deployed();
  console.log(`Deployed to ${deployedfakeNFTMarketplaceContract.address}`);

  const cryptoDevsDaoContract = await hre.ethers.getContractFactory("CryptoDevsDao");
  const deployedcryptoDevsDaoContract = await cryptoDevsDaoContract.deploy(
    deployedfakeNFTMarketplaceContract.address, CRYPTO_DEV_ADDRESS, 
    {value: ethers.utils.parseEther("0.1")}
  );
  await deployedcryptoDevsDaoContract.deployed();
  console.log(`Deployed to ${deployedcryptoDevsDaoContract.address}`);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// DEPLOYED TO: 0xC12D79e3254D0Fc36628Cde05dc4D4034f5AA46b - FakeNFTMarketplace
// DEPLOYED TO: 0xF537EF9163220c278678171CE72E54782D6EB89e - CryotoDevsDAO