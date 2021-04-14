const BoNhaCai = artifacts.require("./BoNhaCai.sol");
const SimpleLottery = artifacts.require("./SimpleLottery.sol");

module.exports = function (deployer) {
  deployer.deploy(BoNhaCai, 1000000).then(function(){
    return deployer.deploy(SimpleLottery, BoNhaCai.address);
  });
};