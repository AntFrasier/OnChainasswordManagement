// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

/**
 * A smart contract that securly store your password onChain 
 * @author Cyril Maranber
 */

 contract PasswordStorage {

    struct Password {
        string url;
        string userName;
        string password;
    }

    Password[] public passwords;

    mapping (address => Password[]) public stored;
    mapping (address => bool) public member;

    modifier onlyMembers (){
        require (member[msg.sender], "Not a member");
        _;
    }

    function memberInscription() external payable {
        require(msg.value >= 0.001 ether, "Please pay at least 0.001 eth to becam member");
        member[msg.sender] = true;
    }

    function addPassword( string memory _url, string memory _userName, string memory _password ) external onlyMembers{
        Password[] storage oldPasswords = stored[msg.sender];
        oldPasswords.push(Password(_url, _userName, _password));
        stored[msg.sender] = oldPasswords;
        
    }

    function getPassword (string memory _url) public view onlyMembers returns(string memory password){
        Password[] memory pass = stored[msg.sender];
        for (uint i=0; i < pass.length; i++){
            if (keccak256(abi.encodePacked(pass[i].url)) == keccak256(abi.encodePacked(_url))) return pass[i].password;
        }
    } 

    receive() external payable{}

 }