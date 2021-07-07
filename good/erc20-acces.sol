// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract KERC is ERC20, ERC20Burnable, AccessControl{
    
    bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    constructor() ERC20("KERC20", "K20") public {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }
    
    function promoteMinter(address minter) public onlyRole(DEFAULT_ADMIN_ROLE){
        grantRole(MINTER_ROLE, minter);
    }
    
    function demoteMinter(address minter) public onlyRole(DEFAULT_ADMIN_ROLE){
        revokeRole(MINTER_ROLE, minter);
    }
    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
}
