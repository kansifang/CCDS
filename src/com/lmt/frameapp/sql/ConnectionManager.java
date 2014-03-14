package com.lmt.frameapp.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnectionManager
{
  public static DataSource getDataSource(String sDataSource)
    throws NamingException
  {
    DataSource ds = null;
    try {
      Context ctx = new InitialContext();
      ds = (DataSource)ctx.lookup(sDataSource);
      ctx.close();
    } catch (NamingException e) {
    	com.lmt.frameapp.ARE.getLog().fatal("get dataSource error!", e);
      e.printStackTrace();
      throw e;
    }
    return ds;
  }

  public static DataSource getDataSource(String sContextFactory, String sProviderUrl, String sDataSource)
    throws Exception
  {
    Context ctx = null;
    Hashtable ht = new Hashtable();
    if ((sContextFactory != null) && (sContextFactory.trim().length() > 0))
      ht.put("java.naming.factory.initial", sContextFactory);
    if ((sProviderUrl != null) && (sProviderUrl.trim().length() > 0))
      ht.put("java.naming.provider.url", sProviderUrl);
    if (ht.size() > 0)
      ctx = new InitialContext(ht);
    else {
      ctx = new InitialContext();
    }
    DataSource ds = (DataSource)ctx.lookup(sDataSource);
    ctx.close();
    return ds;
  }

  public static Connection getConnection(String sDataSource)
    throws NamingException, SQLException
  {
    DataSource ds = getDataSource(sDataSource);
    return ds.getConnection();
  }

  public static Connection getConnection(String sUrl, String sDriverName, String sUserName, String sUserPass)
    throws Exception
  {
    Class.forName(sDriverName);
    return DriverManager.getConnection(sUrl, sUserName, sUserPass);
  }

  public static Connection getConnection(String sContextFactory, String sProviderUrl, String sDataSource)
    throws Exception
  {
    Context ctx = null;
    Hashtable ht = new Hashtable();
    ht.put("java.naming.factory.initial", sContextFactory);
    if (sProviderUrl != null)
      ht.put("java.naming.provider.url", sProviderUrl);
    ctx = new InitialContext(ht);
    DataSource ds = (DataSource)ctx.lookup(sDataSource);
    ctx.close();
    return ds.getConnection();
  }

  public static Connection getConnection(DataSource ds)
    throws Exception
  {
    return ds.getConnection();
  }

  public static Transaction getTransaction(String sUrl, String sDriverName, String sUserName, String sUserPass)
    throws Exception
  {
    return new Transaction(getConnection(sUrl, sDriverName, sUserName, sUserPass));
  }

  public static Transaction getTransaction(int iReadChange, String sUrl, String sDriverName, String sUserName, String sUserPass)
    throws Exception
  {
    return new Transaction(iReadChange, getConnection(sUrl, sDriverName, sUserName, sUserPass));
  }

  public static Transaction getTransaction(String sDataSource) throws Exception
  {
    return new Transaction(getConnection(sDataSource));
  }

  public static Transaction getTransaction(String sContextFactory, String sProviderUrl, String sDataSource)
    throws Exception
  {
    return new Transaction(getConnection(sContextFactory, sProviderUrl, sDataSource));
  }

  public static Transaction getTransaction(int iReadChange, String sContextFactory, String sProviderUrl, String sDataSource)
    throws Exception
  {
    return new Transaction(iReadChange, getConnection(sContextFactory, sProviderUrl, sDataSource));
  }

  public static Transaction getTransaction(DataSource ds)
    throws Exception
  {
    return new Transaction(getConnection(ds));
  }

  public static Transaction getTransaction(int iReadChange, DataSource ds)
    throws Exception
  {
    return new Transaction(iReadChange, getConnection(ds));
  }

  public static Connection getConnection(DataSource ds, String sUser, String sPass)
    throws Exception
  {
    return ds.getConnection(sUser, sPass);
  }

  public static Transaction getTransaction(DataSource ds, String sUser, String sPass)
    throws Exception
  {
    return new Transaction(getConnection(ds, sUser, sPass));
  }

  public static Transaction getTransaction(int iReadChange, DataSource ds, String sUser, String sPass)
    throws Exception
  {
    return new Transaction(iReadChange, getConnection(ds, sUser, sPass));
  }
}