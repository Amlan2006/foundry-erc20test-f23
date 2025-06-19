// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {ERC20Burnable} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
contract erc20test is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;
    constructor(uint256 cap, uint256 reward) ERC20("TestToken", "TTK") ERC20Capped(cap * 1e18) {
        owner = payable(msg.sender);
        _mint(owner, 70000000e18);//mint 70 million tokens
        blockReward = reward * 1e18; // Set the block reward
    }
    function mintMinerReward() internal {
        _mint(block.coinbase, blockReward); // Mint block reward to the miner
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual  {
        if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            mintMinerReward();
    }
    // super._beforeTokenTransfer(from,to,amount);
    }
        
    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * 1e18; // Update the block reward
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    function destroy() public onlyOwner{
        selfdestruct(owner);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) {
        super._update(from, to, value);
    }
}
 