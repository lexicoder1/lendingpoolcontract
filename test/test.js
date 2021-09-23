const Migrations = artifacts.require("lending");

contract ('hello',accounts=>{
    before(async function () {
        res =   await fetch("https://api.compound.finance/api/v2/account?addresses[]=0x6b175474e89094c44da98b954eedeac495271d0f");

        let _res= await  res.json()
        let compintress=_res.accounts[0].tokens[0].lifetime_supply_interest_accrued.value
        let deploy=await Migrations.deployed();
        let impersonatedaccount='0x748de14197922c4ae258c7939c7739f3ff1db573'
      });




    it('confirm user deposit in the account', async ()=>{
       
         let update =await deploy.updatecompoundinterestrate(compintress)
        let depo=await deploy.deposit(100000000000000000000, {from:impersonatedaccount})
        let balance=await deploy.contractbalanceofuser( {from:impersonatedaccount})
        
        assert.equal(u,'100000000000000000000')
        
    })


    it('confirm withdraw by interest rate', async ()=>{
        let f= await deploy.withdraw({from:impersonatedaccount})
        let d= await deploy._currentprotocol()
        if (d==1){
          let q= await deploy.userbalanceincontract(impersonatedaccount);
          assert.equal(q,'113000000000000000000')

        }
        if (d==2){
            let q= await deploy.userbalanceincontract(impersonatedaccount);
            assert.equal(q,'181000000000000000000')
  
          }
        
        
    })
})
        
        
        
        
        
        
        
        
        
        
