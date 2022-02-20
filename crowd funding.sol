//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract crowdFunding{
   mapping(address=>uint) public contributers;     //contributers[msg.sender] represents ether they have sent
   address manager;
   uint deadline;
   uint raisedMoney;
   uint target;
   uint noOfContibuters;

   struct Request{
       string description;
       uint value;
       address payable recipient; //the person for which the request is generated
       bool completed; 
       uint noOfVoters;  
       mapping(address=>bool) voters;    
       
   }

   mapping(uint=>Request) public requests;



   constructor (uint _deadline, uint _target){
       manager=msg.sender;
       deadline= block.timestamp+ _deadline;  //10sec+3600sec
       target= _target;

   }

   function contributeEther() payable public{
       require(msg.value>=1 ether,"Minimum contribution is 1 ether");
       require(block.timestamp<deadline,"Deadline crossed");

       if(contributers[msg.sender]==0)
       {
           noOfContibuters++;
       }

       contributers[msg.sender]=contributers[msg.sender] + msg.value;    //for contributing more than once
        raisedMoney=raisedMoney+contributers[msg.sender];
   }

    function checkBalance() public view returns(uint){
        return address(this).balance;
    }

    function refund() public{
        require(block.timestamp>deadline && raisedMoney<target,"Cannot refund");
        require(contributers[msg.sender]>0,"Cannot refund as don't contribute any");   //to avoid 2nd time refund for the same contributor
        address payable user;
        user.transfer(contributers[msg.sender]);
        contributers[msg.sender]=0;
        
    }

    function makeRequest(string memory _description,uint _value, address payable _recipient) public {
           Request memory newRequest= requests;
           newRequest.description=_description;
           newRequest.value=_value;
           newRequest.recipient=_recipient;
           newRequest.completed=false;
           newRequest.noOfVoters=0;
    }

    function voting() public{
        
    }
}