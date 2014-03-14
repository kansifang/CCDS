package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.Transaction;

public class ASCompDefinitionLoader
  implements IConfigLoader
{
  public ASValuePool loadConfig(Transaction Sqlca)
    throws Exception
  {
    ASValuePool vpCompDefs = new ASValuePool();
    String sSql = null;
    String[] sKeys = { "CompID", "CompName", "OrderNo", "CompType", "DefaultPage", "CompURL", "CompPath", "RightID", "InputUser", "InputTime", "UpdateUser", "UpdateTime", "LogSelect", "LogExecute" };

    sSql = "select CompID,CompName,OrderNo,CompType,DefaultPage,CompURL,CompPath,RightID,InputUser,InputTime,UpdateUser,UpdateTime,LogSelect,LogExecute from REG_COMP_DEF";
    String[][] sCompDefs = (String[][])null;
    try {
      sCompDefs = Sqlca.getStringMatrix(sSql, 10000, 20);
    } catch (Exception ex) {
      ARE.getLog().error("执行装载组件缓存时发生错误。请检查组件注册表的表结构是否更新。最后一次添加字段是2006/08/02添加的LogSelect和LogExecute字段。SQL：" + sSql, ex);
      throw ex;
    }
    for (int i = 0; i < sCompDefs.length; i++) {
      ASValuePool vpTmp = StringFunction.convertStringArray2ValuePool(sKeys, sCompDefs[i]);
      ASCompDefinition compDef = (ASCompDefinition)ASDefinitionFactory.getInstance().createDefinition("ASCompSet", vpTmp);
      vpCompDefs.setAttribute(compDef.id, compDef);
    }
    ASConfigure.setSysConfig("ASCompSet", vpCompDefs);
    return vpCompDefs;
  }
}