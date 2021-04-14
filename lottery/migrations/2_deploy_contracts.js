const BoNhaCai = artifacts.require("BoNhaCai");
const SimpleLottery = artifacts.require("SimpleLottery");

module.exports = function (deployer) {
  deployer.deploy(BoNhaCai,  1000000).then(function(){
    deployer.deploy(SimpleLottery, 120);
  });
};