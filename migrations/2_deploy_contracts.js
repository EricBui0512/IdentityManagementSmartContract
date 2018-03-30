var UserProfile = artifacts.require("UserProfile.sol");
var NextIdNetwork = artifacts.require("NextIdNetwork.sol");
var FacetSmart = artifacts.require("FacetSmart.sol");

module.exports = function(deployer) {  
  deployer.deploy(NextIdNetwork);
  // deployer.deploy(UserProfile);
  // deployer.deploy(FacetSmart);
};
