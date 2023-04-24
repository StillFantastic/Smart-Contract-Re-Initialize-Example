pragma solidity 0.8.19;

contract Factory {
  address immutable owner;
  address private _implementation;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner");
    _;
  }

  function deployContract(bytes32 salt) external onlyOwner returns (address instance) {
    // Selector of getImplementation = 0xaaf10f42
    bytes memory initCode = hex"63aaf10f42595238386040601c335afa6020513b806000806020513c806000f3";
    assembly {
      instance := create2(0, add(initCode, 0x20), mload(initCode), salt)
    }

    require(instance != address(0), "Create2 failed");

    (bool success, ) = instance.call(abi.encodeWithSignature("initialize()"));
    require(success, "Initialization failed");
  }

  function destructContract(address target) external onlyOwner {
    (bool success, ) = target.call(abi.encodeWithSignature("destruct()"));
    require(success, "Desctruct contract failed");
  }

  function setImplementation(address implementation) external onlyOwner {
    _implementation = implementation;
  }

  function getImplementation() external returns (address) {
    return _implementation;
  }
}
