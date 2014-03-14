package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ASCodeDefinitionLoader
  implements IConfigLoader
{
  public ASValuePool loadConfig(Transaction Sqlca)
    throws Exception
  {
    ASValuePool vpCodeDefs = new ASValuePool();
    ASResultSet rs = null;
    String sSql = null;
    String sCurCodeNo = "";
    String sLastCodeNo = "--init--";
    ASCodeDefinition codeDef = null;
    String tmpString = null;
    ARE.getLog().info("ASCodeDefinitionLoader Begin ................." + StringFunction.getNow());

    sSql = "select CodeNo,CodeName from CODE_CATALOG";
    rs = Sqlca.getASResultSet2(sSql);
    ARE.getLog().info("ASCodeDefinitionLoader CODE_CATALOG .................." + StringFunction.getNow());
    while (rs.next()) {
      ASCodeDefinition tmpCodeDef = ASDefinitionFactory.getInstance().createCodeDefinition(rs.getString("CodeNo"));

      tmpCodeDef.name = rs.getString("CodeName");
      vpCodeDefs.setAttribute(rs.getString("CodeNo"), tmpCodeDef);
    }
    rs.getStatement().close();

    String[] sKeys = { "CodeNo", "ItemNo", "ItemName", "ItemDescribe", "ItemAttribute", "BankNo", "SortNo", "IsInUse", "RelativeCode", "Attribute1", "Attribute2", "Attribute3", "Attribute4", "Attribute5", "Attribute6", "Attribute7", "Attribute8" };

    sSql = "select CodeNo,ItemNo,ItemName,ItemDescribe,ItemAttribute,BankNo,SortNo,IsInUse,RelativeCode,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Attribute6,Attribute7,Attribute8 from CODE_LIBRARY where IsInUse='1' order by CodeNo,SortNo";
    rs = Sqlca.getASResultSet2(sSql);
    ARE.getLog().info("ASCodeDefinitionLoader CODE_LIBRARY .................." + StringFunction.getNow());
    while (rs.next()) {
      ASValuePool vpTmp = new ASValuePool();
      for (int i = 0; i < sKeys.length; i++) {
        tmpString = rs.getString(sKeys[i]);
        if (tmpString != null)
          vpTmp.setAttribute(sKeys[i], tmpString.trim());
      }
      sCurCodeNo = rs.getString("CodeNo");
      if (!sLastCodeNo.equals(sCurCodeNo)) {
        codeDef = (ASCodeDefinition)vpCodeDefs.getAttribute(sCurCodeNo);

        sLastCodeNo = sCurCodeNo;
      }
      if (codeDef == null)
      {
        continue;
      }
      codeDef.items.add(vpTmp);
    }
    rs.getStatement().close();
    ARE.getLog().info("ASCodeDefinitionLoader End ..................." + StringFunction.getNow());

    ASConfigure.setSysConfig("ASCodeSet", vpCodeDefs);
    return vpCodeDefs;
  }
}