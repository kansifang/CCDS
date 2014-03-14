package com.lmt.app.cms.explain;

import com.lmt.frameapp.ASException;

class AmarMethodException extends ASException
{
  private static final long serialVersionUID = -3981484770921204837L;

  public AmarMethodException(String sMessage)
  {
    super(sMessage);
  }

  public AmarMethodException(String sMessage, int iErrorLevel) {
    super(sMessage, iErrorLevel);
  }
}