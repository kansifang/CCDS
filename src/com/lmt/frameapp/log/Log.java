package com.lmt.frameapp.log;

public abstract interface Log
{
  public static final int LOG_LEVEL_TRACE = 1;
  public static final int LOG_LEVEL_DEBUG = 2;
  public static final int LOG_LEVEL_INFO = 3;
  public static final int LOG_LEVEL_WARN = 4;
  public static final int LOG_LEVEL_ERROR = 5;
  public static final int LOG_LEVEL_FATAL = 6;
  public static final int LOG_LEVEL_ALL = 0;
  public static final int LOG_LEVEL_OFF = 7;

  public abstract boolean isDebugEnabled();

  public abstract boolean isErrorEnabled();

  public abstract boolean isFatalEnabled();

  public abstract boolean isInfoEnabled();

  public abstract boolean isTraceEnabled();

  public abstract boolean isWarnEnabled();

  public abstract void trace(Object paramObject);

  public abstract void trace(Object paramObject, Throwable paramThrowable);

  public abstract void debug(Object paramObject);

  public abstract void debug(Object paramObject, Throwable paramThrowable);

  public abstract void info(Object paramObject);

  public abstract void info(Object paramObject, Throwable paramThrowable);

  public abstract void warn(Object paramObject);

  public abstract void warn(Object paramObject, Throwable paramThrowable);

  public abstract void error(Object paramObject);

  public abstract void error(Object paramObject, Throwable paramThrowable);

  public abstract void fatal(Object paramObject);

  public abstract void fatal(Object paramObject, Throwable paramThrowable);
}