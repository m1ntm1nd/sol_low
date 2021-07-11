// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "../interface/IERC20.sol";
import "../libs/SafeMath.sol";


contract KERC20 is IERC20 {
    using SafeMath for uint;
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint private _total;
    address private _owner;
    
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowed;
    mapping(address => bool) private _minters;

    
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint initialSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _owner = _msgSender();
        
        _total = _total.add(initialSupply_);
        _balances[_owner] = initialSupply_;
    }
    
    function totalSupply() public view override returns (uint) {
        return _total;
    }
    
    function balanceOf(address user) public view override  returns (uint) {
        require(user != address(0), "Trying to take zero address balance");
        return _balances[user];
    }
    
    function transfer(address to, uint value) public override  returns (bool) {

        _balances[_msgSender()] = _balances[_msgSender()].sub(value);
        _balances[to] = _balances[to].add(value);
        
        emit Transfer(_msgSender(), to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint value) public override  returns (bool) {
        require(allowance(from, to) >= value);
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][to] = _allowed[from][to].sub(value);

        emit Transfer(from, to, value);
        return true;
    }
    
    function approve(address spender, uint value) public override  returns (bool) {
        _allowed[_msgSender()][spender] = value;
        
        emit Approval(_msgSender(), spender, value);
        return true;
    }    
       
    function allowance(address owner, address spender) public view override returns (uint) {
        return _allowed[owner][spender];
    }
    
    modifier OnlyOwner() {
        require(_msgSender() == _Owner(), "ACCESS ERROR: caller is not the owner");
        _;
    }

    function renounceOwnership() public OnlyOwner {
        _owner = address(0);
    }
    
    function addMinter(address minter) public OnlyOwner {
        _minters[minter] = true;
    }
   
    
    function removeMinter(address minter) public OnlyOwner {
        _minters[minter] = false;
    }
    
    modifier OnlyMinter() {
        require(_minters[_msgSender()] != false, "ACCESS ERROR: caller is not the minter");
        _;
    }
    function mint(address to, uint value) public OnlyMinter {
        _balances[to] = _balances[to].add(value);
        _total = _total.add(value);
    }

    function burn(address account, uint256 amount) public {
        require(account != address(0), "ERC20: burn from the zero address");
        require(account == _msgSender(), "ERC20: you can only burn owned coins");
        
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance.sub(amount);
        
        _total -= amount;

        emit Transfer(account, address(0), amount);

    }
    
    function _msgSender() internal view  returns (address) {
        return msg.sender;
    }
    
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }
    
    function _Owner() internal view returns (address) {
        return _owner;
    }
}
