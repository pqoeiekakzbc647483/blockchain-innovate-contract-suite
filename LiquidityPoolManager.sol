// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LiquidityPoolManager {
    uint256 public reserveA;
    uint256 public reserveB;

    event LiquidityAdded(uint256 a, uint256 b);
    event LiquidityRemoved(uint256 a, uint256 b);

    function addLiquidity(uint256 a, uint256 b) external payable {
        reserveA += a;
        reserveB += b;
        emit LiquidityAdded(a, b);
    }

    function removeLiquidity(uint256 a, uint256 b) external {
        require(reserveA >= a && reserveB >= b, "Insufficient liquidity");
        reserveA -= a;
        reserveB -= b;
        emit LiquidityRemoved(a, b);
    }

    function getReserves() external view returns (uint256, uint256) {
        return (reserveA, reserveB);
    }
}
