package com.lmt.frameapp.script;

import com.lmt.baseapp.util.ASValuePool;

public class ScriptObject
  implements IScriptObject
{
  private ASValuePool attributes = new ASValuePool();

  public Object getAttribute(String sKey)
    throws Exception
  {
    return this.attributes.getAttribute(sKey);
  }

  public void setAttribute(String sKey, Object oObj) throws Exception {
    this.attributes.setAttribute(sKey, oObj);
  }

  public ASValuePool getAttributes()
  {
    return this.attributes;
  }

  public Object[] getKeys() {
    return this.attributes.getKeys();
  }

  public void setAttributes(ASValuePool attributes) throws Exception {
    this.attributes = attributes;
  }
}