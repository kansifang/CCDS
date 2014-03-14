/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.app.edoc;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class SaveEDoc extends Bizlet
{
	Log logger;
    public SaveEDoc()
    {
        logger = ARE.getLog();
    }
    public Object run(Transaction transaction) throws Exception {
        String s1;
        String s2;
        String as[];
        String s = (String)getAttribute("ReturnValue");
        if(s == null)
            s = "";
        s1 = (String)getAttribute("EDocNo");
        if(s1 == null)
            s1 = "";
        s2 = (String)getAttribute("EDocType");
        if(s2 == null)
            s2 = "";
        as = null;
        as = s.split("@");
        boolean ac=true;
        try{
        	   logger.debug("\u4FDD\u5B58\u7535\u5B50\u5408\u540C\u6A21\u677F\u5173\u8054\u4E1A\u52A1\u7C7B\u578B\u4E8B\u52A1\u5F00\u59CB...");
               ac=transaction.conn.getAutoCommit();
        	   transaction.conn.setAutoCommit(false);
               String s3 = "delete from EDOC_RELATIVE where EDocNo='" + s1 + "'";
               transaction.executeSQL(s3);
               for(int i = 1; i < as.length; i++){
                 String s5 = "select TypeNo from EDOC_RELATIVE where TypeNo='" + as[i] + "'";
                 ASResultSet asresultset = transaction.getASResultSet(s5);
                 String s6;
                 for(s6 = ""; asresultset.next(); s6 = asresultset.getString("TypeNo"));
                 if(s6 == null || s6.equals("")){
                     String s7 = "";
                     if(s2.equals("010"))
                         s7 = "insert into EDOC_RELATIVE(TypeNo,TypeName,EDocNo,IsInUse) values('" + as[i] + "',(select TypeName from Business_type where Typeno='" + as[i] + "'),'" + s1 + "','1')";
                     if(s2.equals("020"))
                         s7 = "insert into EDOC_RELATIVE(TypeNo,TypeName,EDocNo,IsInUse) values('" + as[i] + "',(select ItemName from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='" + as[i] + "'),'" + s1 + "','1')";
                     transaction.executeSQL(s7);
                 } else
                 {
                     String s8 = "update EDOC_RELATIVE set EDocNo='" + s1 + "' where TypeNo='" + s6 + "'";
                     transaction.executeSQL(s8);
                 }
             }
        	 transaction.conn.commit();
             transaction.conn.setAutoCommit(true);
        }catch(Exception exception){
        	  logger.debug("\u4FDD\u5B58\u7535\u5B50\u5408\u540C\u6A21\u677F\u5173\u8054\u4E1A\u52A1\u7C7B\u578B\u4E8B\u52A1\u7ED3\u675F...");
              logger.debug("\u5904\u7406\u4E8B\u52A1\u65F6\u53D1\u751F\u5F02\u5E38\uFF01");
              exception.printStackTrace();
              transaction.conn.setAutoCommit(ac);
              return "0";
        }
        return "1";
    }
}