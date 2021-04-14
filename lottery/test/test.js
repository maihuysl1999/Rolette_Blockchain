var BoNhaCai = artifacts.require("./BoNhaCai.sol");
var SimpleLottery = artifacts.require("./SimpleLottery.sol");

function promiseTimeout (time) {
    return new Promise(function(resolve,reject){
      setTimeout(function(){resolve(time);},time);
    });
  };

contract("DM", function (accounts) {
  var tokenInstance;
  var simpleInstance;

  it("Init BoNhaCai", function () {
    return BoNhaCai.deployed(100000).then(function (instance) {
      tokenInstance = instance;
    });
  });

  it("Init SimpleLottery", function () {
    return BoNhaCai.deployed(tokenInstance.address).then(function (instance) {
      simpleInstance = instance;
    });
  });

  it("facilitates token buying", function () {
    return BoNhaCai.deployed(100000)
      .then(function (instance) {
        // Grab token instance first
        tokenInstance = instance;
        return SimpleLottery.deployed(tokenInstance.address);
      })
      .then(function (instance) {
        // Then grab token sale instance
        tokenSaleInstance = instance;
        // Provision 75% of all tokens to the token sale
        return tokenInstance.buyToken({
          from: accounts[0],
          value: web3.utils.toWei("1", "ether"),
        });
      })
      .then(function () {
        return tokenInstance.buyToken({
          from: accounts[1],
          value: web3.utils.toWei("1", "ether"),
        });
      })
      .then(function () {
        return tokenInstance.buyToken({
          from: accounts[2],
          value: web3.utils.toWei("1", "ether"),
        });
      })
      .then(function() { 
        return web3.eth.getBlockNumber()
      })
      .then(function (blockNumber) {
        return web3.eth.getBlock(blockNumber);
      })
      .then(function (block) {
        console.log(block.timestamp);
        return tokenInstance.createRound(0, tokenSaleInstance.address, block.timestamp + 20, 20);
      })
      .then(function (roundId) {
        console.log(roundId.toNumber());
        return tokenInstance.buyTicket(0, 4, 0, {from: accounts[0]});
      })
      .then(function () {
        return tokenInstance.buyTicket(0, 4, 0, {from: accounts[1]});
      })
      .then(function () {
        return tokenInstance.buyTicket(0, 4, 0, {from: accounts[2]});
      })
      .then(function () {
        return promiseTimeout(25*1000);
      })
      .then(function () {
        return tokenSaleInstance.drawWinner(0);
      })
      .then(function () {
        return tokenInstance.withDrawTicket(0,{from: accounts[0]});
      })
      .then(function () {
        return tokenInstance.withDrawTicket(1,{from: accounts[1]});
      })
      .then(function () {
        return tokenInstance.withDrawTicket(2,{from: accounts[2]});
      })
      .then(function () {
        return tokenInstance.balanceOf(accounts[0]);
      })
      .then(function (balance) {
        console.log(balance.toNumber());
        return tokenInstance.balanceOf(accounts[1]);
      })
      .then(function (balance) {
        console.log(balance);
        return tokenInstance.balanceOf(accounts[2]);
      })
      .then(function (balance) {
        console.log(balance);
      })

  });
});
