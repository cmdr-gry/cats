pragma solidity ^0.5.17;

import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./Ownable.sol";

contract Kittycontract is IERC721, Ownable {
      
      uint256 public constant CREATION_LIMIT_GEN0 = 10;
      string public constant name = "LeoKitties";
      string public constant symbol = "FK";
      
      bytes4 internal constant MAGIC_ERC_721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

      bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
      bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

      event Birth(
          address owner, 
      uint256 kittenId, 
      uint256 mumId, 
      uint256 dadId, 
      uint256 genes
      );

      struct Kitty {
          uint256 genes;
          uint64 birthTime;
          uint32 mumId;
          uint32 dadId;
          uint16 generation;
      }

      Kitty[] kitties;

      mapping (uint256 => address) public kittyIndexToOwner;
      mapping (address => uint256) ownershipTokenCount;
      mapping (uint256 => address) public kittyIndexToApproved;

mapping (address => mapping (address => bool)) private _operatorApprovals;


uint256 public gen0Counter;

constructor() public {
    _createKitty(0, 0, 0, uint256(-1), address(0));
}
function breed(uint256 _dadId, uint256 _mumId) public returns (uint256) {
    require(_owns(msg.sender, _dadId), "The user doesnt own the token!");
    require(_owns(msg.sender, _mumId), "The user doesnt own the token!");

    ( uint256 dadDna,,,,uint256 DadGeneration ) = getKitty(_dadId);
    ( uint256 mumDna,,,,uint256 MumGeneration ) = getKitty(_mumId);

    uint256 newDna = _mixDna(dadDna, mumDna);

    uint256 kidGen = 0;
    if (DadGeneration < MumGeneration){
        kidGen = MumGeneration + 1;
        kidGen /= 2;
    } else if (DadGeneration > MumGeneration){
        kidGen = DadGeneration + 1;
        kidGen /= 2;
    } else {
        kidGen = MumGeneration + 1;
    }
    
    return _createKitty(_mumId, _dadId, kidGen, newDna, msg.sender);


    // check ownership
    // You got the DNA
    // Figure out the generation 
    // Create a new cat with new properties, give it to the msg.sender

}
function supportsInterface(bytes4 _interfaceId) external view returns (bool){
return ( _interfaceId == _INTERFACE_ID_ERC721 || _interfaceId == _INTERFACE_ID_ERC165);
}

function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
    safeTransferFrom(_from, _to, _tokenId, "");
}

function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public {
require( _isApprovedOrOwner(msg.sender, _from, _to, _tokenId));
_safeTransfer(_from, _to, _tokenId, _data);
}

event ApproveForAll(address indexed owner, address indexed operator, bool approved);

function createKittyGen0(uint256 _genes) public onlyOwner returns (uint256) {
require(gen0Counter < CREATION_LIMIT_GEN0);

gen0Counter++;



}

function getKitty(uint256 _id) public view returns (
    uint256 genes,
    uint256 birthTime,
    uint256 mumId,
    uint256 dadId,
    uint256 generation
)
{
Kitty storage kitty = kitties[_id];

birthTime = uint256(kitty.birthTime);
mumId = uint256(kitty.mumId);
dadId = uint256(kitty.dadId);
generation = uint256(kitty.generation);
genes = kitty.genes;
}

function _createKitty(
    uint256 _mumId,
    uint256 _dadId,
    uint256 _generation,
    uint256 _genes,
    address _owner
) private returns (uint256) {
    Kitty memory _kitty = Kitty({
        genes: _genes,
        birthTime: uint64(now),
        mumId: uint32(_mumId),
        dadId: uint32(_dadId),
        generation: uint16(_generation)
    });

    uint256 newKittenId = kitties.push(_kitty) - 1;
    
    emit Birth(_owner, newKittenId, _mumId, _dadId, _genes);
    _transfer(address(0), _owner, newKittenId);
    return newKittenId;
    }




function balanceOf(address owner) external view returns (uint256 balance) {
    return ownershipTokenCount[owner];
}
function ownerOf(uint256 _tokenId) external view returns (address owner)
{
    return kittyIndexToOwner[_tokenId];
}

function transfer(address _to, uint256 _tokenId) external
{
    require(_to != address(0));
    require(_to != address(this));
    require(_owns(msg.sender, _tokenId));

    _transfer(msg.sender, _to, _tokenId);
}

function _transfer(address _from, address _to, uint256 _tokenId) internal {
    ownershipTokenCount[_to]++;

    kittyIndexToOwner[_tokenId] = _to;

    if (_from != address(0)) {
        ownershipTokenCount[_from]--;
        delete kittyIndexToApproved[_tokenId];
    }

    emit Transfer(_from, _to, _tokenId);
}

function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return kittyIndexToOwner[_tokenId] == _claimant;
}

function _approve(uint256 _tokenId, address _approved) internal {
    kittyIndexToApproved[_tokenId] = _approved;
}
function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
    return kittyIndexToApproved[_tokenId] == _claimant;
}
function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
    if( !_isContract(_to) ){
        return true;
    }
    
    bytes4 returnData = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
    return returnData == MAGIC_ERC_721_RECEIVED;
}

function totalSupply() external view returns (uint256 total)
{
    return kitties.length;
}

function approve(address _to, uint256 _tokenId) public { 

    require(_owns(msg.sender, _tokenId));

    _approve(_tokenId, _to);
    emit Approval(msg.sender, _to, _tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender);

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApproveForAll(msg.sender, operator, approved);
    }
    
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_tokenId < kitties.length);

        return kittyIndexToApproved[_tokenId];
    }
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal {
             _transfer(_from, _to, _tokenId);
             require( _checkERC721Support(_from, _to, _tokenId, _data));
           }



    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(_to != address(0));
        require(msg.sender == _from || _approvedFor(msg.sender, _tokenId) || isApprovedForAll(_from, msg.sender));
        require(_owns(_from, _tokenId));
        require(_tokenId < kitties.length);

        _transfer(_from, _to, _tokenId);
    }

    function _isContract(address _to) view internal returns (bool){
        uint32 size;
        assembly{
            size := extcodesize(_to)
        }
        return size > 0;
    }

    function _isApprovedOrOwner(address _spender, address _from, address _to, uint256 _tokenId) internal view returns (bool) {
    require(_tokenId < kitties.length);
    require(_to != address(0));
    require(_owns(_from, _tokenId));

    return (_spender == _from || _approvedFor(_spender, _tokenId) || isApprovedForAll(_from, _spender));
    }

    function _mixDna(uint256 _dadDna, uint256 _mumDna) internal returns (uint256) {
      uint256[8] memory geneArray;
      uint8 random = uint8( now % 255 ); // 0-255 00000000-11111111
      uint256 i = 1;
      uint256 index = 7;
      for (i = 1; i <= 128; i=i*2) {
          if(random & i != 0){
              geneArray[index] = uint8( _mumDna % 100);
          }
          else{
              geneArray[index] = uint8( _dadDna % 100);
          }
          _mumDna = _mumDna / 100;
          _dadDna = _dadDna / 100;

          index = index - 1;
          // 1, 2, 4, 8, 16, 32, 64, 128
          /*
          00000001 - 1
          00000010 - 2
          00000100 - 4
          00001000 - 8
          00010000 - 16
          00100000 - 32
          01000000 - 64
          10000000 - 128
          
          */
      }
      uint256 newGene;
      for (i = 0; i < 8; i++) {
          newGene = newGene + geneArray[i];
          if(i != 7){
          newGene = newGene * 100;
          }
          

      }

      return newGene;
    }
}