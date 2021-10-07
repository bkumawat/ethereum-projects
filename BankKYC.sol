pragma solidity ^0.8.0;

contract BankKYC{
    address contractAdmin;
    mapping(uint => Customer) customers;
    mapping(uint => Bank) banks;
    mapping(address => address) bannedBanks;

    address[] listOfBanks;
    address[] listOfCustomers;
    uint[] kycRequest;
    
    struct Customer{
        uint bankID;
        uint custID;
        string first_name;
        string second_name;
        address cust_address; 
        bool kyc_status;
    }
    struct Bank{
        uint bankId;
        string bank_name;
        address bankAddress;
        string bank_status;
    }
    modifier restricted(){
        require(msg.sender == contractAdmin);
        _;
    }
    constructor (){
        contractAdmin = msg.sender;
    }
    function addNewBank(uint _bankID,string memory _bankName, address _bankAaddress,string memory _bankStatus) public restricted {
        require(_bankID <=  0,"Bank ID cannot be Blank..!!");
        require(bytes(_bankName).length == 0,"Bank Name cannot be Blank..!!");
        require(keccak256(bytes("_bankStatus")) == "valid" ,"You can only add Bank with Valid Status..!!");
        banks[_bankID] = Bank(_bankID,_bankName,_bankAaddress,_bankStatus);
        listOfBanks.push(_bankAaddress);
    }
    function getBankByBankID(uint _bankID) public view restricted 
        returns (uint bankId, 
        string memory bank_name,
        address bankAddress,
        string memory bank_status){
        require(_bankID <= 0,"Bank ID cannot be Blank..!!");
        return(banks[_bankID].bankId,banks[_bankID].bank_name,banks[_bankID].bankAddress,banks[_bankID].bank_status);
    }
    function addCustomersToBank(uint _bankId,
        uint _custID,
        string memory _custFname, 
        string memory _custLname,
        address _custAddress,
        bool _kycStatus) public {
        require(_bankId <= 0,"Bank ID cannot be Blank..!!");
        require(_custID <= 0,"Customer Id cannot be Blank..!!");
        require(keccak256(bytes(_custFname)).length == 0,"Customer First Name cannot be blank");
        require(keccak256(bytes(_custLname)).length == 0,"Customer Last Name cannot be blank");
        require(keccak256(bytes(banks[_bankId].bank_status)) != keccak256(bytes("banned for Customer")),"Bank in banned status and not allowed to add new Customers....!!!");   
        customers[_custID] = Customer(_bankId,_custID,_custFname,_custLname,_custAddress,_kycStatus);
        listOfCustomers.push(_custAddress);
    }
    function getCustomerByCustID(uint _custId) public view returns(uint _bankId,uint _custID,
        string memory _custFname, 
        string memory _custLname,
        address _custAddress,
        bool _kycStatus){
        require(_custID <= 0,"Customer Id cannot be Blank..!!");
        return (customers[_custId].bankID,customers[_custId].custID,customers[_custId].first_name,customers[_custId].second_name,customers[_custId].cust_address,customers[_custId].kyc_status);
    }
    function checkKYCStatusOfCustomer(uint _custId) public view returns(bool _kycStatus){
        require(_custId <= 0,"Customer Id cannot be Blank..!!");
        return (customers[_custId].kyc_status);
    }
    function bannedTheBank(uint _bankId, string memory _bannedType,address _bankAddress) public restricted returns(string memory _bankStatus) {
        banks[_bankId].bank_status = _bannedType;
        bannedBanks[_bankAddress] = _bankAddress;
        require(_bankId <= 0,"Bank Id cannot be Blank..!!");
        return banks[_bankId].bank_status;
    }
    function liftTheBanned(uint _bankId, string memory _newBankStatus) public restricted returns(string memory _bankStatus) {
        banks[_bankId].bank_status = _newBankStatus;
        require(_bankId <= 0,"Bank Id cannot be Blank..!!");
        return banks[_bankId].bank_status;
    }
    function kycRequestByBank(uint _bankId,uint _custID) public returns(uint _totalKYCRequest) {
        require(keccak256(bytes(banks[_bankId].bank_status)) != keccak256(bytes("banned for KYC")),"Bank in banned status is not allowed to request Customer KYC..!!");   
        require(_bankId <= 0,"Bank Id cannot be Blank..!!");
        require(_custID <= 0,"Customer Id cannot be Blank..!!");
        kycRequest.push(_custID);
        return(kycRequest.length);
    }
    function ListCustomers() public view returns(address[] memory){
        return listOfCustomers;
    }
    function ListRegisteredBanks() public view returns(address[] memory){
        return listOfBanks;
    }
}