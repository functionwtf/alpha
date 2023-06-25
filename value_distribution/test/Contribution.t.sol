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

        contribution.contribute(address(0x1), 1);

        (address[] memory contributors, uint256[] memory values) = contribution
            .getContributions();

        assertEq(contributors.length, 2);

        // test that the contributions are correct
        for (uint256 i = 0; i < contributors.length; i++) {
            if (contributors[i] == address(this)) {
                assertEq(values[i], 200);
            } else if (contributors[i] == address(0x1)) {
                assertEq(values[i], 1);
            }
        }

        (, uint256[] memory shares) = contribution.getContributorsShare();

        // test that the shares are correct
        for (uint256 i = 0; i < contributors.length; i++) {
            if (contributors[i] == address(this)) {
                assertEq(shares[i], 9950);
            } else if (contributors[i] == address(0x1)) {
                assertEq(shares[i], 49);
            }
        }
    }

    function testResetContributions() public {
        contribution.contribute(address(this), 100);
        contribution.contribute(address(this), 100);

        contribution.reset();

        (address[] memory contributors, uint256[] memory values) = contribution
            .getContributions();

        assertEq(contributors.length, 0);
        assertEq(values.length, 0);
    }
}
