const Web3 = require('web3');
const web3 = new Web3();

const UserProfile = artifacts.require("./UserProfile.sol");
const FacetSmart = artifacts.require("./FacetSmart.sol");
const NextIdNetwork = artifacts.require("./NextIdNetwork.sol");

let facetSmart;
let nextIdNetwork;
let firstUser;
let secondUser;

const keys = [
  'firstName',
  'lastName',
  // 'lastName1',
  // 'lastName2',
];
const values = [
    'Thang',
    'Nguyen',
    // 'Quaywin',
    // 'Quaywin2',
];

const titles = [
  'medical',
  'doctor'
];

const links = [
  'https://www.google.com.vn/',
  'https://medium.com/'
];

contract('FacetSmart', function(accounts) {

  before("setup nextIdNetwork", async function() {
    nextIdNetwork = await NextIdNetwork.new();
    // create first user
    const firstUsername = 'thang';
    const firstEmail = 'thang@gmail.com';
    const firstPublicKey = 'abcxyz';
    firstUser = await UserProfile.new(firstUsername, firstEmail, firstPublicKey, nextIdNetwork.address, {from: accounts[0]});
    await nextIdNetwork.addUserProfile(firstUser.address, firstEmail, {from: accounts[0]});
    // create second user
    const secondUsername = 'tuan';
    const secondEmail = 'tuan@gmail.com';
    const secondPublicKey = 'defqwe';
    secondUser = await UserProfile.new(secondUsername, secondEmail, secondPublicKey, nextIdNetwork.address, {from: accounts[1]});
    await nextIdNetwork.addUserProfile(secondUser.address, secondEmail, {from: accounts[1]});
    
    //init facet data
    facetSmart = await FacetSmart.new(titles[0], firstUser.address, {from: accounts[0]});
    await facetSmart.updateAttributes([
        web3.utils.sha3(keys[0]),
        web3.utils.sha3(keys[1]),
        // web3.utils.sha3(keys[2]),
        // web3.utils.sha3(keys[3])
    ], [
        web3.utils.sha3(values[0]),
        web3.utils.sha3(values[1]),
        // web3.utils.sha3(values[2]),
        // web3.utils.sha3(values[3])
    ], []);
  });

  it("test facetsmart title", async function() {
    const title = await facetSmart.getTitle.call();
    assert.equal(title, titles[0], "test title");
    await facetSmart.setTitle(titles[1]);
    const newTitle = await facetSmart.getTitle.call();
    assert.equal(newTitle, titles[1], "test new title");
  });

  
  it("test get attributes", async function() {
    const firstName = await facetSmart.getAttribute(web3.utils.sha3(keys[0]),{from:accounts[0]});
    const lastName = await facetSmart.getAttribute(web3.utils.sha3(keys[1]),{from:accounts[0]});
    assert.equal(web3.utils.sha3(values[0]), firstName, "test firstName");
    assert.equal(web3.utils.sha3(values[1]), lastName, "test firstName");

    // test get first name by second user
    try {
      firstName = await facetSmart.getAttribute(web3.utils.fromAscii(keys[0]),{from:accounts[1]});      
    } catch (err) {
      assert.ok(true,'permission error');
    }
  });

  it("test delete attributes", async function() {
    var attTotal = await facetSmart.getAttributeKeysTotal.call()
 
    var firstAttKey = await facetSmart.getAttributeKeysAt(0)
    var secondAttKey = await facetSmart.getAttributeKeysAt(1)

    assert.equal(secondAttKey,web3.utils.sha3(keys[1]),"test att key")
    assert.equal(firstAttKey,web3.utils.sha3(keys[0]),"test att key")

    assert.equal(attTotal.toNumber(),keys.length,"total keys before delete")

    await setTimeout(()=>{
      console.log("waiti for 2 s")
    },2000)

    await facetSmart.deleteAttributes([web3.utils.sha3(keys[1])],{from:accounts[0]});

    firstAttKey = await facetSmart.getAttributeKeysAt.call(0)
    // secondAttKey = await facetSmart.getAttributeKeysAt.call(1)

    assert.equal(firstAttKey,web3.utils.sha3(keys[0]),"test att key 0")
    // assert.notEqual(secondAttKey,web3.utils.sha3(keys[1]),"test att key 1")



    // // const lastName = await facetSmart.getAttribute(web3.utils.sha3(keys[1]),{from:accounts[0]});

    attTotal = await facetSmart.getAttributeKeysTotal.call()

    assert.equal(attTotal.toNumber(),keys.length-1,"total keys after delete")
    // assert.notEqual(values[1], web3.utils.toAscii(lastName).replace(/\u0000/g, ''), "test firstName");
  });

  it("test share", async function() {
    // share to second user
    const _secondUserAddress = await secondUser.owner();
    await facetSmart.shareToMany([_secondUserAddress],"sk", {from: accounts[0]});

    
    const isShared = await facetSmart.isShared(_secondUserAddress,{from:accounts[0]});
    assert.equal(isShared, true, "test second user was shared");

    // share to email
    const emailShared = 'xyz@email.com';
    await facetSmart.shareToEmail(emailShared,'sk', {from: accounts[0]});
    const isSharedEmail = await facetSmart.isSharedToEmail(emailShared,{from:accounts[0]});
    assert.equal(isSharedEmail, true, "test email was shared");

    // test revoke share
    await facetSmart.revokeShare(_secondUserAddress, {from: accounts[0]});

  });

  it("test verify", async function() {
    // invite second user
    const _secondUser = await secondUser.owner();
    await facetSmart.inviteManyToVerify([_secondUser],'sk', {from: accounts[0]});

    // test revoke share
    await facetSmart.revokeShare(_secondUser, {from: accounts[0]});

  });

  it("test destroy facet",async function(){
    var total = await firstUser.getFacetTotal.call();
    assert.equal(1,total.toNumber(),"user profile has 1 facet")
    await facetSmart.destroy(firstUser.address,{from:accounts[0]});

    total = await firstUser.getFacetTotal.call();
    assert.equal(0,total.toNumber(),"user profile has 0 facet")
  });

});
