package com.lmt.baseapp.flow;


import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class FlowObject
{
  public String ObjectType;
  public String ObjectNo;
  public String PhaseType;
  public String ApplyType;
  public String FlowNo;
  public String FlowName;
  public String PhaseNo;
  public String PhaseName;
  public String ObjDescribe;
  public String ObjAttribute1;
  public String ObjAttribute2;
  public String ObjAttribute3;
  public String ObjAttribute4;
  public String ObjAttribute5;
  public String UserID;
  public String UserName;
  public String OrgID;
  public String OrgName;
  public String InputDate;
  public String ArchiveTime;
  public FlowPhase RelativeFlowPhase;
  Transaction Sqlca;

  public FlowObject(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
    this.ObjectType = paramString1;
    this.ObjectNo = paramString2;
    this.Sqlca = paramTransaction;
    String str = "select * from FLOW_OBJECT where ObjectType='" + this.ObjectType + "' and ObjectNo='" + this.ObjectNo + "'";
    ASResultSet localASResultSet = this.Sqlca.getASResultSet(str);
    if (localASResultSet.next())
    {
      this.PhaseType = localASResultSet.getString("PhaseType");
      this.ApplyType = localASResultSet.getString("ApplyType");
      this.FlowNo = localASResultSet.getString("FlowNo");
      this.FlowName = localASResultSet.getString("FlowName");
      this.PhaseNo = localASResultSet.getString("PhaseNo");
      this.PhaseName = localASResultSet.getString("PhaseName");
      this.ObjDescribe = localASResultSet.getString("ObjDescribe");
      this.ObjAttribute1 = localASResultSet.getString("ObjAttribute1");
      this.ObjAttribute2 = localASResultSet.getString("ObjAttribute2");
      this.ObjAttribute3 = localASResultSet.getString("ObjAttribute3");
      this.ObjAttribute4 = localASResultSet.getString("ObjAttribute4");
      this.ObjAttribute5 = localASResultSet.getString("ObjAttribute5");
      this.OrgID = localASResultSet.getString("OrgID");
      this.OrgName = localASResultSet.getString("OrgName");
      this.UserID = localASResultSet.getString("UserID");
      this.UserName = localASResultSet.getString("UserName");
      this.InputDate = localASResultSet.getString("InputDate");
      this.ArchiveTime = localASResultSet.getString("ArchiveTime");
    }
    else
    {
      localASResultSet.getStatement().close();
      throw new FlowException("FlowObject:ObjectType:" + paramString1 + " ObjectNo:" + paramString2 + " not Exist");
    }
    localASResultSet.getStatement().close();
    if ((this.FlowNo != null) && (!this.FlowNo.equals("")))
      this.RelativeFlowPhase = new FlowPhase(this.FlowNo, this.PhaseNo, this.Sqlca);
  }

  public void changePhase(FlowPhase paramFlowPhase, ASUser paramASUser)
    throws Exception
  {
    FlowCatalog localFlowCatalog = new FlowCatalog(paramFlowPhase.FlowNo, this.Sqlca);
    String[][] arrayOfString = { { "#ObjectType", this.ObjectType }, { "#ObjectNo", this.ObjectNo }, { "#ApplyType", this.ApplyType }, { "#PhaseType", paramFlowPhase.PhaseType }, { "#FlowNo", paramFlowPhase.FlowNo }, { "#FlowName", localFlowCatalog.FlowName }, { "#PhaseNo", paramFlowPhase.PhaseNo }, { "#PhaseName", paramFlowPhase.PhaseName }, { "#UserID", paramASUser.UserID }, { "#UserName", paramASUser.UserName }, { "#OrgID", paramASUser.OrgID }, { "#OrgName", paramASUser.BelongOrgName }, { "#LastPhaseType", this.PhaseType }, { "#LastFlowNo", this.FlowNo }, { "#LastFlowName", this.FlowName }, { "#LastPhaseNo", this.PhaseNo }, { "#LastPhaseName", this.PhaseName }, { "#LastPhaseChoice", "" }, { "#LastPhaseAction", "" }, { "#LastBeginTime", "" }, { "#LastEndTime", "" }, { "#LastUserID", "" }, { "#LastUserName", "" }, { "#LastOrgID", "" }, { "#LastOrgName", "" } };
    changePhase(paramFlowPhase, "", arrayOfString);
  }

  public void changePhase(FlowPhase paramFlowPhase, ASUser paramASUser, String paramString)
    throws Exception
  {
    FlowCatalog localFlowCatalog = new FlowCatalog(paramFlowPhase.FlowNo, this.Sqlca);
    String[][] arrayOfString = { { "#ObjectType", this.ObjectType }, { "#ObjectNo", this.ObjectNo }, { "#ApplyType", this.ApplyType }, { "#PhaseType", paramFlowPhase.PhaseType }, { "#FlowNo", paramFlowPhase.FlowNo }, { "#FlowName", localFlowCatalog.FlowName }, { "#PhaseNo", paramFlowPhase.PhaseNo }, { "#PhaseName", paramFlowPhase.PhaseName }, { "#UserID", paramASUser.UserID }, { "#UserName", paramASUser.UserName }, { "#OrgID", paramASUser.OrgID }, { "#OrgName", paramASUser.BelongOrgName }, { "#LastPhaseType", this.PhaseType }, { "#LastFlowNo", this.FlowNo }, { "#LastFlowName", this.FlowName }, { "#LastPhaseNo", this.PhaseNo }, { "#LastPhaseName", this.PhaseName }, { "#LastPhaseChoice", "" }, { "#LastPhaseAction", "" }, { "#LastBeginTime", "" }, { "#LastEndTime", "" }, { "#LastUserID", "" }, { "#LastUserName", "" }, { "#LastOrgID", "" }, { "#LastOrgName", "" } };
    changePhase(paramFlowPhase, paramString, arrayOfString);
  }

  public void changePhase(FlowPhase nextFlowPhase, FlowTask paramFlowTask)
    throws Exception
  {
    FlowCatalog localFlowCatalog = new FlowCatalog(nextFlowPhase.FlowNo, this.Sqlca);
    String[][] arrayOfString = { { "#ObjectType", this.ObjectType }, { "#ObjectNo", this.ObjectNo }, { "#ApplyType", this.ApplyType }, { "#PhaseType", nextFlowPhase.PhaseType }, { "#FlowNo", nextFlowPhase.FlowNo }, { "#FlowName", localFlowCatalog.FlowName }, { "#PhaseNo", nextFlowPhase.PhaseNo }, { "#PhaseName", nextFlowPhase.PhaseName }, { "#PhaseAction", paramFlowTask.PhaseAction }, { "#PhaseOpinion1", paramFlowTask.PhaseOpinion1 }, { "#UserID", paramFlowTask.UserID }, { "#UserName", paramFlowTask.UserName }, { "#OrgID", paramFlowTask.OrgID }, { "#OrgName", paramFlowTask.OrgName }, { "#LastPhaseType", paramFlowTask.PhaseType }, { "#LastFlowNo", paramFlowTask.FlowNo }, { "#LastFlowName", paramFlowTask.FlowName }, { "#LastPhaseNo", paramFlowTask.PhaseNo }, { "#LastPhaseName", paramFlowTask.PhaseName }, { "#LastPhaseChoice", paramFlowTask.PhaseChoice }, { "#LastPhaseAction", paramFlowTask.PhaseAction }, { "#LastPhaseOpinion1", paramFlowTask.PhaseOpinion1 }, { "#LastBeginTime", paramFlowTask.BeginTime }, { "#LastEndTime", paramFlowTask.EndTime }, { "#LastUserID", paramFlowTask.UserID }, { "#LastUserName", paramFlowTask.UserName }, { "#LastOrgID", paramFlowTask.OrgID }, { "#LastOrgName", paramFlowTask.OrgName } };
    changePhase(nextFlowPhase, paramFlowTask.SerialNo, arrayOfString);
  }

  private void changePhase(FlowPhase nextFlowPhase, String OldSerialNo, String[][] paramArrayOfString)
    throws Exception
  {
    String[] arrayOfString = null;
    try
    {
      updatePhase(nextFlowPhase);
    }
    catch (Exception localException1)
    {
      throw new FlowException(localException1.toString() + "更新FlowObject流程阶段发生错误！");
    }
    try
    {
      nextFlowPhase.executeScript("PreScript", paramArrayOfString);
    }
    catch (Exception localException2)
    {
      throw new FlowException(localException2.toString() + "执行prescript发生错误！");
    }
    Any localAny;
    try
    {
      localAny = nextFlowPhase.executeScript("InitScript", paramArrayOfString);
    }
    catch (Exception localException3)
    {
      throw new FlowException(localException3.toString() + "承办人初始化发生错误！");
    }
    if (localAny != null)
      arrayOfString = localAny.toStringArray();//获取的是 下一个阶段的 UserID数组
    if (arrayOfString != null){
      String BeginTime = StringFunction.getToday() + " " + StringFunction.getNow();
      int i = arrayOfString.length;
      for (int j = 0; j < i; j++)
        try{
          String sTaskNo = FlowTask.newTask(OldSerialNo, this.ObjectType, this.ObjectNo, nextFlowPhase.FlowNo, nextFlowPhase.PhaseNo, this.ApplyType, arrayOfString[j], BeginTime, this.Sqlca);
          FlowTask localFlowTask = new FlowTask(sTaskNo, this.Sqlca);
          //只要下一个阶段的postscript为空意味着下个阶段可以自动结束了
          if ((nextFlowPhase.PostScript == null) || (nextFlowPhase.PostScript.equals("")))
        	  localFlowTask.finish(BeginTime, "AutoFinish");
        }
        catch (Exception localException4)
        {
          throw new FlowException(localException4.toString() + "初始化新任务发生错误！");
        }
    }
  }

  public void updatePhase(FlowPhase paramFlowPhase)
    throws Exception
  {
    FlowCatalog localFlowCatalog = new FlowCatalog(paramFlowPhase.FlowNo, this.Sqlca);
    String str = "update FLOW_OBJECT set PhaseType='" + paramFlowPhase.PhaseType + "',FlowNo='" + paramFlowPhase.FlowNo + "',FlowName='" + localFlowCatalog.FlowName + "',PhaseNo='" + paramFlowPhase.PhaseNo + "',PhaseName = '" + paramFlowPhase.PhaseName + "' where ObjectType='" + this.ObjectType + "' and ObjectNo='" + this.ObjectNo + "'";
    this.Sqlca.executeSQL(str);
    this.RelativeFlowPhase = paramFlowPhase;
    this.PhaseType = paramFlowPhase.PhaseType;
    this.FlowNo = paramFlowPhase.FlowNo;
    this.FlowName = localFlowCatalog.FlowName;
    this.PhaseNo = paramFlowPhase.PhaseNo;
    this.PhaseName = paramFlowPhase.PhaseName;
  }

  public void updateDescribe(String paramString)
    throws Exception
  {
    String str = "update FLOW_OBJECT set ObjDescribe='" + paramString + "' where ObjectType='" + this.ObjectType + "' and ObjectNo='" + this.ObjectNo + "'";
    this.Sqlca.executeSQL(str);
    this.ObjDescribe = paramString;
  }

  static void newFlowObject(String paramString1, String paramString2, Transaction paramTransaction)
    throws Exception
  {
  }
}