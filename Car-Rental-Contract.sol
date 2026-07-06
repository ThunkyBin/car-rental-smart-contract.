// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarRentalContract {
    address payable owner;
    uint256 public deposit; // Security deposit amount

    struct Car {
        address owner;
        address renter;
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
        require(bytes(licenseNumber).length > 0, "License number is required");
        require(rent > 0, "Rent must be greater than zero");
        require(cars[licenseNumber].owner == address(0), "Car already exists");

        cars[licenseNumber] = Car(msg.sender, address(0), licenseNumber, rent, true);
    }

    function bookCar(string memory licenseNumber) public payable {
        Car storage car = cars[licenseNumber];
        require(car.isAvailable && msg.value == (car.rent + deposit), "Car is not available or incorrect ether sent"); // Car is available and exact ether is sent
        car.renter = msg.sender;
        car.isAvailable = false; // Make car unavailable
        payable(car.owner).transfer(car.rent); // Keep deposit in the contract until booking ends
    }

    function endBooking(string memory licenseNumber) public {
        Car storage car = cars[licenseNumber];
        require(msg.sender == car.owner, "Only owner can end booking"); // Only owner can end booking
        address renter = car.renter;
        require(renter != address(0), "Car is not booked");

        car.isAvailable = true; // Make car available again
        car.renter = address(0);
        payable(renter).transfer(deposit); // Return deposit amount to renter
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw"); // Only owner can withdraw
        owner.transfer(address(this).balance); // Transfer all ether to owner
    }
}
