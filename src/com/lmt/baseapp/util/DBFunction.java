/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.util;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.Context.sql:
//            ConnectionManager, Transaction, LSResultSet

public class DBFunction
{
    public static String sDataSource = "";
    public DBFunction()
    {
    }

    public static String getSerialNo(String s, String s1, Transaction transaction)
        throws Exception
    {
        return getSerialNo(s, s1, "yyyyMMdd", "000000", new Date(), transaction);
    }

    public static String getSerialNo(String s, String s1, String s2, Transaction transaction)
        throws Exception
    {
        if(s2 == null || s2.equals(""))
            s2 = "";
        else
            s2 = "'" + s2 + "'";
        return getSerialNo(s, s1, s2 + "yyyyMMdd", "000000", new Date(), transaction);
    }

    private static boolean containsProductName(String s, String s1)
    {
        return s.indexOf(s1) != -1;
    }

    public static String getSerialNo(String s, String s1, String s2, String s3, Date date, Transaction transaction)
        throws Exception
    {
        Transaction transaction1;
        DecimalFormat decimalformat;
        String s4;
        int j;
        transaction1 = null;
        try
        {
            javax.sql.DataSource datasource = ConnectionManager.getDataSource(sDataSource);
            transaction1 = ConnectionManager.getTransaction(datasource);
        }
        catch(Exception exception)
        {
            throw new Exception("getSerialNo...\u5931\u8D25\uFF01" + exception.getMessage());
        }
        boolean flag = false;
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s2);
        decimalformat = new DecimalFormat(s3);
        s4 = simpledateformat.format(date);
        j = s4.length();
        String s5 = "";
        s = s.toUpperCase();
        s1 = s1.toUpperCase();
        transaction1.conn.setAutoCommit(false);
        String s6;
        try
        {
            String s7 = "update OBJECT_MAXSN set MaxSerialNo =MaxSerialNo  where TableName='" + s + "' and ColumnName='" + s1 + "' ";
            transaction1.executeSQL(s7);
            String s8 = "select MaxSerialNo from OBJECT_MAXSN  where TableName='" + s + "' and ColumnName='" + s1 + "' ";
            ASResultSet LSResultSet = transaction1.getResultSet(s8);
            if(LSResultSet.next())
            {
                String s9 = LSResultSet.getString(1);
                LSResultSet.getStatement().close();
                boolean flag1 = false;
                if(s9 != null && s9.indexOf(s4, 0) != -1)
                {
                    int i = Integer.valueOf(s9.substring(j)).intValue();
                    s6 = s4 + decimalformat.format(i + 1);
                } else
                {
                    s6 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                }
                String s11 = "update OBJECT_MAXSN set MaxSerialNo ='" + s6 + "' " + " where TableName='" + s + "' and ColumnName='" + s1 + "' ";
                transaction1.executeSQL(s11);
            } else
            {
                LSResultSet.getStatement().close();
                s6 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                String s10 = "insert into OBJECT_MAXSN (tablename,columnname,maxserialno)  values( '" + s + "','" + s1 + "','" + s6 + "')";
                transaction1.executeSQL(s10);
            }
            transaction1.conn.commit();
        }catch(Exception exception1){
            transaction1.conn.rollback();
            throw new Exception("getSerialNo...\u5931\u8D25\uFF01" + exception1.getMessage());
        }finally{
        	transaction1.disConnect();
        }
        return s6;
    }

    public static String getSerialNoXD(String s, String s1, String s2, String s3, Date date, Transaction transaction)
        throws Exception
    {
        Transaction transaction1;
        DecimalFormat decimalformat;
        String s8;
        int j;
        transaction1 = null;
        try
        {
            String s4 = "XD";
            String s5 = "";
            String s6 = "";
            String s7 = "";
            String s9 = "";
            String s10 = "";
            String s13 = "";
            String s15 = "";
            String s16 = "";
            ResourceBundle resourcebundle = ResourceBundle.getBundle("config", Locale.CHINA);
            s7 = resourcebundle.getString(s4 + "DBType");
            s9 = resourcebundle.getString(s4 + "HostIP");
            int k = Integer.parseInt(resourcebundle.getString(s4 + "Service"));
            s10 = resourcebundle.getString(s4 + "Server");
            s13 = resourcebundle.getString(s4 + "DBName");
            s15 = resourcebundle.getString(s4 + "UserID");
            s16 = resourcebundle.getString(s4 + "UserPassword");
            if(s7.toLowerCase().equals("informix"))
            {
                s6 = "jdbc:informix-sqli://" + s9 + ":" + k + "/" + s13 + ":informixserver=" + s10;
                s5 = "com.informix.jdbc.IfxDriver";
            }
            if(s7.toLowerCase().equals("oracle"))
            {
                s6 = "jdbc:oracle:thin:@" + s9 + ":" + k + ":" + s13;
                s5 = "oracle.jdbc.driver.OracleDriver";
            }
            if(s7.toLowerCase().equals("sybase"))
            {
                s6 = "jdbc:sybase:Tds:" + s9 + ":" + k + "/" + s13;
                s5 = "com.sybase.jdbc2.jdbc.SybDriver";
            }
            transaction1 = ConnectionManager.getTransaction(s6, s5, s15, s16);
        }
        catch(Exception exception)
        {
            throw new Exception("getSerialNo...\u5931\u8D25\uFF01" + exception.getMessage());
        }
        transaction1.conn.setAutoCommit(false);
        boolean flag = false;
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s2);
        decimalformat = new DecimalFormat(s3);
        s8 = simpledateformat.format(date);
        j = s8.length();
        String s11 = "";
        s = s.toUpperCase();
        s1 = s1.toUpperCase();
        String s12;
        try
        {
            String s14 = "select MaxSerialNo from OBJECT_MAXSN  where TableName='" + s + "' and ColumnName='" + s1 + "' " + " for update ";
            if(containsProductName(transaction1.conn.getMetaData().getDatabaseProductName().toUpperCase(), "ADAPTIVE SERVER ENTERPRISE"))
                s14 = "select MaxSerialNo from OBJECT_MAXSN holdlock  where TableName='" + s + "' and ColumnName='" + s1 + "' ";
            ASResultSet LSResultSet = transaction1.getResultSet(s14);
            if(LSResultSet.next())
            {
                String s17 = LSResultSet.getString(1);
                LSResultSet.getStatement().close();
                boolean flag1 = false;
                if(s17 != null && s17.indexOf(s8, 0) != -1)
                {
                    int i = Integer.valueOf(s17.substring(j)).intValue();
                    s12 = s8 + decimalformat.format(i + 1);
                } else
                {
                    s12 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                }
                String s19 = "update OBJECT_MAXSN set MaxSerialNo ='" + s12 + "' " + " where TableName='" + s + "' and ColumnName='" + s1 + "' ";
                transaction1.executeSQL(s19);
            } else
            {
                LSResultSet.getStatement().close();
                s12 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                String s18 = "insert into OBJECT_MAXSN (tablename,columnname,maxserialno)  values( '" + s + "','" + s1 + "','" + s12 + "')";
                transaction1.executeSQL(s18);
            }
            transaction1.conn.commit();
        }
        catch(Exception exception1)
        {
            transaction1.conn.rollback();
            throw new Exception("getSerialNo...\u5931\u8D25\uFF01" + exception1.getMessage());
        }finally{
        	 transaction1.disConnect();
        }
        return s12;
    }

    public static String getSerialNoFromDB(String s, String s1, String s2, String s3, String s4, Date date, Transaction transaction)
        throws Exception
    {
        ARE.getLog().warn("****\u4E0D\u5EFA\u8BAE\u7684\u53D6\u6D41\u6C34\u53F7\u7684\u65B9\u5F0F(getSerialNoFromDB)****[" + s + "][" + s1 + "]******");
        int j = 0;
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s3);
        DecimalFormat decimalformat = new DecimalFormat(s4);
        String s7 = simpledateformat.format(date);
        int i = s7.length();
        String s5 = "select max(" + s1 + ") from " + s + " where " + s1 + " like '" + s7 + "%' ";
        if(s2.length() > 0)
            s5 = s5 + " and " + s2;
        ASResultSet LSResultSet = transaction.getResultSet(s5);
        if(LSResultSet.next())
        {
            String s6 = LSResultSet.getString(1);
            if(s6 != null)
                j = Integer.valueOf(s6.substring(i)).intValue();
        }
        String s8 = s7 + decimalformat.format(j + 1);
        LSResultSet.getStatement().close();
        ARE.getLog().info("..." + s8 + "...");
        return s8;
    }

    public static String getSerialNo(String s, String s1, String s2, String s3, String s4, Date date, Transaction transaction)
        throws Exception
    {
        return getSerialNo(s, s1, s3, s4, date, transaction);
    }

    public static void main(String args[])
    {
        try
        {
            String s = getSerialNo("BUSINESS_WASTEBOOK", "SERIALNO", "yyyyMMdd", "00000000", new Date(), null);
            ARE.getLog().info("SerialNo=" + s);
        }
        catch(Exception exception)
        {
            ARE.getLog().error("main error!", exception);
        }
    }

    public static String getSerialNo_for_alarm(String s, String s1, String s2, String s3, String s4, Date date, Transaction transaction)
        throws Exception
    {
        return getSerialNo_for_alarm(s, s1, s3, s4, date, transaction);
    }

    public static String getSerialNo_for_alarm(String s, String s1, String s2, String s3, Date date, Transaction transaction)
        throws Exception
    {
        Transaction transaction1;
        DecimalFormat decimalformat;
        String s4;
        int j;
        transaction1 = null;
        transaction1 = transaction;
        boolean flag = false;
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s2);
        decimalformat = new DecimalFormat(s3);
        s4 = simpledateformat.format(date);
        j = s4.length();
        String s5 = "";
        s = s.toUpperCase();
        s1 = s1.toUpperCase();
        transaction1.conn.setAutoCommit(false);
        String s6;
        try
        {
            String s7 = "update OBJECT_MAXSN set MaxSerialNo =MaxSerialNo  where TableName='" + s + "' and ColumnName='" + s1 + "' ";
            transaction1.executeSQL(s7);
            String s8 = "select MaxSerialNo from OBJECT_MAXSN  where TableName='" + s + "' and ColumnName='" + s1 + "' ";
            ASResultSet LSResultSet = transaction1.getResultSet(s8);
            if(LSResultSet.next())
            {
                String s9 = LSResultSet.getString(1);
                LSResultSet.getStatement().close();
                boolean flag1 = false;
                if(s9 != null && s9.indexOf(s4, 0) != -1)
                {
                    int i = Integer.valueOf(s9.substring(j)).intValue();
                    s6 = s4 + decimalformat.format(i + 1);
                } else
                {
                    s6 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                }
                String s11 = "update OBJECT_MAXSN set MaxSerialNo ='" + s6 + "' " + " where TableName='" + s + "' and ColumnName='" + s1 + "' ";
                transaction1.executeSQL(s11);
            } else
            {
                LSResultSet.getStatement().close();
                s6 = getSerialNoFromDB(s, s1, "", s2, s3, date, transaction1);
                String s10 = "insert into OBJECT_MAXSN (tablename,columnname,maxserialno)  values( '" + s + "','" + s1 + "','" + s6 + "')";
                transaction1.executeSQL(s10);
            }
            transaction1.conn.commit();
        }
        catch(Exception exception)
        {
            transaction1.conn.rollback();
            throw new Exception("getSerialNo...\u5931\u8D25\uFF01" + exception.getMessage());
        }
        return s6;
    }

}