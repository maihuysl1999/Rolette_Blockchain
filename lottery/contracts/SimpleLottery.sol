pragma solidity >=0.4.22 <0.9.0; 

contract SimpleLottery {
    uint public constant TICKET_PRICE = 1e16; // 0.01 ether

    address[] public tickets;
    address public winner;
    uint public ticketingCloses;

    constructor (uint duration) public {
        ticketingCloses = now + duration;
    }

    function buy () public payable {
        require(msg.value == TICKET_PRICE); 
        require(now < ticketingCloses);

        tickets.push(msg.sender);
    }

    function drawWinner () public {
        require(now > ticketingCloses + 5 minutes);
        require(winner == address(0));

        bytes32 rand = keccak256(
            abi.encodePacked(blockhash(block.number-1))
        );
        winner = tickets[uint(rand) % tickets.length];
    }


    function withdraw () public {
        require(msg.sender == winner);
        msg.sender.transfer(address(this).balance);
    }

    function () payable external{
        buy();
    }
}