// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

// Import the Ownable contract from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

contract Property is Ownable {
    struct PropertyMap {
        uint256[] keys;
        mapping(uint256 => PropertyStruct) values;
    }

    struct PropertyStruct {
        uint256 id;
        string name;
        string location;
        uint256 price;
        string description;
        address owner;
        bool leased;
        address lessee;
    }

    event Log(string message, uint256 gas);

    PropertyMap private properties;

    constructor(address _owner) Ownable(_owner) {}

    receive() external payable {
        emit Log("Receive : ", gasleft());
    }

    fallback() external payable {
        emit Log("Fallback : ", gasleft());
    }

    function deposit() public payable {}

    function createProperty(
        string memory _name,
        string memory _location,
        uint256 _price,
        string memory _description
    ) public onlyOwner {
        uint256 newId = block.timestamp;

        require(
            properties.values[newId].id == 0,
            "Property with this ID already exists"
        );

        properties.values[newId] = PropertyStruct(
            newId,
            _name,
            _location,
            _price,
            _description,
            msg.sender,
            false,
            address(0)
        );
        properties.keys.push(newId);
    }

    function getProperty(uint256 _id)
        public
        view
        returns (PropertyStruct memory)
    {
        return properties.values[_id];
    }

    function requestLease(uint256 _id) public payable {
        PropertyStruct storage property = properties.values[_id];

        require(property.id != 0, "Property does not exist");
        require(!property.leased, "Property is already leased");
        require(msg.value == property.price, "Incorrect payment amount");

        (bool ok,) = payable(address(this)).call{value: property.price}("");
        require(ok, "Payment failed");

        property.leased = true;
        property.lessee = msg.sender;
    }

    function endLease(uint256 _id) public {
        PropertyStruct storage property = properties.values[_id];

        require(property.id != 0, "Property does not exist");
        require(property.leased, "Property is not leased");

        property.leased = false;
        property.lessee = address(0);
    }

    function updateProperty(
        uint256 _id,
        string memory _name,
        string memory _location,
        uint256 _price,
        string memory _description
    ) public onlyOwner {
        PropertyStruct storage property = properties.values[_id];

        require(property.id != 0, "Property does not exist");

        property.name = _name;
        property.location = _location;
        property.price = _price;
        property.description = _description;
    }

    function getPropertiesCount() public view returns (uint256) {
        return properties.keys.length;
    }

    function getAllProperties() public view returns (PropertyStruct[] memory) {
        PropertyStruct[] memory allProperties = new PropertyStruct[](properties.keys.length);

        for (uint256 i = 0; i < properties.keys.length; i++) {
            allProperties[i] = properties.values[properties.keys[i]];
        }

        return allProperties;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Insufficient balance");
        require(msg.sender == owner(), "Only owner can withdraw funds");
        (bool sent,) = payable(owner()).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}