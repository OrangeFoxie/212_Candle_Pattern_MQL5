//+------------------------------------------------------------------+
//|                                                    Fox_class.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#define LinkToIndicators1 "\\OrFox\\Inditest01.ex5"
class Fox_class
  {
private:
      int               Magic_number;
      int               Check_margin;
      double            Lots;
      double            TradePct;
      double            Indi_01;
      int               Indi_01_handle;
      double            Indi_01_val[];
      double            ClosePrice;
      MqlTradeRequest   tradeQuest;
      MqlTradeResult    tradeResul;
      string            symbol;
      ENUM_TIMEFRAMES   period;
      string            ErMsg;
      int               ErCode;

public:
  void   Fox_class();
  void   ~Fox_class();
  void   setSymbol(string syb){symbol = syb;}
  void   setPeriod(ENUM_TIMEFRAMES per){per = period;}
  void   setClose(double closeprice){closeprice = ClosePrice;}
  void   setCheckMargin(int mag){Check_margin=mag;}
  void   setLots(double lots){Lots=lots;}
  void   setTRpct(double tradePercentages){TradePct=tradePercentages/100;}
  void   setMagic(int magic){Magic_number=magic;}
  void   setIndi01(double ind_01){Indi_01=ind_01;}
  void   doInit(int Indicator_01);
  void   checkIndicator(int Indicator);
  void   doUnInit();
  bool   CheckBuy();
  bool   CheckSell();
  void   InfoBuy(MqlTradeRequest &info,MqlTradeResult &info2);
  void   InfoSell(MqlTradeRequest &info,MqlTradeResult &info2);
  void   openBuy(ENUM_ORDER_TYPE odertype,double askprice, double SL, double TP,int dev,string comment="");
  void   openSell(ENUM_ORDER_TYPE odertype,double bidprice, double SL, double TP,int dev,string comment="");
  
protected:
   void  showErrors(string messages, int errcode);
   void  getBuffers();
   bool  MarginOK();                    
  };
  
void Fox_class::Fox_class()
   {
      ZeroMemory(tradeQuest);
      ZeroMemory(tradeResul);
      ZeroMemory(Indi_01_val);
      ErMsg="";
      ErCode=0;
   }

void Fox_class::~Fox_class(){}

void Fox_class::showErrors(string messages,int errcode){Alert(messages,"\n\t--- Mã lỗi:",errcode);}

void Fox_class::getBuffers(void)
   {
      if(CopyBuffer(Indi_01_handle,0,0,50,Indi_01_val)<0)
        {
         ErMsg = "Copy values of indicator is not enough";  ErCode=GetLastError();
         showErrors(ErMsg,ErCode);
        }
   }
   
bool Fox_class::MarginOK()
   {
      double one_lot_price;
      double act_f_mag  =  AccountInfoDouble(ACCOUNT_FREEMARGIN);
      long   levrage    =  AccountInfoInteger(ACCOUNT_LEVERAGE);
      double contract_size = SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE);
      string base_currency = SymbolInfoString(symbol,SYMBOL_CURRENCY_BASE);
      
      if(base_currency == "USD")
        {
         one_lot_price = contract_size/levrage;
        }else
           {
            double bprice = SymbolInfoDouble(symbol,SYMBOL_BID);
            one_lot_price = bprice*contract_size/levrage;
           }
           
      if(MathFloor(Lots*one_lot_price)>MathFloor(act_f_mag*TradePct))
        {
         return(false);
        }else
           {
            return(true);
           }
   }
   
void Fox_class::checkIndicator(int Indicator)
   {
      if(Indicator<0)
        {
         ErMsg="Fail to creating Indicator"; ErCode=GetLastError();
         showErrors(ErMsg,ErCode);
        }
   }
        
void Fox_class::doInit(int Indicator_01)
   {
      Indi_01_handle = iCustom(symbol,period,LinkToIndicators1);  this.checkIndicator(Indi_01_handle);
      ArraySetAsSeries(Indi_01_val,true);
   }
   
void Fox_class::doUnInit(){IndicatorRelease(Indi_01_handle);}
   
bool Fox_class::CheckBuy()
   {
      getBuffers();
      bool Buy_01 = (Indi_01_val[0]<Indi_01_val[1] && Indi_01_val[1]<Indi_01_val[2]);
      if(Buy_01)
        {
         return true;
        }else
           {
            return false;
           }
   }
