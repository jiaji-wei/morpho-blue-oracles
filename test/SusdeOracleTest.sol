// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "../lib/forge-std/src/Test.sol";
import "../src/morpho-chainlink/MorphoChainlinkOracleV2.sol";
import "../src/morpho-chainlink/MoolahChainlinkOracleV2.sol";
import "./mocks/ChainlinkAggregatorMock.sol";
import "./helpers/Constants.sol";
import "forge-std/console.sol";
contract SusdeOracleTest is Test {
    using Math for uint256;

    function setUp() public {
        vm.createSelectFork(vm.envString("BSC_RPC_URL"), 49936384);
        require(block.chainid == 56, "chain isn't BSC");
    }

    function testOracleSusdeUsde() public {
        address usdt = 0x55d398326f99059fF775485246999027B3197955;
        address susde = 0x211Cc4DD073734dA055fbF44a2b4667d5E5fE5d2;

        // baseToken is susde, quoteToken is usdt
        MoolahChainlinkOracleV2 oracle = new MoolahChainlinkOracleV2(
            vaultZero,
            1,
            susdeUsdeFeed,
            feedZero,
            18,
            vaultZero,
            1,
            feedZero,
            feedZero,
            6,
            susde,
            usdt,
            16
        );

        // usdt price
        console2.log("usdt price", oracle.peek(usdt));

        // susde price
        console2.log("susde price", oracle.peek(susde));
    }
}
