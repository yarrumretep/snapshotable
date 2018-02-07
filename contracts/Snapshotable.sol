pragma solidity 0.4.18;

// solhint-disable no-inline-assembly
// solhint-disable no-unused-vars

library Snapshotable {

  struct Uint {
    uint[] snapshots;
  }

  function lastEntry(Uint storage self) internal view returns (uint key, uint value) {
    uint packed = last(self);
    return (toKey(packed), toValue(packed));
  }

  function lastKey(Uint storage self) internal view returns (uint) {
    return toKey(last(self));
  }

  function lastValue(Uint storage self) internal view returns (uint) {
    return toValue(last(self));
  }

  function count(Uint storage self) internal view returns (uint) {
    return self.snapshots.length;
  }

  function entryAt(Uint storage self, uint index) internal view returns (uint key, uint val) {
    uint packed = self.snapshots[index];
    return (toKey(packed), toValue(packed));
  }

  function keyAt(Uint storage self, uint index) internal view returns (uint key) {
    return toKey(self.snapshots[index]);
  }

  function valueAt(Uint storage self, uint index) internal view returns (uint val) {
    return toValue(self.snapshots[index]);
  }

  function reset(Uint storage self, uint key) internal {
    if (self.snapshots.length > 0) {
      self.snapshots[0] = entry(key, self.snapshots[self.snapshots.length-1]);
      self.snapshots.length = 1;
    }
  }

  function increment(Uint storage self, uint key, uint incr) internal {
    uint last = self.snapshots.length;
    if (last == 0) {
      self.snapshots.push(entry(key, incr));
    } else {
      last--;
      uint packed = self.snapshots[last];
      if (toKey(packed) == key) {
        self.snapshots[last] = packed + incr;
      } else {
        self.snapshots.push(entry(key, packed + incr));
      }
    }
  }

  function decrement(Uint storage self, uint key, uint decr) internal {
    uint last = self.snapshots.length;
    require(last > 0);
    last--;
    uint packed = self.snapshots[last];
    require(toValue(packed) >= decr);
    if (toKey(packed) == key) {
      self.snapshots[last] = packed - decr;
    } else {
      self.snapshots.push(entry(key, packed - decr));
    }
  }

  function last(Uint storage self) private view returns (uint) {
    if (self.snapshots.length == 0) {
      return 0;
    } else {
      return self.snapshots[self.snapshots.length-1];
    }
  }

  uint internal constant SHIFT_FACTOR = 2**(256 - 64); // 64 bits of index value

  function toKey(uint packed) private pure returns (uint) {
    return packed / SHIFT_FACTOR;
  }

  function toValue(uint packed) private pure returns (uint) {
    return packed & (SHIFT_FACTOR - 1);
  }

  function entry(uint key, uint value) private pure returns (uint) {
    return (key * SHIFT_FACTOR) | (value & (SHIFT_FACTOR - 1));
  }

}


contract UsingSnapshotable {
  using Snapshotable for Snapshotable.Uint;
}