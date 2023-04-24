pragma solidity 0.8.19;

contract Implementation1 {
  address public owner;

  function initialize() external {
    owner = msg.sender;
  }
 
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner");
    _;
  }

  function destruct() external onlyOwner {
    selfdestruct(payable(msg.sender));
  }

  function getVersion() external returns (string memory) {
    return "1";
  }
}

contract Implementation2 {
  address public owner;

  function initialize() external {
    owner = msg.sender;
  }
 
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner");
    _;
  }

  function destruct() external onlyOwner {
    selfdestruct(payable(msg.sender));
  }
  
  function getVersion() external returns (string memory) {
    return "2";
  }
}
