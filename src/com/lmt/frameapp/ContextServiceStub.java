package com.lmt.frameapp;

import com.lmt.frameapp.lang.ObjectX;
import com.lmt.frameapp.log.Log;
import java.io.PrintStream;
import java.util.Enumeration;
import java.util.Properties;

public class ContextServiceStub
{
  protected String id;
  protected String serviceClass;
  protected Properties properties;
  protected boolean initOnStart = false;
  protected ContextService serviceInstance = null;

  public ContextServiceStub()
  {
    this.properties = new Properties();
  }

  public ContextServiceStub(String paramString)
  {
    this.id = paramString;
    this.properties = new Properties();
  }

  public void setProperty(String paramString1, String paramString2)
  {
    this.properties.setProperty(paramString1, paramString2);
  }

  public String getProperty(String paramString)
  {
    return this.properties.getProperty(paramString);
  }

  public String getServiceClass()
  {
    return this.serviceClass;
  }

  public String getId()
  {
    return this.id;
  }

  public void setId(String paramString)
  {
    this.id = paramString;
  }

  public void setServiceClass(String paramString)
  {
    this.serviceClass = paramString;
  }

  public Properties getProperties()
  {
    return this.properties;
  }

  public boolean isInitOnStart()
  {
    return this.initOnStart;
  }

  public void loadService()
    throws ContextException
  {
    ContextService localContextService = null;
    try
    {
      Class localClass = Class.forName(getServiceClass());
      localContextService = (ContextService)localClass.newInstance();
      Enumeration localEnumeration = this.properties.keys();
      while (localEnumeration.hasMoreElements())
      {
        String str1 = (String)localEnumeration.nextElement();
        String str2 = this.properties.getProperty(str1);
        if (ObjectX.setPropertyX(localContextService, str1, str2, true))
          continue;
        System.err.println("Set services property '" + str1 + "=" + str2 + "' faild!");
      }
      this.serviceInstance = localContextService;
    }
    catch (Exception localException)
    {
      if (this.id.equals("LOG"))
        System.err.println("Load service failed--" + localException.toString());
      else
        ARE.getLog().debug("Load service failed", localException);
      throw new ContextException("Load service failed", localException);
    }
  }

  public void initService()
    throws ContextException
  {
    if (this.serviceInstance != null)
      this.serviceInstance.init();
  }

  public final ContextService getServiceInstance()
  {
    return this.serviceInstance;
  }
}