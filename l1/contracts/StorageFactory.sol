// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.0 < 0.9.0;

import "./SimpleStorage.sol";

contract StorageFactory  { // is SimpleStorage para manejar herencia

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIdx, uint256 _simpleStorageNumber) public {
        SimpleStorage(address(simpleStorageArray[_simpleStorageIdx])).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIdx) public view returns(uint256) {
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIdx])).retrieve();
    }
}