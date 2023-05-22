// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract FakeNFTMarketplace {

    uint private price = 0.1 ether;
    mapping (uint => address) private tokens;
    

    function purchase(uint256 _tokenId) external payable {
        require(msg.value >= price, "This NFT is priced at 0.1 ethers");
        // assign the tokenId to the user
        tokens[_tokenId] = msg.sender;
    } // purchase NFT

    function getPrice() external view returns (uint256){
        return price;
    } // get the price of NFT

    function isAvailable(uint _tokenId) external view returns (bool){
        if (tokens[_tokenId] == address(0)){
            return true;
        } return false;
    } // check if NFT available

}