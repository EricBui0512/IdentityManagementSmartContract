pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract NextIdToken is StandardToken {
    string public name = "NEXTID";
    string public symbol = "NID";
    uint8 public decimals = 2;
    uint public INITIAL_SUPPLY = 1000000;
    function NextIdToken() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}