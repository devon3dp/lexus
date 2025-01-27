// Load environment variables
require('dotenv').config();

// Import dependencies
const Web3 = require('web3'); // Ethereum operations
const { Connection, clusterApiUrl } = require('@solana/web3.js'); // Solana SDK
const axios = require('axios'); // HTTP client
const bitcoin = require('bitcoinjs-lib'); // Bitcoin operations

// Environment variables
const ETH_RPC_URL = process.env.ETH_RPC_URL;
const SOLANA_RPC_URL = process.env.SOLANA_RPC_URL;
const BITCOIN_API_URL = process.env.BITCOIN_RPC_URL;

// Initialize Ethereum Web3
const web3 = new Web3(ETH_RPC_URL);

// Initialize Solana Connection
const solanaConnection = new Connection(SOLANA_RPC_URL || clusterApiUrl('mainnet-beta'));

// Example Functions for Blockchain Interactions

// Ethereum: Get Wallet Balance
async function getEthereumBalance(address) {
  try {
    const balance = await web3.eth.getBalance(address);
    console.log(`Ethereum Balance for ${address}: ${web3.utils.fromWei(balance, 'ether')} ETH`);
  } catch (error) {
    console.error('Error fetching Ethereum balance:', error.message);
  }
}

// Solana: Get Wallet Balance
async function getSolanaBalance(address) {
  try {
    const balance = await solanaConnection.getBalance(address);
    console.log(`Solana Balance for ${address}: ${(balance / Web3.LAMPORTS_PER_SOL).toFixed(6)} SOL`);
  } catch (error) {
    console.error('Error fetching Solana balance:', error.message);
  }
}

// Bitcoin: Get Wallet Balance (via API)
async function getBitcoinBalance(address) {
  try {
    const response = await axios.get(`${BITCOIN_API_URL}/q/addressbalance/${address}`);
    console.log(`Bitcoin Balance for ${address}: ${response.data} BTC`);
  } catch (error) {
    console.error('Error fetching Bitcoin balance:', error.message);
  }
}

// Main Execution Function
(async () => {
  // Wallet Addresses
  const ethAddress = '0xYourEthereumAddressHere';
  const solAddress = 'YourSolanaAddressHere';
  const btcAddress = 'YourBitcoinAddressHere';

  // Fetch balances
  console.log('Fetching blockchain balances...');
  await getEthereumBalance(ethAddress);
  await getSolanaBalance(solAddress);
  await getBitcoinBalance(btcAddress);

  console.log('Done!');
})();
