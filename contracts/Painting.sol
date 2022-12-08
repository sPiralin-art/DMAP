// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Painting {
    struct Pixel {
        address owner;
        uint256 x;
        uint256 y;
        uint8 color;
    }

    mapping(bytes32 => Pixel) private datamatching;
    mapping(address => uint) public CDofPainter;

    uint256 _size;
    uint256 _finishtime;

    Pixel[] public pixels;

    constructor(uint256 size) {
        _size = size;
        _finishtime = block.timestamp + 14 days;
    }

    function mint() private {
        emit Painted(msg.sender, 123);
    }

    function paint(uint256 x, uint256 y, uint8 color) public {
        if (_finishtime < block.timestamp) {mint();}
        require(_finishtime >= block.timestamp);
        require(x <= _size && y <= _size);
        require(color <= 15 && color >= 0);
        require(CDofPainter[msg.sender] <= block.timestamp, "Haven't cooled down!");

        Pixel storage pixel = datamatching[keccak256(abi.encodePacked(x,y))];
        pixel.owner = msg.sender;
        pixel.x = x;
        pixel.y = y;
        pixel.color = color;
        pixels.push(pixel);

        CDofPainter[msg.sender] = block.timestamp + 5 minutes;
        emit Painted(msg.sender, color);
    }

    function getData(uint256 x, uint256 y) view public returns (address, uint, uint, uint) {
        bytes32 position = keccak256(abi.encodePacked(x,y));
        return (datamatching[position].owner, datamatching[position].x, datamatching[position].y, datamatching[position].color);
    }

    function test() pure public returns (uint) {
      return (1);
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

    event Painted(address indexed from, uint256 color);
}

