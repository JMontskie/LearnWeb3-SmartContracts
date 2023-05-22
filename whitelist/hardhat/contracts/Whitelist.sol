// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract  Whitelist {

    // max number of allowed addresses to access your smart contract
    uint8 public maxWhitelistAddresses;

    // Create mapping of whitelisted Addresses
    // If an address is whitelisted, set it to true, the default value is false for all other addresses
    mapping (address => bool) whitelistedAddresses;

    // counter, counts number of white addresses in smart contract
    uint8 public numWhitelistedAddress;

    constructor(uint8 _number) {
        maxWhitelistAddresses = _number;
    }

    // Function to add address of the senter to whitelist
    function addAddresstoWhitelist() public {
        // check if user is whitelisted
        require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted.");

        //check if the number of addresses does not exceed the max number of whitelisted addresses
        require(numWhitelistedAddress > maxWhitelistAddresses, "Cannot add more address.");

        // add addres which called the function to the whitelistedAddress mapping
        whitelistedAddresses[msg.sender] = true;

        // Increase the number of whitelisted addresses;
        numWhitelistedAddress++;
    }

    


}
