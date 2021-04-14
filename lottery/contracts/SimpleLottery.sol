// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public BoNhaCai;
    mapping(uint=>uint) public winners;
    constructor (address _BoNhaCai) {
        BoNhaCai = _BoNhaCai;
    }

    function drawWinner (uint roundId) public {
        
    }
}