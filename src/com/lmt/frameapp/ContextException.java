package com.lmt.frameapp;

public class ContextException extends Exception
{
  private static final long serialVersionUID = 1L;

  public ContextException()
  {
  }

  public ContextException(String paramString, Throwable paramThrowable)
  {
    super(paramString, paramThrowable);
  }

  public ContextException(String paramString)
  {
    super(paramString);
  }

  public ContextException(Throwable paramThrowable)
  {
    super(paramThrowable);
  }
}