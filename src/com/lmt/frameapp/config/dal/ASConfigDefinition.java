package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;

public class ASConfigDefinition
{
  public String id;
  public String name;
  protected ASValuePool attributes = new ASValuePool();

  public Object getAttribute(String sKey)
    throws Exception
  {
    return this.attributes.getAttribute(sKey);
  }

  public void setAttribute(String sKey, Object oTmp)
    throws Exception
  {
    this.attributes.setAttribute(sKey, oTmp);
  }

  public ASValuePool getAttributes()
  {
    return this.attributes;
  }

  public Object[] getKeys()
  {
    return this.attributes.getKeys();
  }
}