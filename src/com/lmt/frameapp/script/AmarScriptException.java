package com.lmt.frameapp.script;

import com.lmt.frameapp.ASException;

public class AmarScriptException extends ASException
{
  private static final long serialVersionUID = 5124268187093323206L;

  public AmarScriptException(String sMessage)
  {
    super(sMessage);
  }

  public AmarScriptException(String sMessage, int iErrorLevel)
  {
    super(sMessage, iErrorLevel);
  }
}