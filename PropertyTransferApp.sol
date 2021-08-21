pragma solidity ^0.5.11;

contract PropertyTransferApp {
    // Defining new Mapping type for property
    mapping(uint256 => Property) public properties;
    // Defining Instance Variable
    address public contractOwner;
    // Defining Struct for Property
    struct Property {
        uint256 id;
        string name;
        string owner;
        uint256 value;
        uint256 area;
    }
    // Initializing Owner of Property Transfer
    constructor() public {
        contractOwner = msg.sender;
    }
    // Defining New Modifier to put restriction
    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }
    // Defining Add Property Method for adding new Property
    function addProperty(uint256 _propertyid,string memory _name,string memory _owner,uint256 _value,uint256 _area) 
    public onlyOwner {
        require(_propertyid > 0,"Property ID should be greater than Zero...!!!");
        properties[_propertyid].id    = _propertyid;
        properties[_propertyid].name  = _name;
        properties[_propertyid].owner = _owner;
        properties[_propertyid].value = _value;
        properties[_propertyid].area  = _area;
    }
    // Query for Property by Query ID
    function queryPropertyById(uint256 _propertyid) public view 
        returns (uint256 propertyID,string memory name,string memory owner,uint256 area,uint256 value) {
        require(_propertyid > 0,"Property ID cannot be null...!!!");
        return (properties[_propertyid].id,properties[_propertyid].name,properties[_propertyid].owner,properties[_propertyid].area,properties[_propertyid].value);
    }
    // Transferring property to new Owner
    function transferPropertyOwnership(uint256 _propertyid,string memory _newOwner) public {
        require(properties[_propertyid].id == _propertyid,"Property does not exists on Blockchain...!!!");
        properties[_propertyid].owner = _newOwner;
    }
}