# Changelog 

All notable changes to this project will be documented in this
file.  This project adheres to [Semantic Versioning](http://semver.org/).

As this project is pre 1.0, breaking changes may happen for minor version
bumps.  A breaking change will get clearly notified in this log.

## [unreleased](https://github.com/stellar/ruby-stellar-base/compare/v0.7.0...master)

### Changed
- BREAKING CHANGE:  The default network for this library is now the stellar test network.  
  To enable this library for the production network use `Stellar.default_network = Stellar::Networks::PUBLIC` 
  at the head of your script or in your configuration function.

## [0.7.0](https://github.com/stellar/ruby-stellar-base/compare/v0.6.1...v0.7.0)

### Changed

- Bump xdr dependency to 1.0.0

## [0.6.1](https://github.com/stellar/ruby-stellar-base/compare/v0.6.0...v0.6.1)

### Changed

- Update default fee for transactions to new minimum of 100 stroops


## [0.6.0](https://github.com/stellar/ruby-stellar-base/compare/v0.5.0...v0.6.0)

### Changed

- Update to latest xdr (stellar-core commit ad22bccafbbc14a358f05a989f7b95714dc9d4c6)

## [0.5.0](https://github.com/stellar/ruby-stellar-base/compare/v0.4.0...v0.5.0)

### Changed

- Update to latest xdr

## [0.4.0](https://github.com/stellar/ruby-stellar-base/compare/v0.3.0...v0.4.0)

### Changed
- BREAKING CHANGE: "Amounts", that is, input parameters that represent a
  certain amount of a given asset, such as the `:starting_balance` option for
  `Operation.create_account` are now interpreted using the convention of 7
  fixed-decimal places.  For example, specifying a payment where the amount is
  `50` will result in a transaction with an amount set to `500000000`.
