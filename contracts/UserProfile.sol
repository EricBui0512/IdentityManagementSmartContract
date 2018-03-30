pragma solidity ^0.4.18;
import "./NextIdNetwork.sol"; 
import './Ownable.sol';

contract UserProfile is Ownable{
  	address public owner;
  	string private userName;
  	string private email;
  	string private publicKey;
	address[] private facetList;
	address private networkAddress;

	modifier validUserProfile( string _userName, string _email, string _publicKey ) {
        require ( bytes(_userName).length > 0 );
		require ( bytes(_email).length > 0 );
		require ( bytes(_publicKey).length > 0 );
        _;
    }

	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	function UserProfile(string _userName, string _email, string _publicKey, address _networkAddress) public validUserProfile(_userName,_email,_publicKey) {
		owner = msg.sender;
		userName = _userName;
		email = _email;
		publicKey = _publicKey;	
		networkAddress = _networkAddress;

		//addfa UserProfile address to NextIdNetwork
		NextIdNetwork network = NextIdNetwork(networkAddress);
		
		//make sure that if user created a profile, they won't be able to create it again
		require ( network.getUserProfile(msg.sender) == address(0x0) );

		network.addUserProfile(msg.sender,_email);

	}

	function setUserName(string _userName) public onlyOwner {
		userName = _userName;		

		require (bytes(_userName).length > 0 );
	}

	function setEmail(string _email) public onlyOwner {
		email = _email;

		require (bytes(_email).length > 0 );

		NextIdNetwork network = NextIdNetwork(networkAddress);
		network.updateEmail(msg.sender, _email);
	} 


	function setPublicKey(string _publicKey) public onlyOwner {
		publicKey = _publicKey;
		require (bytes(_publicKey).length > 0 );
	}

	function getPublicKey() public view returns (string) {
		return publicKey;
	}


	function updateUserNameAndEmail(string _userName, string _email) public onlyOwner {
		userName = _userName;
		email = _email;

		require (bytes(_userName).length > 0 );
		require (bytes(_email).length > 0 );

		NextIdNetwork network = NextIdNetwork(networkAddress);
		network.updateEmail(msg.sender, _email);
	}	

	function getOwner() public view returns (address) {
		return owner;
	}

	function getUserName() public view returns (string) {
		return userName;
	}


	function getEmail() public view returns (string) {
		return email;
	}

	function addFacet(address _facetAddress) public {
		bool hasFacet = false;
		for(uint i = 0; i< facetList.length; i++){
			if (facetList[i] == _facetAddress){
				hasFacet = true;
			}
		}

		require (hasFacet == false);
		require( _facetAddress != address(0x0) );
		require( msg.sender == _facetAddress );

		facetList.push(_facetAddress);		
	}

	function removeFacet(address _facetAddress) public {
		require( _facetAddress != address(0x0) );
		require( msg.sender == _facetAddress );

		uint remIndex = 0;
		bool hasKey = false;

        for (uint i = 0; i < facetList.length - 1; i++){            
            if (facetList[i] == _facetAddress){
            	remIndex = i;
            	delete facetList[i];
            	hasKey = true;
            }

            if ( i >= remIndex && hasKey && facetList[i+1] != address(0x0)) {
            	facetList[i] = facetList[i+1];
            }
        }

        if ( hasKey || facetList[facetList.length - 1] == _facetAddress ){
        	facetList.length--;
        } 
	}

	function getFacetAt(uint _index) public view returns (address) {
		return facetList[_index];
	}

	function getFacetTotal() public view returns (uint) {
		return facetList.length;
	}

	function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}
