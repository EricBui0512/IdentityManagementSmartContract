pragma solidity ^0.4.18;
import './UserProfile.sol';

contract FacetSmart {
  UserProfile public userProfile;  
  bytes32 private title;
  mapping (bytes32 => bytes32) private attributes;
  mapping (address => uint) private verifierList; // 0: pending, 1: verified, 2: declined, 3: cancelled
  mapping (address => uint) private shareList; // 0: shared 1: revoked
  bytes32[] attributeKeys;
  uint public verifierNo;
  uint public shareNo;
  
  function FacetSmart(UserProfile _userProfile) public {
    userProfile = _userProfile;
  }

  /// @notice check if the caller is the owner of the contract
	modifier onlyOwner {
		require(msg.sender == userProfile.owner());
		_;
	}

	modifier onlyViewer {
		require(verifierList[msg.sender] != uint(0x0) || shareList[msg.sender] != uint(0x0));
		_;
	}

	modifier onlyVerifier {
		require(verifierList[msg.sender] != uint(0x0));
		_;
	}

  function isVerifier(address _sender) public view returns (bool) {
    return verifierList[_sender] != uint(0x0);
  }

  function isShared (address _sender) public view returns (bool) {
  	return shareList[_sender] != uint(0x0);
  }

  function isView (address _sender) public view returns (bool) {
  	return (verifierList[_sender] != uint(0x0) || shareList[_sender] != uint(0x0)) ;
  }

  function getAttributes() public view onlyViewer returns (bytes32[] keys, bytes32[] values) {
  	bytes32[] memory attributeValues;
  	for (uint i = 0; i < attributeKeys.length; i++) {
  		attributeValues[i] = attributes[attributeKeys[i]];
    }
  	keys = attributeKeys;
  	values = attributeValues;
  }
  
  function getAttribute(bytes32 _attribute) public view onlyViewer returns (bytes32) {
  	return attributes[_attribute];
  }

  function shareToOne(address _receiver) private {
  	shareList[_receiver] = 0;
  }
  function shareTo(address[] _receivers) public onlyOwner {
  	for (uint i = 0; i < _receivers.length; i++) {
  		shareToOne(_receivers[i]);
    }
  }
  function inviteOneToVerify(address _invitee) private {
  	verifierList[_invitee] = 0;//pending
  }

  function inviteToVerify(address[] _invitees) public onlyOwner {
  	for (uint i = 0; i < _invitees.length; i++) {
  		inviteOneToVerify(_invitees[i]);
    }
  }

  function updateAttribute(bytes32 _attributKey, bytes32 _attributValue) public onlyOwner {
  	attributes[_attributKey] = _attributValue;
  	attributeKeys.push(_attributKey);
  }

  function updateAttributes(bytes32[] _attributKeys, bytes32[] _attributValues) public onlyOwner {
  	for (uint i = 0; i < _attributKeys.length; i++) {
  		updateAttribute(_attributKeys[i],_attributValues[i]);
    }
  }

  function userVerified() public view onlyVerifier returns (bool) {
  	return verifierList[msg.sender] == 1;
  }

  function userDeclined() public view onlyVerifier returns (bool) {
  	return verifierList[msg.sender] == 2;
  }

  function userCancelled() public view onlyVerifier returns (bool) {
  	return verifierList[msg.sender] == 3;
  }

  function cancelVerify(address _address) public onlyOwner returns (bool) {
  	verifierList[_address] = 3;
  }

  function revokeShare(address _address) public onlyOwner returns (bool) {
  	shareList[_address] = 1;
  }
}
