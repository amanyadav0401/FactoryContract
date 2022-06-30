// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./NIOBPoolInitializable.sol";
import "./ProposalInitializable.sol";
import "./SyrupInitialize.sol";

contract Factory is Ownable {
    event NewSmartChefContract(address indexed smartChef);
    uint totalProposals;
    mapping(uint=>address) public proposalAddresses;

    constructor() {
        //
    }

    function createProposal(
        IERC20Metadata _stakedToken,
        bool _updateProposal,
        uint _poolUserLimit,
        address _admin
    ) external onlyOwner {
        require(_stakedToken.totalSupply() >= 0);
       
        bytes memory bytecode = type(SmartChefInitializable2).creationCode;
        // pass constructor argument
        bytecode = abi.encodePacked(
            bytecode,
            abi.encode(_admin,_updateProposal)
        );
        bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _poolUserLimit));
        address smartChefAddress;

        assembly {
            smartChefAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

             SmartChefInitializable2(smartChefAddress).initialize(
            _stakedToken,
            _poolUserLimit
            
        );

        emit NewSmartChefContract(smartChefAddress);
        totalProposals++;
        proposalAddresses[totalProposals]=smartChefAddress;

    }
}
