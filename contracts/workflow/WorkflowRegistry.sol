pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "../agreements/AgreementModels.sol";
import "./StepTransition.sol";
import "./BaseWorkflow.sol";
// 
// @dev A registries for workflows
// 
contract WorkflowRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Emits when an document is created
    event WorkflowCreated(address indexed wf);
    event WorkflowRemoved(address indexed wf);

    event WorkflowRegistered(bytes32 indexed workflowId, uint[] stepIds);
  
    event Withdrawn(address indexed payee, uint256 weiAmount);

    address owner;

    // workflows
    EnumerableSet.AddressSet internal workflows;

    constructor() public {
        owner  = msg.sender;
    }

    function has(address a) 
    public returns (bool) {
        return workflows.contains(a);
    }

    // Registers a PAID workflow contract
    // With states and steps to execute
    // Add msg.sender as owner
    // Each step/status pair gets and id
    function registerWorkflowInstance(
        bytes32 workflowId, // any auto id
        address workflowContract, // previously published BaseWorkflow based contract
        uint[] memory parties, 
        Step[] memory steps, 
        StepTransition[] memory transitions) 
        public returns (address wf, uint[] memory stepIds) {
        // TODO: link with DID eth
        // require(msg.sender == delegatedOwner, "INVALID_USER");

        emit WorkflowCreated(wf);
        bool ok = workflows.add(wf);

        // Compile
        stepIds =  BaseWorkflow(wf)
        .compile(
            workflowId,
            parties,
            steps,
            transitions
        );
        emit WorkflowRegistered(
            workflowId,
            stepIds
        );
        return (wf, stepIds);
    }  


    // removeWorkflowTemplate - admin call
    function removeWorkflowTemplate(address wf) public returns (bool) {
        require(msg.sender == owner, "INVALID_USER");
        bool ok = workflows.remove(wf);
        emit WorkflowRemoved(wf);
        return ok;
    }

    function count() public view returns (uint256) {
        return workflows.length();
    }

    function get(uint256 index) public view returns (address) {
        return workflows.at(index);
    }

    // function setFee(uint256 _fee) public {
    //     require(msg.sender == owner, "INVALID_USER");
    //     fee = _fee;
    // }

    // function getFee() public returns (uint256) {
    //     return fee;
    // }

    // function withdraw(address payable payee) public {
    //     require(msg.sender == owner, "INVALID_USER");
    //     uint256 b = address(this).balance;
    //     payee.sendValue(address(this).balance);
    //     emit Withdrawn(payee, b);
    // }
}