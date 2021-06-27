// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

//import "https://github.com/m1ntm1nd/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol" as SafeMath;


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
    //using SafeMath for uint;
    
    string public constant name = "KERC20";
    string public constant symbol = "K20";
    uint private total;
    
    mapping (address => uint) private balances;
    mapping (address => mapping(address => uint)) private allowed;
    
     
    function mint(address to, uint value) public{
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




library arrayLib{
    function search(uint[] storage self, uint _value) view public returns(uint){
        for (uint i = 0; i<self.length; i++){
            if(self[i] == _value) return self[i];
        }
        return 0;
    }
    
    function remove(uint[] storage self, uint index) public{
        require(index>=0);
        for(uint i = index; i<self.length; i++){
            self[i] = self[i+1];
        }
        delete self[self.length - 1];
        //..lf.length--; 
    }
}


contract contrName{
    address adr;
    constructor() {
        adr = msg.sender;
    }
    function revealAdrress() view public returns(address){
        return adr;
    }
}
