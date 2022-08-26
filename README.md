# defiHacks_via_Foundry
In this repository, I try to perform a mainnet fork and then simulate popular smart contract exploits on various DEFI Protocols using Foundry Framework.

#### TreasureDAO NFT Zero Fee Exploit PoC

`forge test --contracts ./test/1_TreasureDAO.sol -vv`

Reference - https://slowmist.medium.com/analysis-of-the-treasuredao-zero-fee-exploit-73791f4b9c14

------------------------------------------------------------------------------------------------------------------------------------------------------
#### Cover Protocol Unrestricted Mint Exploit PoC

`forge test --contracts ./test/2_Cover.sol --match-contract CoverProtocolHack -vv`

Reference - https://mudit.blog/cover-protocol-hack-analysis-tokens-minted-exploit/

------------------------------------------------------------------------------------------------------------------------------------------------------
### Special Mention
https://github.com/SunWeb3Sec
