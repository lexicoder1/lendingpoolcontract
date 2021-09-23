pragma solidity 0.8.0;
interface Idai{
    function approve(address usr, uint wad) external returns (bool) ;
    function transfer(address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad)external returns (bool);
    function balanceOf(address add)external view returns(uint);
    
}

interface Iaave{
     function deposit(address _reserve, uint256 _amount, uint16 _referralCode)
        external
        payable
        ;
        
    function redeemUnderlying(
        address _reserve,
        address payable _user,
        uint256 _amount,
        uint256 _aTokenBalanceAfterRedeem
    )
        external;
    
    
   
    function getReserveData(address _reserve)
        external
        view
        returns (
            uint256 totalLiquidity,
            uint256 availableLiquidity,
            uint256 totalBorrowsStable,
            uint256 totalBorrowsVariable,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 utilizationRate,
            uint256 liquidityIndex,
            uint256 variableBorrowIndex,
            address aTokenAddress,
            uint40 lastUpdateTimestamp
        );
}

interface Icompound{
    function mint(uint mintAmount) external returns (uint) ;
    function redeem(uint redeemTokens) external returns (uint) ;
    
}


contract lending{
    Idai _Idai= Idai(0x6B175474E89094C44Da98b954EedeAC495271d0F);
     Icompound  _Icompound= Icompound(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
     Iaave _Iaave=Iaave(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);
    uint interestratea;
    uint compoundinterestrate; // this would be gotten using compound api 
    uint aaveinterestrate=0.81*100;
    uint withdrawtime;
    
    
   
    enum Currentprotocol{NONE,COMPOUND,AAVE}
    Currentprotocol public _currentprotocol;
    mapping (address=>uint) userbalanceincontract;
    
    mapping (address=>Currentprotocol) trackingcurrentprotocol;
    mapping (address=>bool) check;
    
    function updatecompoundinterestrate(uint i) public{
        
        compoundinterestrate=i*100;
    }
    
    function updateaaveinterestrate()public{
    // (,,,,,,,aaveinterestrate,,,,,) =_Iaave.getReserveData(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        
    }
    
    
    function deposit(uint amount)public {
        _Idai.transferFrom(msg.sender, address(this), amount);
        userbalanceincontract[msg.sender]+=amount;
        check[msg.sender] =true;
        withdrawtime=block.timestamp;
     if (compoundinterestrate>aaveinterestrate){
         _Icompound.mint(amount); 
         trackingcurrentprotocol[msg.sender]=Currentprotocol.COMPOUND;
         
     }
     if(aaveinterestrate>compoundinterestrate){
         _Iaave.deposit(0x6B175474E89094C44Da98b954EedeAC495271d0F,amount, 0);
          trackingcurrentprotocol[msg.sender]=Currentprotocol.AAVE;
         
     }
    }
    
    function contractbalanceofuser()public view returns(uint){
        return userbalanceincontract[msg.sender];
    }
    
 function rebalance()public{
     require( check[msg.sender] ==true);
      if (compoundinterestrate>aaveinterestrate){
       _Iaave.redeemUnderlying(0x6B175474E89094C44Da98b954EedeAC495271d0F,payable(address(this)),userbalanceincontract[msg.sender],block.timestamp);
        _Icompound.mint(userbalanceincontract[msg.sender]);
        trackingcurrentprotocol[msg.sender]=Currentprotocol.COMPOUND;
     }
     if(aaveinterestrate>compoundinterestrate){
     _Icompound.redeem(userbalanceincontract[msg.sender]);
      _Iaave.deposit(0x6B175474E89094C44Da98b954EedeAC495271d0F,userbalanceincontract[msg.sender], 0);
       trackingcurrentprotocol[msg.sender]=Currentprotocol.AAVE;
     
     }
     
        
    }

function withdraw()public {
   require(block.timestamp>=withdrawtime+ 365 days);
   require(check[msg.sender] ==true);
   userbalanceincontract[msg.sender]-=userbalanceincontract[msg.sender];
   if ( trackingcurrentprotocol[msg.sender]==Currentprotocol.COMPOUND){
        _Icompound.redeem(userbalanceincontract[msg.sender]);
        userbalanceincontract[msg.sender] += userbalanceincontract[msg.sender]* (compoundinterestrate/100);
         _Idai.transfer(msg.sender,userbalanceincontract[msg.sender]);
        
   }
   if ( trackingcurrentprotocol[msg.sender]==Currentprotocol.AAVE){
        _Iaave.redeemUnderlying(0x6B175474E89094C44Da98b954EedeAC495271d0F,payable(address(this)),userbalanceincontract[msg.sender],block.timestamp);
          userbalanceincontract[msg.sender]+=(userbalanceincontract[msg.sender]*(aaveinterestrate/100) );
          _Idai.transfer(msg.sender,userbalanceincontract[msg.sender]);
         
        
   }
   
    
}

function balanceofcontract()public view returns(uint){
    return _Idai.balanceOf(address(this));
}


    
    
    
 }