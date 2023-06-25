// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

contract Distribution  {
    uint256 public distributionRate;
    uint256 public lastDistribution;

    constructor(uint256 _distributionRate) {
        distributionRate = _distributionRate;
        lastDistribution = block.timestamp;
    }

    function distribute() external {
        uint256 timePassed = block.timestamp - lastDistribution;
        uint256 amountToDistribute = (timePassed * distributionRate);
        lastDistribution = block.timestamp;
        // TODO: distribute amountToDistribute
    }
}
