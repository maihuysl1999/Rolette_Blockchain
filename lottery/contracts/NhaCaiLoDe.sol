pragma solidity >=0.4.22 <0.9.0;

contract NhaCaiLoDe {
    struct Ticket {
        address buyer;
        uint256 value;
        uint256 ticketPrice;
        bool payed;
    }

    struct Round {
        address owner;
        uint256 balance;
        uint256 endTime;
        address resultContract;
        uint[] ticketIds;
    }

    function withDraw(uint _roundId, uint _ticketId) public{
        require(rounds[_roundId].endTime < now + 5 minutes);
        require(tickets[_ticketId].buyer==msg.sender);
        require(!tickets[_ticketId].payed);

    }

    Ticket[] public tickets;
    Round[] public rounds;

    mapping(address => uint256) public balance;

    function createRound(uint256) external {}

    string public name = "DApp Token";
    string public symbol = "DAPP";
    uint256 public totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function DappToken(uint256 _initialSupply) public {
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

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }
}
