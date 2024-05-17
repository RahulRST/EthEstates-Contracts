// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

contract Property {
    // Define a struct to represent a property
    struct PropertyStruct {
        string id;
        string name;
        string location;
        uint256 price;
        string description;
        address owner;
        bool leased;
        address leasee;
    }

  // Define a mapping to store properties with their unique IDs as keys
  mapping(string => PropertyStruct) public properties;

  // Function to create a new property
  function createProperty(
    string memory _id,
    string memory _name,
    string memory _location,
    uint256 _price,
    string memory _description
  ) public {
    require(bytes(properties[_id].id).length == 0, "Property with this ID already exists");
    properties[_id] = PropertyStruct(_id, _name, _location, _price, _description, msg.sender, false, address(0));
  }

  // Function to get details of a property by ID
  function getProperty(string memory _id) public view returns (PropertyStruct memory) {
    return properties[_id];
  }

  // Function to return an array of all properties
  function getAllProperties() public view returns (PropertyStruct[] memory) {
    // Initialize an empty array to store all properties
    PropertyStruct[] memory allProperties = new PropertyStruct[](0);

    // Loop through the mapping and add each property to the array
    for (string memory key in properties) {
      allProperties = push(allProperties, properties[key]);
    }


    return allProperties;
  }

  // Helper function to add elements to a dynamic array (not built-in in Solidity)
  function push(PropertyStruct[] memory array, PropertyStruct memory element) internal pure returns (PropertyStruct[] memory) {
    uint newLength = array.length + 1;
    PropertyStruct[] memory newArray = new PropertyStruct[](newLength);

    for (uint i = 0; i < array.length; i++) {
      newArray[i] = array[i];
    }

    newArray[newLength - 1] = element;
    return newArray;
  }
}
