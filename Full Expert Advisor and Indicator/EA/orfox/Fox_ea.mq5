//+------------------------------------------------------------------+
//|                                                       Fox_ea.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Fox_class.mqh>

input int   StopLoss = 30;
input int   TakeProfit = 35;
input int   Indi_01_Period = 10;
input int   Indi_03_Period = 10;
input int   Indi_04_Period = 1;
input double   Lots = 0.2;
input int   Margin_Chk  =  9;
input double   Trd_percent = 11;
input int   EA_magic = 521753;

input int   ADX_Period = 10;
input int   MA_Period  = 15;


int STP,TKP;
Fox_class fox;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   fox.doInit(Indi_01_Period,ADX_Period,MA_Period,Indi_03_Period,Indi_04_Period);
   fox.setPeriod(_Period);
   fox.setSymbol(_Symbol);
   fox.setMagic(EA_magic);
   fox.setLots(Lots);
   fox.setCheckMargin(Margin_Chk);
   fox.setTRpct(Trd_percent);
   STP = StopLoss;
   TKP = TakeProfit;
   
   if(_Digits==5)
     {
      STP=STP*10; TKP=TKP*10;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   fox.doUnInit();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   int Mybars = Bars(_Symbol,_Period);
   if(Mybars<60)
     {
      Alert("We don't have enough 60 bars");  return;
     }
     
   MqlTick lates_price;
   MqlRates mrate[];
   ArraySetAsSeries(mrate,true);
   if(!SymbolInfoTick(_Symbol,lates_price))
     {
      Alert("Can't get the new price: ",GetLastError());   return;
     }
   if(CopyRates(_Symbol,_Period,0,5,mrate)<0)
     {
      Alert("Failed to copy data to arrays: ",GetLastError()); return;
     }
     
     static datetime Prev_time;
     datetime Bar_time[1];
     Bar_time[0] = mrate[0].time;
     if(Prev_time == Bar_time[0]){return;}Prev_time = Bar_time[0];
     
     bool Buy_opend=false, Sell_opened=false;
     
     if(PositionSelect(_Symbol)==true)
       {
        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){Buy_opend = true;}
        if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL){Sell_opened = true;}
       }
       
     fox.setClose(mrate[1].close);
     if(fox.CheckBuy()==true)
       {
        if(Buy_opend)
          {printf("We have enter this buy pos");
           return;
          }
          
         double aprice = NormalizeDouble(lates_price.ask,_Digits);
         double astl    = NormalizeDouble(lates_price.ask - STP*_Point,_Digits);
         double atkp   = NormalizeDouble(lates_price.ask + TKP*_Point,_Digits);
         int amdev = 100;
         fox.openBuy(ORDER_TYPE_BUY,aprice,astl,atkp,amdev);
       }
       
     if(fox.CheckSell()==true)
       {
        if(Sell_opened)
          {printf("We have enter this sell pos");
           return;
          }
          
         double bprice = NormalizeDouble(lates_price.bid,_Digits);
         double bstl    = NormalizeDouble(lates_price.bid + STP*_Point,_Digits);
         double btkp   = NormalizeDouble(lates_price.bid - TKP*_Point,_Digits);
         int bmdev = 100;
         fox.openSell(ORDER_TYPE_SELL,bprice,bstl,btkp,bmdev);
       }
       return;
  }
//+------------------------------------------------------------------+
