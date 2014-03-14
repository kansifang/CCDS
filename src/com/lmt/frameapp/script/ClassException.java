package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

public class ClassException extends ASException
{
  private static final long serialVersionUID = -3981484770921204837L;

  public ClassException(String sMessage)
  {
    super(sMessage);
  }

  public ClassException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}