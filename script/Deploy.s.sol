// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {DiamondCutFacet, IDiamondCut} from "@diamonds/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet, IDiamondLoupe} from "@diamonds/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet, IERC173} from "@diamonds/facets/OwnershipFacet.sol";
import {DiamondInit} from "@diamonds/upgradeInitializers/DiamondInit.sol";
import {Diamond, DiamondArgs} from "@diamonds/Diamond.sol";
import {IDiamond} from "@diamonds/interfaces/IDiamond.sol";
import "@diamonds/interfaces/IERC165.sol";

import "@contracts/facets/CounterFacet.sol";

contract DeployDiamond is Script {
    function run() external {
        // Setup
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Start
        IDiamond.FacetCut[] memory diamondCut = new IDiamond.FacetCut[](4);

        // Counter Facet
        {
            CounterFacet counterContractInstance = new CounterFacet();

            bytes4[] memory counterFacetSelectors = new bytes4[](2);

            counterFacetSelectors[0] = ICounterFacet.increment.selector;
            counterFacetSelectors[1] = ICounterFacet.setNumber.selector;

            diamondCut[0] = IDiamond.FacetCut({
                facetAddress: address(counterContractInstance),
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: counterFacetSelectors
            });
        }

        // DiamondCutFacet
        {
            DiamondCutFacet diamondCutContractInstance = new DiamondCutFacet();

            bytes4[] memory diamondCutFacetSelectors = new bytes4[](1);

            diamondCutFacetSelectors[0] = (IDiamondCut.diamondCut.selector);

            diamondCut[1] = IDiamond.FacetCut({
                facetAddress: address(diamondCutContractInstance),
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: diamondCutFacetSelectors
            });
        }

        // DiamondLoupeFacet
        {
            DiamondLoupeFacet diamondLoupeContractInstance = new DiamondLoupeFacet();

            bytes4[] memory diamondLoupeFacetSelectors = new bytes4[](4);

            diamondLoupeFacetSelectors[0] = (IDiamondLoupe.facets.selector);
            diamondLoupeFacetSelectors[1] = (
                IDiamondLoupe.facetFunctionSelectors.selector
            );
            diamondLoupeFacetSelectors[2] = (
                IDiamondLoupe.facetAddress.selector
            );
            diamondLoupeFacetSelectors[3] = (
                IERC165.supportsInterface.selector
            );

            diamondCut[2] = IDiamond.FacetCut({
                facetAddress: address(diamondLoupeContractInstance),
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: diamondLoupeFacetSelectors
            });
        }

        // OwnershipFacet
        {
            OwnershipFacet ownershipContractInstance = new OwnershipFacet();

            bytes4[] memory ownershipFacetSelectors = new bytes4[](2);

            ownershipFacetSelectors[0] = (IERC173.owner.selector);
            ownershipFacetSelectors[1] = (IERC173.transferOwnership.selector);

            diamondCut[3] = IDiamond.FacetCut({
                facetAddress: address(ownershipContractInstance),
                action: IDiamond.FacetCutAction.Add,
                functionSelectors: ownershipFacetSelectors
            });
        }

        // Deploy
        DiamondInit initer = new DiamondInit();

        DiamondArgs memory args = DiamondArgs({
            owner: address(deployerAddress),
            init: address(initer),
            initCalldata: abi.encodeWithSelector(
                DiamondInit.init.selector,
                abi.encode()
            )
        });

        new Diamond(diamondCut, args);

        // Clean up
        vm.stopBroadcast();
    }
}
