# Multisig Wallet Smart Contract
Written by REGO350 in Solidity.  
Copy & Paste the code to https://remix.ethereum.org.   

Register owners of the wallet (example):   
```["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"], 2```

Transfer request input example:   
```0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, 2000000000000000000```

Approve transfer request:  
click the orange approveTransfer button

What is a multisig wallet:  
A multisig wallet is a wallet where multiple "signatures" or approvals are needed for an outgoing transfer to take place. As an example, I could create a multisig wallet with me and my 2 friends. I configure the wallet such that it requires at least 2 of us to sign any transfer before it is valid. Anyone can deposit funds into this wallet. But as soon as we want to spend funds, it requires 2/3 approvals.  

Note:  
* Only one transfer request at a time. 
* Double voting does not work.
