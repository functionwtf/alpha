// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

import "./Contribution.sol";
import "./Score.sol";

contract Distribution {
    uint256 constant PRECISION = 10_000;

    uint256 public distributionRate;
    uint256 public lastDistribution;

    Contribution contribution;
    Score score;

    constructor(
        uint256 _distributionRate,
        address _contributionAddress,
        address _scoreAddress
    ) {
        distributionRate = _distributionRate;
        lastDistribution = block.timestamp;
        contribution = Contribution(_contributionAddress);
        score = Score(_scoreAddress);
    }

    function distribute() external {
        uint256 amountToDistribute = getPendingDistribution() / PRECISION;
        lastDistribution = block.timestamp;
        (address[] memory contributors, uint256[] memory shares) = contribution
            .getContributorsShare();

        uint256 contributorsLength = contributors.length;

        for (uint256 i = 0; i < contributorsLength; ++i) {
            score.addScore(contributors[i], amountToDistribute * shares[i]);
        }
        contribution.reset();
    }

    function getPendingDistribution() public view returns (uint256) {
        uint256 timePassed = block.timestamp - lastDistribution;
        uint256 amountToDistribute = timePassed * distributionRate;
        return amountToDistribute;
    }
}
