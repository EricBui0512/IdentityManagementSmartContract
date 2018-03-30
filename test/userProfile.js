const Web3 = require('web3');
const web3 = new Web3();
const namor = require('namor');
// console.log(web3.utils);
var UserProfile = artifacts.require("UserProfile.sol");
var NextIdNetwork = artifacts.require("NextIdNetwork.sol");
// let nextIdNetwork;
let nextIdNetwork;
let userProfile;
contract('UserProfile', function(accounts) {
  
  before("setup nextIdnetwork", async function() {
    nextIdNetwork = await NextIdNetwork.new();
  });

  it("contructs an user profile", async function() {
    var testusername = namor.generate();
    var testemail = namor.generate() + '@email.com';
    var testpublicKey = namor.generate();
    userProfile = await UserProfile.new(testusername, testemail, testpublicKey, nextIdNetwork.address);
    
    // await nextIdNetwork.addUserProfile(accounts[0], userProfile.address);
    // const user = await nextIdNetwork.getUserProfile(accounts[0]);
    const owner = await userProfile.getOwner.call()
    const email = await userProfile.getEmail.call()
    const userName = await userProfile.getUserName.call()
    const publicKey = await userProfile.getPublicKey.call()


    // assert.equal(userAdress, userProfile.address, "test user profile address")
    assert.equal(accounts[0], owner, "test user ETH address")
    
    assert.equal(testusername, userName, "test username")
    assert.equal(testemail, email, "test user email")
    assert.equal(testpublicKey, publicKey, "test public key")

    const accountByEmail = await nextIdNetwork.getAccountByEmail.call(testemail)
    assert.equal(accountByEmail, owner, "test search account by email")
    
    const userProfileAddress = await nextIdNetwork.getUserProfile(owner)    
    assert.equal(userProfileAddress, userProfile.address, "test user profile in nextid network")
  });

  it("test user name", async function() {
    const testUserName = namor.generate();
    await userProfile.setUserName(testUserName);
    const _username = await userProfile.getUserName.call();
    assert.equal(testUserName, _username, "test username")
  });

  it("test email", async function() {
    const testemail = namor.generate() + '@email.com';
    await userProfile.setEmail(testemail);
    const _email = await userProfile.getEmail.call();
    assert.equal(testemail, _email, "test email")
  });

  it("test public key", async function() {
    const testPublicKey = namor.generate();
    await userProfile.setPublicKey(testPublicKey);
    const _publicKey = await userProfile.getPublicKey.call();
    assert.equal(testPublicKey, _publicKey, "test public key");
  });


});
