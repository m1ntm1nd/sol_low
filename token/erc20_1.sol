// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


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


contract KERC20 is IERC20{
    using SafeMath for uint;
    using utility for address;
    
    uint private total;
    string public constant name = "KERC20";
    string public constant symbol = "K20";
    
    mapping (address => uint) private balances;
    mapping (address => mapping(address => uint)) private allowed;
    address[] public minters;
    
    constructor () public{
        minters.push(msg.sender);
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
    
    function totalSupply() override public view returns(uint){
        return total;
    }
    
    function balanceOf(address _owner) override public view returns(uint){
        return balances[_owner];
    }
    
    function allowance(address _owner, address _sender) override public view returns(uint){
        return allowed[_owner][_sender];
    }
    
    function transfer(address _to, uint _value) override public returns(bool){
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) override public returns(bool){
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][_to] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][_to] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint _value) override public returns(bool){
        allowed[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
}
