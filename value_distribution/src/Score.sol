// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

contract Score {
    mapping(address => uint256) public scores;

    function addScore(address user, uint256 score) external {
        scores[user] += score;
    }
}
