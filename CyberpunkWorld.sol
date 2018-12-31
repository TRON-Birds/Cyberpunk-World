pragma solidity ^0.4.23;

// Just ownable contract
contract Ownable {
  address public owner;
  
  constructor() public{
    owner = msg.sender;
  }
  
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  
  function transferOwnership(address newOwner) external onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }
}

// Pausable contract which allows children to implement an emergency stop mechanism.
contract Pausable is Ownable {
  event Pause();
  event Unpause();
  
  bool public paused = false;
  
  // Modifier to make a function callable only when the contract is not paused.
  modifier whenNotPaused() {
    require(!paused);
    _;
  }
  
  // Modifier to make a function callable only when the contract is paused.
  modifier whenPaused() {
    require(paused);
    _;
  }
  
  
  // called by the owner to pause, triggers stopped state
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }
  
  // called by the owner to unpause, returns to normal state
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

contract CyberpunkWorld is Pausable {
  
  // note that all deposits begin to be recorded starting at index 0
  // list of all deposits
  mapping(uint64 => address) public deposits;
  
  // total count of deposits
  uint64 public depositsCount = 0;
  
  event DepositCreated(address onwer);
  
  
  function deposit() external whenNotPaused payable {
    require(msg.value == 1500000 * 10**6);
    deposits[depositsCount] = msg.sender;
    depositsCount++;
    
    emit DepositCreated(msg.sender);
  }
  
  function withdrawBalance(uint256 summ) external onlyOwner {
    owner.transfer(summ);
  }
}
