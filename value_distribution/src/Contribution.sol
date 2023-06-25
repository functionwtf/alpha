// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/structs/EnumerableMap.sol";

contract Contribution {
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
        address[] memory keys = new address[](length);
        uint256[] memory values = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            (keys[i], values[i]) = contributions.at(i);
        }
        return (keys, values);
    }

    function reset() external {
        uint256 length = contributions.length();
        for (uint256 i = 0; i < length; i++) {
            (address key, ) = contributions.at(i);
            contributions.remove(key);
        }
    }
}
