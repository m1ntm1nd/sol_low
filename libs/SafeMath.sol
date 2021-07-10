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