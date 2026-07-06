# Car Rental Smart Contract

Solidity prototype for managing simple car rental bookings with a fixed security
deposit.

## Contract

`Car-Rental-Contract.sol` defines `CarRentalContract`.

## Rental Flow

1. The deployer becomes the contract owner.
2. The owner registers cars with `addCar`.
3. A renter books an available car by paying `rent + deposit`.
4. The rent is transferred to the car owner immediately.
5. The deposit stays in the contract until the booking ends.
6. When the owner ends the booking, the deposit is returned to the renter.

## Main Functions

- `addCar(string licenseNumber, uint256 rent)`
- `bookCar(string licenseNumber)`
- `endBooking(string licenseNumber)`
- `withdraw()`

## Safety Checks

- License numbers cannot be empty.
- Rent must be greater than zero.
- Duplicate car license numbers are rejected.
- Booking payment must exactly equal `rent + deposit`.
- The renter address is stored so the deposit can be returned correctly.

## Notes

This is a learning prototype. A production rental protocol would need stronger
access control, dispute handling, renter approvals, cancellation flows, and tests.
