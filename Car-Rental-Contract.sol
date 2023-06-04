// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarRentalContract {
    address payable owner;
    uint256 public deposit; // Security deposit amount

    struct Car {
        address owner;
        string licenseNumber;
        uint256 rent; // Rent amount
        bool isAvailable;
    }

    mapping(string => Car) public cars; // Car license number to car info

    constructor() {
        owner = payable(msg.sender); // Set owner as contract deployer
        deposit = 1 ether; // Set security deposit amount
    }

    function addCar(string memory licenseNumber, uint256 rent) public {
        require(msg.sender == owner, "Only owner can add cars"); // Only owner can add cars
        cars[licenseNumber] = Car(msg.sender, licenseNumber, rent, true);
    }

    function bookCar(string memory licenseNumber) public payable {
        Car storage car = cars[licenseNumber];
        require(car.isAvailable && msg.value >= (car.rent + deposit), "Car is not available or insufficient ether sent"); // Car is available and enough ether is sent
        car.isAvailable = false; // Make car unavailable
        payable(address(uint160(car.owner))).transfer(msg.value); // Transfer ether to owner, will deduct deposit amount
    }

    function endBooking(string memory licenseNumber) public {
        Car storage car = cars[licenseNumber];
        require(msg.sender == car.owner, "Only owner can end booking"); // Only owner can end booking
        car.isAvailable = true; // Make car available again
        payable(msg.sender).transfer(deposit); // Return deposit amount to renter
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw"); // Only owner can withdraw
        owner.transfer(address(this).balance); // Transfer all ether to owner
    }
}