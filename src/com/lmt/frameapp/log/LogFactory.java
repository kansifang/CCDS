package com.lmt.frameapp.log;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.ContextException;
import com.lmt.frameapp.ContextService;
import com.lmt.frameapp.ContextServiceStub;
import com.lmt.frameapp.log.impl.DefaultLogFactory;

public abstract class LogFactory implements ContextService
{
  public static final String FACTORY_DEFAULT = "com.amarsoft.Context.log.impl.DefaultLogFactory";
  public static final String serviceId = "LOG";
  private static String factoryClass = "com.amarsoft.Context.log.impl.DefaultLogFactory";
  protected static LogFactory factory = null;

  public abstract Log getInstance(String paramString)
    throws LogException;

  public abstract void shutdown();

  public static LogFactory getFactory()
    throws LogException
  {
    if (factory == null)
    {
      ContextServiceStub localContextServiceStub = ARE.getServiceStub("LOG");
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
      else
        factory = createDefaultFactory();
    }
    return factory;
  }

  public static Log getLog(String paramString)
    throws LogException
  {
    return getFactory().getInstance(paramString);
  }

  protected static LogFactory createDefaultFactory()
    throws LogException
  {
    DefaultLogFactory localDefaultLogFactory = null;
    try
    {
      Class localClass = Class.forName("com.amarsoft.Context.log.impl.DefaultLogFactory");
      localDefaultLogFactory = (DefaultLogFactory)localClass.newInstance();
    }
    catch (Exception localException)
    {
      localException.printStackTrace();
    }
    return localDefaultLogFactory;
  }

  public String getProperty(String paramString)
  {
    return null;
  }

  public String getServiceClass()
  {
    return factoryClass;
  }

  public String getServiceId()
  {
    return "LOG";
  }

  public void setProperty(String paramString1, String paramString2)
  {
  }

  public final void init()
    throws ContextException
  {
    try
    {
      initLogFactory();
    }
    catch (Exception localException)
    {
      throw new ContextException("Initialize LOG service failed", localException);
    }
    factory = this;
  }

  public abstract void initLogFactory()
    throws Exception;
}