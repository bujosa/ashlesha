// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ICounterFacet {
    /**
     * @dev Increement the number by 1.
     */
    function increment() external;

    /**
     * @dev Allows the user set the number of the counter
     */
    function setNumber(uint256 newNumber) external;
}
