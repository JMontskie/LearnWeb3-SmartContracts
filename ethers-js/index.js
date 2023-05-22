let signer;
let message = "Hello World";
// let mnemonic = "hello world red pig wall think move dynamic turon coke money cloud";
let mnemonic = "sauce execute true love rebel juice diesel story employ globe advance balance"


async function _getChainId() {
    const chainID = await signer.getChainId();
    console.log(`This is the Chain ID of this account: ${chainID}`);
}

async function _getAddress() {
    const address = await signer.getAddress();
    console.log(`This is the address of this account: ${address}`);
}

async function _getCurrentGasPrice() {
    const gasPrice = await signer.getGasPrice();
    console.log(`This is the current gas price: ${gasPrice}`);
}

async function _getBalance() {
    const balance = await signer.getBalance();
    console.log(`This is the balance of this account: ${balance}`);
}

async function _getTransactionCount() {
    const transactionCount = await signer.getTransactionCount("latest");
    console.log(`This is the transaction count of this account: ${transactionCount}`);
}

async function _signMessage() {
    //digitalSignature =  mukha sa pwet 
    const digitalSignature = await signer.signMessage(message);
    console.log(`This is the Digital Signature: ${digitalSignature}`);
}

async function _privateKey() {
    const privateKeyAddress = await new ethers.Wallet.fromMnemonic(mnemonic);
    console.log(privateKeyAddress.address);

    const publicKeyAddress = privateKeyAddress.publicKey;
    console.log(`This is the Public Key: ${publicKeyAddress}`);
}

async function _randomPrivateKey(){
    const randomPrivateKey = await ethers.Wallet.createRandom();
    console.log(`This is the Random Private Key: ${randomPrivateKey.address}`);

    const publicKeyAddress = randomPrivateKey.publicKey();
    console.log(`This is the Random Private Key: ${publicKeyAddress.address}`);

    const wallet = randomPrivateKey.connect(provider);
    console.log(wallet);
}



async function getAccounts() {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    console.log(provider);
    const randomPrivateKey = await ethers.Wallet.createRandom();
    console.log(`This is the Random Private Key: ${randomPrivateKey.address}`);

    const publicKeyAddress = randomPrivateKey.publicKey;
    console.log(`This is the Random Public Key: ${publicKeyAddress}`);

    const wallet = randomPrivateKey.connect(provider);

    const bal = await wallet.getBalance();
    console.log(`balance: ${bal}`);

    const chainIDs = await wallet.getChainId();
    console.log(`Chain ID: ${chainIDs}`);
    
    const gasPrice = await wallet.getGasPrice();
    console.log(ethers.utils.formatEther(gasPrice));

    provider.send("eth_requestAccounts", [])
        .then(() => {
            provider.listAccounts().then((accounts) => {
                signer = provider.getSigner(accounts[0]);
                document.getElementById("button").innerHTML = accounts[0].slice(0, 5) + '...' + accounts[0].slice(38,42)
                /* _privateKey()
                _randomPrivateKey()
                _getAddress()
                _getChainId()
                _getCurrentGasPrice()
                _getTransactionCount()
                _signMessage()  */
            })
        }).catch(error => {
            console.error(error);
        })    
}





