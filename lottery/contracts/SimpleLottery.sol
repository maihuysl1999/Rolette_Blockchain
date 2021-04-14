// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BoNhaCai.sol"

contract SimpleLottery {
    address public BoNhaCaiAddr;
    BoNhaCai boNhaCai;

    mapping(uint=>uint) public winners;

    constructor (address addr) {
        BoNhaCaiAddr = addr;
        boNhaCai = BoNhaCai(addr);
    }

    function drawWinner (uint roundId) public {
        require(winners[roundId]!=0);
        Round memory tempRound = boNhaCai.rounds[roundId];

        require(block.timestamp > tempRound.endTime + 1 minutes);

        bytes32 rand = keccak256(abi.encode(bloackhash(block.number-1));
        winner[roundId] = uint(rand) % tempRound.ticketIds.length + 1;
    }

    function checkResult(uint ticketId) external view virtual returns (uint256){
        Ticket memory tempTicket = boNhaCai.tickets[ticketId];
        if(ticketId == winner[tempTicket.roundId)]){
            return boNhaCai.balanceOfRound(tempTicket.roundId);
        }
        else return 0;
    }

    function checkTicketBuy(uint roundId, uint _data) external view virtual returns (bool){
        Round memory tempRound = boNhaCai.rounds[roundId];
        require(tempRound.endTime < block.timestamp);
        require(winner[roundId]==0);
        return true;
    };

    function checkRoundCreate(uint _data, uint _endtime) external view virtual returns (bool){
        require(_endtime>block.timestamp);
        return true;
    }
}