package com.lmt.frameapp.log.impl;

import com.lmt.frameapp.log.Log;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.LogRecord;

public class SimpleLog implements Log
{
  protected static final Properties props = new Properties();
  protected static final String DEFAULT_DATE_TIME_FORMAT = "yyyy/MM/dd HH:mm:ss:SSS zzz ";
  protected static ArrayList handlers = null;
  public static final String systemPrefix = "com.lmt.frameapp.log.impl.SimpleLog.";
  protected static String logName = null;
  protected static int currentLogLevel;

  public SimpleLog(String paramString)
  {
    logName = paramString;
    setLevel(getStringProperty("com.lmt.frameapp.log.SimpleLog." + logName + ".level"));
  }

  private static String getStringProperty(String paramString)
  {
    String str = null;
    try
    {
      str = props.getProperty(paramString);
    }
    catch (SecurityException localSecurityException)
    {
    }
    return str;
  }

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
      props.load(paramInputStream);
      setLevel(getStringProperty("com.lmt.frameapp.log.impl.SimpleLog.level"));
      ByteArrayOutputStream localByteArrayOutputStream = new ByteArrayOutputStream(1024);
      props.store(localByteArrayOutputStream, "Reset SimpleLog Properties");
      SimpleHandler.props.load(new ByteArrayInputStream(localByteArrayOutputStream.toByteArray()));
      localByteArrayOutputStream.close();
      String str1 = getStringProperty("com.lmt.frameapp.log.impl.SimpleLog.handlers");
      String[] arrayOfString;
      if (str1 == null)
        arrayOfString = new String[0];
      else
        arrayOfString = str1.split(",");
      for (int i = 0; i < arrayOfString.length; i++)
      {
        String str2 = arrayOfString[i];
        try
        {
          Class localClass = Thread.currentThread().getContextClassLoader().loadClass(str2);
          SimpleHandler localSimpleHandler = (SimpleHandler)localClass.newInstance();
          addHandler(localSimpleHandler);
        }
        catch (Exception localException)
        {
          System.err.println("Can't load log handler \"" + str2 + "\"");
          System.err.println("" + localException);
          localException.printStackTrace();
        }
      }
    }
    catch (IOException localIOException)
    {
      localIOException.printStackTrace();
    }
  }

  public static synchronized void addHandler(SimpleHandler paramSimpleHandler)
  {
    if (handlers == null)
      handlers = new ArrayList();
    handlers.add(paramSimpleHandler);
  }

  public static synchronized SimpleHandler[] getHandlers()
  {
    if (handlers == null)
    {
      handlers = new ArrayList();
      handlers.add(new ConsoleHandler());
    }
    SimpleHandler[] arrayOfSimpleHandler = new SimpleHandler[handlers.size()];
    arrayOfSimpleHandler = (SimpleHandler[])handlers.toArray(arrayOfSimpleHandler);
    return arrayOfSimpleHandler;
  }

  public static void setLevel(int paramInt)
  {
    currentLogLevel = paramInt;
  }

  public static void setLevel(String paramString)
  {
    if (paramString == null)
      return;
    if ("all".equalsIgnoreCase(paramString))
      setLevel(0);
    else if ("trace".equalsIgnoreCase(paramString))
      setLevel(1);
    else if ("debug".equalsIgnoreCase(paramString))
      setLevel(2);
    else if ("info".equalsIgnoreCase(paramString))
      setLevel(3);
    else if ("warn".equalsIgnoreCase(paramString))
      setLevel(4);
    else if ("error".equalsIgnoreCase(paramString))
      setLevel(5);
    else if ("fatal".equalsIgnoreCase(paramString))
      setLevel(6);
    else if ("off".equalsIgnoreCase(paramString))
      setLevel(7);
  }

  public int getLevel()
  {
    return currentLogLevel;
  }

  private Level getJDKLevel(int paramInt)
  {
    Level localLevel = Level.INFO;
    switch (paramInt)
    {
    case 1:
      localLevel = Level.FINEST;
      break;
    case 2:
      localLevel = Level.FINE;
      break;
    case 3:
      localLevel = Level.INFO;
      break;
    case 4:
      localLevel = Level.WARNING;
      break;
    case 5:
      localLevel = Level.SEVERE;
      break;
    case 6:
      localLevel = Level.SEVERE;
    }
    return localLevel;
  }

  protected void log(int paramInt, Object paramObject, Throwable paramThrowable)
  {
    StringBuffer localStringBuffer = new StringBuffer();
    switch (paramInt)
    {
    case 1:
      localStringBuffer.append("[TRACE] ");
      break;
    case 2:
      localStringBuffer.append("[DEBUG] ");
      break;
    case 3:
      localStringBuffer.append("[INFO] ");
      break;
    case 4:
      localStringBuffer.append("[WARN] ");
      break;
    case 5:
      localStringBuffer.append("[ERROR] ");
      break;
    case 6:
      localStringBuffer.append("[FATAL] ");
    }
    localStringBuffer.append(String.valueOf(paramObject));
    if (paramThrowable != null)
    {
      localStringBuffer.append(" <");
      localStringBuffer.append(paramThrowable.toString());
      localStringBuffer.append(">");
      StringWriter localObject1 = new StringWriter(1024);
      PrintWriter localObject2 = new PrintWriter((Writer)localObject1);
      paramThrowable.printStackTrace((PrintWriter)localObject2);
      ((PrintWriter)localObject2).close();
      localStringBuffer.append(((StringWriter)localObject1).toString());
    }
    Object localObject1 = new LogRecord(getJDKLevel(paramInt), localStringBuffer.toString());
    ((LogRecord)localObject1).setThrown(paramThrowable);
    ((LogRecord)localObject1).setLoggerName(logName);
    Object localObject2 = new Throwable();
    StackTraceElement[] arrayOfStackTraceElement = ((Throwable)localObject2).getStackTrace();
    String str1 = "unknown";
    String str2 = "unknown";
    if ((arrayOfStackTraceElement != null) && (arrayOfStackTraceElement.length > 2))
    {
    	StackTraceElement localObject3 = arrayOfStackTraceElement[2];
      str1 = ((StackTraceElement)localObject3).getClassName();
      ((LogRecord)localObject1).setSourceClassName(str1);
      str2 = ((StackTraceElement)localObject3).getMethodName();
      ((LogRecord)localObject1).setSourceMethodName(str2);
    }
    SimpleHandler[] localObject3 = getHandlers();
    if (localObject3 != null)
      for (int i = 0; i < localObject3.length; i++)
      {
        if (!localObject3[i].isLevelEnabled(paramInt))
          continue;
        localObject3[i].publish((LogRecord)localObject1);
      }
  }

  protected boolean isLevelEnabled(int paramInt)
  {
    return paramInt >= currentLogLevel;
  }

  public final void debug(Object paramObject)
  {
    if (isLevelEnabled(2))
      log(2, paramObject, null);
  }

  public final void debug(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(2))
      log(2, paramObject, paramThrowable);
  }

  public final void trace(Object paramObject)
  {
    if (isLevelEnabled(1))
      log(1, paramObject, null);
  }

  public final void trace(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(1))
      log(1, paramObject, paramThrowable);
  }

  public final void info(Object paramObject)
  {
    if (isLevelEnabled(3))
      log(3, paramObject, null);
  }

  public final void info(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(3))
      log(3, paramObject, paramThrowable);
  }

  public final void warn(Object paramObject)
  {
    if (isLevelEnabled(4))
      log(4, paramObject, null);
  }

  public final void warn(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(4))
      log(4, paramObject, paramThrowable);
  }

  public final void error(Object paramObject)
  {
    if (isLevelEnabled(5))
      log(5, paramObject, null);
  }

  public final void error(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(5))
      log(5, paramObject, paramThrowable);
  }

  public final void fatal(Object paramObject)
  {
    if (isLevelEnabled(6))
      log(6, paramObject, null);
  }

  public final void fatal(Object paramObject, Throwable paramThrowable)
  {
    if (isLevelEnabled(6))
      log(6, paramObject, paramThrowable);
  }

  public final boolean isDebugEnabled()
  {
    return isLevelEnabled(2);
  }

  public final boolean isErrorEnabled()
  {
    return isLevelEnabled(5);
  }

  public final boolean isFatalEnabled()
  {
    return isLevelEnabled(6);
  }

  public final boolean isInfoEnabled()
  {
    return isLevelEnabled(3);
  }

  public final boolean isTraceEnabled()
  {
    return isLevelEnabled(1);
  }

  public final boolean isWarnEnabled()
  {
    return isLevelEnabled(4);
  }
}