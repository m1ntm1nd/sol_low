// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

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


library utility{
    function search(address[] storage self, address _needed) internal returns(bool){
        for(uint i = 0; i< self.length; i++){
            if (self[i] == _needed)
                return true;
        }
        return false;
    }
}



contract KERC20 is IERC20{
    
    using SafeMath for uint;
    using utility for address;
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint private _total;
    
    mapping (address => uint) private _balances;
    mapping (address => mapping(address => uint)) private _allowed;
    // mapping (address => bool) private _minters;
    address[] private _minters;
    address private _owner;
    
    /*
        owner = _minters[0]
        ему начислили initialSupply_, также добавили ее в total
    */
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint initialSupply_, address owner_) public{
        if (owner_ == address(0))
            owner_ = _msgSender();
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _owner = owner_;
        _minters.push(_msgSender());
        
        _total = _total.add(initialSupply_);
        _balances[_owner] = initialSupply_;
    }
    
    function decetralize_contract() public {
        require(_msgSender() == _minters[0], "Only contract creator can decetralize_contract");
        for(uint i = 0; i<_minters.length; i++){
            _minters[i] = address(0);
        }
    }
    
    function minter_facilitate(address _new_minter) public{
        require(msg.sender == _minters[0], "Only contract creator can create new minters");
        _minters.push(_new_minter);
    }
   
    
    function demote_minter(address _demoting_minter) public{
        require(msg.sender == _minters[0], "Only contract creator can demote minters");
        for(uint i = 0; i<_minters.length; i++){
            if (_minters[i] == _demoting_minter) 
                _minters[i] = address(0);
        }
    }
    
    function show_minters() public view returns(address[] memory){
        return _minters;
    }
    function mint(address _to, uint _value) public returns(bool){
        require(utility.search(_minters, _msgSender()));
        
        _balances[_to] = _balances[_to].add(_value);
        _total = _total.add(_value);
    }
    
    function totalSupply() override public view returns(uint){
        return _total;
    }
    
    function balanceOf(address _user) override public view returns(uint){
        require(_user != address(0), "Trying to take zero address balance");
        return _balances[_user];
    }
   
    function allowance(address _owner, address _spender) override public view returns(uint){
        return _allowed[_owner][_spender];
    }
    
    function transfer(address _to, uint _value) override public returns(bool){

        _balances[_msgSender()] = _balances[_msgSender()].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        
        emit Transfer(_msgSender(), _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) override public returns(bool){
        require(allowance(_from, _to) >= _value);
        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        _allowed[_from][_to] = _allowed[_from][_to].sub(_value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint _value) override public returns(bool){
        _allowed[_msgSender() ][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function burn(address _account, uint256 _amount) public  {
        require(_account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[_account];
        require(accountBalance >= _amount, "ERC20: burn amount exceeds balance");
        _balances[_account] = accountBalance.sub(_amount);
        
        _total -= _amount;

        emit Transfer(_account, address(0), _amount);

    }
    
    
    
    function _msgSender() internal view  returns (address) {
        return msg.sender;
    }
    
    

    // function _msgData() internal view  returns (bytes calldata) {
    //     return msg.data;
    // }
    
    function name() public view returns (string memory){
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function decimals() external view returns (uint8){
        return _decimals;
    }
}
