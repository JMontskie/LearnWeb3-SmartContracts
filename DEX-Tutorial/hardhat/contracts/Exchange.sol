// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {

    // 1 state variable that contains the address of the crypto devs token
    address public cryptoDevsTokenAddress;

    // constructor takes the address of the crypto devs token and stores it in the state variable
    // make sure that the crypto devs token address is not the zero address
    constructor(address _cryptoDevsTokenAddress) ERC20("CryptoDev LP Token", "CDLP") {
        require(_cryptoDevsTokenAddress != address(0), "Invalid address");
        cryptoDevsTokenAddress = _cryptoDevsTokenAddress;
    }

    // create a function to get the reserved amount cryptodevs token held in this smart contract
    function getReserve() public view returns (uint256){
        return ERC20(cryptoDevsTokenAddress).balanceOf(address(this));
    }

    // add liquidity to the exchange
    function addLiquidity(uint256 _amount) public payable returns(uint256) {
        uint liquidity; // initialized to 0
        uint ethBalance = address(this).balance; // balance of the contract
        uint cryptoDevsTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevsTokenAddress);

        // checks if there is balance inside the contract
        if (cryptoDevsTokenReserve == 0) {
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else { // if there  is balance inside contract
            uint ethReserve = ethBalance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevsTokenReserve) / (ethReserve);
            require(_amount >= cryptoDevTokenAmount, "Amount of the token is less than the minimum required");
            cryptoDevToken.transferFrom(msg.sender, address(this), cryptoDevTokenAmount);
            liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);
        }
            return liquidity;
    }

    function removeLiquidity(uint _amount) public returns (uint, uint) {
        require(_amount > 0, "_amount should be greater than 0");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply(); // total supply of the TOKEN

        // ether to be returned to the user
        uint ethAmount = (ethReserve * _amount) / _totalSupply;

        // token that will be returned to the reserve
        uint cryptoDevTokenAmount = (getReserve() * _amount)/ _totalSupply;
        // burn the token
        _burn(msg.sender, _amount);

        // transfer eth back to user
        payable(msg.sender).transfer(ethAmount);
        ERC20(cryptoDevsTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
        return (ethAmount, cryptoDevTokenAmount);
    }
    
    function getAmountOfTokens(
        uint inputAmount,
        uint inputReserve,
        uint outputReserve
    ) public pure returns (uint) {
        require(inputReserve > 0 && outputReserve > 0, "Invalid reserves!");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
        return numerator / denominator;
    }

    function ethToCryptoDevToken(uint _minTokens) public payable {
        uint256 tokenReserve = getReserve(); // get token reserve of smart contract
        uint256 tokensBought = getAmountOfTokens(
            msg.value, // input amount
            address(this).balance - msg.value, //reserved amount in the smart contract
            tokenReserve // output reserve
        );
        require(tokensBought >= _minTokens, "insufficient output amount");
        ERC20(cryptoDevsTokenAddress).transfer(msg.sender, tokensBought);
    }

    function cryptoDevTokenToEth(uint _tokensSold, uint _minEth) public {
        uint256 tokenReserve = getReserve(); // get token reserve of smart contract
        uint256 ethBought = getAmountOfTokens(
            _tokensSold, // is the token you want to sell back to the contract
            tokenReserve, // reserve in the contract
            address(this).balance // outout reserve
            );
        require(ethBought >= _minEth, "insufficient output amount");
        ERC20(cryptoDevsTokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        payable(msg.sender).transfer(ethBought);
    }
}