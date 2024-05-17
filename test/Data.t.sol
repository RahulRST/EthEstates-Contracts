// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import { Test, console2 } from 'forge-std/Test.sol';
import { Data } from '../src/Data.sol';

contract DataTest is Test {
    Data public data;

    function setUp() public {
        data = new Data();
    }

    function testSetData() public {
        data.setData(123);
        assertEq(data.getData(), 123);
    }
}