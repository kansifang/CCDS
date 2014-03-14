package com.lmt.frameapp.log;

public class LogException extends RuntimeException
{
  private static final long serialVersionUID = 1L;
  protected Throwable cause = null;

  public LogException()
  {
  }

  public LogException(String paramString)
  {
    super(paramString);
  }

  public LogException(Throwable paramThrowable)
  {
    this(paramThrowable == null ? null : paramThrowable.toString(), paramThrowable);
  }

  public LogException(String paramString, Throwable paramThrowable)
  {
    super(paramString + " (Caused by " + paramThrowable + ")");
    this.cause = paramThrowable;
  }

  public Throwable getCause()
  {
    return this.cause;
  }
}