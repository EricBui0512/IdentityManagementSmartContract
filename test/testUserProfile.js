var UserProfile = artifacts.require("UserProfile.sol");

contract('UserProfile', function(accounts) {
  const adminAddress = accounts[0];
  const userNameText = 'Thang';
  const emailText = 'thang@gmail.com';
  // const user = new UserProfile(adminAddress);
  
  it("test get username", function() {
    return UserProfile.deployed(adminAddress).then(function(user) {
      user.setUserName(userNameText);
      return user.getUserName.call();
    }).then(function(username) {
      assert.equal(username, userNameText, "this was username");
    });
  });

});
