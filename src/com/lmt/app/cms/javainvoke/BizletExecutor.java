package com.lmt.app.cms.javainvoke;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.frameapp.web.ASRuntimeContext;

public class BizletExecutor
{
  public ASRuntimeContext CurARC;
  private ASValuePool context = new ASValuePool();

  public BizletExecutor()
  {
  }

  public BizletExecutor(ASRuntimeContext arc) {
    this.CurARC = arc;
  }
  public void setContext(ASValuePool vpContext) {
    this.context = vpContext;
  }
  public ASValuePool getContext() {
    return this.context;
  }
  public Object execute(Transaction Sqlca, String sClassName, ASValuePool vpParas) throws Exception {
    IBizlet bizlet;
    try {
      Class c = Class.forName(sClassName);
      bizlet = (Bizlet)c.newInstance();
    } catch (Exception ex) {
      throw new Exception("无法装载类" + sClassName + "。错误：" + ex.getMessage());
    }
    if (bizlet == null) throw new Exception("逻辑" + sClassName + "为null");
    bizlet.init(this);
    bizlet.initAttributes(vpParas);
    try {
      return bizlet.run(Sqlca);
    } catch (Exception ex) {
      ARE.getLog().error("============运行bizlet [" + sClassName + "] 时发生错误。", ex);
      throw ex;
    }
  }
}