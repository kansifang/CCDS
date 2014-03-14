/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.sql;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.SpecialTools;
import com.lmt.frameapp.ARE;

// Referenced classes of package com.amarsoft.Context.sql:
//            LSResultSet

public class Transaction
{

    public void setDataSourceName(String s)
    {
        sDataSourceName = s;
    }

    public String getDataSourceName()
    {
        return sDataSourceName;
    }

    public Transaction(Connection connection)
        throws Exception
    {
        LOG_EXECUTE = false;
        LOG_SELECT = false;
        dBeginTime = new Date();
        sDataSourceName = "";
        conn = connection;
        conn.setAutoCommit(false);
    }

    public Transaction(int i, Connection connection)
        throws Exception
    {
        LOG_EXECUTE = false;
        LOG_SELECT = false;
        dBeginTime = new Date();
        sDataSourceName = "";
        iChange = i;
        conn = connection;
        conn.setAutoCommit(false);
    }

    public ResultSet getResultSetOld(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        statement = null;
        resultset = null;
        try
        {
            setDebugTime();
            statement = conn.createStatement(iResultSetType, iResultSetConcurrency);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            resultset = null;
            throw exception;
        }
        DebugSQL(s);
        return resultset;
    }

    public ASResultSet getResultSet(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        if(iChange == 1 && s != null)
            s = new String(s.getBytes("GBK"), "ISO8859_1");
        if(iChange == 3 && s != null)
            s = new String(s.getBytes("ISO8859_1"), "GBK");
        s = SpecialTools.amarsoft2DB(s);
        statement = null;
        resultset = null;
        ASResultSet LSResultSet;
        try
        {
            setDebugTime();
            statement = conn.createStatement(iResultSetType, iResultSetConcurrency);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
            LSResultSet = new ASResultSet(iChange, resultset);
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return LSResultSet;
    }

    public ASResultSet getASResultSet(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        if(iChange == 1 && s != null)
            s = new String(s.getBytes("GBK"), "ISO8859_1");
        if(iChange == 3 && s != null)
            s = new String(s.getBytes("ISO8859_1"), "GBK");
        s = SpecialTools.amarsoft2DB(s);
        statement = null;
        resultset = null;
        ASResultSet LSResultSet;
        try
        {
            setDebugTime();
            statement = conn.createStatement(iResultSetType, iResultSetConcurrency);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
            LSResultSet = new ASResultSet(iChange, resultset);
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return LSResultSet;
    }

    public int executeSQL(String s)
        throws Exception
    {
        Statement statement;
        s = convertAmarStr2DBStr(s);
        statement = null;
        int j;
        try
        {
            setDebugTime();
            statement = conn.createStatement(iResultSetType, iResultSetConcurrency);
            int i = statement.executeUpdate(s);
            if(LOG_EXECUTE)
                log(s, "EXECUTE");
            statement.close();
            j = i;
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return j;
    }

    public int executeSQLWithoutLog(String s)
        throws Exception
    {
        Statement statement;
        s = convertAmarStr2DBStr(s);
        statement = null;
        int j;
        try
        {
            setDebugTime();
            statement = conn.createStatement(iResultSetType, iResultSetConcurrency);
            int i = statement.executeUpdate(s);
            statement.close();
            j = i;
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return j;
    }

    public ResultSet getResultSet2Old(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        statement = null;
        resultset = null;
        try
        {
            setDebugTime();
            statement = conn.createStatement(1003, 1008);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            resultset = null;
            throw exception;
        }
        DebugSQL(s);
        return resultset;
    }

    public ASResultSet getResultSet2(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        if(iChange == 1 && s != null)
            s = new String(s.getBytes("GBK"), "ISO8859_1");
        if(iChange == 3 && s != null)
            s = new String(s.getBytes("ISO8859_1"), "GBK");
        s = SpecialTools.amarsoft2DB(s);
        statement = null;
        resultset = null;
        ASResultSet LSResultSet;
        try
        {
            setDebugTime();
            statement = conn.createStatement(1003, 1008);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
            LSResultSet = new ASResultSet(iChange, resultset);
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return LSResultSet;
    }

    public ASResultSet getASResultSet2(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        if(iChange == 1 && s != null)
            s = new String(s.getBytes("GBK"), "ISO8859_1");
        if(iChange == 3 && s != null)
            s = new String(s.getBytes("ISO8859_1"), "GBK");
        s = SpecialTools.amarsoft2DB(s);
        statement = null;
        resultset = null;
        ASResultSet LSResultSet;
        try
        {
            setDebugTime();
            statement = conn.createStatement(1003, 1007);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
            LSResultSet = new ASResultSet(iChange, resultset);
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return LSResultSet;
    }

    public ASResultSet getASResultSetForUpdate(String s)
        throws Exception
    {
        Statement statement;
        ResultSet resultset;
        s = convertAmarStr2DBStr(s);
        statement = null;
        resultset = null;
        ASResultSet LSResultSet;
        try
        {
            setDebugTime();
            statement = conn.createStatement(1003, 1008);
            resultset = statement.executeQuery(s);
            if(LOG_SELECT)
                log(s, "SELECT");
            LSResultSet = new ASResultSet(iChange, resultset);
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(resultset != null)
                resultset.close();
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return LSResultSet;
    }

    public int executeSQL2(String s)
        throws Exception
    {
        Statement statement;
        s = convertAmarStr2DBStr(s);
        statement = null;
        int j;
        try
        {
            setDebugTime();
            statement = conn.createStatement(1003, 1008);
            int i = statement.executeUpdate(s);
            if(LOG_EXECUTE)
                log(s, "EXECUTE");
            statement.close();
            j = i;
        }
        catch(Exception exception)
        {
            ARE.getLog().error(exception.getMessage(), exception);
            if(statement != null)
                statement.close();
            throw exception;
        }
        DebugSQL(s);
        return j;
    }

    public String getString(String s)
        throws Exception
    {
        String s1 = null;
        ASResultSet LSResultSet = getASResultSet(s);
        if(LSResultSet.next())
            s1 = LSResultSet.getString(1);
        LSResultSet.getStatement().close();
        return s1;
    }

    public String[] getStringArray(String s)
        throws Exception
    {
        return getStringArray(s, 2000);
    }

    public String[] getStringArray(String s, int i)
        throws Exception
    {
        String as[][] = getStringMatrix(s, i, 1);
        String as1[] = new String[as.length];
        for(int j = 0; j < as.length; j++)
            as1[j] = as[j][0];

        return as1;
    }

    public String[][] getStringMatrix(String s)
        throws Exception
    {
        return getStringMatrix(s, 2000, 100);
    }

    public String[][] getStringMatrix(String s, int i, int j)
        throws Exception
    {
        String as[][] = new String[i][j];
        int k = 0;
        int l = 0;
        ASResultSet LSResultSet = getASResultSet2(s);
        l = LSResultSet.getColumnCount();
label0:
        do
        {
            if(LSResultSet.next() && ++k < i)
            {
                int i1 = 0;
                do
                {
                    if(i1 >= l)
                        continue label0;
                    if(i1 >= j)
                    {
                        l = j;
                        continue label0;
                    }
                    as[k - 1][i1] = LSResultSet.getString(i1 + 1);
                    i1++;
                } while(true);
            }
            LSResultSet.getStatement().close();
            String as1[][] = new String[k][l];
            for(int j1 = 0; j1 < k; j1++)
            {
                for(int k1 = 0; k1 < l; k1++)
                    as1[j1][k1] = as[j1][k1];

            }

            return as1;
        } while(true);
    }

    public void disConnect()
        throws Exception
    {
        conn.close();
    }

    public void finalize()
        throws Exception
    {
        disConnect();
    }

    public String convertAmarStr2DBStr(String s)
        throws Exception
    {
        if(iChange == 1 && s != null)
            s = new String(s.getBytes("GBK"), "ISO8859_1");
        if(iChange == 3 && s != null)
            s = new String(s.getBytes("ISO8859_1"), "GBK");
        s = SpecialTools.amarsoft2DB(s);
        String s1 = conn.getMetaData().getDatabaseProductName();
        if(s1 != null && s1.equalsIgnoreCase("Informix Dynamic Server"))
            s = SpecialTools.db2Informix(s);
        return s;
    }

    public Double getDouble(String s)
        throws Exception
    {
        Double double1 = null;
        ASResultSet LSResultSet = getASResultSet(s);
        if(LSResultSet.next())
            double1 = new Double(LSResultSet.getDouble(1));
        LSResultSet.getStatement().close();
        return double1;
    }

    private void setDebugTime()
    {
        if(iDebugMode == 1 || iDebugMode == 2)
            dBeginTime = new Date();
    }

    private void DebugSQL(String s)
    {
        if(iDebugMode == 1 || iDebugMode == 2)
        {
            Date date = new Date();
            double d = (double)(date.getTime() - dBeginTime.getTime()) / 1000D;
            if(d > WARNING_SQLTIME)
                ARE.getLog().warn("[SQL]" + sdf.format(dBeginTime) + " : " + d + " [" + s + "]");
            else
                ARE.getLog().debug("[SQL]" + sdf.format(dBeginTime) + " : " + d + " [" + s + "]");
        }
    }

    private void log(String s, String s1)
        throws Exception
    {
        Object obj = null;
    }

    public void setLogExecute(boolean flag)
    {
        LOG_EXECUTE = flag;
    }

    public void setLogSelect(boolean flag)
    {
        LOG_SELECT = flag;
    }

    public ASValuePool getValuePool(String s)
        throws Exception
    {
        ASValuePool LSValuePool = new ASValuePool();
        ASResultSet LSResultSet = getASResultSet(s);
        if(LSResultSet.next())
        {
            for(int i = 1; i < LSResultSet.iColumnCount + 1; i++)
            {
                String s1 = DataConvert.toString(LSResultSet.getColumnName(i)).toUpperCase();
                LSValuePool.setAttribute(s1, LSResultSet.getString(i));
            }

        }
        LSResultSet.getStatement().close();
        return LSValuePool;
    }

    public Vector getVector(String s)
        throws Exception
    {
        Vector vector = new Vector();
        ASResultSet LSResultSet;
        ASValuePool LSValuePool;
        for(LSResultSet = getASResultSet(s); LSResultSet.next(); vector.add(LSValuePool))
        {
            LSValuePool = new ASValuePool();
            for(int i = 1; i < LSResultSet.iColumnCount + 1; i++)
                LSValuePool.setAttribute(LSResultSet.getColumnName(i), LSResultSet.getString(i));

        }

        LSResultSet.getStatement().close();
        return vector;
    }

    public Vector getVector(String s, String s1, String s2, String s3, String s4, int i, int j)
        throws Exception
    {
        String s5 = conn.getMetaData().getDatabaseProductName();
        String s6 = "";
        if("mysql".equalsIgnoreCase(s5))
        {
            s6 = s6 + s + s1 + s2;
            s6 = s6 + s3 + s4;
            s6 = s6 + " limit " + i + "," + (j - i);
        } else
        {
            throw new Exception("\u6B64\u51FD\u6570\u76EE\u524D\u4E0D\u652F\u6301\u8FD9\u79CD\u6570\u636E\u5E93\uFF1A" + s5);
        }
        Vector vector = new Vector();
        ASResultSet LSResultSet;
        ASValuePool LSValuePool;
        for(LSResultSet = getASResultSet(s6); LSResultSet.next(); vector.add(LSValuePool))
        {
            LSValuePool = new ASValuePool();
            for(int k = 1; k < LSResultSet.iColumnCount + 1; k++)
                LSValuePool.setAttribute(LSResultSet.getColumnName(k), LSResultSet.getString(k));

        }

        LSResultSet.getStatement().close();
        return vector;
    }

    public static double getWarningSqlTime()
    {
        return WARNING_SQLTIME;
    }

    public static void setWarningSqlTime(double d)
    {
        WARNING_SQLTIME = d;
    }

    public Connection conn;
    public static int iChange = 0;
    public static int iDebugMode = 0;
    public static int iResultSetType = 1004;
    public static int iResultSetConcurrency = 1007;
    public static final int FETCH_FORWARD = 1000;
    public static final int FETCH_REVERSE = 1001;
    public static final int FETCH_UNKNOWN = 1002;
    public static final int TYPE_FORWARD_ONLY = 1003;
    public static final int TYPE_SCROLL_INSENSITIVE = 1004;
    public static final int TYPE_SCROLL_SENSITIVE = 1005;
    public static final int CONCUR_READ_ONLY = 1007;
    public static final int CONCUR_UPDATABLE = 1008;
    private static double WARNING_SQLTIME = 0.5D;
    private boolean LOG_EXECUTE;
    private boolean LOG_SELECT;
    private Date dBeginTime;
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
    private String sDataSourceName;

}


