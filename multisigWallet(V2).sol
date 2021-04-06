// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.3;
pragma abicoder v2;

contract Wallet{
    uint balance;
    uint minApprovals;
    uint numberOfOwners;
    
    address[] owners;
    
    struct Request {
        uint id;
        address recipient;
        uint amount;
        bool accepted;
        address [] approvers;
    }
    Request[] requests;
    
    event TransferRequestCreated(uint _id, address _initiator, address _recipient, uint _amount);
    event ApprovalRecieved(uint _id, address _approver, uint _approvals);
    event TransferApproved(uint _id);
    
    constructor(address[] memory _addresses, uint _minApprovals){
        for(uint i=0;i<_addresses.length;i++){
            owners.push(_addresses[i]);
        }
        minApprovals = _minApprovals;
    }
    
    modifier onlyOwners{
        bool isOwner = false;
        for(uint i=0;i<owners.length;i++){
            if(msg.sender==owners[i]){
                isOwner = true;
                break;
            }
        }
        require(isOwner, "You are not the owner of this wallet!");
        _;
    }
    
    function deposit() public payable onlyOwners{
        balance += msg.value;
    }
    
    address [] tmp;
    function transferRequest(address _recipient, uint _amount) public onlyOwners{
        require(balance >= _amount, "Balance not sufficient");
        uint n = requests.length;
        emit TransferRequestCreated(n, msg.sender, _recipient, _amount);
        while(tmp.length!=0){
            tmp.pop();
        }
        tmp.push(msg.sender);
        Request memory requestInstance = Request(n, _recipient, _amount, false, tmp);
        requests.push(requestInstance);
    }
    
    function viewTransferRequests() public view returns(Request[] memory){
        return requests;
    }
    
    function approveTransfer(uint _id) public onlyOwners{
        require(!requests[_id].accepted, "This transaction has already been completed!");
        bool firstVote = true;
        uint i=0;
        for(;i<requests[_id].approvers.length;i++){
            if(msg.sender == requests[_id].approvers[i]){
                firstVote = false;
            }
        }
        require(firstVote, "You already accepted this request!");
        emit ApprovalRecieved(_id, msg.sender, i+1);
        requests[_id].approvers.push(msg.sender);
        if(i + 1 >= minApprovals){
            transfer(_id);
        }
    }
    
    function transfer(uint _id) private{
        require(balance >= requests[_id].amount, "Balance not sufficient");
        emit TransferApproved(_id);
        requests[_id].accepted = true;
        balance -= requests[_id].amount;
        payable(requests[_id].recipient).transfer(requests[_id].amount);
    }
    
    function getBalance() public view onlyOwners returns(uint){
        return balance;
    }
    
    function viewOwners() public view returns(address[] memory){
        return owners; 
    }
}
