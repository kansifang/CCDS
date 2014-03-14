package com.lmt.baseapp.user;

import java.io.Serializable;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.MessageDigest;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.dal.ASRoleDefinition;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ASUser
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String UserID;
  public String UserName;
  public String OrgID;
  public String BelongOrgName;
  public String Status;
  public String Password;
  public String FormerPassword;
  public ASOrg BelongOrg;
  public ASValuePool rights = new ASValuePool();
  public ASValuePool roles = new ASValuePool();
  public String BelongLOB = null;

  public ASUser(String paramString, Transaction paramTransaction)
    throws Exception
  {
    initUser(paramString, paramTransaction);
  }

  public ASUser(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    this.FormerPassword = paramString2;
    initUser(paramString1, paramTransaction);
    if (!this.Password.equalsIgnoreCase(MessageDigest.getDigestAsUpperHexString("MD5", paramString2)))
      throw new ASUserException("ASUser Constructor : User " + paramString1 + " Password Error");
  }

  public void initUser(String paramString, Transaction paramTransaction)
    throws Exception
  {
    ASValuePool localLSValuePool1 = ASConfigure.getSysConfig("ASRoleSet", paramTransaction);
    String str1 = "select * from USER_INFO where UserID = '" + paramString + "' and Status='1'";
    ASResultSet localLSResultSet = paramTransaction.getASResultSet(str1);
    if (localLSResultSet.next())
    {
      this.UserID = localLSResultSet.getString("UserID");
      this.UserName = localLSResultSet.getString("UserName");
      this.OrgID = localLSResultSet.getString("BelongOrg");
      this.Status = localLSResultSet.getString("Status");
      this.Password = localLSResultSet.getString("Password");
      try
      {
        this.BelongLOB = localLSResultSet.getString("LOB");
      }
      catch (Exception localException)
      {
        ARE.getLog().error("没有在USER_INFO表中定义LOB（业务条线）字段。", localException);
      }
      this.BelongOrg = new ASOrg(localLSResultSet.getString("BelongOrg"), paramTransaction);
      this.BelongOrgName = this.BelongOrg.OrgName;
    }
    else
    {
      throw new ASUserException("用户[" + paramString + "]不存在！");
    }
    localLSResultSet.getStatement().close();
    str1 = "select RightID from USER_RIGHT where UserID = '" + paramString + "' and Status='1'";
    localLSResultSet = paramTransaction.getASResultSet2(str1);
    while (localLSResultSet.next())
      this.rights.setAttribute(localLSResultSet.getString("RightID"), null);
    localLSResultSet.getStatement().close();
    this.roles.setAttribute("800", null);
    Object localObject = localLSValuePool1.getAttribute("800");
    if (localObject == null)
      throw new Exception("没有定义的角色：800");
    ASValuePool localLSValuePool2 = ((ASRoleDefinition)localObject).rights;
    this.rights.uniteFromValuePool(localLSValuePool2);
    str1 = "select RoleID from USER_ROLE where UserID = '" + paramString + "' and Status='1' order by RoleID";
    localLSResultSet = paramTransaction.getASResultSet(str1);
    while (localLSResultSet.next())
    {
      String str2 = localLSResultSet.getString("RoleID");
      if (str2 == null)
        str2 = "";
      if ("800".equals(str2))
        continue;
      this.roles.setAttribute(str2, null);
    }
    localLSResultSet.getStatement().close();
  }

  public void changePassword(String paramString, Transaction paramTransaction)
    throws Exception
  {
    this.FormerPassword = paramString;
    this.Password = MessageDigest.getDigestAsUpperHexString("MD5",paramString);
    paramTransaction.executeSQL("update USER_INFO set Password='" + this.Password + "' where UserID='" + this.UserID + "'");
  }

  public boolean hasRole(String paramString)
    throws Exception
  {
    return this.roles.containsKey(paramString);
  }

  public boolean hasRole(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    ASResultSet localLSResultSet = paramTransaction.getASResultSet("select count(*) from USER_ROLE where UserID = '" + this.UserID + "' and RoleID='" + paramString1 + "' and Grantor='" + paramString2 + "'and Status='1'");
    localLSResultSet.next();
    int i = localLSResultSet.getInt(1);
    localLSResultSet.getStatement().close();
    return i > 0;
  }

  public boolean hasRight(String paramString)
    throws Exception
  {
    if (this.rights.containsKey(paramString))
      return true;
    Object[] arrayOfObject = this.roles.getKeys();
    for (int i = 0; i < arrayOfObject.length; i++)
    {
      String str = (String)arrayOfObject[i];
      ASValuePool localLSValuePool = (ASValuePool)ASConfigure.getSysConfig("ASRoleSet");
      ASRoleDefinition localASRoleDefinition = (ASRoleDefinition)localLSValuePool.getAttribute(str);
      if (localASRoleDefinition == null)
        throw new Exception("当前用户拥有一个没有定义的角色：" + str + "，请检查角色定义（ROLE_INFO）");
      if (localASRoleDefinition.rights.containsKey(paramString))
        return true;
    }
    return false;
  }

  public boolean grantRoleTo(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    ASUser localASUser = new ASUser(paramString1, paramTransaction);
    if (hasRole(paramString2))
    {
      String str = StringFunction.getToday() + " " + StringFunction.getNow();
      localASUser.addRole(paramString2, this.UserID, str, "", "1", paramTransaction);
      setRoleStatus(paramString2, "0", paramTransaction);
    }
    else
    {
      return false;
    }
    return true;
  }

  public boolean revokeRoleFrom(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    ASUser localASUser = new ASUser(paramString1, paramTransaction);
    if (localASUser.hasRole(paramString2, this.UserID, paramTransaction))
    {
      String str = StringFunction.getToday() + " " + StringFunction.getNow();
      localASUser.setRoleStatus(paramString2, this.UserID, "0", paramTransaction);
      localASUser.setRoleEndTime(paramString2, str, paramTransaction);
      setRoleStatus(paramString2, "1", paramTransaction);
    }
    else
    {
      return false;
    }
    return true;
  }

  public boolean addRole(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5, Transaction paramTransaction)
    throws Exception
  {
    paramTransaction.executeSQL("insert into USER_ROLE (UserID,RoleID,Grantor,BeginTime,EndTime,Status) values('" + this.UserID + "','" + paramString1 + "','" + paramString2 + "','" + paramString3 + "','" + paramString4 + "','" + paramString5 + "')");
    return true;
  }

  public boolean setRoleStatus(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    paramTransaction.executeSQL("update USER_ROLE set Status='" + paramString2 + "' where UserID='" + this.UserID + "' and RoleID='" + paramString1 + "' and (length(EndTime)=0 or EndTime is null)");
    return true;
  }

  public boolean setRoleStatus(String paramString1, String paramString2, String paramString3, Transaction paramTransaction)
    throws Exception
  {
    paramTransaction.executeSQL("update USER_ROLE set Status='" + paramString3 + "' where UserID='" + this.UserID + "' and RoleID='" + paramString1 + "' and Grantor='" + paramString2 + "' and (length(EndTime)=0 or EndTime is null) ");
    return true;
  }

  public boolean setRoleEndTime(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    paramTransaction.executeSQL("update USER_ROLE set EndTime='" + paramString2 + "' where UserID='" + this.UserID + "' and RoleID='" + paramString1 + "'  and (length(EndTime)=0 or EndTime is null) ");
    return true;
  }

  public void addLog(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    String str = StringFunction.getToday() + " " + StringFunction.getNow();
    paramTransaction.executeSQL("insert into SYSTEM_LOG (OccurTime,OrgID,UserID,EventType,OrgName,UserName,EventDescribe) values('" + str + "','" + this.BelongOrg.OrgID + "','" + this.UserID + "','" + paramString1 + "','" + this.BelongOrg.OrgName + "','" + this.UserName + "','" + paramString2 + "')");
  }

  public void addLog(String paramString1, String paramString2)
    throws Exception
  {
    throw new Exception("本方法已经被 addLog(String sEventType,String sEventDescribe,Transaction transSql)替代，请使用新方法。(byhu20040821)");
  }

  public boolean canUpdateBusiness(String paramString, Transaction paramTransaction)
    throws Exception
  {
    boolean i = false;
    int j = 1;
    ASResultSet localLSResultSet = null;
    String str1 = "";
    String str2 = "";
    String str3 = "";
    str1 = "select count(*) from APPLY_RELATIVE where BusinessNo='" + paramString + "'";
    localLSResultSet = paramTransaction.getASResultSet(str1);
    while (localLSResultSet.next())
      j = localLSResultSet.getInt(1);
    localLSResultSet.getStatement().close();
    if (j > 1)
      return false;
    if (j == 1)
    {
      str1 = " select F.PhaseType,A.UserID from APPLY_INFO A,APPLY_RELATIVE R,FLOW_MODEL F  where R.ApplyNo=A.ApplyNo and R.BusinessNo='" + paramString + "' " + " and A.ApplyFlow=F.FlowNo and A.ApplyPhase=F.PhaseNo ";
      localLSResultSet = paramTransaction.getASResultSet(str1);
      while (localLSResultSet.next())
      {
        str2 = DataConvert.toString(localLSResultSet.getString("PhaseType"));
        str3 = DataConvert.toString(localLSResultSet.getString("UserID"));
      }
      localLSResultSet.getStatement().close();
      i = ((str2.equals("0")) || (str2.equals("4"))) && (this.UserID.equals(str3)) ? true : false;
      return i;
    }
    return true;
  }

  public boolean canUpdateApply(String paramString, Transaction paramTransaction)
    throws Exception
  {
    boolean bool = false;
    String str1 = "";
    String str2 = "";
    ASResultSet localLSResultSet = null;
    String str3 = "";
    str3 = " select F.PhaseType,A.UserID from APPLY_INFO A,FLOW_MODEL F  where ApplyNo='" + paramString + "' and A.ApplyFlow=F.FlowNo and A.ApplyPhase=F.PhaseNo ";
    localLSResultSet = paramTransaction.getASResultSet(str3);
    while (localLSResultSet.next())
    {
      str1 = DataConvert.toString(localLSResultSet.getString("PhaseType"));
      str2 = DataConvert.toString(localLSResultSet.getString("UserID"));
    }
    localLSResultSet.getStatement().close();
    bool = ((str1.equals("0")) || (str1.equals("4"))) && (this.UserID.equals(str2));
    ARE.getLog().debug(str1 + ";" + str2 + ";" + bool);
    return bool;
  }

  public void setTransaction(Transaction paramTransaction)
    throws Exception
  {
  }
}