package com.lmt.frameapp.sql;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.ContextException;
import com.lmt.frameapp.ContextService;
import com.lmt.frameapp.ContextServiceStub;
import com.lmt.frameapp.log.Log;
import java.sql.Connection;
import java.sql.SQLException;

public abstract class DBConnectionFactory implements ContextService
{
  private static final String serviceID = "DBCONNECTION";
  private static DBConnectionFactory factory = null;
  private static String factoryClass = null;

  public abstract Connection getInstance(String paramString)
    throws SQLException;

  public abstract String[] getInstanceList();

  public abstract void shutdown();

  public static DBConnectionFactory getFactory()
    throws SQLException
  {
    if (factory == null)
    {
      ContextServiceStub localContextServiceStub = ARE.getServiceStub("DBCONNECTION");
      if (localContextServiceStub != null)
        try
        {
          localContextServiceStub.loadService();
          localContextServiceStub.initService();
          ARE.getLog().debug("ContextService " + localContextServiceStub.getId() + " initialiezed!");
        }
        catch (ContextException localContextException)
        {
        	ARE.getLog().debug("ContextService " + localContextServiceStub.getId() + " initialieze failed!", localContextException);
        }
    }
    return factory;
  }

  public abstract void initConnectionFactory()
    throws Exception;

  public static Connection getConnection(String paramString)
    throws SQLException
  {
    return getFactory().getInstance(paramString);
  }

  public String getServiceClass()
  {
    return factoryClass;
  }

  public String getServiceId()
  {
    return "DBCONNECTION";
  }

  public final void init()
    throws ContextException
  {
    try
    {
      initConnectionFactory();
    }
    catch (Exception localException)
    {
      throw new ContextException("Initialize DBCONNECTION service failed" + localException.getMessage(), localException);
    }
    factory = this;
  }
}