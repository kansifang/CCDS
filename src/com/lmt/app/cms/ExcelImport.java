package com.lmt.app.cms;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import jxl.Sheet;
import jxl.Workbook;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ExcelImport
{
  public String msg = "";

  public ExcelImport(Transaction Sqlca, String path, String Today, String OrgID, String UserID)
  {
    try
    {
      int Columnscount = 0;
      int Rowscount = 0;
      int RealRows = 0;
      int RealColumns = 0;
      int length = 0;
      String sSql = "";
      String IndustryTypeName = "";
      String sIndustrytype = "";
      String sSerialNo = "";
      String sItemCode = "";

      InputStream is = new FileInputStream(new File(path));

      Workbook workbook = Workbook.getWorkbook(is);

      int count = workbook.getSheets().length;

      for (int i = 0; i < count; ++i)
      {
        String temp;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMddhhmmss");
        StringBuffer s5 = new StringBuffer(
          format.format(new Date()));
        int countNo = 0;

        Sheet sheet = workbook.getSheet(i);
        Columnscount = sheet.getColumns();

        Rowscount = sheet.getRows();

        for (RealColumns = 0; RealColumns < Columnscount; ++RealColumns) {
          temp = sheet.getCell(RealColumns, 1).getContents
            ().trim();

          if (temp.equals("")) break; if (temp == null) {
            break;
          }

        }

        for (RealRows = 0; RealRows < Rowscount; ++RealRows) {
          temp = sheet.getCell(0, RealRows).getContents().trim
            ();
          if (temp.equals("")) break; if (temp == null)
            break;

        }

        if ((RealColumns == 0) || (RealRows == 0))
        {
          is.close();
          workbook.close();
          throw new Exception("gs");
        }
        String dCol1ValueName = sheet.getCell(1, 1).getContents().trim();
        String dCol2ValueName = sheet.getCell(2, 1).getContents().trim();
        String dCol3ValueName = sheet.getCell(3, 1).getContents().trim();
        String dCol4ValueName = sheet.getCell(4, 1).getContents().trim();
        String dCol5ValueName = sheet.getCell(5, 1).getContents().trim();
        if ((!(dCol1ValueName.equals("优秀值"))) || (!(dCol2ValueName.equals("良好值"))) || (!(dCol3ValueName.equals("平均值"))) || (!(dCol4ValueName.equals("较低值"))) || (!(dCol5ValueName.equals("较差值"))))
        {
          is.close();
          workbook.close();
          throw new Exception("gs");
        }

        IndustryTypeName = sheet.getCell(0, 1).getContents().trim
          ();

        sSql = "select itemno from code_library  where codeno='GzwIndustryCode' and itemname like '%" + 
          IndustryTypeName + "%'";
        ASResultSet rs1 = Sqlca.getASResultSet(sSql);
        while (rs1.next()) {
          sIndustrytype = rs1.getString(1);
        }

        String sizeString = "";
        int iSize = 0;
        String timeString = "";

        for (int j = 1; j < RealColumns; j += 5) {
          String SizeTime = sheet.getCell(j, 0).getContents().trim
            ();
          for (int x = 2; x < RealRows; ++x)
          {
            //if ((x != 9) && (x != 15) && (x != 22)) { 
            //	if (x == 28)
            //    continue;

              ++countNo;

              int length2 = String.valueOf(countNo).length();
              StringBuffer sStringBuffer = new StringBuffer();
              if (length2 < 18)
              {
                for (int n = 0; n < 18 - length2; ++n)
                {
                  sStringBuffer.append("0");
                }
              }
              sSerialNo = s5 + 
                sStringBuffer.append(countNo).toString();

              //生成对应的ItemCode
              StringBuffer itemCode = new StringBuffer();
              
              if(x-1<10){
            	  sItemCode = itemCode.append("0").append(x-1).toString();
              }else{
            	  sItemCode = String.valueOf(x - 1);
              }
              String dCol1Value = sheet.getCell(j, x).getContents();
              String dCol2Value = sheet.getCell(j + 1, x).getContents();
              String dCol3Value = sheet.getCell(j + 2, x).getContents();
              String dCol4Value = sheet.getCell(j + 3, x).getContents();
              String dCol5Value = sheet.getCell(j + 4, x).getContents();

              length = SizeTime.length();

              sizeString = SizeTime.substring(0, length - 7);
              if (sizeString.equals("全行业"))
                iSize = 1;
              else if (sizeString.equals("大型企业"))
                iSize = 2;
              else if (sizeString.equals("中型企业")) {
                iSize = 3;
              }
              else
                iSize = 4;

              timeString = SizeTime.substring(length - 6, 
                length - 1);

              sSql = "select serialno from GZW_DATA where reportdate='" + 
                timeString + 
                "' and  industrytype='" + 
                sIndustrytype + 
                "' and  scope='" + 
                iSize + 
                "' and  itemcode='" + sItemCode + "'";
              ASResultSet rs2 = Sqlca.getASResultSet(sSql);

              while (rs2.next()) {
                sSerialNo = rs2.getString(1);
              }

              rs2.getStatement().close();
              if (Sqlca.executeSQL(sSql) == 0)
              {
                sSql = "insert into GZW_DATA  (serialno, industrytype, reportdate, scope, itemcode,itemvalue1,itemvalue2,itemvalue3,itemvalue4,itemvalue5,inputdate,orgid,userid) VALUES ('" + 
                  sSerialNo + 
                  "','" + 
                  sIndustrytype + 
                  "','" + 
                  timeString + 
                  "','" + 
                  iSize + 
                  "','" + 
                  sItemCode + 
                  "','" + 
                  dCol1Value + 
                  "','" + 
                  dCol2Value + 
                  "','" + 
                  dCol3Value + 
                  "','" + 
                  dCol4Value + 
                  "','" + 
                  dCol5Value + 
                  "','" + 
                  Today + 
                  "','" + 
                  OrgID + 
                  "','" + 
                  UserID + "')";
                Sqlca.executeSQL(sSql);
              } else {
                sSql = "update  GZW_DATA  set  itemvalue1='" + 
                  dCol1Value + "',itemvalue2='" + 
                  dCol2Value + "',itemvalue3='" + 
                  dCol3Value + "',itemvalue4='" + 
                  dCol4Value + "',itemvalue5='" + 
                  dCol5Value + "',updatedate='" + Today + 
                  "',orgid='" + OrgID + "',userid='" + 
                  UserID + "' where serialno='" + 
                  sSerialNo + "'";
                Sqlca.executeSQL(sSql);
              }
            }
          }
        //}

      }

      is.close();
      workbook.close();
      this.msg = "导入成功";
    }
    catch (Exception e)
    {
      if (e.getMessage() == "gs") {
        this.msg = "导入格式错误";
      }
      else {
        e.printStackTrace();

        this.msg = "导入失败";
      }
    }
  }
}