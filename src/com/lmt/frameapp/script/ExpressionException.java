package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

public class ExpressionException extends ASException
{
  private static final long serialVersionUID = 5124268187093323206L;

  public ExpressionException(String sMessage)
  {
    super(sMessage);
  }

  public ExpressionException(String sMessage, int iErrorLevel)
  {
    super(sMessage, iErrorLevel);
  }
}