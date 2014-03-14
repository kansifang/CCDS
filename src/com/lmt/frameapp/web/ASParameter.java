package com.lmt.frameapp.web;

import java.io.Serializable;

public class ASParameter
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String paraName;
  public Object paraValue;

  public ASParameter()
  {
  }

  public ASParameter(String sParaName, Object oParaValue)
  {
    this.paraName = sParaName;
    this.paraValue = oParaValue;
  }
}