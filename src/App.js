import './App.css';
import React, {useState}  from 'react'; 

import Abi from './abi.json';
const web3 =require('web3')
require('dotenv').config()



function App() {

  


  let url = 'https://mainnet.infura.io/v3/'+process.env.SECRET_KEY
  let Web3 = new web3(url)
  
  let contractAddress = '0xf8EF7d0f98070CD8D45dB4c9E638EbC25da840b1'
  let impersonatedaccount='0x748de14197922c4ae258c7939c7739f3ff1db573'

// //instantiate the cotract
let contract = new Web3.eth.Contract(Abi.abi,contractAddress)
  
  

const [token,setName]=useState()


const [ispending,isfinished]=useState(true)
const [c,_show]=useState()
const [tittle,settitle]=useState()
const [print,setprint]=useState()

 


async function   deposit(){
  let amount =tittle* 10**18
 
 await contract.methods.deposit(amount).send({from:impersonatedaccount})

 
}
async function   rebalance(){
 
  await contract.methods.rebalance().send({from:impersonatedaccount})
 
}
async function  withdraw(){
 
  await contract.methods. withdraw().send({from:impersonatedaccount})
 
}


  return (
    <div className="App">

      <div className='heading'>
        <p>DAPPUNIVERSITY</p>
        
        <button className='btn btn-success'>CONNECT METAMASK</button>
        </div> 
        <div className='innerbody'>
          
          
      <input type="text" onChange={(e)=>settitle(e.target.value)} /> <br /> <br />
      {/* <button className='btn btn-success' onClick={ _update}> UPDATE </button> */}
      
      <button className='btn btn-success' onClick={deposit}> DEPOSIT </button><br /> <br />
      <button className='btn btn-success' onClick={rebalance}> REBALANCE </button> <br /> <br />
      <button className='btn btn-success' onClick={withdraw}> WITHDRAW</button>
      
      </div>
     
    </div>
  );
}

export default App;
