// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interface/INIOBProfile.sol";

contract SmartChefInitializable2 is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20Metadata;

   
    address public immutable SMART_CHEF_FACTORY;

    bool public updateProposal;

    bool public userLimit;

    bool public isInitialized;

    uint256 public poolUserLimit;

    address public admin;

    IERC20Metadata public rewardToken;

    IERC20Metadata public stakedToken;

    mapping(address => UserInfo) public userInfo;

    struct UserInfo {
        uint256 amount; // How many staked tokens the user has provided
        uint256 rewardDebt; // Reward debt
    }

    event Deposit(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
    event NewRewardPerBlock(uint256 rewardPerBlock);
    event NewPoolLimit(uint256 poolLimitPerUser);
    event RewardsStop(uint256 blockNumber);
    event TokenRecovery(address indexed token, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event UpdateProfileAndThresholdPointsRequirement(bool isProfileRequested, uint256 thresholdPoints);

    constructor(
        address _admin,
        bool _updateProposal
    ) {
        SMART_CHEF_FACTORY = msg.sender;
        admin = _admin;
        updateProposal = _updateProposal;

    }

    function initialize(
        IERC20Metadata _stakedToken,
        uint256 _poolUserLimit
    ) external {
        require(!isInitialized, "Already initialized");
        require(msg.sender == SMART_CHEF_FACTORY, "Not factory");

        // Make this contract initialized
        isInitialized = true;

        stakedToken = _stakedToken;
     
    }

    function updatePoolLimitPerUser(bool _userLimit, uint256 _poolUserLimit) external onlyOwner {
        require(userLimit, "Must be set");
        if (_userLimit) {
            require(_poolUserLimit > poolUserLimit, "New limit must be higher");
            poolUserLimit = _poolUserLimit;
        } else {
            userLimit = _userLimit;
            poolUserLimit = 0;
        }
        emit NewPoolLimit(poolUserLimit);
    }

   
    }
