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

    if (type == null) throw new Exception("û���ҵ���������" + sObjectType + "�Ķ��塣\n\n��ȷ�ϣ�\n1. OBJECTTYPE_CATALOG����ע���˸ö������͡�\n2. ˢ���ˡ��������ͻ��桱������Ӧ�÷�������");

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
        throw new Exception("��̬��" + sClassName + "�ļ��س���:" + e.getMessage());
      }
    }
    try
    {
      bo.init(Sqlca, type, sObjectNo, sViewID);
    } catch (Exception ex) {
      ARE.getLog().error("============��ʼ��ҵ�����[" + sObjectType + "]ʱ��������", ex);
      throw ex;
    }
    return bo;
  }
}