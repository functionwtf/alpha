// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Distribution.sol";
import "../src/Contribution.sol";
import "../src/Score.sol";

contract DistributionTest is Test {
    Distribution public distribution;
    Contribution public contribution;
    Score public score;

    function setUp() public {
        contribution = new Contribution();
        score = new Score();

        distribution = new Distribution(
            1_000_000,
            address(contribution),
            address(score)
        );

        contribution.contribute(address(this), 100);
        contribution.contribute(address(this), 100);

        contribution.contribute(address(0x1), 1);
    }

    function testDistribution() public {
        assertEq(distribution.getPendingDistribution(), 0);
        vm.warp(101);
        uint256 expectedDistribution = 100 * 1_000_000;
        assertEq(distribution.getPendingDistribution(), expectedDistribution);

        distribution.distribute();

        assertEq(
            score.scores(address(this)),
            (expectedDistribution * 9950) / 10000
        );
        assertEq(
            score.scores(address(0x1)),
            (expectedDistribution * 49) / 10000
        );
    }
}
