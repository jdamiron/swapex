pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * The Token contract creates an ERC-20 Token
 */
contract Token {
	using SafeMath for uint;

	//Variables
	string public name = "Swapex";
	string public symbol = "SWAP";
	uint256 public decimals = 18;
	uint256 public totalSupply;
	//Track Balances
	mapping(address  => uint256) public balanceOf;
	mapping(address  => mapping(address => uint256)) public allowance;

	//Events
	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);

	constructor() public {
		totalSupply = 1000000 * (10 ** decimals);
	  	balanceOf[msg.sender] = totalSupply;
	 }

	function _transfer(address _from, address _to, uint256 _value) internal {
		//Needs to be valid Address
		require(_to != address(0));
		//Subtract balance from Sender
	  	balanceOf[_from] = balanceOf[_from].sub(_value);
	  	//Add balace to Reciever
	  	balanceOf[_to] = balanceOf[_to].add(_value);
	  	emit Transfer(_from, _to, _value);
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {
		//Sender needs to have funds
		require(balanceOf[msg.sender] >= _value);
		_transfer(msg.sender, _to, _value);
	  	return true;
	}


	//Approve Tokens
	function approve(address _spender, uint256 _value) public returns (bool success) {
		//Needs to be valid Address
		require(_spender != address(0));
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}


	//Transfer from
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(balanceOf[_from] >= _value);
		require(allowance[_from][msg.sender] >= _value);
		//Reset Allowance
		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
		_transfer(_from, _to, _value);
	  	return true;
	}
}