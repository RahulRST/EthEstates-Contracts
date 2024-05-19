// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Property } from "../src/Property.sol";

// Import the testing framework from the forge std library
import { Vm } from "forge-std/Vm.sol";
import { Test, console } from "forge-std/Test.sol";

contract PropertyTest is Test {
    Property propertyContract;
    address owner;

    function setUp() public virtual {
        owner = address(this);
        propertyContract = new Property(owner);
    }

    function testDeployment() public view {
        // Assert the owner of the contract is the deployer
        assertEq(propertyContract.owner(), owner);
    }

    function testCreateProperty() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Call the function and store the transaction
        uint256 propertyId = block.timestamp;
        propertyContract.createProperty(name, location, price, description);

        // Fetch the created property
        Property.PropertyStruct memory createdProperty = propertyContract.getProperty(propertyId);

        // Assert property details
        assertEq(createdProperty.name, name);
        assertEq(createdProperty.location, location);
        assertEq(createdProperty.price, price);
        assertEq(createdProperty.description, description);
        assertEq(createdProperty.owner, owner);
    }

    function testCreateProperty_RevertDuplicateId() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        propertyContract.createProperty(name, location, price, description);

        // Expect revert when creating with the same ID
        vm.expectRevert("Property with this ID already exists");
        propertyContract.createProperty(name, location, price, description);
    }

    function testRequestLease() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        uint256 propertyId = block.timestamp;
        propertyContract.createProperty(name, location, price, description);

        // Lease the property
        propertyContract.requestLease(propertyId);

        // Fetch the created property
        Property.PropertyStruct memory createdProperty = propertyContract.getProperty(propertyId);
        console.log("Property Id : ",createdProperty.id);
        console.log("Property Name : ",createdProperty.name);
        console.log("Property Location : ",createdProperty.location);
        console.log("Property Price : ",createdProperty.price);
        console.log("Property Description : ",createdProperty.description);
        console.log("Property Owner : ",createdProperty.owner);
        console.log("Property Leased : ",createdProperty.leased);
        console.log("Property Leasee : ",createdProperty.leasee);

        // Assert property details
        assertEq(createdProperty.leased, true);
    }

    function testEndLease() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        uint256 propertyId = block.timestamp;
        propertyContract.createProperty(name, location, price, description);

        // Lease the property
        propertyContract.requestLease(propertyId);

        // End the lease
        propertyContract.endLease(propertyId);

        // Fetch the created property
        Property.PropertyStruct memory createdProperty = propertyContract.getProperty(propertyId);

        // Assert property details
        assertEq(createdProperty.leased, false);
        assertEq(createdProperty.leasee, address(0));
    }

    function testUpdateProperty() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        uint256 propertyId = block.timestamp;
        propertyContract.createProperty(name, location, price, description);

        // Update the property
        string memory updatedName = "Updated Property";
        string memory updatedLocation = "456 Main St";
        uint256 updatedPrice = 2000000;
        string memory updatedDescription = "An even more beautiful property";

        propertyContract.updateProperty(propertyId, updatedName, updatedLocation, updatedPrice, updatedDescription);

        // Fetch the created property
        Property.PropertyStruct memory createdProperty = propertyContract.getProperty(propertyId);

        // Assert property details
        assertEq(createdProperty.name, updatedName);
        assertEq(createdProperty.location, updatedLocation);
        assertEq(createdProperty.price, updatedPrice);
        assertEq(createdProperty.description, updatedDescription);
    }

    function testGetPropertiesCount() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        propertyContract.createProperty(name, location, price, description);

        // Fetch the owner's properties count
        uint256 propertiesCount = propertyContract.getPropertiesCount();

        // Assert the owner has the created property
        assertEq(propertiesCount, 1);
    }

    function testGetAllProperties() public {
        string memory name = "Test Property";
        string memory location = "123 Main St";
        uint256 price = 1000000;
        string memory description = "A beautiful property";

        // Create a property first
        uint256 propertyId = block.timestamp;
        propertyContract.createProperty(name, location, price, description);

        // Fetch the owner's properties
        Property.PropertyStruct[] memory allProperties = propertyContract.getAllProperties();

        console.log("Properties Count : ", allProperties.length);

        // Assert the owner has the created property
        assertEq(allProperties.length, 1);
        assertEq(allProperties[0].id, propertyId);
        // assertEq(allProperties[1].id, propertyId2);
    }
}

