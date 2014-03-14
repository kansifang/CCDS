package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

class IDException extends ASException
{
  private static final long serialVersionUID = -92430388859106556L;

  public IDException(String sMessage)
  {
    super(sMessage);
  }

  public IDException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}