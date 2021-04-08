var SimpleLottery = artifacts.require("SimpleLottery");

module.exports = function(deployer) {
  deployer.deploy(SimpleLottery, 700)
}