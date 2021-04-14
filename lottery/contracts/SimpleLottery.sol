// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BoNhaCai.sol";

contract SimpleLottery {
    address public BoNhaCaiAddr;
    BoNhaCai boNhaCai;

    mapping(uint=>uint) public winners;

    constructor (address addr) {
        BoNhaCaiAddr = addr;
        boNhaCai = BoNhaCai(payable(addr));
    }

    function drawWinner (uint roundId) public {
        require(winners[roundId]!=0);
        BoNhaCai.Round memory tempRound = BoNhaCai.Round(boNhaCai.rounds[roundId]);

        require(block.timestamp > tempRound.endTime + 1 minutes);

        bytes32 rand = keccak256(abi.encode(blockhash(block.number-1)));
        winners[roundId] = uint(rand) % tempRound.ticketIds.length + 1;
    }

    function checkResult(uint ticketId) external view virtual returns (uint256){
        BoNhaCai.Ticket memory tempTicket = boNhaCai.tickets[ticketId];
        if(ticketId == winners[tempTicket.roundId]){
            return boNhaCai.balanceOfRound(tempTicket.roundId);
        }
        else {
            return 0;
        }
    }

    function checkTicketBuy(uint roundId, uint _data) external view virtual returns (bool){
        BoNhaCai.Round memory tempRound = boNhaCai.rounds[roundId];
        require(tempRound.endTime < block.timestamp);
        require(winners[roundId]==0);
        return true;
    }

    function checkRoundCreate(uint _data, uint _endtime) external view virtual returns (bool){
        require(_endtime>block.timestamp);
        return true;
    }
}