bool Fox_class::CheckSell()
   {
      getBuffers();
      bool Sell_01 = (Indi_01_val[0]>Indi_01_val[1] && Indi_01_val[1]>Indi_01_val[2]);
      if(Sell_01)
        {
         return true;
        }else
           {
            return false;
           }
   }
   
void Fox_class::InfoBuy(MqlTradeRequest &info,MqlTradeResult &info2)
   {
        if(!OrderSend(info,info2))
          {
           Alert("The Buy order request could not be completed: ",GetLastError());
          }else
             {
              Alert("--->> Giao dich Buy thanh cong !!! ","Deal: ",info2.deal," Order: ",info2.order," RetCode: ",info2.retcode);
             }
   }
   
void Fox_class::InfoSell(MqlTradeRequest &info,MqlTradeResult &info2)
   {
          if(!OrderSend(info,info2))
          {
           Alert("The Sell order request could not be completed: ",GetLastError());
          }else
             {
              Alert("--->> Giao dich Sell thanh cong !!! ","Deal: ",info2.deal," Order: ",info2.order," RetCode: ",info2.retcode);
             }
   }
   
void Fox_class::openBuy(ENUM_ORDER_TYPE odertype,double askprice,double SL,double TP,int dev,string comment="")
   {
      if(Check_margin==1)
        {
         if(MarginOK()==false)
           {
            ErMsg="We don't have enough money to open this Position";   ErCode=GetLastError();
            showErrors(ErMsg,ErCode);
           }else
              {
               tradeQuest.action =  TRADE_ACTION_DEAL;
               tradeQuest.type   =  odertype;
               tradeQuest.volume =  Lots;
               tradeQuest.price  =  askprice;
               tradeQuest.sl     =  SL;
               tradeQuest.tp     =  TP;
               tradeQuest.deviation=   dev;
               tradeQuest.magic  =  Magic_number;
               tradeQuest.symbol =  symbol;
               tradeQuest.type_filling =  ORDER_FILLING_FOK;
               OrderSend(tradeQuest,tradeResul);
               this.InfoBuy(tradeQuest,tradeResul);
              }
        }else
           {
               tradeQuest.action =  TRADE_ACTION_DEAL;
               tradeQuest.type   =  odertype;
               tradeQuest.volume =  Lots;
               tradeQuest.price  =  askprice;
               tradeQuest.sl     =  SL;
               tradeQuest.tp     =  TP;
               tradeQuest.deviation=   dev;
               tradeQuest.magic  =  Magic_number;
               tradeQuest.symbol =  symbol;
               tradeQuest.type_filling =  ORDER_FILLING_FOK;
               OrderSend(tradeQuest,tradeResul);
               this.InfoBuy(tradeQuest,tradeResul);
           }
   }
   
void Fox_class::openSell(ENUM_ORDER_TYPE odertype,double bidprice,double SL,double TP,int dev,string comment="")
   {
      if(Check_margin==1)
        {
         if(MarginOK()==false)
           {
            ErMsg="We don't have enough money to open this Position";   ErCode=GetLastError();
            showErrors(ErMsg,ErCode);
           }else
              {
               tradeQuest.action =  TRADE_ACTION_DEAL;
               tradeQuest.type   =  odertype;
               tradeQuest.volume =  Lots;
               tradeQuest.price  =  bidprice;
               tradeQuest.sl     =  SL;
               tradeQuest.tp     =  TP;
               tradeQuest.deviation=   dev;
               tradeQuest.magic  =  Magic_number;
               tradeQuest.symbol =  symbol;
               tradeQuest.type_filling =  ORDER_FILLING_FOK;
               OrderSend(tradeQuest,tradeResul);
               this.InfoBuy(tradeQuest,tradeResul);
              }
        }else
           {
               tradeQuest.action =  TRADE_ACTION_DEAL;
               tradeQuest.type   =  odertype;
               tradeQuest.volume =  Lots;
               tradeQuest.price  =  bidprice;
               tradeQuest.sl     =  SL;
               tradeQuest.tp     =  TP;
               tradeQuest.deviation=   dev;
               tradeQuest.magic  =  Magic_number;
               tradeQuest.symbol =  symbol;
               tradeQuest.type_filling =  ORDER_FILLING_FOK;
               OrderSend(tradeQuest,tradeResul);
               this.InfoBuy(tradeQuest,tradeResul);
           }
   }

//+------------------------------------------------------------------+
