/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.sql;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.frameapp.lang.DataElement;
import com.lmt.frameapp.lang.StringX;

public class SqlObject
{

    public SqlObject(String sql)
        throws SQLException
    {
        parameters = null;
        parameterReference = null;
        if(sql == null)
        {
            throw new SQLException("[ASSQL]Null sql to building");
        } else
        {
            parameters = new LinkedHashMap();
            parameterReference = new TreeMap();
            setOriginalSql(sql);
            anaylseParameters();
            return;
        }
    }

    private void anaylseParameters()
        throws SQLException
    {
        String sql = StringX.trimAll(getOriginalSql()).replaceAll("\\s*,\\s*", ",").replaceAll("\\s+", " ");
        StringBuffer sb = new StringBuffer();
        Matcher m = paramPattern.matcher(sql);
        int paramPositon = 0;
        String p;
        for(; m.find(); addParameter(p, paramPositon))
        {
            paramPositon++;
            m.appendReplacement(sb, "?");
            p = m.group();
        }

        m.appendTail(sb);
        setRunSql(sb.toString());
        StringBuffer sbd = new StringBuffer();
        m = paramPattern.matcher(sql);
        paramPositon = 0;
        for(; m.find(); m.appendReplacement(sbd, (new StringBuilder()).append("\u3010\u203B").append(paramPositon).append("\u3011").toString()))
            paramPositon++;

        m.appendTail(sbd);
        setDebugSql(sbd.toString());
    }

    private void addParameter(String name, int position)
    {
        if(name == null || position < 1)
            return;
        String pName = getPrettyName(name);
        if(!parameters.containsKey(pName))
            parameters.put(pName, null);
        Integer p = new Integer(position);
        if(!parameterReference.containsKey(p))
            parameterReference.put(p, pName);
    }

    private void replaceDebugSql(int position, String value)
    {
        debugSql = debugSql.replaceFirst((new StringBuilder()).append("\u3010\u203B").append(position).append("\u3011").toString(), value);
    }

    public SqlObject setParameter(String name, int value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    public SqlObject setParameter(String name, long value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    public SqlObject setParameter(String name, double value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    public SqlObject setParameter(String name, String value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    public SqlObject setParameter(String name, Date value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    public SqlObject setParameter(String name, boolean value)
        throws SQLException
    {
        String pName = getPrettyName(name);
        if(pName != null)
            parameters.put(pName, DataElement.valueOf(name, value));
        return this;
    }

    private String getPrettyName(String s)
    {
        String param = null;
        if(s != null)
            param = StringX.trimAll(s).toUpperCase();
        if(param.startsWith("{$"))
            param = param.substring(2, param.length() - 1);
        else
        if(param.startsWith(":"))
            param = param.substring(1);
        return param;
    }

    public void bindParameter(PreparedStatement ps)
        throws SQLException
    {
        for(int i = 0; i < parameterReference.size(); i++)
        {
            String pk = (String)parameterReference.get(new Integer(i + 1));
            DataElement f = (DataElement)parameters.get(pk);
            if(f == null)
                throw new SQLException((new StringBuilder()).append("Query Parameters not set.").append(pk).toString());
            switch(f.getType())
            {
            case 1: // '\001'
                if(f.isNull())
                    ps.setNull(i + 1, 4);
                else
                    ps.setInt(i + 1, f.getInt());
                replaceDebugSql(i + 1, f.getString());
                break;

            case 2: // '\002'
                if(f.isNull())
                    ps.setNull(i + 1, -5);
                else
                    ps.setLong(i + 1, f.getLong());
                replaceDebugSql(i + 1, f.getString());
                break;

            case 4: // '\004'
                if(f.isNull())
                    ps.setNull(i + 1, 8);
                else
                    ps.setDouble(i + 1, f.getDouble());
                replaceDebugSql(i + 1, f.getString());
                break;

            case 8: // '\b'
                if(f.isNull())
                    ps.setNull(i + 1, -7);
                else
                    ps.setBoolean(i + 1, f.getBoolean());
                replaceDebugSql(i + 1, f.getString());
                break;

            case 16: // '\020'
                Date d = f.getDate();
                if(f.isNull() || d == null)
                {
                    ps.setNull(i + 1, 93);
                } else
                {
                    Timestamp sqlts = new Timestamp(d.getTime());
                    ps.setObject(i + 1, sqlts);
                    replaceDebugSql(i + 1, (new StringBuilder()).append("'").append(f.getString()).append("'").toString());
                }
                break;

            default:
                if(f.isNull())
                    ps.setNull(i + 1, 12);
                else
                    ps.setString(i + 1, f.getString());
                replaceDebugSql(i + 1, (new StringBuilder()).append("'").append(f.getString()).append("'").toString());
                break;
            }
        }

    }

    public String getOriginalSql()
    {
        return originalSql;
    }

    public void setOriginalSql(String originalSql)
    {
        this.originalSql = originalSql;
    }

    public String getRunSql()
    {
        return runSql;
    }

    public void setRunSql(String runSql)
    {
        this.runSql = runSql;
    }

    public void setDebugSql(String debugSql)
    {
        this.debugSql = debugSql;
    }

    public String getDebugSql()
    {
        return debugSql;
    }

    private static Pattern paramPattern = Pattern.compile("(\\:\\w+)|(\\{\\$\\w+\\})");
    private String originalSql;
    private String runSql;
    private String debugSql;
    private Map parameters;
    private Map parameterReference;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 182 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/