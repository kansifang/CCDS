package com.lmt.app.object;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.dal.IConfigLoader;
import com.lmt.frameapp.sql.Transaction;

public class BizObjectTypeDefinitionLoader
  implements IConfigLoader
{
  public ASValuePool loadConfig(Transaction Sqlca)
    throws Exception
  {
    ASValuePool vpCLTypeDef = null;
    String sCLTypeKey = null;
    BizObjectType tmpType = null;

    vpCLTypeDef = new ASValuePool();
    String[] sKeys = { "ObjectType", "ObjectName", "SortNo", "TreeCode", "PagePath", "ObjectAttribute", "ObjectTable", "KeyCol", "KeyColName", "ViewType", "DefaultView", "RightType", "UsageDescribe", "Attribute1", "Attribute2", "Attribute3", "InputOrg", "InputUser", "InputTime", "UpdateUser", "UpdateTime", "Remark", "RelativeTable", "ObjectColAttribute", "CatalogSQL" };

    StringBuffer sbSelect = new StringBuffer("");
    sbSelect.append("select ");
    for (int i = 0; i < sKeys.length; i++) sbSelect.append(sKeys[i] + ",");
    sbSelect.deleteCharAt(sbSelect.length() - 1);
    sbSelect.append(" from OBJECTTYPE_CATALOG ");

    String[][] sValueMatrix = Sqlca.getStringMatrix(sbSelect.toString());
    for (int i = 0; i < sValueMatrix.length; i++) {
      sCLTypeKey = sValueMatrix[i][0];
      tmpType = new BizObjectType();
      for (int j = 0; j < sValueMatrix[i].length; j++) {
        tmpType.setAttribute(sKeys[j], sValueMatrix[i][j]);
      }
      tmpType.id = sValueMatrix[i][0];
      tmpType.name = sValueMatrix[i][1];
      vpCLTypeDef.setAttribute(sCLTypeKey, tmpType, false);
    }

    ASConfigure.setSysConfig("SYSCONF_BO_TYPE", vpCLTypeDef);
    return vpCLTypeDef;
  }
}