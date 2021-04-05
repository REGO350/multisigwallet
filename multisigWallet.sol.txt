// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;

contract Wallet{
    uint balance;
    uint minApprovals;
    bool requested = false;
    address recipient;
    uint amount;
    uint id=0;
    
    mapping(address => uint) index;
    struct Owner{
        address user;
        bool accept;
    }
    Owner[] owners;
    
    event TransferRequestCreated(uint _id, address _initiator, address _recipient, uint _amount);
    event ApprovalRecieved(uint _id, address _approver, uint _approvals);
    event TransferApproved(uint _id);
    
    
    constructor(address[] memory _addresses, uint _minApprovals){
        for(uint i=0;i<_addresses.length;i++){
            Owner memory newOwner = Owner(_addresses[i], false);
            owners.push(newOwner);
            index[_addresses[i]] = i;
        }
        minApprovals = _minApprovals;
    }
    
    modifier onlyOwners{
        bool isOwner = false;
        for(uint i=0;i<owners.length;i++){
            if(msg.sender==owners[i].user){
                isOwner = true;
                break;
            }
        }
        require(isOwner);
        _;
    }
    
    
    function deposit() public payable onlyOwners {
        balance += msg.value;
    }
    
    function transferRequest(address _recipient, uint _amount) public onlyOwners{
        id++;
        resetApproval();
        recipient = _recipient;
        amount = _amount;
        require(balance >= amount, "Balance not sufficient");
        requested = true;
        owners[index[msg.sender]].accept = true;
        emit TransferRequestCreated(id, msg.sender, recipient, amount);
    }
    
    function approveTransfer() public onlyOwners{
        require(requested);
        owners[index[msg.sender]].accept = true;
        uint count=0;
        for(uint i=0;i<owners.length;i++){
            if(owners[i].accept == true){ 
                count++;
            }
        }
        emit ApprovalRecieved(id, msg.sender, count);
        if(count >= minApprovals){
            emit TransferApproved(id);
            transfer();
        }
    }
    
    function transfer() private{
        require(balance >= amount, "Balance not sufficient");
        payable(recipient).transfer(amount);
        balance -= amount;
    }
    
    function resetApproval() private{
        for(uint i=0;i<owners.length;i++){
            owners[i].accept = false;
        }
        requested = false;
    }
    
    function getBalance() public view returns(uint){
        return balance;
    }
}


