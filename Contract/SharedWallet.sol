// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;


contract SharedWallet {
    
    event AllowanceChanged(address indexed _forWho,address indexed _fromWhom,  uint _oldAmount, uint _newAmount);
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    address public owner;
    mapping(address => uint) public allowance;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "You are not allowed");
        _;
    }

    function isOwner() public view returns(bool){
        if(owner == msg.sender){
            return true;
        }else{
            return false;
        }
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount,"You are not allowed");
        _;

    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }


    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if (!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    receive() external payable{
        emit MoneyReceived(msg.sender,msg.value);
    }

}
