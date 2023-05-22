// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    string _baseTokenURI; // token uri
    uint256 private _price = 0.01 ether; // price of the nft
    bool private _paused; // will pause the smart contract
    uint256 private _maxSupply = 20; // max supply of the nft
    uint256 private tokenIds;  // token id
    IWhitelist whitelist; // whitelist contract instance
    bool private presaleActive; // true or false if presale is active
    uint256 private presaleEnded; // timestamp of when presale ends

    modifier onlyWhenNotPause {
        require (!_paused, "Contract currently paused");
        _;
    }


    // base uri and address of the whitelist contract
    // assign base uri and whitelist contract
    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    // start presale
    function startPresale() public onlyOwner {
        presaleActive = true;
        presaleEnded = block.timestamp + 5 minutes; // presale must reach 5 mins
    }

    function presaleMint() public payable onlyWhenNotPause {
        require(presaleActive && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < _maxSupply, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPause {
        require(presaleActive && block.timestamp < presaleEnded, "Presale is not running");
        require(tokenIds < _maxSupply, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    // override the openzeppelins _baseURI implementation
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
        
    }

}