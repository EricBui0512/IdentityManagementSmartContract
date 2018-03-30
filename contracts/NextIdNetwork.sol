pragma solidity ^0.4.18;

contract NextIdNetwork {
  	address public owner;  	
  	mapping(address => address) private users;
  	mapping (address => string) private emails;
  	address[] private accounts;

  	event OnAddNewUserProfile(
  		address _ethAddress, 
  		address _userProfileAddress, 
  		string _email
  	);

  	function NextIdNetwork() public {
  		owner = msg.sender;
  	}

  	//this method is used by User Profile Smart Contract
	function addUserProfile(address _userProfileOwner, string _email) public {					
		
		if (users[_userProfileOwner] == address(0x0)) {			
			//emits an event					
			OnAddNewUserProfile(_userProfileOwner,msg.sender,_email);

			users[_userProfileOwner] = msg.sender;//assign to msg.sender (user profile smart contract)
	 		emails[_userProfileOwner] = _email;
	 		accounts.push(_userProfileOwner);
		}

		require ( _userProfileOwner != address(0x0) );		
		require ( bytes(_email).length > 0 );
	}

	//this method is used by User Profile Smart Contract
	function updateEmail(address _userProfileOwner, string _newEmail) public {
		
		require ( bytes(emails[_userProfileOwner]).length > 0 );
		require ( _userProfileOwner != address(0x0) );
		require ( bytes(_newEmail).length > 0 );
		// only allow sender is a user profile contract
		require ( users[_userProfileOwner] == msg.sender );
		
		emails[_userProfileOwner] = _newEmail;
	}

	function getAccountByEmail(string _email) public view returns(address) {
		for(uint i = 0; i < accounts.length ; i++ ) {
			address accountAddress = accounts[i];
			if (keccak256(emails[accountAddress]) == keccak256(_email)) {
				return accountAddress;
			}
		}
		return address(0x0);
	}

	function getUserProfile(address _account) public view returns (address) {
	  return users[_account];  		
	}

	function getAccounts() public view returns (address[]){
		return accounts;
	}
  	
}
