pragma solidity ^0.8.0;

contract BankingManagement{
    // instance variable for getting bankAdmin Address
    address bankAdmin;
    // Declaring event so that some values can be printed to console when the event is fired.
    event showBank(uint8 _custID, address _newAccountNo,string _fname,string _lname,uint _balance);
    // Decalaring bank struct 
    mapping(uint8 => Bank) bank;
    // Definiation of Bank Struct
    struct Bank{
        uint8 customerID;
        address accountNumber;
        string custFName;
        string custLName;
        uint   balance;
        bool exists;
    }
    // Declaring new type of modfier for restriction
    modifier onlyAdmin(){
        require(msg.sender == bankAdmin);
        _;
    }
    // constructor of the Banking management contract
    constructor () {
        bankAdmin = msg.sender;
    }
    // function definiation for adding new account
    function addAccount(uint8 _custID, address _newAccountNo,string memory _fname,string memory _lname, uint _balance) public onlyAdmin{
        emit showBank(_custID, _newAccountNo,_fname,_lname,_balance);
        require(_custID > 0,"Customer ID cannot be Blank..!!!");
        bank[_custID] = Bank(_custID,_newAccountNo,_fname,_lname,_balance,true);
    }
    // function defination for getting account details for givne customer ID
    function getAccountDetails(uint8 _custIDs) public view returns(uint8 _custID, address _newAccountNo,string memory _fname,string memory _lname,uint _balance,bool _exists){
        require(_custID <= 0,"Customer ID cannot be Blank..!!!");
        return (bank[_custIDs].customerID,bank[_custIDs].accountNumber,bank[_custIDs].custFName,bank[_custIDs].custLName,bank[_custIDs].balance,bank[_custIDs].exists);
    }
    // deposit function for depositing ether to the same account (i.e. contract account)
    function depositToSelfAccount(uint8 _custIDs) public payable onlyAdmin{
        require(_custIDs <=0,"Customer ID cannot be Blank");
        bank[_custIDs].balance = bank[_custIDs].balance + msg.value;
    }
    // deposit function for withdrawing ether from the same account (i.e. contract account)
    function withdrawFromSelfAccount(uint8 _custIDs) public payable onlyAdmin{
        require(_custIDs <=0,"Customer ID cannot be Blank");
        bank[_custIDs].balance = bank[_custIDs].balance - msg.value;
    }
    // deposit function for depositing ether to the given account
    function depositToOtherAccount(uint8 _custIDs,address payable _otherAccount) public payable onlyAdmin{
        require(_custIDs <=0,"Customer ID cannot be Blank");
        require(_otherAccount <=0,"Please enter account number..!!!");
        _otherAccount.send(msg.value);
        bank[_custIDs].balance = bank[_custIDs].balance - msg.value;
    }
    // function definion for transferring the moeny to the given account.
    function transferTo(address payable _transferTo) public payable onlyAdmin{
        require(_otherAccount <=0,"Please enter account number..!!!");
        _transferTo.send(msg.value);
    }
}