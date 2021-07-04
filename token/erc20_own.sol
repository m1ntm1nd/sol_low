// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library SafeMath{
    function add(uint a, uint b) internal pure returns(uint){
        require(a+b>a);
        return a+b;
    }
    
    function sub(uint a, uint b) internal pure returns(uint){
        require(a-b<a);
        return a-b;
    }
    
    function mul(uint a, uint b) internal pure returns(uint){
        if (a == 0) return(0);
        uint c = a * b;
        require(c / a == b);
        return c;
    }
    
    function div(uint a, uint b) internal pure returns(uint){
        require(b != 0);
        return a/b;
    }
    
    function mod(uint a, uint b) internal pure returns(uint){
        require(b != 0);
        return a % b;
    }
}

interface IERC20{
    function totalSupply() external view returns(uint);
    function balanceOf(address account) external view returns(uint);
    function allowance(address owner, address sender) external view returns(uint);
    
    function transfer(address recipient, uint amount) external returns(bool);
    function approve(address spender, uint amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint amount) external returns(bool);
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IERC20Metadata is IERC20 {


    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract Mintable is Context, Ownable{
    
    mapping(address => bool) private _minters;
    
    event MinterTrueFalse(address indexed minter, bool statement);
    
    function promoteMinter(address minter) public virtual onlyOwner{
        _minters[minter] = true;
        
        emit MinterTrueFalse(minter, true);
    }
    
    function demoteMinter(address minter) public virtual onlyOwner{
        _minters[minter] = false;
        
        emit MinterTrueFalse(minter, false);
    }
    
    modifier onlyMinter(){
        require(_minters[_msgSender()] != false, "Mintable: caller is not the minter");
        _;
    }
}


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

    function transfer(address recipient, uint amount) override public returns(bool){

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
    ) public virtual override returns(bool){
        
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(allowance(sender, recipient) >= amount, "ERC20: transfer amount exceeds balance");
        
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        _allowances[sender][recipient] = _allowances[sender][recipient].sub(amount);
        
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    
    function mint(address account, uint256 amount) public onlyMinter{
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




    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
