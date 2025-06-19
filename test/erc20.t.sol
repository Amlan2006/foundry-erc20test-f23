// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/erc20test.sol";

contract ERC20TestTest is Test {
    erc20test public token;
    address public owner = address(this);
    address public user = address(1);
    address public miner = address(2); // simulate block.coinbase
    uint256 public cap = 100_000_000;
    uint256 public reward = 10;

    function setUp() public {
        token = new erc20test(cap, reward);
    }

    function testInitialMint() public {
        assertEq(token.totalSupply(), 70000000e18);
        assertEq(token.balanceOf(owner), 70000000e18);
    }

    // function testCapLimit() public {
    //     // Try minting beyond cap using reward
    //     vm.roll(block.number + 1);
    //     vm.coinbase(miner);
    //     token.transfer(user, 1e18); // triggers reward mint

    //     assertEq(token.balanceOf(miner), 10e18);
    //     assertEq(token.totalSupply(), 70000000e18 + 10e18);
    // }

    function testOnlyOwnerCanSetBlockReward() public {
        vm.prank(user);
        vm.expectRevert("Only owner can call this function");
        token.setBlockReward(100);
    }

    function testSetBlockReward() public {
        token.setBlockReward(50);
        assertEq(token.blockReward(), 50e18);
    }

    // function testTransferTriggersMinerReward() public {
    //     vm.roll(block.number + 1);
    //     vm.coinbase(miner);

    //     token.transfer(user, 1e18);

    //     assertEq(token.balanceOf(miner), 10e18); // reward
    // }

    // function testNoRewardOnMint() public {
    //     vm.roll(block.number + 1);
    //     vm.coinbase(miner);

    //     token.transfer(user, 1 ether); // only transfer gives reward
    //     assertEq(token.balanceOf(miner), 10e18);
    // }

    function testDestroy() public {
        token.destroy();
        // Can't test selfdestruct result directly here, just check call success
    }
}
