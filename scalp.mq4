//+------------------------------------------------------------------+
//|                                                        Scalp.mq4 |
//|                                                    Graham Cleven |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Graham Cleven"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---

//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//---
   // plot 8, 21 EMA on H1
   double ema_21 = iMA("EURUSD", PERIOD_H1, 21, MODE_EMA, PRICE_CLOSE, 0);
   double ema_13; // will use this later on M5
   double ema_8 = iMA("EURUSD", PERIOD_H1, 8, MODE_EMA, PRICE_CLOSE, 0);

   // check direction of trade on anchor chart //

   // if ema_8 > ema_21, long
   bool direction;

   if (ema_8 > ema_21) {
      direction = 1; // long

      // confirm bars are on correct side of EMAs
      for (int i = 0; i < 5; i++) {
         if(iLow("EURUSD", PERIOD_H1, i) < ema_8) { // all bars should be above EMA 8
            return;
         }
      }

      // if ema_8 < ema_21, short
      if (ema_8 < ema_21) {
         direction = 0; // short

         // confirm bars are on correct side of EMAs
         for (int i = 0; i < 5; i++) {
            if(iHigh("EURUSD", PERIOD_H1, i) > ema_8) { // all bars should be under EMA 8
               return;
            }
         }
      }

      // determine if averages fan on M5 //

      // plot 21, 13, 8 EMAs on M5
      ema_21 = iMA("EURUSD", PERIOD_M5, 21, MODE_EMA, PRICE_CLOSE, 0);
      ema_13 = iMA("EURUSD", PERIOD_M5, 13, MODE_EMA, PRICE_CLOSE, 0);
      ema_8 = iMA("EURUSD", PERIOD_M5, 8, MODE_EMA, PRICE_CLOSE, 0);

      // check fan (21 > 13 > 8) on M5 if short
      if ((direction == 0) && (!ema_21 > ema_13 > ema_8)) {
         return;
      }

      // fan must be (21 < 13 < 8) on M5 if long
      if ((direction == 1) && (!ema_21 < ema_13 < ema_8)) {
         return;
      }

      // identify trigger bar //

      // find trigger bar short
      // if short, trigger bar (previous bar) high will touch or cross ema_8 but not close over ema_21
      if (direction == 0) {
         // high on previous bar must be >= ema_8
         if (!iHigh("EURUSD", PERIOD_M5, 1) >= ema_8) {
            return;
         }

         // close of previous bar must be < ema_21
         if (!iClose("EURUSD", PERIOD_M5, 1) < ema_21) {
            return;
         }

      }

      // find trigger bar long
      // if long, trigger bar (previous bar) low must be  =< ema_8 but not close under ema_21
      // check if close on previous bar is > ema_21
      if (direction == 1) {
         // high on previous bar must be >= ema_8
         if (!iLow("EURUSD", PERIOD_M5, 1) <= ema_8) {
            return;
         }

         // close of previous bar must be < ema_21
         if (!iClose("EURUSD", PERIOD_M5, 1) > ema_21) {
            return;
         }

      }

      // enter and exit conditions //

      // capture highest and lowest close from last 5 bars
      double high = 0.0;
      double low = 0.0;
      double close; // temp variable to compare and find highest and lowest close in 5 bar set
      
      // capture high and low (not close) from trigger bar
      double triggerHigh;
      double triggerLow;
      
      // initialze order params
      double enter;
      double sl;
      double tp1;
      double tp2;
      
      for (int i = 1; i < 6; i++) {
         close = iClose("EURUSD", PERIOD_M5, i);
         
         if (close > high) {
            high = close;
         }
         if (close < low) {
            low = close;
         }
      }
      
      // if long, enter 3 pips above high
      if (direction == 1) {
         enter = high + 3*Point;
      }
      
      // if short, enter 3 pips under low
      if (direction == 0) {
         enter = low - 3*Point;
      }

      // if long, set SL lowest close - 3P
      // enter trigger bar high + 3P
      // set TP 1 to abs(enter - SL)
      // set TP 2 to abs(enter - SL) * 2

      // if short, set SL highest close + 3P
      // enter trigger bar low - 3P
      // set TP 1 to abs(enter - SL)
      // set TP 2 to abs(enter -SL) * 2


   }

}

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
//---
   double ret=0.0;
//---

//---
   return(ret);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---

}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
