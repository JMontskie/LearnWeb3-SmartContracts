// ehtersJS - this is used to interact with the smart contract
// ethersJS is installed automatically after installing hardhat

const {ethers} = require('hardhat');

// 
async function main() {
  /*
    ContractFactory used to deploy new smart contracts.
    Makes whitelistContract a
  */
  const whitelistContract = await ethers.getContractFactory("Whitelist");

  // deploys the smart contract
  const deplyoyedwhitelistContract = await whitelistContract.deploy(10);

  // wait for the deployment to be finished.
  await deplyoyedwhitelistContract.deployed();

  // log to see the smart contract adddress
  console.log(`Contract deployed to: ${deplyoyedwhitelistContract.address}`);

}

main() 
  .then(() => process.exit(0))

  //catch errors during deployment
  .catch((err) =>{
    console.error(err);
    process.exit(1);
  })

  // DEPLOYED TO: 0xDA4274BA20Bb178ef5f4551142918C37df96344D