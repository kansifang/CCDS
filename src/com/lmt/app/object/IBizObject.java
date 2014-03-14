package com.lmt.app.object;

import com.lmt.frameapp.sql.Transaction;

public abstract interface IBizObject
{
  public abstract Object getAttribute(String paramString)
    throws Exception;

  public abstract void setAttribute(String paramString, Object paramObject)
    throws Exception;

  public abstract BizObjectType getType();

  public abstract String name();

  public abstract String id();

  public abstract void init(Transaction paramTransaction, BizObjectType paramBizObjectType, String paramString)
    throws Exception;

  public abstract void init(Transaction paramTransaction, BizObjectType paramBizObjectType, String paramString1, String paramString2)
    throws Exception;

  public abstract String getRightType(Transaction paramTransaction, String paramString1, String paramString2)
    throws Exception;

  public abstract String[][] getTabArray(Transaction paramTransaction)
    throws Exception;

  public abstract String[][] getConstants()
    throws Exception;
}