package com.lmt.app.cms.javainvoke;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.sql.Transaction;

public abstract interface IBizlet
{
  public abstract void init(BizletExecutor paramBizletExecutor);

  public abstract void setAttribute(String paramString, Object paramObject)
    throws Exception;

  public abstract Object getAttribute(String paramString)
    throws Exception;

  public abstract Object run(Transaction paramTransaction)
    throws Exception;

  public abstract ASValuePool getAttributes()
    throws Exception;

  public abstract void initAttributes(ASValuePool paramLSValuePool)
    throws Exception;
}