// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function purchase(uint256 _tokenId) external payable;
    function getPrice() external view returns (uint256);
    function isAvailable(uint _tokenId) external view returns (bool);
}

interface ICryptoDevs {
    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}

contract CryptoDevsDao is Ownable {
    
    // store proposals
    struct Proposal {
        uint256 nftTokenId; // token id
        uint256 deadline; // deadline for voting
        uint256 yesVotes; // counts the number of yes votes
        uint256 noVotes; // counts the number of no votes
        bool executed; // check if the proposal is executed
        mapping(uint256 => bool) voters; // check if token has already voted by mapping a token to a boolean.
    }

    enum Vote {
        Yes,
        No
    }

    // map proposal ids to particular proposal
    mapping (uint256 => Proposal) public proposals;

    // counter to count number of proposals
    uint256 public numProposal;

    IFakeNFTMarketplace nftMarketplace;
    ICryptoDevs cryptoDevsNFT;

    // assign addresses to constructor to access Interfaced Contracts
    constructor(address _nftAddress, address _cryptoNFTAddress) payable {
        nftMarketplace = IFakeNFTMarketplace(_nftAddress);
        cryptoDevsNFT = ICryptoDevs(_cryptoNFTAddress);
    }

    // function createProposal(uint _tokenId) public {
    //     require(nftMarketplace.isAvailable(numProposal), "NFT not for sale");
    //     Proposal storage proposal = proposals[numProposal];
    //     numProposal++;
    //     proposal = Proposal(_tokenId, block.timestamp + 5 minutes);
    // }

    function createProposal(uint _tokenId) public returns (uint) {
        require(nftMarketplace.isAvailable(numProposal), "NFT not for sale");
        Proposal storage proposal = proposals[numProposal];
        proposal.nftTokenId = _tokenId;
        proposal.deadline = block.timestamp + 5 minutes;

        numProposal++;

        return numProposal - 1;
    }

    // function to vote on a specific proposal, the ones who can vote are NFT holders and the proposal should be active
    function voteOnProposal(uint256 proposalIndex, Vote vote) external nftHolderOnly onlyActive(proposalIndex) {

        // in order for us to get a value from a Struct that has a nested mapping,
        // we need to initialize a Storage for Proposal because mappings by default is a type of storage that is persistent
        // meaning, once it is stored in the blockchain, it cannot be changed.
        // 
        Proposal storage proposal = proposals[proposalIndex];

        // get nft balance of user, we will use this later.
        uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender);

        //counter for votes, this will hold the number of votes each user used.
        uint256 numVotes = 0;

        // Each NFT Balance = vote, to ensure we can have the number of votes to nft balance, we will use for-loop
        for (uint i = 0; i < voterNFTBalance; i++) {

            // 
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);

            if (proposal.voters[tokenId] == false)  {
                numVotes++;
                proposal.voters[tokenId] = true;
            }

            require (numVotes > 0, "Already voted");

            if (vote == Vote.Yes) {
                proposal.yesVotes += numVotes;
            } else {
                proposal.noVotes += numVotes;
            }
        }
    }

    function executeProposal(uint _proposalId) external nftHolderOnly onlyInactive(_proposalId){
        Proposal storage proposal = proposals[_proposalId];

        if (proposal.yesVotes > proposal.noVotes) {
            uint256 nftPrice = nftMarketplace.getPrice();
            require(address(this).balance >= nftPrice, "Not enough funds");
            nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }
        proposal.executed = true;
    }

    function withdrawEther() external onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw");
        (bool sent, ) = payable(owner()).call {value: amount}("");
        require(sent, "Failed to widthdraw");
    }



    // limit users to nft holders only
    modifier nftHolderOnly {
        require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "You are not a holder of Crypto Devs NFT");
        _;
    }

    // active proposals only
    modifier onlyActive (uint256 proposalIndex){
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "Deadline exceeded"
        );
        _;
    }

    // inactive proposals only
    modifier onlyInactive (uint256 proposalIndex) {
        require(
            proposals[proposalIndex].deadline > block.timestamp,
            "Deadline exceeded"
        );
        require(
            proposals[proposalIndex].executed == false,
            "Proposal already executed"
        );
        _;
    }


}