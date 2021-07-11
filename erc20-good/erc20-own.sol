// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "../extensions/Mintable.sol";

contract KERC is ERC20, ERC20Burnable, Ownable, Mintable {

    constructor(uint initialSupply_) ERC20("KERC20", "K20") {
        _mint(owner(), initialSupply_); 
    }
    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
    }
}