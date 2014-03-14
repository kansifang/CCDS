package com.lmt.frameapp.log.impl;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.log.Log;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.LogManager;
import java.util.logging.Logger;

public class JDKLog implements Log
{
  public static final String PROPERTIES = "com.amarsoft.are.log.properties";
  protected transient Logger logger = null;
  protected String name = null;

  public static void setLogProperties(String paramString)
  {
    if (paramString != null)
      try
      {
        FileInputStream localFileInputStream = new FileInputStream(paramString);
        setLogProperties(localFileInputStream);
        localFileInputStream.close();
      }
      catch (Exception localException)
      {
        localException.printStackTrace();
      }
  }

  public static void setLogProperties(InputStream paramInputStream)
  {
    try
    {
      Properties localProperties = new Properties();
      localProperties.load(paramInputStream);
      String str = localProperties.getProperty("java.util.logging.FileHandler.pattern");
      if (str != null)
      {
        str = ARE.replaceARETags(str);
        Date localObject1 = new Date();
        SimpleDateFormat localObject2 = new SimpleDateFormat("yyyyMMdd");
        str = str.replaceAll("%D", ((SimpleDateFormat)localObject2).format((Date)localObject1));
        ((SimpleDateFormat)localObject2).applyPattern("yyyyMMddHHmmss");
        str = str.replaceAll("%d", ((SimpleDateFormat)localObject2).format((Date)localObject1));
        localProperties.setProperty("java.util.logging.FileHandler.pattern", str);
      }
      Object localObject1 = new ByteArrayOutputStream(1024);
      localProperties.store((OutputStream)localObject1, "Reset JDKLog Properties");
      Object localObject2 = new ByteArrayInputStream(((ByteArrayOutputStream)localObject1).toByteArray());
      ((ByteArrayOutputStream)localObject1).close();
      LogManager.getLogManager().readConfiguration((InputStream)localObject2);
      ((ByteArrayInputStream)localObject2).close();
    }
    catch (Exception localException)
    {
      localException.printStackTrace();
    }
  }

  public JDKLog(String paramString)
  {
    this.name = paramString;
    this.logger = getLogger();
  }

  private void log(Level paramLevel, String paramString, Throwable paramThrowable)
  {
    Logger localLogger = getLogger();
    if (localLogger.isLoggable(paramLevel))
    {
      Throwable localThrowable = new Throwable();
      StackTraceElement[] arrayOfStackTraceElement = localThrowable.getStackTrace();
      String str1 = "unknown";
      String str2 = "unknown";
      if ((arrayOfStackTraceElement != null) && (arrayOfStackTraceElement.length > 2))
      {
        StackTraceElement localStackTraceElement = arrayOfStackTraceElement[2];
        str1 = localStackTraceElement.getClassName();
        str2 = localStackTraceElement.getMethodName();
      }
      if (paramThrowable == null)
        localLogger.logp(paramLevel, str1, str2, paramString);
      else
        localLogger.logp(paramLevel, str1, str2, paramString, paramThrowable);
    }
  }

  public void debug(Object paramObject)
  {
    log(Level.FINE, String.valueOf(paramObject), null);
  }

  public void debug(Object paramObject, Throwable paramThrowable)
  {
    log(Level.FINE, String.valueOf(paramObject), paramThrowable);
  }

  public void error(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      error(((Throwable)paramObject).getMessage(), (Throwable)paramObject);
    else
      log(Level.SEVERE, String.valueOf(paramObject), null);
  }

  public void error(Object paramObject, Throwable paramThrowable)
  {
    error(String.valueOf(paramObject));
    debug(paramObject, paramThrowable);
  }

  public void fatal(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      fatal(((Throwable)paramObject).getMessage(), (Throwable)paramObject);
    else
      log(Level.SEVERE, String.valueOf(paramObject), null);
  }

  public void fatal(Object paramObject, Throwable paramThrowable)
  {
    fatal(String.valueOf(paramObject));
    debug(paramObject, paramThrowable);
  }

  public Logger getLogger()
  {
    if (this.logger == null)
      this.logger = Logger.getLogger(this.name);
    return this.logger;
  }

  public void info(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      info(((Throwable)paramObject).getMessage(), (Throwable)paramObject);
    else
      log(Level.INFO, String.valueOf(paramObject), null);
  }

  public void info(Object paramObject, Throwable paramThrowable)
  {
    info(String.valueOf(paramObject));
    debug(paramObject, paramThrowable);
  }

  public boolean isDebugEnabled()
  {
    return getLogger().isLoggable(Level.FINE);
  }

  public boolean isErrorEnabled()
  {
    return getLogger().isLoggable(Level.SEVERE);
  }

  public boolean isFatalEnabled()
  {
    return getLogger().isLoggable(Level.SEVERE);
  }

  public boolean isInfoEnabled()
  {
    return getLogger().isLoggable(Level.INFO);
  }

  public boolean isTraceEnabled()
  {
    return getLogger().isLoggable(Level.FINEST);
  }

  public boolean isWarnEnabled()
  {
    return getLogger().isLoggable(Level.WARNING);
  }

  public void trace(Object paramObject)
  {
    log(Level.FINEST, String.valueOf(paramObject), null);
  }

  public void trace(Object paramObject, Throwable paramThrowable)
  {
    log(Level.FINEST, String.valueOf(paramObject), paramThrowable);
  }

  public void warn(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      warn("", (Throwable)paramObject);
    else
      log(Level.WARNING, String.valueOf(paramObject), null);
  }

  public void warn(Object paramObject, Throwable paramThrowable)
  {
    warn(String.valueOf(paramObject) + paramThrowable.getMessage());
    debug(paramObject, paramThrowable);
  }
}