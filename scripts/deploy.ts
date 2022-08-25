import { ethers } from "hardhat";

async function main() {


  const lottery = await ethers.getContractFactory("lottery");
  const Lottery = await lottery.deploy();

  await Lottery.deployed();

  console.log(`contract deployed to ${Lottery.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
