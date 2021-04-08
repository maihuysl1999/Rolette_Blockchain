pragma solidity ^0.8.0;

abstract contract checkResultInterface {
    function checkResult() external view virtual returns(int) ;
}

abstract contract checkTicketBuyInterface {
    function checkTicketBuy() external view virtual returns(bool) ;
}

contract BoNhaCai{
    struct Ticket {
        address buyer;
        uint256 value;
        uint256 ticketPrice;
        bool payed;
        uint roundId;
    }

    struct Round {
        address owner;
        uint256 balance;
        uint256 endTime;
        address resultContract;
        uint[] ticketIds;
    }

    Ticket[] public tickets;
    Round[] public rounds;
    
    mapping(uint256 => uint256) public balanceOfRound;
    mapping(address => uint256) public balanceOf;

    string public name = "DApp Token";
    string public symbol = "DAPP";
    uint256 public totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor (uint256 _initialSupply){
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function withDraw(uint _ticketId) public{
        uint roundId = tickets[_ticketId].roundId;
        require(rounds[roundId].endTime < block.timestamp + 5 minutes);
        require(tickets[_ticketId].buyer==msg.sender);
        require(!tickets[_ticketId].payed);
        checkResultInterface resultContract = checkResultInterface(rounds[roundId].resultContract);
        int winPrice = resultContract.checkResult();
        require(winPrice > 0);

    }

}
