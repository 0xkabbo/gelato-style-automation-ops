// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title AutomationManager
 * @dev Manages and executes automated blockchain tasks.
 */
contract AutomationManager is ReentrancyGuard {
    struct Task {
        address creator;
        address target;
        bytes execData;
        uint256 lastExecuted;
        uint256 interval;
        bool active;
    }

    mapping(uint256 => Task) public tasks;
    mapping(address => uint256) public gasTanks;
    uint256 public nextTaskId;

    event TaskCreated(uint256 indexed taskId, address indexed target);
    event TaskExecuted(uint256 indexed taskId, uint256 timestamp);

    function depositGas() external payable {
        gasTanks[msg.sender] += msg.value;
    }

    function createTask(address _target, bytes calldata _execData, uint256 _interval) external {
        tasks[nextTaskId] = Task({
            creator: msg.sender,
            target: _target,
            execData: _execData,
            lastExecuted: block.timestamp,
            interval: _interval,
            active: true
        });
        emit TaskCreated(nextTaskId++, _target);
    }

    /**
     * @dev Executed by an authorized automation bot.
     */
    function execute(uint256 _taskId) external nonReentrant {
        Task storage t = tasks[_taskId];
        require(t.active, "Task inactive");
        require(block.timestamp >= t.lastExecuted + t.interval, "Too soon");
        
        uint256 startGas = gasleft();
        
        (bool success, ) = t.target.call(t.execData);
        require(success, "Execution failed");

        t.lastExecuted = block.timestamp;
        
        // Calculate gas used and reimburse executor from creator's gas tank
        uint256 gasUsed = (startGas - gasleft() + 50000) * tx.gasprice;
        require(gasTanks[t.creator] >= gasUsed, "Insufficient gas tank");
        gasTanks[t.creator] -= gasUsed;
        payable(msg.sender).transfer(gasUsed);

        emit TaskExecuted(_taskId, block.timestamp);
    }
}
