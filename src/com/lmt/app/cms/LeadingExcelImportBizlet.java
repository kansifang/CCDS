package com.lmt.app.cms;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.Transaction;

public class LeadingExcelImportBizlet extends Bizlet
{
  public Object run(Transaction Sqlca)
    throws Exception
  {
    String Today = null; String OrgID = null; String UserID = null; String FilePath = null; String MSg = null; String FileName = null;

    Today = (String)getAttribute("sToday");
    OrgID = (String)getAttribute("sOrgID");
    UserID = (String)getAttribute("sUserID");
    FilePath = (String)getAttribute("sFileFullPath");
    MSg = Excel(Sqlca, FilePath, Today, OrgID, UserID);
    
    System.out.println("sFileFullPath:"+FilePath);
    
    return MSg;
  }

  private String Excel(Transaction Sqlca, String path, String Today, String OrgID, String UserID)
    throws Exception
  {
    LeadingExcelImport eImport = new LeadingExcelImport(Sqlca, path, Today, OrgID, UserID);
    return eImport.msg;
  }
  
  
//  public static void main(String[] args){
//	  
//	  File f = new File("E:/tomcat-6.0/webapps/CRMS_NEW/SystemManage/Upload/LeadingData.xls");
//	  
//	  System.out.print(f.exists());	  
//  }
  
}