const express = require('express');
const { Transaction } = require('@ethereumjs/tx');
const Common = require('@ethereumjs/common').default;
const ethers = require('ethers');
const app = express();
app.use(express.json());

const SMART_CONTRACT_ADDRESS = "address of the smart contract";
//get the abi from a file
const SMART_CONTRACT_ABI = require('./abi.json');

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');
const contract = new ethers.Contract(SMART_CONTRACT_ADDRESS, SMART_CONTRACT_ABI, provider);

app.post('/receive-transaction', async (req, res) => {
  try {
    const rawTransaction = req.body.rawTransaction;

    // Transaction is deserialized
    const common = new Common({ chain: 'mainnet', hardfork: 'petersburg' }); // Replace with your network
    const transaction = Transaction.fromSerializedTx(Buffer.from(rawTransaction, 'hex'), { common });

    // Verify the signature
    if (!transaction.verifySignature()) {
      console.log('Invalid signature');
      return res.status(400).send('Invalid signature');
    }

    // Sender address is retrieved
    const senderAddress = '0x' + transaction.getSenderAddress().toString('hex');

    // Retrieve the whitelist from the blockchain
    const whitelistedAddresses = await contract.getWhitelist();

    // Check if the sender's address is in the whitelist
    if (whitelistedAddresses.includes(senderAddress)) {
      console.log('Access granted to:', senderAddress);
      // TODO: Add your logic to unlock the door
      res.status(200).send('Access granted');
    } else {
      console.log('Access denied to:', senderAddress);
      res.status(403).send('Access denied');
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Error processing transaction');
  }
});

app.listen(3000, () => console.log('Server started on port 3000'));
