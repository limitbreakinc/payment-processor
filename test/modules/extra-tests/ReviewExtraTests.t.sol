pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../PaymentProcessorModule.t.sol";

contract ReviewExtraTests is PaymentProcessorModuleTest {
    uint256 constant PER_TX_ORDER_LENGTH = 10;
    uint256 constant DEPTH = 10;
    uint256 constant ONE_ETHER = 1 ether;

    struct Temps {
        uint256 erc1155AmountToMint;
        uint256 erc1155FilledAmount;
    }

    function setUp() public override {
        super.setUp();
        _allocateTokensAndApprovals(benchmarkBeneficiary, uint128(MAX_INT));
    }

    function testFuzzEventEmittedCorrectlyAndNonceValidatedAndRestoredSecurelyForBulkAcceptOffer(
        bool[DEPTH][PER_TX_ORDER_LENGTH] calldata shouldFill,
        uint8[PER_TX_ORDER_LENGTH] calldata batchSizes,
        uint256[PER_TX_ORDER_LENGTH] calldata orderProtocols
    ) public {
        uint256 nonce;
        uint256 lastMinted721;
        Temps memory temps;

        // setup
        for (uint256 i; i < shouldFill.length; ++i) {
            bytes memory fnCalldata;
            uint256 batchSize = bound(batchSizes[i], 1, 10);

            Order[] memory orders = new Order[](batchSize);
            SignatureECDSA[] memory signatures = new SignatureECDSA[](batchSize);
            Cosignature[] memory cosignatures = new Cosignature[](batchSize);
            FeeOnTop[] memory feesOnTop = new FeeOnTop[](batchSize);

            // setup struct, mints and sigs
            for (uint256 j; j < batchSize; ++j) {
                uint256 orderProtocol =
                    uint256(bound(orderProtocols[i], 0, ORDER_PROTOCOLS_INVALID - 1));
                uint248 requestedFillAmount = uint248(bound(uint256(10), 1, 10));
                orders[j] = Order({
                    protocol: orderProtocol,
                    maker: benchmarkBeneficiary,
                    beneficiary: benchmarkBeneficiary,
                    marketplace: abe,
                    fallbackRoyaltyRecipient: cal,
                    paymentMethod: address(weth),
                    tokenAddress: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? address(test721) : address(test1155),
                    tokenId: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? ++lastMinted721 : j + 1,
                    amount: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 1 : 10,
                    itemPrice: 1 ether,
                    nonce: ++nonce,
                    expiration: type(uint256).max,
                    marketplaceFeeNumerator: 500,
                    maxRoyaltyFeeNumerator: 1000,
                    requestedFillAmount: requestedFillAmount,
                    minimumFillAmount: orderProtocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL
                        ? uint248(bound(uint256(10), 1, requestedFillAmount))
                        : 10,
                    protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
                });
                signatures[j] = _getSignedItemOffer(benchmarkBeneficiaryPk, orders[j]);
                cosignatures[j] = Cosignature({
                    signer: address(0),
                    taker: address(0),
                    expiration: 0,
                    v: 0,
                    r: bytes32(0),
                    s: bytes32(0)
                });
                feesOnTop[j] = FeeOnTop({recipient: address(0), amount: 0});

                if (shouldFill[i][j]) {
                    if (orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                        test721.mint(bob, orders[j].tokenId);
                        test721.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    } else if (orderProtocol == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
                        test1155.mint(bob, orders[j].tokenId, orders[j].amount);
                        test1155.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    } else {
                        temps.erc1155AmountToMint =
                            bound(orders[j].amount, orders[j].minimumFillAmount, orders[j].amount);
                        test1155.mint(bob, orders[j].tokenId, temps.erc1155AmountToMint);
                        test1155.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));

                        if (temps.erc1155AmountToMint >= orders[j].requestedFillAmount) {
                            temps.erc1155FilledAmount = orders[j].requestedFillAmount;
                        } else {
                            temps.erc1155FilledAmount = temps.erc1155AmountToMint;
                        }
                    }
                }

                assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
            }

            {
                uint256[] memory offerTypesArray = new uint256[](batchSize);
                for (uint256 i; i < batchSize; ++i) {
                    offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
                }

                fnCalldata = _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                    address(_paymentProcessor),
                    offerTypesArray,
                    orders,
                    signatures,
                    new TokenSetProof[](batchSize),
                    cosignatures,
                    feesOnTop
                );
            }

            // expect correct event emission for order digest if erc1155 partial fill or nonce otherwise
            for (uint256 j; j < batchSize; ++j) {
                if (orders[j].protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    bytes32 orderHash = 
                        keccak256(
                            bytes.concat(
                                abi.encode(
                                    ITEM_OFFER_APPROVAL_HASH,
                                    uint8(orders[j].protocol),
                                    cosignatures[j].signer,
                                    orders[j].maker,
                                    orders[j].beneficiary,
                                    orders[j].marketplace,
                                    orders[j].fallbackRoyaltyRecipient,
                                    orders[j].paymentMethod,
                                    orders[j].tokenAddress
                                ),
                                abi.encode(
                                    orders[j].tokenId,
                                    orders[j].amount,
                                    orders[j].itemPrice,
                                    orders[j].expiration,
                                    orders[j].marketplaceFeeNumerator,
                                    orders[j].nonce,
                                    0
                                )
                            )
                        );

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestOpened(orderHash, orders[j].maker, orders[j].minimumFillAmount);

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestItemsFilled(orderHash, orders[j].maker, orders[j].minimumFillAmount);

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestInvalidated(orderHash, orders[j].maker, false);

                    if (temps.erc1155FilledAmount > temps.erc1155AmountToMint && shouldFill[i][j]) {
                        vm.expectEmit(true, true, false, true);
                        emit OrderDigestItemsRestored(orderHash, orders[j].maker, uint248(temps.erc1155FilledAmount));
                    }

                    if (temps.erc1155FilledAmount == 0) {
                        vm.expectEmit(true, true, false, true);
                        emit OrderDigestItemsRestored(orderHash, orders[j].maker, orders[j].requestedFillAmount);
                    }
                } else {
                    vm.expectEmit(true, true, false, true);
                    emit NonceInvalidated(orders[j].nonce, orders[j].maker, false);

                    if (!shouldFill[i][j]) {
                        vm.expectEmit(true, true, false, true);
                        emit NonceRestored(orders[j].nonce, orders[j].maker);
                    }
                }
            }

            // make tx
            vm.prank(bob, bob);
            _paymentProcessor.bulkAcceptOffers(fnCalldata);

            // assert nonce was used or restored correctly or if erc1155 partial fill, partiallyFillableOrderStatus info was set correctly
            for (uint256 j; j < batchSize; ++j) {
                if (orders[j].protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    if (shouldFill[i][j]) {
                        assertTrue(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                    } else {
                        assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                    }
                } else {
                    bytes32 orderHash = 
                        keccak256(
                            bytes.concat(
                                abi.encode(
                                    ITEM_OFFER_APPROVAL_HASH,
                                    uint8(orders[j].protocol),
                                    cosignatures[j].signer,
                                    orders[j].maker,
                                    orders[j].beneficiary,
                                    orders[j].marketplace,
                                    orders[j].fallbackRoyaltyRecipient,
                                    orders[j].paymentMethod,
                                    orders[j].tokenAddress
                                ),
                                abi.encode(
                                    orders[j].tokenId,
                                    orders[j].amount,
                                    orders[j].itemPrice,
                                    orders[j].expiration,
                                    orders[j].marketplaceFeeNumerator,
                                    orders[j].nonce,
                                    0
                                )
                            )
                        );
                    PartiallyFillableOrderStatus memory partiallyFillableOrderStatus =
                        _paymentProcessor.remainingFillableQuantity(benchmarkBeneficiary, orderHash);
                    if (shouldFill[i][j]) {
                        temps.erc1155FilledAmount == orders[j].amount
                            ? assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Filled)
                            : assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Open);
                        assertEq(partiallyFillableOrderStatus.remainingFillableQuantity, 10 - temps.erc1155FilledAmount);
                    } else {
                        assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Open);
                        assertEq(partiallyFillableOrderStatus.remainingFillableQuantity, 10);
                    }
                }
            }
        }
    }

    function testFuzzEventEmittedCorrectlyAndNonceValidatedAndRestoredSecurelyForBulkBuyListing(
        bool[DEPTH][PER_TX_ORDER_LENGTH] calldata shouldFill,
        uint8[PER_TX_ORDER_LENGTH] calldata batchSizes,
        uint256[PER_TX_ORDER_LENGTH] calldata orderProtocols
    ) public {
        uint256 nonce;
        uint256 lastMinted721;
        Temps memory temps;

        // setup struct, mints and sigs
        for (uint256 i; i < shouldFill.length; ++i) {
            bytes memory fnCalldata;
            uint256 batchSize = bound(batchSizes[i], 1, 10);

            Order[] memory orders = new Order[](batchSize);
            SignatureECDSA[] memory signatures = new SignatureECDSA[](batchSize);
            Cosignature[] memory cosignatures = new Cosignature[](batchSize);
            FeeOnTop[] memory feesOnTop = new FeeOnTop[](batchSize);

            for (uint256 j; j < batchSize; ++j) {
                uint256 orderProtocol =
                    uint256(bound(orderProtocols[i], 0, ORDER_PROTOCOLS_INVALID - 1));
                uint248 requestedFillAmount = uint248(bound(uint256(10), 1, 10));
                orders[j] = Order({
                    protocol: orderProtocol,
                    maker: bob,
                    beneficiary: benchmarkBeneficiary,
                    marketplace: abe,
                    fallbackRoyaltyRecipient: cal,
                    paymentMethod: address(weth),
                    tokenAddress: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? address(test721) : address(test1155),
                    tokenId: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? ++lastMinted721 : j + 1,
                    amount: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 1 : 10,
                    itemPrice: 1 ether,
                    nonce: ++nonce,
                    expiration: type(uint256).max,
                    marketplaceFeeNumerator: 500,
                    maxRoyaltyFeeNumerator: 1000,
                    requestedFillAmount: requestedFillAmount,
                    minimumFillAmount: orderProtocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL
                        ? uint248(bound(uint256(10), 1, requestedFillAmount))
                        : 10,
                    protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
                });
                signatures[j] = _getSignedSaleApproval(bobPk, orders[j]);
                cosignatures[j] = Cosignature({
                    signer: address(0),
                    taker: address(0),
                    expiration: 0,
                    v: 0,
                    r: bytes32(0),
                    s: bytes32(0)
                });
                feesOnTop[j] = FeeOnTop({recipient: address(0), amount: 0});

                if (shouldFill[i][j]) {
                    if (orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                        test721.mint(orders[j].maker, orders[j].tokenId);
                        test721.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    } else if (orderProtocol == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
                        test1155.mint(orders[j].maker, orders[j].tokenId, orders[j].amount);
                        test1155.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    } else {
                        temps.erc1155AmountToMint =
                            bound(orders[j].amount, orders[j].minimumFillAmount, orders[j].amount);
                        test1155.mint(orders[j].maker, orders[j].tokenId, temps.erc1155AmountToMint);
                        test1155.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));

                        if (temps.erc1155AmountToMint >= orders[j].requestedFillAmount) {
                            temps.erc1155FilledAmount = orders[j].requestedFillAmount;
                        } else {
                            temps.erc1155FilledAmount = temps.erc1155AmountToMint;
                        }
                    }
                }

                assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
            }

            fnCalldata = _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), orders, signatures, cosignatures, feesOnTop
            );

            // expect correct event emission for order digest if erc1155 partial fill or nonce otherwise
            for (uint256 j; j < batchSize; ++j) {
                if (orders[j].protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    bytes32 orderHash = 
                        keccak256(
                            bytes.concat(
                                abi.encode(
                                    SALE_APPROVAL_HASH,
                                    uint8(orders[j].protocol),
                                    cosignatures[j].signer,
                                    orders[j].maker,
                                    orders[j].marketplace,
                                    orders[j].fallbackRoyaltyRecipient,
                                    orders[j].paymentMethod,
                                    orders[j].tokenAddress,
                                    orders[j].tokenId
                                ),
                                abi.encode(
                                    orders[j].amount,
                                    orders[j].itemPrice,
                                    orders[j].expiration,
                                    orders[j].marketplaceFeeNumerator,
                                    orders[j].maxRoyaltyFeeNumerator,
                                    orders[j].nonce,
                                    0,
                                    _paymentProcessor.getProtocolFeeVersion()
                                )
                            )
                        );

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestOpened(orderHash, orders[j].maker, orders[j].minimumFillAmount);

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestItemsFilled(orderHash, orders[j].maker, orders[j].minimumFillAmount);

                    vm.expectEmit(true, true, false, true);
                    emit OrderDigestInvalidated(orderHash, orders[j].maker, false);

                    if (temps.erc1155FilledAmount > temps.erc1155AmountToMint && shouldFill[i][j]) {
                        vm.expectEmit(true, true, false, true);
                        emit OrderDigestItemsRestored(orderHash, orders[j].maker, uint248(temps.erc1155FilledAmount));
                    }

                    if (temps.erc1155FilledAmount == 0) {
                        vm.expectEmit(true, true, false, true);
                        emit OrderDigestItemsRestored(orderHash, orders[j].maker, orders[j].requestedFillAmount);
                    }
                } else {
                    vm.expectEmit(true, true, false, true);
                    emit NonceInvalidated(orders[j].nonce, orders[j].maker, false);

                    if (!shouldFill[i][j]) {
                        vm.expectEmit(true, true, false, true);
                        emit NonceRestored(orders[j].nonce, orders[j].maker);
                    }
                }
            }

            // make tx
            vm.prank(benchmarkBeneficiary, benchmarkBeneficiary);
            _paymentProcessor.bulkBuyListings(fnCalldata);

            // assert nonce was used or restored correctly or if erc1155 partial fill, partiallyFillableOrderStatus info was set correctly
            for (uint256 j; j < batchSize; ++j) {
                if (orders[j].protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    if (shouldFill[i][j]) {
                        assertTrue(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                    } else {
                        assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                    }
                } else {
                    bytes32 orderHash = 
                        keccak256(
                            bytes.concat(
                                abi.encode(
                                    SALE_APPROVAL_HASH,
                                    uint8(orders[j].protocol),
                                    cosignatures[j].signer,
                                    orders[j].maker,
                                    orders[j].marketplace,
                                    orders[j].fallbackRoyaltyRecipient,
                                    orders[j].paymentMethod,
                                    orders[j].tokenAddress,
                                    orders[j].tokenId
                                ),
                                abi.encode(
                                    orders[j].amount,
                                    orders[j].itemPrice,
                                    orders[j].expiration,
                                    orders[j].marketplaceFeeNumerator,
                                    orders[j].maxRoyaltyFeeNumerator,
                                    orders[j].nonce,
                                    0,
                                    _paymentProcessor.getProtocolFeeVersion()
                                )
                            )
                        );
                    PartiallyFillableOrderStatus memory partiallyFillableOrderStatus =
                        _paymentProcessor.remainingFillableQuantity(bob, orderHash);
                    if (shouldFill[i][j]) {
                        temps.erc1155FilledAmount == orders[j].amount
                            ? assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Filled)
                            : assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Open);
                        assertEq(partiallyFillableOrderStatus.remainingFillableQuantity, 10 - temps.erc1155FilledAmount);
                    } else {
                        assertTrue(partiallyFillableOrderStatus.state == PartiallyFillableOrderState.Open);
                        assertEq(partiallyFillableOrderStatus.remainingFillableQuantity, 10);
                    }
                }
            }
        }
    }

    function testFuzzEventEmittedCorrectlyAndNonceValidatedAndRestoredSecurelyForSweep(
        bool[DEPTH][PER_TX_ORDER_LENGTH] calldata shouldFill,
        uint8[PER_TX_ORDER_LENGTH] calldata batchSizes,
        uint256[PER_TX_ORDER_LENGTH] calldata orderProtocols
    ) public {
        uint256 nonce;
        uint256 lastMinted721;

        // setup struct, mints and sigs
        for (uint256 i; i < shouldFill.length; ++i) {
            bytes memory fnCalldata;
            uint256 batchSize = bound(batchSizes[i], 1, 10);

            Order[] memory orders = new Order[](batchSize);
            SignatureECDSA[] memory signatures = new SignatureECDSA[](batchSize);
            Cosignature[] memory cosignatures = new Cosignature[](batchSize);
            FeeOnTop[] memory feesOnTop = new FeeOnTop[](batchSize);

            uint256 orderProtocol =
                uint256(bound(orderProtocols[i], 0, ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL - 1));

            for (uint256 j; j < batchSize; ++j) {
                uint248 requestedFillAmount = uint248(bound(uint256(10), 1, 10));
                orders[j] = Order({
                    protocol: orderProtocol,
                    maker: bob,
                    beneficiary: benchmarkBeneficiary,
                    marketplace: abe,
                    fallbackRoyaltyRecipient: cal,
                    paymentMethod: address(0),
                    tokenAddress: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? address(test721) : address(test1155),
                    tokenId: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? ++lastMinted721 : j + 1,
                    amount: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 1 : 10,
                    itemPrice: 1 ether,
                    nonce: ++nonce,
                    expiration: type(uint256).max,
                    marketplaceFeeNumerator: 500,
                    maxRoyaltyFeeNumerator: 1000,
                    requestedFillAmount: requestedFillAmount,
                    minimumFillAmount: 10,
                    protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
                });
                signatures[j] = _getSignedSaleApproval(bobPk, orders[j]);
                cosignatures[j] = Cosignature({
                    signer: address(0),
                    taker: address(0),
                    expiration: 0,
                    v: 0,
                    r: bytes32(0),
                    s: bytes32(0)
                });
                feesOnTop[j] = FeeOnTop({recipient: address(0), amount: 0});

                if (shouldFill[i][j]) {
                    if (orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                        test721.mint(orders[j].maker, orders[j].tokenId);
                        test721.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    } else {
                        test1155.mint(orders[j].maker, orders[j].tokenId, orders[j].amount);
                        test1155.setDefaultRoyaltyInfo(cal, uint96(orders[j].maxRoyaltyFeeNumerator));
                    }
                }

                assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
            }

            SweepItem[] memory sweepItems = new SweepItem[](orders.length);
            for (uint256 j = 0; j < orders.length; j++) {
                sweepItems[j] = SweepItem({
                    maker: orders[j].maker,
                    marketplace: orders[j].marketplace,
                    fallbackRoyaltyRecipient: orders[j].fallbackRoyaltyRecipient,
                    tokenId: orders[j].tokenId,
                    amount: orders[j].amount,
                    itemPrice: orders[j].itemPrice,
                    nonce: orders[j].nonce,
                    expiration: orders[j].expiration,
                    marketplaceFeeNumerator: orders[j].marketplaceFeeNumerator,
                    maxRoyaltyFeeNumerator: orders[j].maxRoyaltyFeeNumerator,
                    protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
                });
            }

            SweepOrder memory sweepOrder = SweepOrder({
                protocol: orderProtocol,
                tokenAddress: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? address(test721) : address(test1155),
                paymentMethod: address(0),
                beneficiary: benchmarkBeneficiary
            });

            fnCalldata = _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor),
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                sweepItems,
                signatures,
                cosignatures
            );

            // expect correct event emission for order digest if erc1155 partial fill or nonce otherwise
            // nonce invalidation
            for (uint256 j; j < batchSize; ++j) {
                vm.expectEmit(true, true, false, true);
                emit NonceInvalidated(orders[j].nonce, orders[j].maker, false);
                if (!shouldFill[i][j]) {
                    vm.expectEmit(true, true, false, true);
                    emit NonceRestored(orders[j].nonce, orders[j].maker);
                }
            }

            // make tx
            vm.prank(benchmarkBeneficiary, benchmarkBeneficiary);
            _paymentProcessor.sweepCollection{value: 1 ether * batchSize}(fnCalldata);

            // assert nonce was used or restored correctly or if erc1155 partial fill, partiallyFillableOrderStatus info was set correctly
            for (uint256 j; j < batchSize; ++j) {
                if (shouldFill[i][j]) {
                    assertTrue(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                } else {
                    assertFalse(_paymentProcessor.isNonceUsed(orders[j].maker, orders[j].nonce));
                }
            }
        }
    }
}
