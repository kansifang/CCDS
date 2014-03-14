package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

class LSDateException extends ASException
{
  private static final long serialVersionUID = 1164675203455700406L;

  public LSDateException(String sMessage)
  {
    super(sMessage);
  }

  public LSDateException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}