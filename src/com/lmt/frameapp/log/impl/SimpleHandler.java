package com.lmt.frameapp.log.impl;

import java.io.PrintStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Properties;
import java.util.TimeZone;
import java.util.logging.Formatter;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

public class SimpleHandler extends Handler
{
  protected static final Properties props = new Properties();
  protected static final String DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss.SSS zzz";
  protected static DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS zzz");
  private int logLevel = 3;

  public SimpleHandler()
  {
    configure();
  }

  public void configure()
  {
    dateFormatter.setTimeZone(TimeZone.getTimeZone("Asia/Shanghai"));
  }

  protected static String getStringProperty(String paramString)
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

  protected static String getStringProperty(String paramString1, String paramString2)
  {
    String str = getStringProperty(paramString1);
    return str == null ? paramString2 : str;
  }

  protected static boolean getBooleanProperty(String paramString, boolean paramBoolean)
  {
    String str = getStringProperty(paramString);
    return str == null ? paramBoolean : "true".equalsIgnoreCase(str);
  }

  public int getLogLevel()
  {
    return this.logLevel;
  }

  public void setLogLevel(int paramInt)
  {
    this.logLevel = paramInt;
  }

  public void setLogLevel(String paramString)
  {
    if ("all".equalsIgnoreCase(paramString))
      setLogLevel(0);
    else if ("trace".equalsIgnoreCase(paramString))
      setLogLevel(1);
    else if ("debug".equalsIgnoreCase(paramString))
      setLogLevel(2);
    else if ("info".equalsIgnoreCase(paramString))
      setLogLevel(3);
    else if ("warn".equalsIgnoreCase(paramString))
      setLogLevel(4);
    else if ("error".equalsIgnoreCase(paramString))
      setLogLevel(5);
    else if ("fatal".equalsIgnoreCase(paramString))
      setLogLevel(6);
    else if ("off".equalsIgnoreCase(paramString))
      setLogLevel(7);
  }

  protected boolean isLevelEnabled(int paramInt)
  {
    return paramInt >= this.logLevel;
  }

  public void close()
    throws SecurityException
  {
  }

  public void flush()
  {
  }

  public void publish(LogRecord paramLogRecord)
  {
    if (getFormatter() != null)
      publish(getFormatter().format(paramLogRecord));
    else
      publish(paramLogRecord.getMessage());
  }

  public void publish(String paramString)
  {
    System.out.println(dateFormatter.format(Calendar.getInstance().getTime()) + " " + paramString);
  }
}