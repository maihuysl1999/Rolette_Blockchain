const BoNhaCai = artifacts.require("./BoNhaCai.sol");
const SimpleLottery = artifacts.require("./SimpleLottery.sol");
const NhaCaiBongDa = artifacts.require("./NhaCaiBongDa.sol");

module.exports = function (deployer) {
  deployer.deploy(BoNhaCai, 1000000).then(function(){
    return deployer.deploy(SimpleLottery, BoNhaCai.address).then(function(){
      return deployer.deploy(NhaCaiBongDa, BoNhaCai.address);
    });
  });
};