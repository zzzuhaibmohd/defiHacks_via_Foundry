// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";

interface CheatCodes {
  // This allows us to getRecordedLogs()
  struct Log {bytes32[] topics; bytes data;}
  // Set block.timestamp (newTimestamp)
  function warp(uint256) external;
  // Set block.height (newHeight)
  function roll(uint256) external;
  // Set block.basefee (newBasefee)
  function fee(uint256) external;
  // Set block.coinbase (who)
  function coinbase(address) external;
  // Loads a storage slot from an address (who, slot)
  function load(address,bytes32) external returns (bytes32);
  // Stores a value to an address' storage slot, (who, slot, value)
  function store(address,bytes32,bytes32) external;
  // Signs data, (privateKey, digest) => (v, r, s)
  function sign(uint256,bytes32) external returns (uint8,bytes32,bytes32);
  // Gets address for a given private key, (privateKey) => (address)
  function addr(uint256) external returns (address);
  // Derive a private key from a provided mnenomic string (or mnenomic file path) at the derivation path m/44'/60'/0'/0/{index}
  function deriveKey(string calldata, uint32) external returns (uint256);
  // Derive a private key from a provided mnenomic string (or mnenomic file path) at the derivation path {path}{index}
  function deriveKey(string calldata, string calldata, uint32) external returns (uint256);
  // Performs a foreign function call via terminal, (stringInputs) => (result)
  function ffi(string[] calldata) external returns (bytes memory);
  // Set environment variables, (name, value)
  function setEnv(string calldata, string calldata) external;
  // Read environment variables, (name) => (value)
  function envBool(string calldata) external returns (bool);
  function envUint(string calldata) external returns (uint256);
  function envInt(string calldata) external returns (int256);
  function envAddress(string calldata) external returns (address);
  function envBytes32(string calldata) external returns (bytes32);
  function envString(string calldata) external returns (string memory);
  function envBytes(string calldata) external returns (bytes memory);
  // Read environment variables as arrays, (name, delim) => (value[])
  function envBool(string calldata, string calldata) external returns (bool[] memory);
  function envUint(string calldata, string calldata) external returns (uint256[] memory);
  function envInt(string calldata, string calldata) external returns (int256[] memory);
  function envAddress(string calldata, string calldata) external returns (address[] memory);
  function envBytes32(string calldata, string calldata) external returns (bytes32[] memory);
  function envString(string calldata, string calldata) external returns (string[] memory);
  function envBytes(string calldata, string calldata) external returns (bytes[] memory);
  // Sets the *next* call's msg.sender to be the input address
  function prank(address) external;
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called
  function startPrank(address) external;
  // Sets the *next* call's msg.sender to be the input address, and the tx.origin to be the second input
  function prank(address,address) external;
  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input
  function startPrank(address,address) external;
  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;
  // Sets an address' balance, (who, newBalance)
  function deal(address, uint256) external;
  // Sets an address' code, (who, newCode)
  function etch(address, bytes calldata) external;
  // Expects an error on next call
  function expectRevert() external;
  function expectRevert(bytes calldata) external;
  function expectRevert(bytes4) external;
  // Record all storage reads and writes
  function record() external;
  // Gets all accessed reads and write slot from a recording session, for a given address
  function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);
  // Record all the transaction logs
  function recordLogs() external;
  // Gets all the recorded logs
  function getRecordedLogs() external returns (Log[] memory);
  // Prepare an expected log with (bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData).
  // Call this function, then emit an event, then call a function. Internally after the call, we check if
  // logs were emitted in the expected order with the expected topics and data (as specified by the booleans).
  // Second form also checks supplied address against emitting contract.
  function expectEmit(bool,bool,bool,bool) external;
  function expectEmit(bool,bool,bool,bool,address) external;
  // Mocks a call to an address, returning specified data.
  // Calldata can either be strict or a partial match, e.g. if you only
  // pass a Solidity selector to the expected calldata, then the entire Solidity
  // function will be mocked.
  function mockCall(address,bytes calldata,bytes calldata) external;
  // Mocks a call to an address with a specific msg.value, returning specified data.
  // Calldata match takes precedence over msg.value in case of ambiguity.
  function mockCall(address,uint256,bytes calldata,bytes calldata) external;
  // Clears all mocked calls
  function clearMockedCalls() external;
  // Expect a call to an address with the specified calldata.
  // Calldata can either be strict or a partial match
  function expectCall(address,bytes calldata) external;
  // Expect a call to an address with the specified msg.value and calldata
  function expectCall(address,uint256,bytes calldata) external;
  // Gets the code from an artifact file. Takes in the relative path to the json file
  function getCode(string calldata) external returns (bytes memory);
  // Labels an address in call traces
  function label(address, string calldata) external;
  // If the condition is false, discard this run's fuzz inputs and generate new ones
  function assume(bool) external;
  // Set nonce for an account
  function setNonce(address,uint64) external;
  // Get nonce for an account
  function getNonce(address) external returns(uint64);
  // Set block.chainid (newChainId)
  function chainId(uint256) external;
  // Using the address that calls the test contract, has the next call (at this call depth only) create a transaction that can later be signed and sent onchain
  function broadcast() external;
  // Has the next call (at this call depth only) create a transaction with the address provided as the sender that can later be signed and sent onchain
  function broadcast(address) external;
  // Using the address that calls the test contract, has the all subsequent calls (at this call depth only) create transactions that can later be signed and sent onchain
  function startBroadcast() external;
  // Has the all subsequent calls (at this call depth only) create transactions that can later be signed and sent onchain
  function startBroadcast(address) external;
  // Stops collecting onchain transactions
  function stopBroadcast() external;
  // Reads the entire content of file to string. Path is relative to the project root. (path) => (data)
  function readFile(string calldata) external returns (string memory);
  // Reads next line of file to string, (path) => (line)
  function readLine(string calldata) external returns (string memory);
  // Writes data to file, creating a file if it does not exist, and entirely replacing its contents if it does.
  // Path is relative to the project root. (path, data) => ()
  function writeFile(string calldata, string calldata) external;
  // Writes line to file, creating a file if it does not exist.
  // Path is relative to the project root. (path, data) => ()
  function writeLine(string calldata, string calldata) external;
  // Closes file for reading, resetting the offset and allowing to read it from beginning with readLine.
  // Path is relative to the project root. (path) => ()
  function closeFile(string calldata) external;
  // Removes file. This cheatcode will revert in the following situations, but is not limited to just these cases:
  // - Path points to a directory.
  // - The file doesn't exist.
  // - The user lacks permissions to remove the file.
  // Path is relative to the project root. (path) => ()
  function removeFile(string calldata) external;

  function toString(address)        external returns(string memory);
  function toString(bytes calldata) external returns(string memory);
  function toString(bytes32)        external returns(string memory);
  function toString(bool)           external returns(string memory);
  function toString(uint256)        external returns(string memory);
  function toString(int256)         external returns(string memory);
  // Snapshot the current state of the evm.
  // Returns the id of the snapshot that was created.
  // To revert a snapshot use `revertTo`
  function snapshot() external returns(uint256);
  // Revert the state of the evm to a previous snapshot
  // Takes the snapshot id to revert to.
  // This deletes the snapshot and all snapshots taken after the given snapshot id.
  function revertTo(uint256) external returns(bool);
  // Creates a new fork with the given endpoint and block and returns the identifier of the fork
  function createFork(string calldata,uint256) external returns(uint256);
  // Creates a new fork with the given endpoint and the _latest_ block and returns the identifier of the fork
  function createFork(string calldata) external returns(uint256);
  // Creates _and_ also selects a new fork with the given endpoint and block and returns the identifier of the fork
  function createSelectFork(string calldata,uint256) external returns(uint256);
  // Creates _and_ also selects a new fork with the given endpoint and the latest block and returns the identifier of the fork
  function createSelectFork(string calldata) external returns(uint256);
  // Takes a fork identifier created by `createFork` and sets the corresponding forked state as active.
  function selectFork(uint256) external;
  /// Returns the currently active fork
  /// Reverts if no fork is currently active
  function activeFork() external returns(uint256);
  // Updates the currently active fork to given block number
  // This is similar to `roll` but for the currently active fork
  function rollFork(uint256) external;
  // Updates the given fork to given block number
  function rollFork(uint256 forkId, uint256 blockNumber) external;
  /// Returns the RPC url for the given alias
  function rpcUrl(string calldata) external returns(string memory);
  /// Returns all rpc urls and their aliases `[alias, url][]`
  function rpcUrls() external returns(string[2][] memory);
}

