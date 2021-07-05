// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "https://github.com/m1ntm1nd/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/m1ntm1nd/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract KERC is ERC20, ERC20Burnable{
    constructor() ERC20("KERC20", "K20") public {
    }
}
