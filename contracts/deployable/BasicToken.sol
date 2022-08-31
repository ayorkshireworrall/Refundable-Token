// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title BasicToken
 * @dev A deployable ERC20 token that defines the initial supply and gives it all
 * to the wallet of the deployer
 */
contract BasicToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Basic", "BSC") {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }
}