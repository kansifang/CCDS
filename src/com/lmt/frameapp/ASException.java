package com.lmt.frameapp;

public class ASException extends Exception
{
  private int ErrorLevel = 1;
  private static final long serialVersionUID = 1L;

  public ASException(String paramString)
  {
    super(paramString);
  }

  public ASException(String paramString, int paramInt)
  {
    super(paramString);
    this.ErrorLevel = paramInt;
  }

  public String getMessage()
  {
    return "<br>" + super.getMessage();
  }

  public int getErrorLevel()
  {
    return this.ErrorLevel;
  }
}