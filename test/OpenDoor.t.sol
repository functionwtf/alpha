// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "forge-std/Test.sol";
import "../src/Counter.sol";

contract YourContractTest {
    function testCheckAccess() public {
        YourContract yourContract = YourContract(DeployedAddresses.YourContract());

        // Define test inputs
        address user = address(0x123);  // Example user address

        // Call the checkAccess function
        bool accessGranted = yourContract.checkAccess(user);

        // Perform assertions to verify the expected behavior
        Assert.isTrue(accessGranted, "Access should be granted");
    }
}
