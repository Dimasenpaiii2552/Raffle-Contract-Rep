// SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/Interaction.s.sol";

contract DeployRaffle is Script {
    function run() public {
        deployContract();
    }

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperconfig = new HelperConfig();
        // local => deploy mocks, get local config
        // sepolia => ger sepolia config
        HelperConfig.NetworkConfig memory config = helperconfig.getConfig();

        if (config.subscriptionID == 0) {
            CreateSubscription create_Subcscription = new CreateSubscription();
            (
                config.subscriptionID,
                config.vrfCoordinator
            ) = create_Subcscription.createSubscription(config.vrfCoordinator);

            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                config.vrfCoordinator,
                config.subscriptionID,
                config.link
            );
        }

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            config.entrancefee,
            config.interval,
            config.vrfCoordinator,
            config.gaslane,
            config.subscriptionID,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        AddConsumer add_Consumer = new AddConsumer();
        add_Consumer.addConsumer(
            address(raffle),
            config.vrfCoordinator,
            config.subscriptionID
        );

        return (raffle, helperconfig);
    }
}
