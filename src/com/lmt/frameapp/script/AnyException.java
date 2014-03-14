package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

public class AnyException extends ASException
{
  private static final long serialVersionUID = 8687623714156835069L;

  public AnyException(String sMessage)
  {
    super(sMessage);
  }

  public AnyException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}