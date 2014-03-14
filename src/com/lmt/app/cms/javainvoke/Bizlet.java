package com.lmt.app.cms.javainvoke;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ASRuntimeContext;

public abstract class Bizlet implements IBizlet
{
  private BizletExecutor executor;
  private ASValuePool attributes = new ASValuePool();
  private ASValuePool context = null;

  public final void init(BizletExecutor exe)
  {
    this.executor = exe;
    this.context = exe.getContext();
  }

  public final void initAttributes(ASValuePool attrs) throws Exception {
    this.attributes.uniteFromValuePool(attrs);
  }

  public final BizletExecutor getExecutor() {
    return this.executor;
  }

  public final ASRuntimeContext getRuntimeContext() {
    return getExecutor().CurARC;
  }

  public final void setAttribute(String sKey, Object oValue)
    throws Exception
  {
    this.attributes.setAttribute(sKey, oValue);
  }

  public final Object getAttribute(String sKey)
    throws Exception
  {
    return this.attributes.getAttribute(sKey);
  }

  public final ASValuePool getAttributes()
    throws Exception
  {
    return this.attributes;
  }

  public final ASValuePool getContext() throws Exception {
    return this.context;
  }

  public abstract Object run(Transaction paramTransaction)
    throws Exception;
}