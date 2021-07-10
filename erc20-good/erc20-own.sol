// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "../interface/IERC20Metadata.sol";
import "../libs/SafeMath.sol";
import "../extensions/Mintable.sol";


contract KERC20 is Context, IERC20, IERC20Metadata, Ownable, Mintable {  
    using SafeMath for uint;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _totalSupply;
    uint8 private _decimals;
    
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint initialSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
                
        _mint(owner(), initialSupply_); 
    }
    

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint amount) public override returns (bool) { 

        _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        
        emit Transfer(_msgSender(), recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) public virtual override returns (bool) {
        
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(allowance(sender, recipient) >= amount, "ERC20: transfer amount exceeds balance");
        
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        _allowances[sender][recipient] = _allowances[sender][recipient].sub(amount);
        
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    
    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);

    }

     function burn(address account, uint256 amount) public virtual {
        require(account == _msgSender(), "KERC20: Possible to burn only owned coins");
        
        _burn(account, amount);
    }
    
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);

    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}