package com.lmt.frameapp.metadata;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.ContextException;
import com.lmt.frameapp.ContextService;
import com.lmt.frameapp.ContextServiceStub;
import com.lmt.frameapp.log.Log;

public abstract class MetaDataFactory
  implements ContextService
{
  protected static MetaDataFactory factory;
  protected static String factoryClass;
  public static final String serviceId = "METADATA";

  public abstract DataSourceMetaData getInstance(String paramString);

  public static DataSourceMetaData getMetaData(String paramString)
  {
    return getFactory().getInstance(paramString);
  }

  public static MetaDataFactory getFactory()
  {
    if (factory == null)
    {
      ContextServiceStub localContextServiceStub = ARE.getServiceStub("METADATA");
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

  public final void init()
    throws ContextException
  {
    try
    {
      initMetaDataFactory();
    }
    catch (Exception localException)
    {
      throw new ContextException("Initialize METADATA service failed", localException);
    }
    factoryClass = getClass().getName();
    factory = this;
  }

  public abstract void initMetaDataFactory()
    throws Exception;

  public abstract DataSourceMetaData[] getDataSources();

  public String getServiceClass()
  {
    return factoryClass;
  }

  public String getServiceId()
  {
    return "METADATA";
  }
}