const fs = require('fs')

const main = async () => {
  // const accounts = await ethers.provider.listAccounts()

  const nftContractFactory = await hre.ethers.getContractFactory('MyWeb3NFT')
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()
  console.log('Contract deployed to:', nftContract.address)

  const contractAddress = JSON.stringify({
    contractAddress: nftContract.address,
  })

  await fs.writeFileSync(
    '../src/artifacts/contractAddress.json',
    contractAddress,
    'utf8',
  )
  console.log('The file was saved!')

  // Call the function.
  let txn = await nftContract.makeAWeb3NFT()
  // Wait for it to be mined.
  await txn.wait()
  console.log('Minted NFT #1')

  // txn = await nftContract.makeAWeb3NFT(accounts[0])
  // // Wait for it to be mined.
  // await txn.wait()
  // console.log('Minted NFT #2')
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
