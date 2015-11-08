import "ecere"

struct Model
{                 
    String Text;   
    double Value;  
};                    

class Form1 : Window
{
   caption = "派诺特 - 阻垢剂计算器";
   background = activeBorder;
   borderStyle = sizable;
   hasMinimize = true;
   hasClose = true;
   size = { 632, 626 };
   anchor = { horz = -175, vert = 2 };
   icon = { "icon.png" };

   Label label1 { this, caption = "型号", position = { 24, 24 } };
   Label label3 { this, caption = "总硬度", position = { 336, 24 } };
   Label label4 { this, caption = "SDI", position = { 24, 64 } };
   Label label5 { this, caption = "浊度", position = { 336, 64 } };
   Label label6 { this, caption = "PH", position = { 24, 104 } };
   Label label7 { this, caption = "COD", position = { 336, 104 } };
   Label label2 { this, caption = "钙 (Ca2+)", position = { 24, 144 } };
   Label label8 { this, caption = "碳酸根 (CO32-)", position = { 336, 144 } };
   Label label9 { this, caption = "镁 (Mg2+)", position = { 24, 184 } };
   Label label10 { this, caption = "重碳酸盐 (HCO3-)", position = { 336, 184 } };
   Label label11 { this, caption = "钠 (Na+)", position = { 24, 224 } };
   Label label12 { this, caption = "硫酸盐 (SO42-)", position = { 336, 224 } };
   Label label13 { this, caption = "钾 (K+)", position = { 24, 264 } };
   Label label14 { this, caption = "余氯 (Cl2)", position = { 336, 264 } };
   Label label15 { this, caption = "钡 (Ba2+)", position = { 24, 304 } };
   Label label16 { this, caption = "氯化物 (Cl-)", position = { 336, 304 } };
   Label label17 { this, caption = "锶 (Sr2+)", position = { 24, 344 } };
   Label label18 { this, caption = "氟化物 (F-)", position = { 336, 344 } };
   Label label19 { this, caption = "铁 (Fe)", position = { 24, 384 } };
   Label label20 { this, caption = "硝酸盐 (NO3-)", position = { 336, 384 } };
   Label label21 { this, caption = "铝 (Al3+)", position = { 24, 424 } };
   Label label22 { this, caption = "硅 (SiO2)", position = { 336, 424 } };
   Label label23 { this, caption = "锰 (Mn4+)", position = { 24, 464 } };
   Label label24 { this, caption = "氨根 (NH4+)", position = { 24, 504 } };
   DropBox dropBox1 { this, caption = "dropBoxModel", size = { 104, 24 }, position = { 80, 20 } };
   EditBox editBox_zyd { this, caption = "editBox1", contents = "0", size = { 102, 19 }, position = { 400, 20 } };
   EditBox editBox_SDI { this, caption = "editBox1", contents = "0", size = { 102, 19 }, position = { 80, 60 } };
   EditBox editBox_dd { this, caption = "editBox3", contents = "0", size = { 102, 19 }, position = { 400, 60 } };
   EditBox editBox_PH { this, caption = "editBox4", contents = "0", size = { 102, 19 }, position = { 80, 100 } };
   EditBox editBox_COD { this, caption = "editBox5", contents = "0", size = { 102, 19 }, position = { 400, 100 } };
   EditBox editBox_ca { this, caption = "editBox1", contents = "0", size = { 102, 19 }, position = { 96, 140 } };
   EditBox editBox_co3 { this, caption = "editBox2", contents = "0", size = { 102, 19 }, position = { 440, 140 } };
   EditBox editBox_mg { this, caption = "editBox3", contents = "0", size = { 102, 19 }, position = { 96, 180 } };
   EditBox editBox_hco { this, caption = "editBox4", contents = "0", size = { 102, 19 }, position = { 440, 180 } };
   EditBox editBox_na { this, caption = "editBox5", contents = "0", size = { 102, 19 }, position = { 96, 220 } };
   EditBox editBox_so4 { this, caption = "editBox6", contents = "0", size = { 102, 19 }, position = { 440, 220 } };
   EditBox editBox_k { this, caption = "editBox7", contents = "0", size = { 102, 19 }, position = { 96, 260 } };
   EditBox editBox_cl { this, caption = "editBox8", contents = "0", size = { 102, 19 }, position = { 440, 260 } };
   EditBox editBox_ba { this, caption = "editBox9", contents = "0", size = { 102, 19 }, position = { 96, 300 }; };
   EditBox editBox_cl02 { this, caption = "editBox10", contents = "0", size = { 102, 19 }, position = { 440, 300 } };
   EditBox editBox_sr { this, caption = "editBox11", contents = "0", size = { 102, 19 }, position = { 96, 340 } };
   EditBox editBox_f { this, caption = "editBox12", contents = "0", size = { 102, 19 }, position = { 440, 340 } };
   EditBox editBox_fe { this, caption = "editBox13", contents = "0", size = { 102, 19 }, position = { 96, 380 } };
   EditBox editBox_no3 { this, caption = "editBox14", contents = "0", size = { 102, 19 }, position = { 440, 380 } };
   EditBox editBox_al { this, caption = "editBox15", contents = "0", size = { 102, 19 }, position = { 96, 420 } };
   EditBox editBox_sio { this, caption = "editBox18", contents = "0", size = { 102, 19 }, position = { 440, 420 } };
   EditBox editBox_mn { this, caption = "editBox16", contents = "0", size = { 102, 19 }, position = { 96, 460 } };
   EditBox editBox_nh { this, caption = "editBox17", contents = "0", size = { 102, 19 }, position = { 96, 500 } };
   Label labelResult { this, size = { 428, 13 }, position = { 152, 554 } };
   DataField df { class(String) };
   Button button1
   {
      this, caption = "计算", clientSize = { 90, 23 }, position = { 48, 550 };

      bool NotifyClicked(Button button, int x, int y, Modifiers mods)
      { 
         double total = calculate();
         char result[100]; 
         sprintf(result, "投药量为: %f mg/L", total );
         labelResult.text = result;
         return true;
      }
   };

