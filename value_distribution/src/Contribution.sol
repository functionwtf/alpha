// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";

contract Contribution {
    uint256 constant PRECISION = 10_000;

    using EnumerableMap for EnumerableMap.AddressToUintMap;
    EnumerableMap.AddressToUintMap contributions;
    uint256 public totalContributions;

    function contribute(address contributor, uint256 amount) external {
        (, uint256 currentAmount) = contributions.tryGet(contributor);
        contributions.set(contributor, currentAmount + amount);
        totalContributions += amount;
    }

    function getContributions()
        external
        view
        returns (address[] memory, uint256[] memory)
    {
        uint256 length = contributions.length();
        address[] memory contributors = new address[](length);
        uint256[] memory values = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            (contributors[i], values[i]) = contributions.at(i);
        }
        return (contributors, values);
    }

    function reset() external {
        for (uint256 i = 0; i < contributions.length(); i++) {
            (address key, ) = contributions.at(i);
            contributions.remove(key);
        }
    }

    function getContributorsShare()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        uint256 length = contributions.length();
        address[] memory contributors = new address[](length);
        uint256[] memory values = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            (contributors[i], values[i]) = contributions.at(i);
            values[i] = (values[i] * PRECISION) / totalContributions;
        }
        return (contributors, values);
    }
}
