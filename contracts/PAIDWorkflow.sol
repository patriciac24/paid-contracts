pragma solidity ^0.6.10;


import "./BaseWorkflow.sol";


contract PAIDWorkflow is BaseWorkflow {
    address owner;
    event PartySignatureCompleted(bytes32 indexed id, bytes indexed documentDigest, address from, address, to);

    constructor(
        address _owner
    )
    public {
        owner = _owner;
    }

    struct AgreementWorkflowModel {
        address from,
        address to,
        bytes fromUserSignature,
        bytes toUserSignature,
        bytes documentDigest
    }

    mapping(bytes32 => AgreementWorkflowModel) signedAgreements;

    // Sets the agrement party signatures previously signed using
    // document wallet
    // Stores the IPFS reference to the signature and stores document digest
    function setPartySignature(
        address to,
        uint agreementId,
        bytes fromUserSignature,
        bytes toUserSignature,
        bytes documentDigest
    ) returns(uint) {
        // Store document signature and digest
        bytes32 id = keccak256(
            abi.encodePacked(
                msg.sender,
                to,
                agreementId
            )
        );
        signedAgreements[id] = AgreementWorkflowModel({
            msg.sender,
            from,
            fromUserSignature,
            toUserSignature,
            documentDigest
        });

        // TODO: EDDSA
        emit PartySignatureCompleted(
            id,
            documentDigest,
            msg.sender,
            from
        );
    }

    function apply() 
    external override returns(uint) {
        // Must have been sign by parties
        // Payable
        // must have been paid before allowing creation
        // Transfer funds to Escrow account
        // Accounting
        // Emit events
        // Change state to next
    }

    function create(
        address _owner
    ) external override returns(address) {
        return address(new PAIDWorkflow(_owner));
    }

    function execute()
    public override returns(bool) {
        // Must called oracle and get real time data
    }
    function completed()
    public override returns(bool);
    function canceled()
    public override returns(bool);
}