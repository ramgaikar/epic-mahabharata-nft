import { ethers } from 'ethers'
import React, { useEffect, useState } from 'react'
import Alert from '@mui/material/Alert'
import AlertTitle from '@mui/material/AlertTitle'
import './styles/App.css'

import linkedinlogo from './assets/linkedin-logo.svg'
import loaderIcon from './assets/loader.svg'
import myEpicWeb3Nft from './artifacts/contracts/MyWeb3NFT.sol/MyWeb3NFT.json'
import { contractAddress } from './artifacts/contractAddress.json'

const LINKEDIN_HANDLE = 'ram-gaikar'
const LINKEDIN_LINK = `https://www.linkedin.com/in/${LINKEDIN_HANDLE}`

const App = () => {
  const [currentAccount, setCurrentAccount] = useState('')
  const [isLoading, setLoading] = useState(false)
  const [tokenId, setTokenId] = useState(null)

  const connectWallet = async () => {
    try {
      const { ethereum } = window

      if (!ethereum) {
        alert('Get MetaMask!')
        return
      }

      const accounts = await ethereum.request({ method: 'eth_requestAccounts' })

      console.log('Connected', accounts[0])
      setCurrentAccount(accounts[0])

      // Setup listener! This is for the case where a user comes to our site
      // and connected their wallet for the first time.
      setupEventListener()
    } catch (error) {
      console.log(error)
    }
  }

  // Setup our listener.
  const setupEventListener = async () => {
    // Most of this looks the same as our function askContractToMintNft
    try {
      const { ethereum } = window

      if (ethereum) {
        // Same stuff again
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const connectedContract = new ethers.Contract(
          contractAddress,
          myEpicWeb3Nft.abi,
          signer,
        )

        // THIS IS THE MAGIC SAUCE.
        // This will essentially "capture" our event when our contract throws it.
        // If you're familiar with webhooks, it's very similar to that!
        connectedContract.on('NewWeb3NFTMinted', (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          setTokenId(tokenId.toNumber())
        })

        console.log('Setup event listener!')
      } else {
        console.log("Ethereum object doesn't exist!")
      }
    } catch (error) {
      console.log(error)
    }
  }

  const askContractToMintNft = async () => {
    setTokenId(null)
    try {
      const { ethereum } = window

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum)
        const signer = provider.getSigner()
        const connectedContract = new ethers.Contract(
          contractAddress,
          myEpicWeb3Nft.abi,
          signer,
        )

        console.log('Going to pop wallet now to pay gas...')
        let nftTxn = await connectedContract.makeAWeb3NFT()

        setLoading(true)
        console.log('Mining...please wait.')
        await nftTxn.wait()
        setLoading(false)
        // console.log(nftTxn)
        console.log(
          `Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`,
        )
      } else {
        console.log("Ethereum object doesn't exist!")
      }
    } catch (error) {
      console.log(error)
    }
  }

  useEffect(() => {
    const checkIfWalletIsConnected = async () => {
      const { ethereum } = window

      if (!ethereum) {
        console.log('Make sure you have metamask!')
        return
      } else {
        console.log('We have the ethereum object', ethereum)
      }

      const accounts = await ethereum.request({ method: 'eth_accounts' })

      if (accounts.length !== 0) {
        const account = accounts[0]
        console.log('Found an authorized account:', account)
        setCurrentAccount(account)

        // Setup listener! This is for the case where a user comes to our site
        // and ALREADY had their wallet connected + authorized.
        setupEventListener()
      } else {
        console.log('No authorized account found')
      }

      let chainId = await ethereum.request({ method: 'eth_chainId' })
      console.log('Connected to chain ' + chainId)

      // String, hex code of the chainId of the Rinkebey test network
      const rinkebyChainId = '0x4'
      if (chainId !== rinkebyChainId) {
        alert('You are not connected to the Rinkeby Test Network!')
      }
    }
    checkIfWalletIsConnected()
  }, [])

  const renderNotConnectedContainer = () => (
    <button
      onClick={connectWallet}
      className="cta-button connect-wallet-button"
    >
      Connect to Wallet
    </button>
  )

  const renderMintUI = () => (
    <React.Fragment>
      <button
        onClick={askContractToMintNft}
        className="cta-button connect-wallet-button"
      >
        Mint NFT
      </button>
      {tokenId && (
        <Alert onClose={() => {}} severity="success" className="alert-box">
          <AlertTitle>
            Hey there! We've minted your NFT and sent it to your wallet.
          </AlertTitle>
          It may be blank right now. It can take a max of 10 min to show up on
          OpenSea. Here's the link:{' '}
          <a
            href={`https://testnets.opensea.io/assets/${contractAddress}/${tokenId}`}
            target="_blank"
            rel="noreferrer"
          >
            OpenSea
          </a>
        </Alert>
      )}
    </React.Fragment>
  )

  return (
    <div className="App">
      <div className={isLoading ? 'container loading' : 'container'}>
        <div className="header-container">
          <p className="header gradient-text">
            EPIC Mahabharat Characters NFT Collection
          </p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your Mahabharat Character
            today.
          </p>
          {currentAccount === ''
            ? renderNotConnectedContainer()
            : renderMintUI()}
        </div>
        <div className="footer-container">
          <a
            className="footer-text"
            href={LINKEDIN_LINK}
            target="_blank"
            rel="noreferrer"
          >
            Built by{' '}
            <img
              alt="Linkedin Logo"
              className="linkedin-logo"
              src={linkedinlogo}
            />
          </a>
        </div>
      </div>
      {isLoading && (
        <div className="loader">
          <img src={loaderIcon} alt="Loader"></img>
        </div>
      )}
    </div>
  )
}

export default App
