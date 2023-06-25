import React, { useState } from 'react';
import { ethers } from 'ethers';

const provider = new ethers.providers.Web3Provider(window.ethereum);

const WalletCard = () => {
  const [errorMessage, setErrorMessage] = useState(null);
  const [defaultAccount, setDefaultAccount] = useState(null);
  const [userBalance, setUserBalance] = useState(null);

  const connectWalletHandler = async () => {
    if (window.ethereum) {
      try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const signer = provider.getSigner();
        await accountChangedHandler(signer);
      } catch (error) {
        setErrorMessage('Failed to connect with MetaMask: ' + error.message);
      }
    } else {
      setErrorMessage('MetaMask extension not detected.');
    }
  };

  const accountChangedHandler = async (newAccount) => {
    const address = await newAccount.getAddress();
    setDefaultAccount(address);
    const balance = await newAccount.getBalance();
    setUserBalance(ethers.utils.formatEther(balance));
    await getUserBalance(address);
  };

  const getUserBalance = async (address) => {
    const balance = await provider.getBalance(address);
    console.log('User balance:', balance.toString());
  };

  const createTransaction = async () => {
    const signer = provider.getSigner();
    const senderAddress = await signer.getAddress();

    const transaction = {
      to: senderAddress,
      value: ethers.utils.parseEther('0.0'), // Amount of ETH set to 0
    };

    try {
      const signedTransaction = await signer.signTransaction(transaction);
      console.log('Signed transaction:', signedTransaction);
    } catch (error) {
      console.error('Failed to sign transaction:', error);
    }
  };


  return (
    <div className="WalletCard">
      <h3 className="h4">Welcome to a decentralized Application</h3>
      <button
        style={{ background: defaultAccount ? '#A5CC82' : 'white' }}
        onClick={connectWalletHandler}
      >
        {defaultAccount ? 'Connected!!' : 'Connect'}
      </button>
      <div className="displayAccount">
        <h4 className="walletAddress">Address: {defaultAccount}</h4>
        <div className="balanceDisplay">
          <h3>Wallet Amount: {userBalance}</h3>
        </div>
      </div>
      <button onClick={createTransaction}>Create Transaction</button>
      {errorMessage}
    </div>
  );
};

export default WalletCard;
