//+------------------------------------------------------------------+
//|                                                   Inditest01.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Indicator làm mịn các đường của Bảng chỉ số"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot LineText
#property indicator_label1  "LineText"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         LineTextBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,LineTextBuffer,INDICATOR_DATA);
   
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
//---
   for(int i=1;i<rates_total;i++)
     {
      if(close[i-1]>open[i]) // Giá giảm
        {
         LineTextBuffer[i]=low[i]; 
        }
      if(close[i-1]<open[i]) // Giá tăng
        {
         LineTextBuffer[i]=high[i]; 
        }
      LineTextBuffer[i]=(high[i]+low[i])/2;  // Giá trung tính
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
