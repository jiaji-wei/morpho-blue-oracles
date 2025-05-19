pragma solidity 0.8.21;

import "forge-std/Script.sol";
import "../test/helpers/Constants.sol";
import {MoolahChainlinkOracleV2} from "../src/morpho-chainlink/MoolahChainlinkOracleV2.sol";

contract MoolahChainlinkOracleV2Deploy is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer: ", deployer);
        vm.startBroadcast(deployerPrivateKey);

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
        console.log("MoolahChainlinkOracleV2 deploy to: ", address(oracle));

        vm.stopBroadcast();
    }
}
