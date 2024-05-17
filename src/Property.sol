// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Property is Ownable {
  // Define a struct to represent a property
  struct PropertyStruct {
    uint256 id; // Use a counter for unique IDs
    string name;
    string location;
    uint256 price;
    string description;
    address owner;
    bool leased;
    address leasee;
  }

  // Use a counter to generate unique IDs for properties
  using Counters for Counters.Counter;
  Counters.Counter private _propertyIds;

  // Define a mapping to store properties with their IDs as keys
  mapping(uint256 => PropertyStruct) public properties;

  // Function to create a new property
  function createProperty(
    string memory _name,
    string memory _location,
    uint256 _price,
    string memory _description
  ) public onlyOwner {
    uint256 newId = _propertyIds.current();
    _propertyIds.increment();

    properties[newId] = PropertyStruct(
      newId,
      _name,
      _location,
      _price,
      _description,
      msg.sender,
      false,
      address(0)
    );
  }

  // Function to get details of a property by ID
  function getProperty(uint256 _id) public view returns (PropertyStruct memory) {
    return properties[_id];
  }

  // Function to return an array of all properties (using a loop with counters)
  function getAllProperties() public view returns (PropertyStruct[] memory) {
    uint256 totalProperties = _propertyIds.current();
    PropertyStruct[] memory allProperties = new PropertyStruct[](totalProperties);

    // Loop through all property IDs and fetch details
    for (uint256 i = 0; i < totalProperties; i++) {
      allProperties[i] = properties[i + 1]; // IDs start from 1
    }

    return allProperties;
  }
}
