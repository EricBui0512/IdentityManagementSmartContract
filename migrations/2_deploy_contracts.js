var UserProfile = artifacts.require("UserProfile.sol");
var NextIdNetwork = artifacts.require("NextIdNetwork.sol");
var NextIdToken = artifacts.require("NextIdToken.sol");
var FacetSmart = artifacts.require("FacetSmart.sol");

module.exports = function(deployer) {  
  deployer.deploy(NextIdNetwork);
  // deployer.deploy(NextIdToken);
  // deployer.deploy(UserProfile);
  // deployer.deploy(FacetSmart);
};