   Form1()
   {
      dropBox1.AddField(df);
      dropBox1.AddRow().SetData(df, "PNT210" );
      dropBox1.AddRow().SetData(df, "PNT220" );   
      dropBox1.AddRow().SetData(df, "PNT240" );   
      dropBox1.AddRow().SetData(df, "PNT250" );  
      dropBox1.SelectRow(dropBox1.firstRow);
   }

   double getValue(EditBox editBox)
   {
      char* text = editBox.contents;
      return atof(text);
   }

   double getModel()
   {
      int rowIndex = dropBox1.currentRow.index;
      switch(rowIndex)
      {
         case 0:
            return 200;
         case 1:
            return 400;
         case 2:
            return 300;
         case 3:
            return 200;
         default:
            return 200;
      }
   }

   double calculate()
   {
         double model = getModel();
         double zyd = getValue(editBox_zyd);
         double SDI = getValue(editBox_SDI);
         double dd = getValue(editBox_dd);
         double PH = getValue(editBox_PH);
         double COD = getValue(editBox_COD);
         double ca = getValue(editBox_ca);
         double co3 = getValue(editBox_co3);
         double mg = getValue(editBox_mg);
         double hco = getValue(editBox_hco);
         double na = getValue(editBox_na);
         double so4 = getValue(editBox_so4);
         double k = getValue(editBox_k);
         double cl = getValue(editBox_cl);
         double ba = getValue(editBox_ba);
         double cl02 = getValue(editBox_cl02);
         double sr = getValue(editBox_sr);
         double f = getValue(editBox_f);
         double fe = getValue(editBox_fe);
         double no3 = getValue(editBox_no3);
         double al = getValue(editBox_al);
         double sio = getValue(editBox_sio);
         double mn = getValue(editBox_mn);
         double nh = getValue(editBox_nh);

         double item1 = zyd / model;
         double item2 = SDI / 10 + dd / 10 + PH / 100 + COD / 100;
         double item3 = ca / 100 + mg / 100 + na / 2000 + k / 100 + ba / 100 + sr / 100 + fe / 10 + al / 100 + mn / 100 + nh / 100;
         double item4 = co3 / 1000 + hco / 1000 + so4 / 1000 + cl / 50 + cl02 / 1000 + f / 50 + no3 / 50 + sio / 50;

         if (item1 > 4) { item1 = 4; }
         if (item2 > 2) { item2 = 2; }
         if (item3 > 1) { item3 = 1; }
         if (item4 > 1) { item4 = 1; }  

         return item1 + item2 + item3 + item4;                           
   }
}

Form1 form1 {};
