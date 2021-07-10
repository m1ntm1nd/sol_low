abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract Mintable is Context, Ownable {
    
    mapping(address => bool) private _minters;
    
    event MinterTrueFalse(address indexed minter, bool statement);
    
    function promoteMinter(address minter) public virtual onlyOwner{
        _minters[minter] = true;
        
        emit MinterTrueFalse(minter, true);
    }
    
    function demoteMinter(address minter) public virtual onlyOwner {
        _minters[minter] = false;
        
        emit MinterTrueFalse(minter, false);
    }
    
    modifier onlyMinter(){
        require(_minters[_msgSender()] != false, "Mintable: caller is not the minter");
        _;
    }
}