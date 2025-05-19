// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.21;

import {IOracle} from "../../lib/morpho-blue/src/interfaces/IOracle.sol";
import {IMorphoChainlinkOracleV2} from "./interfaces/IMorphoChainlinkOracleV2.sol";

import {ErrorsLib} from "./libraries/ErrorsLib.sol";
import {IERC4626, VaultLib} from "./libraries/VaultLib.sol";
import {Math} from "../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import {AggregatorV3Interface, ChainlinkDataFeedLib} from "./libraries/ChainlinkDataFeedLib.sol";

import {MorphoChainlinkOracleV2} from "./MorphoChainlinkOracleV2.sol";
import {IMoolahOracle} from "./interfaces/IMoolahOracle.sol";

contract MoolahChainlinkOracleV2 is MorphoChainlinkOracleV2 {
    using Math for uint256;
    using VaultLib for IERC4626;
    using ChainlinkDataFeedLib for AggregatorV3Interface;

    // @dev resilient oracle address
    address public constant RESILIENT_ORACLE =
        0xf3afD82A4071f272F403dC176916141f44E6c750;

    address public immutable baseToken;
    address public immutable quoteToken;
    uint256 public immutable adjustment;

    constructor(
        IERC4626 baseVault,
        uint256 baseVaultConversionSample,
        AggregatorV3Interface baseFeed1,
        AggregatorV3Interface baseFeed2,
        uint256 baseTokenDecimals,
        IERC4626 quoteVault,
        uint256 quoteVaultConversionSample,
        AggregatorV3Interface quoteFeed1,
        AggregatorV3Interface quoteFeed2,
        uint256 quoteTokenDecimals,
        address _baseToken,
        address _quoteToken,
        uint256 _adjustment
    )
        MorphoChainlinkOracleV2(
            baseVault,
            baseVaultConversionSample,
            baseFeed1,
            baseFeed2,
            baseTokenDecimals,
            quoteVault,
            quoteVaultConversionSample,
            quoteFeed1,
            quoteFeed2,
            quoteTokenDecimals
        )
    {
        baseToken = _baseToken;
        quoteToken = _quoteToken;
        adjustment = _adjustment;
    }
    
    function peek(address _asset) external view returns (uint256) {
        if (_asset == baseToken) {
            return
                SCALE_FACTOR.mulDiv(
                    BASE_VAULT.getAssets(BASE_VAULT_CONVERSION_SAMPLE) *
                        BASE_FEED_1.getPrice() *
                        BASE_FEED_2.getPrice(),
                    QUOTE_VAULT.getAssets(QUOTE_VAULT_CONVERSION_SAMPLE) *
                        QUOTE_FEED_1.getPrice() *
                        QUOTE_FEED_2.getPrice()
                ) / (10 ** (adjustment));
        } else if (_asset == quoteToken) {
            return IMoolahOracle(RESILIENT_ORACLE).peek(_asset);
        }

        revert(ErrorsLib.INVALID_ASSET);
    }
}
