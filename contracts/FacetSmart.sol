// pragma experimental ABIEncoderV2;
pragma solidity ^0.4.18;
import './UserProfile.sol';
import './Ownable.sol';

contract FacetSmart is Ownable {
  //verification constants
  uint constant VERIFICATION_PENDING    =   1;
  uint constant VERIFICATION_VERIFIED   =   2;
  uint constant VERIFICATION_DECLINED   =   3;

  //share constants
  uint constant SHARED    =   1;
  uint constant REVOKED   =   2;

  address public owner;  
  string public title;

  mapping (bytes32 => bytes32) private attributes;

  mapping (address => uint) private verifierList; // 0: pending, 1: verified, 2: declined, 3: cancelled
  mapping (address => uint) private shareList; // 0: shared 1: revoked
  mapping (bytes32 => uint) private externalShareList; // 0: shared 1: revoked //for user outside of network
  mapping (bytes32 => uint) private externalVeriferList;
  
  mapping (address => string) private shareKeys;
  mapping (bytes32 => string) private shareKeysByEmail;


  bytes32[] private attributeKeys ;
  
  uint public verifierTotal;
  uint public shareTotal;
  
  function FacetSmart(string _title, address profileAddress) public {
    owner = msg.sender;
    title = _title;

    require ( profileAddress != address(0x0) );
    require ( bytes(_title).length > 0 );
    
    //add facet to profile
    
    UserProfile profile = UserProfile(profileAddress);
    profile.addFacet(address(this));
  }


  event Logs(address from);

	modifier onlyViewer {
		require(verifierList[msg.sender] != uint(0x0) || shareList[msg.sender] != uint(0x0) || msg.sender == owner);
		_;
	}


  function setTitle(string _title) public onlyOwner {
    title = _title;

    require ( bytes(_title).length > 0 );
  }

  function getTitle() public view returns (string) {
    return title;
  }

	modifier onlyVerifier {
		require(verifierList[msg.sender] != uint(0x0));
		_;
	}

  function isVerifier(address _sender) public view returns (bool) {
    return verifierList[_sender] != uint(0x0);
  }

  function isShared (address _sender) public view returns (bool) {
  	return shareList[_sender] == SHARED;
  }

  function isSharedToEmail (bytes32 _emailHash) public view returns (bool) {
    return externalShareList[_emailHash] == SHARED;
  }

  function isViewer (address _sender) public view returns (bool) {
  	return (verifierList[_sender] != uint(0x0) || shareList[_sender] == uint(0x0) || msg.sender == owner) ;
  }

  function getAttributeKeysTotal() public view onlyViewer returns (uint) {
    return attributeKeys.length;
  }

  function getAttributeKeysAt (uint _index) public view onlyViewer returns (bytes32) {
    return attributeKeys[_index];
  }
  
  
  function getAttribute(bytes32 _attributeKey) public view onlyViewer returns (bytes32) {
  	return attributes[_attributeKey];
  }

  function shareTo(address _receiver,string _shareKey) public onlyOwner {
    shareList[_receiver] = SHARED;
    shareTotal++; 	
    shareKeys[_receiver] =  _shareKey;
    require ( _receiver != address(0x0) );
  }

  function shareToEmail(bytes32 _emailHash, string _shareKey) public onlyOwner {
    externalShareList[_emailHash] = SHARED;
    shareTotal++;
    shareKeysByEmail[_emailHash] = _shareKey;
  }

  function revokeShare(address _receiver) public onlyOwner {    
  	shareList[_receiver] = REVOKED;
    shareTotal--;
    shareKeys[_receiver] = "";
    require (shareList[_receiver] != uint (0x0) );
  }

  function revokeEmailShare(bytes32 _emailHash) public onlyOwner {
    externalShareList[_emailHash] = REVOKED;
    shareTotal--;
    shareKeysByEmail[_emailHash] = "";
    require (externalShareList[_emailHash] != uint (0x0) );
  }

  function shareToMany(address[] _receivers, string _shareKey) public onlyOwner {
  	for (uint i = 0; i < _receivers.length; i++) {
  		shareTo(_receivers[i],_shareKey);
    }
  }

  function inviteToVerify(address _invitee, string _shareKey) public {
    verifierList[_invitee] = VERIFICATION_PENDING;
    verifierTotal++;
    shareKeys[_invitee] = _shareKey;
    require (_invitee != address (0x0) );
  }

  function inviteToVerifyByEmail(bytes32 _emailHash, string _shareKey) public {
    externalVeriferList[_emailHash] = VERIFICATION_PENDING;
    verifierTotal++;
    shareKeysByEmail[_emailHash] = _shareKey;
  }

  function inviteManyToVerify(address[] _invitees, string _shareKey) public onlyOwner {
  	for (uint i = 0; i < _invitees.length; i++) {
  		inviteToVerify(_invitees[i], _shareKey);
    }
  }

  function updateAttribute(bytes32 _attributeKey, bytes32 _attributeValue) public onlyOwner {
  	attributes[_attributeKey] = _attributeValue;
    bool hasKey = false;
    for(uint i = 0; i < attributeKeys.length; i++){
      if (attributeKeys[i] == _attributeKey) {
        hasKey = true;
      }
    }
    if (!hasKey) {
      attributeKeys.push(_attributeKey);  	 
    }
  }

  function updateAttributes (bytes32[] _attributeKeys, bytes32[] _attributValues, bytes32[] _deletedKeys ) public onlyOwner {
    for (uint i = 0; i < _attributeKeys.length; i++) {
      updateAttribute(_attributeKeys[i],_attributValues[i]);
    }

    deleteAttributes(_deletedKeys);
  }  
  
  function deleteAttribute(bytes32 _attributeKey) public onlyOwner{    
    uint remIndex = 0;
    bool hasKey = false;
    for (uint i = 0; i < attributeKeys.length -1  ; i++){     
        
        if (attributeKeys[i] == _attributeKey){
          hasKey = true;
          remIndex = i;
        }

        if ( i >= remIndex && hasKey) {
          attributeKeys[i] = attributeKeys[i+1];
        }
    }
    if ( hasKey || attributeKeys[attributeKeys.length-1] == _attributeKey) {
      delete attributeKeys[attributeKeys.length-1];
      attributeKeys.length--;
      delete attributes[_attributeKey];
    }    
  }

  function deleteAttributes (bytes32[] _attributeKeys) public onlyOwner {
    for (uint i = 0; i < _attributeKeys.length; i++) {
      deleteAttribute(_attributeKeys[i]);
    }
  }

  function userVerified() public view returns (bool) {
  	return verifierList[msg.sender] == VERIFICATION_VERIFIED;
  }

  function userDeclined() public view returns (bool) {
  	return verifierList[msg.sender] == VERIFICATION_DECLINED;
  }


  function userVerifiedByEmail(bytes32 _emailHash) public view returns (bool) {
    return externalVeriferList[_emailHash] == VERIFICATION_VERIFIED;
  }

  function userDeclinedByEmail(bytes32 _emailHash) public view returns (bool) {
    return externalVeriferList[_emailHash] == VERIFICATION_DECLINED;
  }


  function verifyByEmail(bytes32 _emailHash, uint _status) public {
    externalVeriferList[_emailHash] = _status;
    require(externalVeriferList[_emailHash] != uint(0x0));
  }

  function verifyByAccount(uint _status) public onlyVerifier {
    verifierList[msg.sender] = _status;
    require(verifierList[msg.sender] != uint(0x0));
  }

  function getShareKey() public view onlyViewer returns (string) {
    return shareKeys[msg.sender];
  }

  function getShareKeyByEmail(bytes32 _emailHash) public view returns(string) {
    return shareKeysByEmail[_emailHash];
  }
  

  function destroy(address userProfileAddress) public onlyOwner {
    UserProfile userProfile = UserProfile(userProfileAddress);
    userProfile.removeFacet(address(this));

    require ( userProfileAddress != address(0x0) );
    selfdestruct(owner);
  }
}
