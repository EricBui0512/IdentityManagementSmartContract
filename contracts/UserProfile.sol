pragma solidity ^0.4.18;

contract UserProfile {
  	address public owner;
  	address public nextIdAddress;
  	bytes32 private userName;
  	bytes32 private email;
	address[] private facetList;
	uint private veriferNo;
	uint private shareNo;

	function UserProfile(address _networkIdAddress) public {
		nextIdAddress = _networkIdAddress;
	}

	/// @notice check if the caller is the owner of the contract
	modifier onlyOwner {
    	require(msg.sender == owner);
    	_;
	}

	//setters
	function setNextIdNetwork(address _networkIdAddress) public  onlyOwner {
		nextIdAddress = _networkIdAddress;
	}

	function setUserName(bytes32 _userName) public onlyOwner {
		userName = _userName;
	}

	function setEmail(bytes32 _email) public onlyOwner {
		email = _email;
	}

	//getters
	function getUserName() public view returns (bytes32) {
		return userName;
	}

	function getEmail() public view returns (bytes32 ) {
		return email;
	}

	function getFacetList() private view onlyOwner returns (address[]) {
		return facetList;
	}  
}
