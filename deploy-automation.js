const hre = require("hardhat");

async function main() {
  const Automation = await hre.ethers.getContractFactory("AutomationManager");
  const automation = await Automation.deploy();

  await automation.waitForDeployment();
  console.log("Automation Engine deployed to:", await automation.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
