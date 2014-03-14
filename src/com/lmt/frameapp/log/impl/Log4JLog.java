package com.lmt.frameapp.log.impl;

import com.lmt.frameapp.log.Log;
import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.log4j.xml.DOMConfigurator;

public class Log4JLog implements Log
{
  private static final String FQCN = Log4JLog.class.getName();
  private transient Logger logger = null;
  private String name = null;

  public static void setLogProperties(String paramString)
    throws Exception
  {
    if (paramString == null)
      BasicConfigurator.configure();
    else if (paramString.endsWith(".xml"))
      DOMConfigurator.configure(paramString);
    else
      PropertyConfigurator.configure(paramString);
  }

  public Log4JLog()
  {
  }

  public Log4JLog(String paramString)
  {
    this.name = paramString;
    this.logger = getLogger();
  }

  public Log4JLog(Logger paramLogger)
  {
    this.name = paramLogger.getName();
    this.logger = paramLogger;
  }

  public void trace(Object paramObject)
  {
    getLogger().log(FQCN, Level.DEBUG, paramObject, null);
  }

  public void trace(Object paramObject, Throwable paramThrowable)
  {
    getLogger().log(FQCN, Level.DEBUG, paramObject, paramThrowable);
  }

  public void debug(Object paramObject)
  {
    getLogger().log(FQCN, Level.DEBUG, paramObject, null);
  }

  public void debug(Object paramObject, Throwable paramThrowable)
  {
    getLogger().log(FQCN, Level.DEBUG, paramObject, paramThrowable);
  }

  public void info(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      info("", (Throwable)paramObject);
    else
      getLogger().log(FQCN, Level.INFO, paramObject, null);
  }

  public void info(Object paramObject, Throwable paramThrowable)
  {
    info(String.valueOf(paramObject) + paramThrowable.getMessage());
    debug(paramObject, paramThrowable);
  }

  public void warn(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      warn("", (Throwable)paramObject);
    else
      getLogger().log(FQCN, Level.WARN, paramObject, null);
  }

  public void warn(Object paramObject, Throwable paramThrowable)
  {
    warn(String.valueOf(paramObject) + paramThrowable.getMessage());
    debug(paramObject, paramThrowable);
  }

  public void error(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      error("", (Throwable)paramObject);
    else
      getLogger().log(FQCN, Level.ERROR, paramObject, null);
  }

  public void error(Object paramObject, Throwable paramThrowable)
  {
    error(String.valueOf(paramObject) + paramThrowable.getMessage());
    debug(paramObject, paramThrowable);
  }

  public void fatal(Object paramObject)
  {
    if ((paramObject instanceof Throwable))
      fatal("", (Throwable)paramObject);
    else
      getLogger().log(FQCN, Level.FATAL, paramObject, null);
  }

  public void fatal(Object paramObject, Throwable paramThrowable)
  {
    fatal(String.valueOf(paramObject) + paramThrowable.getMessage());
    debug(paramObject, paramThrowable);
  }

  public Logger getLogger()
  {
    if (this.logger == null)
      this.logger = Logger.getLogger(this.name);
    return this.logger;
  }

  public boolean isDebugEnabled()
  {
    return getLogger().isDebugEnabled();
  }

  public boolean isErrorEnabled()
  {
    return getLogger().isEnabledFor(Level.ERROR);
  }

  public boolean isFatalEnabled()
  {
    return getLogger().isEnabledFor(Level.FATAL);
  }

  public boolean isInfoEnabled()
  {
    return getLogger().isInfoEnabled();
  }

  public boolean isTraceEnabled()
  {
    return getLogger().isDebugEnabled();
  }

  public boolean isWarnEnabled()
  {
    return getLogger().isEnabledFor(Level.WARN);
  }
}