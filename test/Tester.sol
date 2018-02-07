pragma solidity 0.4.18;

import "../contracts/Snapshotable.sol";


contract Tester is UsingSnapshotable {

  Snapshotable.Uint internal test;

  function count() public view returns (uint) {
    return test.count();
  }

  function entryAt(uint index) public view returns (uint key, uint value) {
    return test.entryAt(index);
  }

  function lastEntry() public view returns (uint key, uint value) {
    return test.lastEntry();
  }

  function increment(uint key, uint value) public {
    test.increment(key, value);
  }

  function decrement(uint key, uint value) public {
    test.decrement(key, value);
  }

  function reset(uint key) public {
    test.reset(key);
  }
}
