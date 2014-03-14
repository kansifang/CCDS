package com.lmt.frameapp.sql;

import com.lmt.baseapp.util.SpecialTools;
import com.lmt.baseapp.util.StringFunction;

import java.io.InputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;

public class ASResultSet
{
  public ResultSet rs;
  public int iColumnCount;
  public int iRowCount;
  public ResultSetMetaData rsmd;
  public int iChange;

  public ASResultSet(ResultSet paramResultSet)
    throws Exception
  {
    this.rs = paramResultSet;
    this.rsmd = paramResultSet.getMetaData();
    this.iColumnCount = this.rsmd.getColumnCount();
    this.iChange = 0;
  }

  public ASResultSet(int paramInt, ResultSet paramResultSet)
    throws Exception
  {
    this.rs = paramResultSet;
    this.rsmd = paramResultSet.getMetaData();
    this.iColumnCount = this.rsmd.getColumnCount();
    this.iChange = paramInt;
  }

  public void close()
    throws Exception
  {
    this.rs.getStatement().close();
  }

  public Statement getStatement()
    throws Exception
  {
    return this.rs.getStatement();
  }

  public int getColumnCount()
    throws Exception
  {
    return this.iColumnCount;
  }

  public int getRowCount()
    throws Exception
  {
    int i = this.rs.getRow();
    this.rs.last();
    this.iRowCount = this.rs.getRow();
    if (i <= 0)
      this.rs.beforeFirst();
    else
      this.rs.absolute(i);
    return this.iRowCount;
  }

  public String getColumnName(int paramInt)
    throws Exception
  {
    return this.rsmd.getColumnName(paramInt);
  }

  public int getColumnIndex(String paramString)
    throws Exception
  {
	int i=1;
    for (; (i <= this.iColumnCount) && (!paramString.equals(this.rsmd.getColumnName(i))); i++);
    if (i > this.iColumnCount)
      i = 0;
    return i;
  }

  public int getColumnType(int paramInt)
    throws Exception
  {
    return this.rsmd.getColumnType(paramInt);
  }

  public String getColumnTypeName(int paramInt)
    throws Exception
  {
    return this.rsmd.getColumnTypeName(paramInt);
  }

  public void beforeFirst()
    throws Exception
  {
    this.rs.beforeFirst();
  }

  public boolean first()
    throws Exception
  {
    return this.rs.first();
  }

  public boolean last()
    throws Exception
  {
    return this.rs.last();
  }

  public boolean next()
    throws Exception
  {
    return this.rs.next();
  }

  public int getRow()
    throws Exception
  {
    return this.rs.getRow();
  }

  public boolean wasNull()
    throws Exception
  {
    return this.rs.wasNull();
  }

  public String getStringValue(String paramString)
    throws Exception
  {
    return getStringValue(getColumnIndex(paramString));
  }

  public String getStringValue(int paramInt)
    throws Exception
  {
    String str = "";
    int i = this.rsmd.getColumnType(paramInt);
    if ((i == -7) || (i == -6) || (i == 5) || (i == 4) || (i == -5))
    {
      str = String.valueOf(this.rs.getLong(paramInt));
    }
    else if ((i == 6) || (i == 7) || (i == 8) || (i == 3) || (i == 2))
    {
      double d = this.rs.getDouble(paramInt);
      if (this.rs.wasNull())
        str = "";
      else
        str = String.valueOf(d);
    }
    else if ((i == 1) || (i == 12) || (i == -1))
    {
      str = this.rs.getString(paramInt);
      str = StringFunction.rtrim(str);
      if ((this.iChange == 1) && (str != null))
        try
        {
          str = new String(str.getBytes("ISO8859_1"), "GBK");
        }
        catch (UnsupportedEncodingException localUnsupportedEncodingException1)
        {
          throw new SQLException("UnsupportedEncodingException");
        }
      else if ((this.iChange == 3) && (str != null))
        try
        {
          str = new String(str.getBytes("GBK"), "ISO8859_1");
        }
        catch (UnsupportedEncodingException localUnsupportedEncodingException2)
        {
          throw new SQLException("UnsupportedEncodingException");
        }
      else if ((this.iChange == 11) && (str != null))
        try
        {
          str = new String(str.getBytes(), "UTF-8");
        }
        catch (UnsupportedEncodingException localUnsupportedEncodingException3)
        {
          throw new SQLException("UnsupportedEncodingException");
        }
    }
    else if (i == 91)
    {
      str = this.rs.getDate(paramInt).toString();
    }
    else if (i == 92)
    {
      str = this.rs.getTime(paramInt).toString();
    }
    else if (i == 93)
    {
      str = this.rs.getTimestamp(paramInt).toString();
    }
    if (this.rs.wasNull())
      str = "";
    return str;
  }

