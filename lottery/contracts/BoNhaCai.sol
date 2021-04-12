// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./CustomERC20.sol";

abstract contract checkResultInterface {
    function checkResult() external view virtual returns (int256);
}

abstract contract checkTicketBuyInterface {
    function checkTicketBuy() external view virtual returns (bool);
}

contract BoNhaCai is CustomERC20 {
    constructor() CustomERC20("Chip", "CHI") {}

    struct Ticket {
        uint256 value;
        uint256 ticketPrice;
        bool payed;
        uint256 roundId;
    }

    struct Round {
        uint256 endTime;
        address resultContract;
        uint256[] ticketIds;
    }

    Ticket[] public tickets;
    Round[] public rounds;

    mapping(uint256 => uint256) private _balanceOfRounds;

    mapping(uint256 => address) private _roundOwners;

    mapping(uint256 => address) private _ticketOwners;

    function createRound(
        address _resultContract,
        uint256 _endTime,
        uint256 _balance
    ) external {
        Round memory newRound = Round(_endTime, _resultContract, new uint256[](0));
        rounds.push(newRound);
        uint roundId = rounds.length-1;
        _roundOwners[roundId] = msg.sender;
        _transferToRound(msg.sender, roundId, _balance);
    }

    function buyTicket(
        uint256 _roundId,
        uint256 _price,
        uint256 _data
    ) external {

        _transferToRound(msg.sender, _roundId, _price);
        Ticket memory newTicket = Ticket(_roundId, _price, false, _data);
        tickets.push(newTicket);
        uint ticketId = tickets.length - 1;
        rounds[_roundId].ticketIds.push(ticketId);
        _ticketOwners[ticketId] = msg.sender;
    }

    function _transferToRound(
        address _sender,
        uint256 _roundId,
        uint256 _amount
    ) internal {
        require(_sender != address(0), "ERC20: transfer from the zero address");
        require(_roundExists(_roundId), "Operator query for nonexistent round");

        uint256 senderBalance = _balances[_sender];
        require(senderBalance >= _amount, "ERC20: transfer amount exceeds balance");
        _balances[_sender] = senderBalance - _amount;
        _balanceOfRounds[_roundId] += _amount;
    }

    function _transferFromRound(
        address _recipient,
        uint256 _roundId,
        uint256 _amount
    ) internal {
        require(
            _recipient != address(0),
            "ERC20: transfer to the zero address"
        );
        require(_roundExists(_roundId), "Operator query for nonexistent round");

        uint256 senderBalance = _balanceOfRounds[_roundId];
        require(
            senderBalance >= _amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balanceOfRounds[_roundId] = senderBalance - _amount;
        _balances[_recipient] += _amount;
    }

    function _roundExists(uint256 _roundId) internal view returns (bool) {
        return _roundOwners[_roundId] != address(0);
    }

    function _ticketExists(uint256 _roundId) internal view returns (bool) {
        return _ticketOwners[_roundId] != address(0);
    }
}
