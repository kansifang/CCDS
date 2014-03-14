package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

public class AnythingException extends ASException
{
  private static final long serialVersionUID = 8687623714156835069L;

  public AnythingException(String sMessage)
  {
    super(sMessage);
  }

  public AnythingException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}