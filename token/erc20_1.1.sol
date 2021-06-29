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
    function search(mapping(address => bool) storage self, address _needed) internal returns(bool){
        for(uint i = 0; i< self.length; i++){
            if (self[i] == _needed)
                return true;
        }
        return false;
    }
}



contract KERC20 is IERC20{
    
    using SafeMath for uint;
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint private _total;
    
    mapping (address => uint) private _balances;
    mapping (address => mapping(address => uint)) private _allowed;
    mapping (address => bool) private _minters;
    address private _owner;
    
    
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint initialSupply_, address owner_){
        if (admin == address(0))
            admin = _msgSender();
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _owner = owner_;
        _minters[_msgSender()] = true;
        
        
    }
    
    
    
    
    function minter_facilitate(address _new_minter) public{
        require(msg.sender == minters[0]);
        
        minters.push(_new_minter);
    }
    
    
    
    function mint(address to, uint value) public returns(bool){
        require(utility.search(minters, msg.sender));
        require(total + value > total && balances[to] + value >= balances[to]);
        balances[to] += value;
        total += value;
    }
    
    function _msgSender() internal view  returns (address) {
        return msg.sender;
    }
    
    
    function _msgSender() internal view  returns (address) {
        return msg.sender;
    }

    // function _msgData() internal view  returns (bytes calldata) {
    //     return msg.data;
    // }
    
    function name()  internal view  returns (string){
        return _name;
    }

    function symbol() external view returns (string){
        return _symbol;
    }

    function decimals() external view returns (uint8){
        return _decimals;
    }
}
