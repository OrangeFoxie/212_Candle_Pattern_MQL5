//+------------------------------------------------------------------+
//|                                                       212-03.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//-- Mô tả chỉ báo:
#property description "-----------Chỉ báo 212 (indicator 212)-----------"
#property description "Dự đoán giá trị tiếp theo của nến số 1 sẽ bắt đầu chuỗi Lên hoặc Xuống"
#property description "(＃￣0￣) Dự báo có sai sót mức trung bình, cận cao (；￣Д￣)"
#property description "          Đỏ là Giá lên, Vàng là giá xuống"
#property description "      (」°ロ°)」      ---------------------------->>>              (＃￣ω￣)"
//---
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Long
#property indicator_label1  "Long"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_DASH
#property indicator_width1  15
//--- plot Short
#property indicator_label2  "Short"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_DASH
#property indicator_width2  15
//--- indicator buffers
double         LongBuffer[];
double         ShortBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,LongBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ShortBuffer,INDICATOR_DATA);
   
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
//--- Long is Yellow (Down), Short is Red (UP)
//--- RED is UP, Yell is Down

    for(int i=7; i< rates_total; i++){
      if(close[i-6]<open[i-6] &&
         close[i-5]>open[i-5] &&
         close[i-4]>open[i-4] &&
         close[i-3]<open[i-3] &&
         close[i-2]>open[i-2] &&
         close[i-1]>open[i-1])
            ShortBuffer[i]=high[i];
      else if(
         close[i-6]>open[i-6] &&
         close[i-5]<open[i-5] &&
         close[i-4]<open[i-4] &&
         close[i-3]>open[i-3] &&
         close[i-2]<open[i-2] &&
         close[i-1]<open[i-1])
            LongBuffer[i]=low[i]; 
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
  
  
//+------------------------------------------------------------------+
/*if(
            close[i+6]  <  open[i+6]   &&
            close[i+5]  >  open[i+5]   &&
            close[i+4]  >  open[i+4]   &&
            close[i+3]  <  open[i+3]   &&
            close[i+2]  >  open[i+2]   &&
            close[i+1]  >  open[i+1]                
         )
           {
               LongBuffer[i] = high[i];
           }
         else if(
            close[i+6]  >  open[i+6]   &&
            close[i+5]  <  open[i+5]   &&
            close[i+4]  <  open[i+4]   &&
            close[i+3]  >  open[i+3]   &&
            close[i+2]  <  open[i+2]   &&
            close[i+1]  <  open[i+1]           
         )
           {
               ShortBuffer[i] = low[i]; 
           }
           */