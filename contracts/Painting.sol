// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Painting is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private currentTokenId;

    string public baseTokenURI;


    struct Pixel {
        address owner;
        uint256 x;
        uint256 y;
        uint8 color;
    }

    struct Pic {
        string name;
        bytes32 seed;
    }

    mapping(bytes32 => Pixel) private datamatching;
    mapping(address => uint) public CDofPainter;
    mapping(address => uint) public ownerpixelscount;
    mapping(bytes32 => uint) public indexofpaint;

    uint256 _size;
    uint256 _finishtime;
    uint _idx;

    Pixel[] public pixels;
    Pic[] public pictures;

    constructor() ERC721("DMAP", "NFT") {
        _size = 128;
        _finishtime = block.timestamp + 14 days;
        baseTokenURI = "";
    }

    function mintTo(address recipient) private returns (uint256){
        require(ownerpixelscount[recipient] > 0);
        currentTokenId.increment();
        uint256 newItemId = currentTokenId.current();
        _safeMint(recipient, newItemId);
        return newItemId;
    }

    function paint(uint256 x, uint256 y, uint8 color) public {
        if (_finishtime < block.timestamp) {mintTo(msg.sender);}
        require(_finishtime >= block.timestamp);
        require(x <= _size && y <= _size);
        require(color <= 15 && color >= 0);
        require(CDofPainter[msg.sender] <= block.timestamp, "Haven't cooled down!");

        bytes32 position = keccak256(abi.encodePacked(x,y));
        Pixel storage pixel = datamatching[position];
        if (pixel.owner == 0x0000000000000000000000000000000000000000) {
            pixel.owner = msg.sender;
            pixel.x = x;
            pixel.y = y;
            pixel.color = color;
            pixels.push(pixel);
            ownerpixelscount[msg.sender] ++;
            indexofpaint[position] = _idx;
            _idx ++;

        } else {
            pixels[indexofpaint[position]].color = color;
            ownerpixelscount[msg.sender] ++;
            ownerpixelscount[pixels[indexofpaint[position]].owner] --;
        }

        CDofPainter[msg.sender] = block.timestamp + 5 minutes;
        emit Painted(msg.sender, color);
    }

    function getsize() view public returns (uint) {
        return _size;
    }

    function getfinishtime() view public returns (uint) {
        return _finishtime;
    }

    function getpixels() view public returns (Pixel[] memory) {
        return pixels;
    }

    function setBaseTokenURI(string memory _baseTokenURI) public {
        baseTokenURI = _baseTokenURI;
    }

    event Painted(address indexed from, uint256 color);
}

