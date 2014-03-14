package com.lmt.baseapp.flow;

public class ReturnMessage
{
  public int ReturnCode;
  public String ReturnMessage;

  public ReturnMessage(int paramInt, String paramString)
  {
    this.ReturnCode = paramInt;
    this.ReturnMessage = paramString;
  }
}