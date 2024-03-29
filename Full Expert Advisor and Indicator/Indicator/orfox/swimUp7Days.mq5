//+------------------------------------------------------------------+
//|                                                  swimUp7Days.mq5 |
//|                                                            CaMeo |
//|                         https://www.facebook.com/hitoshi.itamino |
//+------------------------------------------------------------------+
#property copyright "CaMeo"
#property link      "https://www.facebook.com/hitoshi.itamino"
#property version   "1.00"
#property description "INDICATOR XÁC ĐỊNH CHUỖI NẾN BƠI NGƯỢC DÒNG 7 NGÀY"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Buy

#property indicator_label1  "buy"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  5
//--- plot Sell
#property indicator_label2  "sell"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrBlueViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  5
//--- indicator buffers
double         BuyBuffer[];
double         SellBuffer[];
bool           buySignal = false,
               sellSignal = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,BuyBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,SellBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   int code = 125;
   PlotIndexSetInteger(0,PLOT_ARROW,code);
   PlotIndexSetInteger(1,PLOT_ARROW,code);
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0);
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//--- CODE HERE

   for(int i=8;i<rates_total;i++)
     {     
        if(close[i-7] != open[i-7] &&
            close[i-6] != open[i-6] &&
            close[i-5] != open[i-5] &&
            close[i-4] != open[i-4] &&
            close[i-3] != open[i-3] &&
            close[i-2] != open[i-2] &&
            close[i-1] != open[i-1]  )               
           {

               if(close[i-7] > close[i-6] &&
                  close[i-6] > close[i-5] &&
                  close[i-5] > close[i-4] &&
                  close[i-4] > close[i-3] &&
                  close[i-4] > close[i-3] &&
                  close[i-3] > close[i-2] &&
                  close[i-2] > close[i-1]    )
                {
                     BuyBuffer[i] = open[i]; 
                     buySignal = true;  
                     sellSignal = false; 
                }
         
               if(close[i-7] < close[i-6] &&
                  close[i-6] < close[i-5] &&
                  close[i-5] < close[i-4] &&
                  close[i-4] < close[i-3] &&
                  close[i-4] < close[i-3] &&
                  close[i-3] < close[i-2] &&
                  close[i-2] < close[i-1]    )
                {
                     SellBuffer[i] = open[i];  
                     buySignal = false;
                     sellSignal = true;                        
                } 
              else
                {
                 buySignal = false;
                 sellSignal = false;
                }}}   

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
