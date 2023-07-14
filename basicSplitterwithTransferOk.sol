// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Forwarder is Ownable {
    using SafeERC20 for IERC20;

    address private _destination1;  //address owner 1
    address private _destination2;  //address owner 2

    uint256 private _owner1;  // Proportion for destination1 in percentage (0-100)
    uint256 private _owner2;  // Proportion for destination2 in percentage (0-100)

    constructor(address initialDestination1, address initialDestination2, uint256 initialProportion1) {
        require(initialDestination1 != address(0), "ERC20Forwarder: destination1 is the zero address");
        require(initialDestination2 != address(0), "ERC20Forwarder: destination2 is the zero address");
        require(initialProportion1 <= 100, "ERC20Forwarder: proportion1 is more than 100");
        
        _destination1 = initialDestination1;
        _destination2 = initialDestination2;
        
        _owner1 = initialProportion1;
        _owner2 = 100 - initialProportion1; // As this is a two-address scenario, owner1 is always 100 - owner
    }

    function receiveTokensAndForward(IERC20 token, uint256 amount) public {
        token.safeTransferFrom(msg.sender, _destination1, amount * _owner1 / 100);
        token.safeTransferFrom(msg.sender, _destination2, amount * _owner2 / 100);
    }

    function destination1() public view returns (address) {
        return _destination1;
    }
    
    function destination2() public view returns (address) {
        return _destination2;
    }

    function changeDestination1(address newDestination) public onlyOwner {
        require(newDestination != address(0), "ERC20Forwarder: new destination1 is the zero address");
        _destination1 = newDestination;
    }
    
    function changeDestination2(address newDestination) public onlyOwner {
        require(newDestination != address(0), "ERC20Forwarder: new destination2 is the zero address");
        _destination2 = newDestination;
    }
}

