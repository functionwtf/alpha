// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

contract Contribution {
    mapping(address => uint256) public contributions;

    function contribute(address contributor, uint256 amount) external {
        contributions[contributor] += amount;
    }
}