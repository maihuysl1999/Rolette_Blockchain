// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    uint public constant TICKET_PRICE = 1e16; // 0.01 ether

    address[] public tickets;
    address public winner;
    uint public ticketingCloses;

    constructor (uint duration) {
        ticketingCloses = block.timestamp + duration;
    }

    function buy () public payable {
        require(msg.value == TICKET_PRICE); 
        require(block.timestamp < ticketingCloses);

        tickets.push(msg.sender);
    }

    function drawWinner () public {
        require(block.timestamp > ticketingCloses + 5 minutes);
        require(winner == address(0));

        bytes32 rand = keccak256(
            abi.encodePacked(blockhash(block.number-1))
        );
        winner = tickets[uint(rand) % tickets.length];
    }


    function withdraw () public payable{
        require(msg.sender == winner);
        payable(msg.sender).transfer(address(this).balance);
    }

    fallback () payable external{
        buy();
    }

    receive() external payable {
        buy();
    }
}