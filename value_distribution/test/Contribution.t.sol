// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Contribution.sol";

contract ContributionTest is Test {
    Contribution public contribution;

    function setUp() public {
        contribution = new Contribution();
    }

    function testContribution() public {
        contribution.contribute(address(this), 100);
        contribution.contribute(address(this), 100);

        contribution.contribute(address(0x1), 100);

        (address[] memory keys, uint256[] memory values) = contribution
            .getContributions();
        (keys, values) = contribution.getContributions();

        for (uint256 i = 0; i < keys.length; i++) {
            if (keys[i] == address(this)) {
                assertEq(values[i], 200);
            } else if (keys[i] == address(0x1)) {
                assertEq(values[i], 100);
            }
        }
    }
}
