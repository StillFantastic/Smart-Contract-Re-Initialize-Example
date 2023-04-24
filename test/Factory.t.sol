// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../src/Factory.sol";
import "../src/Implementation.sol";

contract FactoryTest is Test {
  Factory public factory;
  Implementation1 public implementation1;


  function setUp() public {
    factory = new Factory();
    implementation1 = new Implementation1();
  }

  function testDeployContract() public {
    bytes32 salt = bytes32(0);
    
    factory.setImplementation(address(implementation1));
    address instance = factory.deployContract(salt);  

    string memory version = Implementation1(instance).getVersion();
    assertEq(version, "1");
  }
}

contract UpgradeTest is Test {
  Factory public factory;
  Implementation1 public implementation1;
  Implementation2 public implementation2;
  bytes32 public salt = bytes32(0);


  function setUp() public {
    factory = new Factory();
    implementation1 = new Implementation1();
    implementation2 = new Implementation2();

    factory.setImplementation(address(implementation1));
    address instance = factory.deployContract(salt);  
    factory.destructContract(instance);
  }

  function testUpgrade() public {
    factory.setImplementation(address(implementation2));

    factory.setImplementation(address(implementation2));
    address instance = factory.deployContract(salt);
    string memory version = Implementation1(instance).getVersion();
    assertEq(version, "2");
  }
}
