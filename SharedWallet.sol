// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
 
contract SharedWallet {
    
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "You are not allowed");
        _;
    }


    
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner {
        _to.transfer(_amount);
    }

    receive() external payable{}

}
