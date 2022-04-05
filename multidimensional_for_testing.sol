// "SPDX-License-Identifier: MIT"
pragma solidity ^0.8.0;

// This are used only for test how exactly do a nested array and returned it
// i have the question if this code is not showing in the right format in remix ethereum
// so i gonna test with web3 how the result really it is

contract Testing {

    enum State{ A, B, C }

    State[] curState;
    State[][] myArray;

    uint i=0;

    constructor(uint Machines)public{
        for(i=0;i<Machines;i++){
            curState.push(State.A);
            myArray.push(curState);
        }
    }

    function historyOfStateMachine() public view returns (State[][] memory) {
        return myArray;
    }

}