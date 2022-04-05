// "SPDX-License-Identifier: MIT"
// Smart contract Developed by BeeHive Team for Meter Hackathon

pragma solidity ^0.8.0;

contract BeeTeamLottery {

    // Status of the Raffle
    enum statusRaffle { InProgress, Finished }

    // Raffle events
    event raffleCreated(uint256, string, uint256,uint256,uint256); // [idRaffle,name,reward,maxTickets,counterTickets,status]
    event userClaimReward(uint256,address); // [idRaffle,winner]
    event raffleClosed(uint256,address); // [idRaffle,owner]

    // The Raffle
    struct Raffle{

        // Part one | Values returned in functions, see below
        address ownerOfRaffle;
        address winner;
        string nameOfRaffle;
        uint rewardAmount;
        bool statusRewarded;
        uint priceTicket;
        uint maxTickets;

        // Part two | Values returned in functions, see below
        statusRaffle status;
        uint counterTickets;
        mapping(uint => address) tickets; // this are used to participants can claim if the raffle pass the finish date without 80% of partic>
        address[] participants;
        uint counterParticipants;
    
    }

    // User Tickets
    struct MyTickets {
        uint256[] ownedIdRaffles;
        uint256[] participantIdRaffle; // Id of the raffles the user participated
        uint256[] tickets; // Tickets of the raffles that user participated
        mapping(uint256 => uint256) myParticipation; // [IdRaffle => MyTicketBuyed]
        uint256 counterForMyTickets;
    }

    // Mappings for Raffles and Participants of that Raffles
    mapping(uint256 => Raffle) public raffles;
    mapping(address => MyTickets) user;

    // TicketCounter
    uint256 raffleNumber = 1;

    // Users can create all Raffles that they want
    function createRaffle(string memory _nameRaffle, uint256 _rewardAmount, uint256 _priceTicket, uint256 _maxTickets) public payable {
        require( (_rewardAmount * 10 ** 18) == msg.value, 'send the same MTR at rewardAmount');
        raffles[raffleNumber].ownerOfRaffle = msg.sender;
        raffles[raffleNumber].nameOfRaffle = _nameRaffle;
        raffles[raffleNumber].rewardAmount = _rewardAmount;
        raffles[raffleNumber].priceTicket = _priceTicket;
        raffles[raffleNumber].maxTickets = _maxTickets;
        raffles[raffleNumber].status = statusRaffle.InProgress;
        raffles[raffleNumber].counterTickets = 0;
        raffleNumber++;
    }

    // Get information of some raffle here | You need to use the Part one and part Two functions to get all the data
    function getRaffleByIdPartOne(uint256 _id) public view returns(
        address ownerOfRaffle,
        address winner,
        string memory nameOfRaffle,
        uint rewardAmount,
        bool statusRewarded,
        uint priceTicket,
        uint maxTickets
        ) {
        return(
            raffles[_id].ownerOfRaffle,
            raffles[_id].winner,
            raffles[_id].nameOfRaffle,
            raffles[_id].rewardAmount,
            raffles[_id].statusRewarded,
            raffles[_id].priceTicket,
            raffles[_id].maxTickets
        );
    }

    function getRaffleByIdPartTwo(uint256 _id) public view returns(
        statusRaffle status,
        uint counterTickets, // this are used to participants can claim if the raffle pass the finish date without 80% of partic>
        address[] memory _participants
    ){
        return(
            raffles[_id].status,
            raffles[_id].counterTickets,
            raffles[_id].participants
        );
    }

    // Here you can buy a ticket for some tickets for specific raffle, anyone can buy exept the owner of the raffle
    // You can buy some many tickets that you want
    function buyTicket(uint256 _idRaffle) public payable {

        // You need to send the same MTR at the price per ticket
        // Example input : msg.value = 1 ether in wei | raffles[_idRaffle].priceTicket = value * 10 ** 18
        require(msg.value == ( raffles[_idRaffle].priceTicket * 10 ** 18 ),'You need to send the price in MTR');

        // You cant buy tickets in your own raffle
        require(msg.sender != raffles[_idRaffle].ownerOfRaffle,'You cant buy tickets in your own raffle');
        
        // Procced to buy the ticket
        bool result = checkParticipant(_idRaffle,msg.sender);
        if(result == false) raffles[_idRaffle].participants.push(msg.sender);
        user[msg.sender].tickets.push(_idRaffle);
    
    }

    // This function check if the participant exists in the Raffle
    function checkParticipant(uint256 _idRaffle, address _userAddress) public view returns(bool){
        bool result = false;
        for(uint i = 0; i < raffles[_idRaffle].counterParticipants;i++){
            if(raffles[_idRaffle].participants[i] == _userAddress){
                result = true;
                break;
            }
        }
        return result;
    }

    // You can check your tickets with this function :)
    function getMyTicketsNumbers() private view returns(uint256[] memory){
        uint256[] memory _tickets;
        for(uint i=0; i < user[msg.sender].counterForMyTickets; i++){
            _tickets[i] = user[msg.sender].myParticipation[i];
        }
        return user[msg.sender].tickets; // this needed to return a key => value result and not only the value result
    }

    // Get the balance of this contract here | Status of Smart Contract Raffle - BeeHive Team
    function getSmartContractBalance() public view returns(uint256){
        return address(this).balance;
    }

}
