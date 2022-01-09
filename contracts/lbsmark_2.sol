//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Endorse {
  mapping(address => uint) public endorsers;
  address public admin;
  uint public noOfEndorsers;
  uint public minEndorsement; // Minimum to make it significant
  uint public maxEndorsement; // Maximum to force multiple Endorsements
  uint public deadline; // timestamp to deadline
  uint public thresholdAmount; // Amount needed for Endorsement
  uint public endorsedAmount;
  bool public endorseStatus = false; // Prevents any transfers to the creator until deadline is complete and endorsed achieved.

  /*
    Events to emit to interfaces
   */

  event Endorsement_CreatedEvent(address _sender, uint _deadline); // Event notifying Who is needed endorsement and by When
  event Endorsement_EndorseEvent(address _sender, uint _value); // Event notifying Who had endorsed and the Amount
  event Endorsement_CompleteEvent(address _sender, uint _value); // Event notifying Who is needed endorsement and by When

  constructor(uint _deadlineperiod) { //Input the ***Additional time*** used to deadline
    thresholdAmount = 1000 wei; // Requires 1000 wei to form an Endorsement
    deadline = block.timestamp + _deadlineperiod; // Deadline is time from Contract creation
    minEndorsement = 100 wei; // Minimum requires 100 wei (10 endorsers)
    maxEndorsement = 300 wei; // Maximum requires 300 wei (4 ensorsers)

    noOfEndorsers = 0; // Start from no Endorsers
    endorsedAmount = 0; // Start from 0 wei endorsed

    admin = msg.sender;
    emit Endorsement_CreatedEvent(msg.sender,deadline);
  }

  function endorse() public payable {
    require(block.timestamp < deadline, "Error: Deadline has Passed!"); // Check the Endorsement is still on going
    require(msg.value >= minEndorsement, "Error: Minimum Endorsement is not met!"); // Check there is sufficient Endorsement
    require(msg.value <= maxEndorsement, "Error: Maximum Endorsement is exceeded"); // Check it does not exceed max Endorsement

    if (endorsers[msg.sender] == 0) noOfEndorsers++;

    endorsers[msg.sender] += msg.value;
    endorsedAmount += msg.value;

    emit Endorsement_EndorseEvent(msg.sender, msg.value);
  }

  receive() payable external {
    endorse();
  }

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }

  function getRefund() public {
    require(block.timestamp) > deadline && (endorsedAmount < thresholdAmount)); // Refunds when exceed deadline and not enough endorsement
    require(endorsers[msg.sender] > 0); // Actually endorsed

    uint refundValue = endorsers[msg.sender];
    payable(msg.sender).transfer(refundValue); // Pay back the msg sender what was endorsed.
    endorses[msg.sender]=0; // Reduce that back to 0 since it was refunded



  }

  modifier onlyAdmin() {
    require(msg.sender == admin, "only admin can call");
    _;
  }

  function getEndorsement() public onlyAdmin {
    require(endorseStatus == false,"Error: Already completed.");
    require(endorsedAmount >= thresholdAmount,"Error: Not yet passed Endorsement Threshold");
    require(endorsedAmount >= thresholdAmount && block.timestamp < deadline, "Error: Not yet past the deadline");
    endorseStatus == true; // close the payments.

    admin.transfer(endorsedAmount); //Transfer amount
  }


}
