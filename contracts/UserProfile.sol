pragma solidity ^0.4.18;

contract UserProfile {
  	address public owner;
  	address public nextIdAddress;
  	string private userName;
  	string private email;
	address[] private facetList;
	uint private veriferNo;
	uint private shareNo;

	function UserProfile(address _networkIdAddress) public {
		owner = msg.sender;
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

	function setUserName(string _userName) public onlyOwner returns (string) {
		userName = _userName;
	}

	function setEmail(string _email) public onlyOwner returns (string) {
		email = _email;
	}

	//getters
	function getUserName() public view returns (string) {
		return userName;
	}

	function getEmail() public view returns (string) {
		return email;
	}

	function getFacetList() private view onlyOwner returns (address[]) {
		return facetList;
	}  
}
