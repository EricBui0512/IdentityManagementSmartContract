pragma solidity ^0.4.18;
import './UserProfile.sol';

contract NextIdNetwork {
  	address public admin;  	
  	UserProfile[] public nextIdUserProfiles;
  	mapping(address => UserProfile) userList;
  	

	function NextIdNetwork(address _adminAddress) public {
		admin = _adminAddress;
	}

  	function getUserTotal() public view returns (uint) {
  		return nextIdUserProfiles.length;
  	}

  	// function isUser(address _address) public returns (bool) {
  	// 	return userList[_address];
  	// }

  	function getUserProfile(address _address) public view returns (UserProfile){
		return userList[_address];  		
  	}
  	
}
