// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC20 and Ownable from Open Zeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevsToken is ERC20, Ownable {

    uint256 private constant tokenPrice = 0.001 ether; // price per token
    uint256 private constant tokensPerNFT = 10 * 10 ** 18; // owning 1NFT is equivalent to 10 tokens
    uint256 public maxTotalSupply = 10000 * 10 ** 18; // max supply of tokens
    

    ICryptoDevs cryptoDevsNft; // initialize Interface cryptoDevsNFT collection

    mapping (uint => bool) public tokenIdsClaimed; // tracking ids of the claimed tokens


    constructor(address _CryptoDevsAddress) ERC20 ("Crypto Devs Token", "CD"){
        cryptoDevsNft = ICryptoDevs(_CryptoDevsAddress);
    }

    // 1. Create a mint function that takes an amount as parameter, make the function public and payable
    function mint(uint _amount) public payable {
        // 2. inside the function create a new uint variable called _requiredAmount which is the sum of the token price and the amount in the constructor parameter
        uint256 _requiredAmount = tokenPrice + _amount;
        // 3. check whether the msg.value is enought to pay for the required amount, otherwise revert the transaction
        require(msg.value > _requiredAmount, "Please pay the right fees!");
        // 4. create a uint256 variable named amountWithDecimals and convert the amount parameter to a token by multiplying it with 10 ** 18
        uint256 amountWithDecimals = _amount * 10 ** 18;
        // 5. check if the current supply in circulation is less than the maxTotalSupply, if it is, then revert
        require(amountWithDecimals < maxTotalSupply, "You have exceeded the maximum supply!");
        // 6. mint the tokens using the amountWithDecimals
        _mint(msg.sender, amountWithDecimals);
    }

    // Start your function with function claim() public {
    // Define the sender's address with address sender = msg.sender;
    // Get the number of CryptoDev NFTs owned by the sender: uint256 balance = CryptoDevsNFT.balanceOf(sender);
    // Check if the balance is greater than 0, otherwise, throw an error: require(balance > 0, "You don't own any Crypto Dev NFT");
    // Define a variable to keep track of unclaimed tokens: uint256 amount = 0;
    // Loop over the balance to check for unclaimed tokens and increase the amount accordingly.
    // Add a require statement to check if the amount is greater than zero.
    // Finally, mint new tokens based on the amount of unclaimed tokens: _mint(msg.sender, amount * tokensPerNFT);

    function claim() public {
        uint256 amount = 0;
        address sender = msg.sender;
        uint256 balance = cryptoDevsNft.balanceOf(sender);
        
        require(balance > 0, "You don't own any Crypto Dev NFT");
        
        for (uint i = 0; i < balance; i++) {
            uint256 tokenId = cryptoDevsNft.tokenOfOwnerByIndex(sender, i);

            if(!tokenIdsClaimed[tokenId]) {
                amount++;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        require(amount > 0, "You have already claimed all of the token!");
        _mint(msg.sender, amount * tokensPerNFT);                
    }

    // Begin the function definition with function withdraw() public onlyOwner {.
    // Declare a variable to store the contract's current balance:
    // Make sure there is some balance in the contract to withdraw:
    // Get the owner's address:
    // Attempt to send all the contract's balance to the owner:
    // Check if the transfer was successful:
    // Close the function with }.

    // function withdraw() public onlyOwner{
    //     uint256 private currentBalance = address(this).balance; //balanceOf(address(this));
    //     address payable owner = payable(address(this));
    //     //address owner = msg.sender;
    //     require(currrentBalance > 0, "There is no balance in the contract!");
    //     (bool success) = transfer(owner, currentBalance);
    //     require(success, "Transfer not successful!");
    // }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw, contract balance empty");
        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

}