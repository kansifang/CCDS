package com.lmt.frameapp.script;

import com.lmt.baseapp.util.ASValuePool;

public abstract interface IScriptObject
{
  public abstract Object getAttribute(String paramString)
    throws Exception;

  public abstract void setAttribute(String paramString, Object paramObject)
    throws Exception;

  public abstract void setAttributes(ASValuePool paramLSValuePool)
    throws Exception;

  public abstract ASValuePool getAttributes();

  public abstract Object[] getKeys();
}