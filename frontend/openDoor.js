let provider;

async function connectWallet() {
    if (window.ethereum) {
        try {
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            provider = new ethers.providers.Web3Provider(window.ethereum);
        } catch (error) {
            console.error("User denied account access:", error);
            alert("Unable to connect to wallet. User denied account access.");
        }
    } else {
        console.error("Non-Ethereum browser detected. Please consider installing MetaMask");
        alert("Non-Ethereum browser detected. Please consider installing MetaMask");
    }
}

async function createTransaction() {
    if (!provider) return;

    const signer = provider.getSigner();
    const transaction = {
        to: await signer.getAddress(),
        value: ethers.utils.parseEther("0.0"),
    };

    try {
        const signedTransaction = await signer.signTransaction(transaction);

        const response = await fetch('http://future-server-url/receive-transaction', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ rawTransaction: signedTransaction })
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        } else {
            const responseData = await response.text();
            console.log(responseData);
            alert(responseData);
        }
    } catch (error) {
        console.error("Error while creating and sending transaction:", error);
        alert("Error while creating and sending transaction: " + error.message);
    }
}

window.onload = function() {
    document.getElementById('connectWallet').addEventListener('click', connectWallet);
    document.getElementById('createTransaction').addEventListener('click', createTransaction);
}
