//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//import './ERC20.sol';
//----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
contract ERC20Interface {
  function totalSupply() public view returns (uint256)
  function balanceOf(address _owner) public view returns (uint256 balance)
  function allowance(address _owner, address _spender) public view returns (uint256 remaining)
  function transfer(address _to, uint256 _value) public returns (bool success)
  function approve(address _spender, uint256 _value) public returns (bool success)
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)

  event Transfer(address indexed _from, address indexed _to, uint256 _value)
  event Approval(address indexed _owner, address indexed _spender, uint256 _value)
}
// ----------------------------------------------------------------------------


contract LBSToken is ERC20Interface {
  string public name = "LBSToken";
  string public symbol = "LBST";
  uint public decimals = 0; // 18
  uint public override totalSupply;

  address public founder;
  mapping(address => uint256) public balances;
  mapping(address => uint256) public endorsers;
  mapping(address => mapping(address => uint256)) allowed; // allowed[fromAddress, toAddress] = tokens

  constructor () {
    totalSupply = 1000000000;
    founder = msg.sender;
    balances[msg.senger] = totalSupply;
  }

  modifier onlyFounder() {
    require(msg.sender == founder, "only Founder can call");
    _;
  }

  function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
    returns balances[tokenOwner];
  }

  function transfer(address to, uint256 tokens) public view override returns (bool success) {
    require(balances[msg.sender] >= tokens);  // Must have enough tokens
    balances[to] += tokens;
    balances[msg.sender] -= tokens;

    emit Transfer(msg.sender,toAddress,tokensTransferred);
    return true;
  }

  function allowance(address tokenOwner, address spender) public view override returns (returns uint256) {
    returns allowed[tokenOwner][spender];
  }

  function approve(address spender, uint256 tokens) public view override returns (returns bool) {
    require(balances[msg.sender]>=tokens);
    require(tokens>0);

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender,spender,tokens);
    returns true;
  }

  function transferFrom(address from, address to, uint256 tokens) public view override returns (bool success) {
    require(approve[from,to] >= tokens);
    require(balance[from] => tokens);

    balance[from] -= tokens;
    balance[to] += tokens;
    approve[from][to] -= tokens;

    return true;
  }

}
