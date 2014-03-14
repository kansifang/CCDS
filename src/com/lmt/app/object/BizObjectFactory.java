package com.lmt.app.object;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.Transaction;

public class BizObjectFactory
{
  private static BizObjectFactory instance = null;

  public static synchronized BizObjectFactory getInstance()
  {
    if (instance == null) {
      instance = new BizObjectFactory();
    }
    return instance;
  }

  public IBizObject createBizObject(Transaction Sqlca, String sObjectType, String sObjectNo) throws Exception {
    IBizObject bo = createBizObject(Sqlca, sObjectType, sObjectNo, "001");
    return bo;
  }

  public IBizObject createBizObject(Transaction Sqlca, String sObjectType, String sObjectNo, String sViewID) throws Exception
  {
    String sClassName = null;

    ASValuePool config = ASConfigure.getSysConfig("SYSCONF_BO_TYPE", Sqlca);

    BizObjectType type = (BizObjectType)config.getAttribute(sObjectType);

    if (type == null) throw new Exception("没有找到对象类型" + sObjectType + "的定义。\n\n请确认：\n1. OBJECTTYPE_CATALOG表中注册了该对象类型。\n2. 刷新了“对象类型缓存”或重启应用服务器。");

    sClassName = (String)type.getAttribute("ObjectClass");
    IBizObject bo;
    if ((sClassName == null) || (sClassName.length() < 1))
      bo = new BizObject();
    else {
      try {
        Class tClass = Class.forName(sClassName);
        bo = (IBizObject)tClass.newInstance();
      }
      catch (Exception e) {
        throw new Exception("动态类" + sClassName + "的加载出错:" + e.getMessage());
      }
    }
    try
    {
      bo.init(Sqlca, type, sObjectNo, sViewID);
    } catch (Exception ex) {
      ARE.getLog().error("============初始化业务对象[" + sObjectType + "]时发生错误：", ex);
      throw ex;
    }
    return bo;
  }
}