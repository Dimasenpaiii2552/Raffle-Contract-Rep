// SPDX-License-Identifier: MIT

//  UNIT TEST
// INTEGRATION TEST ; Testing all our deploy scripts and how our contracts intract with each other
// Forked test
// Staging test ; Deploying to a live testnet environment

// Fuzzing
// Stateful Fuzzing
// Stateless Fuzzing
// Formol Verification

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interaction.s.sol";

contract InteractionsTest is Test {
    Raffle public raffle;
    HelperConfig public helperconfig;

    uint256 entrancefee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gaslane;
    uint256 subscriptionID;
    uint32 callbackGasLimit;

    address public PLAYER = makeAddr("player");
    uint256 public STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() public {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperconfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperconfig.getConfig();
        entrancefee = config.entrancefee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gaslane = config.gaslane;
        subscriptionID = config.subscriptionID;
        callbackGasLimit = config.callbackGasLimit;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }

    function testUsercanCreateSubscription() public {
        // Arrange
        CreateSubscription create_Subscription = new CreateSubscription();
        (uint256 sub_Id, ) = create_Subscription.createSubscription(
            config.vrfCoordinator
        );
        // uint256 old_Id = helperconfig.getConfig().subscriptionID;

        // uint256 preSubId = address(PLAYER).subscriptionID;
        // address preVrfCoordinator = address(PLAYER).vrfCoordinator;

        // Act
        vm.prank(PLAYER);
        (uint256 new_subId, ) = create_Subscription.createSubscription(PLAYER);
        // (uint256 new_subId, ) = create_Subscription
        //     .createSubscription();
        // uint256 new_Id = helperconfig.getConfig().subscriptionID;

        // Assert
        assert(sub_Id == new_subId);
    }
}