  public String getString(int paramInt)
    throws Exception
  {
    String str1 = this.rs.getString(paramInt);
    str1 = StringFunction.rtrim(str1);
    String str2 = getStatement().getConnection().getMetaData().getDatabaseProductName();
    if ((str2 != null) && (str2.equalsIgnoreCase("Informix Dynamic Server")))
      str1 = SpecialTools.informix2DB(str1);
    if ((str1 != null) && (str1.equals(" ")))
      return "";
    if ((this.iChange == 1) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes("ISO8859_1"), "GBK");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException1)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    if ((this.iChange == 3) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes("GBK"), "ISO8859_1");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException2)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    if ((this.iChange == 11) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes(), "UTF-8");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException3)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    return str1;
  }

  public String getString(String paramString)
    throws Exception
  {
    String str1 = this.rs.getString(paramString);
    str1 = StringFunction.rtrim(str1);
    String str2 = getStatement().getConnection().getMetaData().getDatabaseProductName();
    if ((str2 != null) && (str2.equalsIgnoreCase("Informix Dynamic Server")))
      str1 = SpecialTools.informix2DB(str1);
    if ((str1 != null) && (str1.equals(" ")))
      return "";
    if ((this.iChange == 1) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes("ISO8859_1"), "GBK");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException1)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    else if ((this.iChange == 3) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes("GBK"), "ISO8859_1");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException2)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    else if ((this.iChange == 11) && (str1 != null))
      try
      {
        str1 = new String(str1.getBytes(), "UTF-8");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException3)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    return str1;
  }

  public double getDouble(int paramInt)
    throws Exception
  {
    return this.rs.getDouble(paramInt);
  }

  public double getDouble(String paramString)
    throws Exception
  {
    return this.rs.getDouble(paramString);
  }

  public int getInt(int paramInt)
    throws Exception
  {
    return this.rs.getInt(paramInt);
  }

  public int getInt(String paramString)
    throws Exception
  {
    return this.rs.getInt(paramString);
  }

  public void toSystemString()
    throws Exception
  {
    if (this.rs.next())
      for (int i = 1; i <= getColumnCount(); i++)
      {
        if (i > 1)
          System.out.print(",");
        String str = getString(i);
        if (this.rs.wasNull())
          System.out.print("null");
        else
          System.out.print(str);
      }
  }

  public ResultSetMetaData getMetaData()
    throws SQLException
  {
    return this.rsmd;
  }

  public long getLong(int paramInt)
    throws SQLException
  {
    return this.rs.getLong(paramInt);
  }

  public long getLong(String paramString)
    throws SQLException
  {
    return this.rs.getLong(paramString);
  }

  public float getFloat(int paramInt)
    throws SQLException
  {
    return this.rs.getFloat(paramInt);
  }

  public float getFloat(String paramString)
    throws SQLException
  {
    return this.rs.getFloat(paramString);
  }

  public void updateDouble(int paramInt, double paramDouble)
    throws SQLException
  {
    this.rs.updateDouble(paramInt, paramDouble);
  }

  public void updateDouble(String paramString, double paramDouble)
    throws SQLException
  {
    this.rs.updateDouble(paramString, paramDouble);
  }

  public void updateFloat(int paramInt, float paramFloat)
    throws SQLException
  {
    this.rs.updateFloat(paramInt, paramFloat);
  }

  public void updateFloat(String paramString, float paramFloat)
    throws SQLException
  {
    this.rs.updateFloat(paramString, paramFloat);
  }

  public void updateString(int paramInt, String paramString)
    throws SQLException, Exception
  {
    if ((this.iChange == 1) && (paramString != null))
      try
      {
        paramString = new String(paramString.getBytes("GBK"), "ISO8859_1");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException1)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    if ((this.iChange == 3) && (paramString != null))
      try
      {
        paramString = new String(paramString.getBytes("ISO8859_1"), "GBK");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException2)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    paramString = SpecialTools.amarsoft2DB(paramString);
    this.rs.updateString(paramInt, paramString);
  }

  public void updateString(String paramString1, String paramString2)
    throws SQLException, Exception
  {
    if ((this.iChange == 1) && (paramString2 != null))
      try
      {
        paramString2 = new String(paramString2.getBytes("GBK"), "ISO8859_1");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException1)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    if ((this.iChange == 3) && (paramString2 != null))
      try
      {
        paramString2 = new String(paramString2.getBytes("ISO8859_1"), "GBK");
      }
      catch (UnsupportedEncodingException localUnsupportedEncodingException2)
      {
        throw new SQLException("UnsupportedEncodingException");
      }
    paramString1 = SpecialTools.amarsoft2DB(paramString1);
    this.rs.updateString(paramString1, paramString2);
  }

  public void updateRow()
    throws SQLException
  {
    this.rs.updateRow();
  }

  public BigDecimal getBigDecimal(int paramInt)
    throws SQLException
  {
    return this.rs.getBigDecimal(paramInt);
  }

  public BigDecimal getBigDecimal(String paramString)
    throws SQLException
  {
    return this.rs.getBigDecimal(paramString);
  }

  public InputStream getBinaryStream(int paramInt)
    throws SQLException
  {
    return this.rs.getBinaryStream(paramInt);
  }

  public InputStream getBinaryStream(String paramString)
    throws SQLException
  {
    return this.rs.getBinaryStream(paramString);
  }
}