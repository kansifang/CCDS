package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ASRoleDefinitionLoader
  implements IConfigLoader
{
  public ASValuePool loadConfig(Transaction Sqlca)
    throws Exception
  {
    ASValuePool roleDefinitions = new ASValuePool();

    String sTmpRoleID = null;
    String sSql = null;
    ASResultSet rs = null;

    sSql = "select RoleID,RoleName,RoleStatus from ROLE_INFO order by RoleID";
    rs = Sqlca.getASResultSet(sSql);
    while (rs.next()) {
      String sRoleID = rs.getString("RoleID");
      ASRoleDefinition tmpRoleDef = (ASRoleDefinition)ASDefinitionFactory.getInstance().createDefinition("ASRoleSet", sRoleID);
      tmpRoleDef.name = rs.getString("RoleName");
      roleDefinitions.setAttribute(rs.getString("RoleID"), tmpRoleDef);
    }
    rs.getStatement().close();

    sSql = "select RoleID,RightID from ROLE_RIGHT order by RoleID";
    rs = Sqlca.getASResultSet2(sSql);
    while (rs.next()) {
      sTmpRoleID = rs.getString("RoleID");
      Object sTmpObj = roleDefinitions.getAttribute(sTmpRoleID);
      if (sTmpObj == null) throw new Exception("ROLE_RIGHT中出现了没有定义的RightID。");
      ASRoleDefinition tmpRoleDef = (ASRoleDefinition)sTmpObj;
      tmpRoleDef.rights.setAttribute(rs.getString("RightID"), null);
    }
    rs.getStatement().close();

    ASConfigure.setSysConfig("ASRoleSet", roleDefinitions);
    return roleDefinitions;
  }
}