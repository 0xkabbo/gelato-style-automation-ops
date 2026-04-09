# Smart Contract Automation (Gelato-style)

A professional-grade implementation for "Autonomous Smart Contracts." This repository solves the "Passive Contract" problem where Solidity code cannot execute itself. By using a network of decentralized executors, this system monitors on-chain and off-chain triggers to call functions automatically, enabling features like limit orders, liquidations, and recurring payments.

## Core Features
* **Time-Based Triggers:** Execute a function every $X$ blocks or at a specific Unix timestamp.
* **State-Based Triggers:** Monitor a contract variable (e.g., price drop below $Y$) to trigger defensive actions.
* **Off-chain Resolvers:** Advanced logic that runs in a secure sandbox to decide if a transaction is needed, saving gas on-chain.
* **Flat Architecture:** Single-directory layout for the Task Manager, Execution Relay, and Fee Treasury.



## Logic Flow
1. **Register:** A developer submits a "Task" (e.g., `harvestYield()`) and defines the trigger condition.
2. **Deposit:** The developer funds the "Gas Tank" with ETH or USDC.
3. **Monitor:** The automation network continuously checks the `checker()` function.
4. **Execute:** Once the checker returns `true`, an executor submits the transaction and is reimbursed from the gas tank.

## Setup
1. `npm install`
2. Deploy `AutomationManager.sol`.
