// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChipToken is ERC20 {
    constructor() ERC20("Chip", "CHI") {

    }

    function mint(address user, uint256 amount) internal {
        _mint(user, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
