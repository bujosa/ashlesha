# Ashlesha

This is a simple project for undestading and practice the Diamond Proxy, ERC-2535.

## Documentation

A Beginners guide to the diamong standard proxy

Blessing Emah via [medium](https://blessingemah.medium.com/a-beginners-guide-to-the-diamond-standard-proxy-b57076365403)

### HISTORY

The Diamond Standard also known as an EIP-2535 is a form of an Upgradeable Proxy Pattern which was created by [Nick Mudge](https://www.linkedin.com/in/mudge/).

It was birthed out of the problem Nick faced as he was implementing an ERC721 token that could control other ERC721 tokens and ERC20 tokens but he was limited by the fact that a smart contract can only accommodate 24 KB Size of data. Once this limit is reached, nothing can be added to the smart contract code.

Nick created EIP-2535 Diamond to solve the 24KB contract limit, but it turned out this solution is applicable beyond the Data size scope. EIP-2535 also provides a framework for building larger smart contract systems that can grow as time develops without data limits.