interface IERC721 {
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );
  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );
  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  function balanceOf(address owner) external view returns (uint256 balance);

  function ownerOf(uint256 tokenId) external view returns (address owner);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function approve(address to, uint256 tokenId) external;

  function getApproved(uint256 tokenId)
  external
  view
  returns (address operator);

  function setApprovalForAll(address operator, bool _approved) external;

  function isApprovedForAll(address owner, address operator)
  external
  view
  returns (bool);

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;
}

interface ITreasureMarketplaceBuyer {
  function buyItem(
    address _nftAddress,
    uint256 _tokenId,
    address _owner,
    uint256 _quantity,
    uint256 _pricePerItem
  ) external;

  function marketplace() external view returns (address);

  function onERC1155BatchReceived(
    address,
    address,
    uint256[] memory,
    uint256[] memory,
    bytes memory
  ) external returns (bytes4);

  function onERC1155Received(
    address,
    address,
    uint256,
    uint256,
    bytes memory
  ) external returns (bytes4);

  function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
  ) external returns (bytes4);

  function supportsInterface(bytes4 interfaceId) external view returns (bool);

  function withdraw() external;

  function withdrawNFT(
    address _nftAddress,
    uint256 _tokenId,
    uint256 _quantity
  ) external;
}

interface IERC20 {
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);

  function totalSupply() external view returns (uint256);

  function balanceOf(address owner) external view returns (uint256);

  function allowance(address owner, address spender)
  external
  view
  returns (uint256);

  function approve(address spender, uint256 value) external returns (bool);

  function transfer(address to, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);
  function withdraw(uint256 wad) external;
  function deposit(uint256 wad) external returns (bool);
}

