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
#### $APE Airdrop Flash Loan Exploit PoC

`forge test --contracts ./test/3_ApeAirdrop.sol --match-contract ApeAirdropExploit -vv`

Reference - https://medium.com/amber-group/reproducing-the-ape-airdrop-flash-loan-arbitrage-exploit-93f79728fcf5

------------------------------------------------------------------------------------------------------------------------------------------------------
#### Redacted Cartel Custom Approval Logic Exploit PoC

`forge test --contracts ./test/4_RedatedCartel.sol --match-contract RedactedCartelExploit -vv`

Reference - https://medium.com/immunefi/redacted-cartel-custom-approval-logic-bugfix-review-9b2d039ca2c5

------------------------------------------------------------------------------------------------------------------------------------------------------
#### Visor Finance Logic Bug and Rentrancy Exploit PoC

`forge test --contracts ./test/5_VisorFinance.sol --match-contract VisorFinanceExploit -vv`

Reference - https://beosin.medium.com/two-vulnerabilities-in-one-function-the-analysis-of-visor-finance-exploit-a15735e2492

------------------------------------------------------------------------------------------------------------------------------------------------------
#### ShadowFi Public Burn Function Exploit PoC

`forge test --contracts test/6_ShadowFi.sol --match-contract ShadowFiExploit -vv`

Reference - https://medium.com/quillhash/shadowfi-301k-burn-function-exploit-analysis-quillaudits-45a17ce04193

------------------------------------------------------------------------------------------------------------------------------------------------------
#### Discover Flashloan Exploit PoC

`forge test --contracts ./test/7_Discover.sol --match-contract DiscoverExploit -vv`

Reference - https://www.twitter.com/BeosinAlert/status/1533734518623899648

https://www.anquanke.com/post/id/274003

------------------------------------------------------------------------------------------------------------------------------------------------------
#### Bad Guys by RPF Business Logic Flaw Exploit PoC

`forge test --contracts ./test/8_BadGuysbyRPF --match-contract BadGuysbyRPFExploit -vv`

Reference - https://twitter.com/RugDoctorApe/status/1565739119606890498

https://etherscan.io/tx/0xb613c68b00c532fe9b28a50a91c021d61a98d907d0217ab9b44cd8d6ae441d9f

------------------------------------------------------------------------------------------------------------------------------------------------------
### Special Mention
https://github.com/SunWeb3Sec
