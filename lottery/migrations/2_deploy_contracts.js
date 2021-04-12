const BoNhaCai = artifacts.require("BoNhaCai");
const SimpleLottery = artifacts.require("SimpleLottery");

module.exports = function (deployer) {
  deployer.deploy(BoNhaCai).then(function(){
    deployer.deploy(SimpleLottery, 120);
  });
};