interface IBAYCi {
  function setApprovalForAll(address operator, bool approved) external;
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;
}
interface INFTXVault {
  function redeem(uint256 amount, uint256[] memory specificIds)
  external
  returns (uint256[] memory);
  function flashLoan(
    address receiver,
    address token,
    uint256 amount,
    bytes memory data
  ) external returns (bool);
  function approve(address spender, uint256 amount) external returns (bool);
  function mint(uint256[] memory tokenIds, uint256[] memory amounts)
  external
  returns (uint256);
}
interface IAirdrop {
  function claimTokens() external;
}

interface ISafeERC20 {
  function unFreezeToken () external;
  function balanceOf(address account) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IRewardsHypervisor {
  function deposit(
    uint256 visrDeposit,
    address from,
    address to
  ) external returns (uint256 shares);

  function owner() external view returns (address);

  function snapshot() external;

  function transferOwnership(address newOwner) external;

  function transferTokenOwnership(address newOwner) external;

  function visr() external view returns (address);

  function vvisr() external view returns (address);

  function withdraw(
    uint256 shares,
    address to,
    address from
  ) external returns (uint256 rewards);
}

interface IvVISR {
  function balanceOf(address account) external view returns (uint256);

  function mint(address account, uint256 amount) external;

  function burn(address account, uint256 amount) external;
}

interface IShadowFi {
  function burn(address account, uint256 amount) external;
}

interface IShadowFiPancakePair{
    function sync() external;

    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);

    function token0() external view returns (address);

    function token1() external view returns (address);
}