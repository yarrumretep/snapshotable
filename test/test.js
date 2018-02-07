const expect = require('expect');

const Tester = artifacts.require('./Tester.sol');

const logGas = (tx => {
  console.log(tx.receipt.gasUsed);
})

contract("Tester", () => {

  var tester;

  beforeEach(() => {
    return Tester.new()
      .then(t => {
        tester = t;
      })
  })

  it('should deploy', () => {
    return tester.lastEntry()
      .then(([key, value]) => {
        expect(+key).toBe(0);
        expect(+value).toBe(0);
      })
  })

  it('should increment', () => {
    return tester.increment(1, 12)
      .then(() => tester.entryAt(0))
      .then(([key, value]) => {
        expect(+key).toBe(1);
        expect(+value).toBe(12);
      })
      .then(() => tester.lastEntry())
      .then(([key, value]) => {
        expect(+key).toBe(1);
        expect(+value).toBe(12);
      })
  })

  it('should increment twice with same key', () => {
    return Promise.resolve()
      .then(() => tester.increment(1, 12))
      .then(() => tester.increment(1, 10))
      .then(() => tester.lastEntry())
      .then(([key, value]) => {
        expect(+key).toBe(1);
        expect(+value).toBe(22);
      })
  })
})