package com.lmt.baseapp.flow;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class FlowTask
{

    public FlowTask(String s, Transaction transaction)
        throws Exception
    {
        SerialNo = s;
        Sqlca = transaction;
        ASResultSet asresultset = Sqlca.getASResultSet("select FLOW_TASK.* from FLOW_TASK where SerialNo='" + s + "'");
        if(asresultset.next())
        {
            RelativeSerialNo = asresultset.getString("RelativeSerialNo");
            ObjectType = asresultset.getString("ObjectType");
            ObjectNo = asresultset.getString("ObjectNo");
            FlowNo = asresultset.getString("FlowNo");
            FlowName = asresultset.getString("FlowName");
            PhaseNo = asresultset.getString("PhaseNo");
            PhaseName = asresultset.getString("PhaseName");
            PhaseType = asresultset.getString("PhaseType");
            ApplyType = asresultset.getString("ApplyType");
            UserID = asresultset.getString("UserID");
            UserName = asresultset.getString("UserName");
            OrgID = asresultset.getString("OrgID");
            OrgName = asresultset.getString("OrgName");
            BeginTime = asresultset.getString("BeginTime");
            EndTime = asresultset.getString("EndTime");
            PhaseChoice = asresultset.getString("PhaseChoice");
            PhaseAction = asresultset.getString("PhaseAction");
            PhaseOpinion = asresultset.getString("PhaseOpinion");
            PhaseOpinion1 = asresultset.getString("PhaseOpinion1");
            PhaseOpinion2 = asresultset.getString("PhaseOpinion2");
            PhaseOpinion3 = asresultset.getString("PhaseOpinion3");
            PhaseOpinion4 = asresultset.getString("PhaseOpinion4");
        } else
        {
            asresultset.getStatement().close();
            throw new FlowException("FlowTask:SerialNo:'" + s + "' not Exist");
        }
        asresultset.getStatement().close();
        RelativeFlowPhase = new FlowPhase(FlowNo, PhaseNo, Sqlca);
        RelativeFlowObject = new FlowObject(ObjectType, ObjectNo, Sqlca);
    }
    //逻辑是一切以RelativeFlowObject.RelativeFlowPhase为准
    //FlowTask仅仅完成当前阶段
    //FlowObject则负责指向下一阶段及在数据库中初始化下一阶段task
    public FlowPhase commitAction(String s) throws Exception{
        String s1 = StringFunction.getToday() + " " + StringFunction.getNow();
        FlowPhase flowphase;
        if(!RelativeFlowPhase.equals(RelativeFlowObject.RelativeFlowPhase))
        {
            finish(s1, s);
            flowphase = RelativeFlowObject.RelativeFlowPhase;
        } else{
            flowphase = getNextFlowPhase(s);
            if(flowphase != null && !flowphase.PhaseNo.equals(""))
                if(RelativeFlowPhase.equals(flowphase))
                {
                    finish(s1, s);
                } else
                {
                    finish(s1, s);
                    RelativeFlowObject.changePhase(flowphase, this);
                }
        }
        return flowphase;
    }

    public FlowPhase commitAction(String PhaseAction, String PhaseOpinion1)
        throws Exception
    {
        String EndTime = StringFunction.getToday() + " " + StringFunction.getNow();
        FlowPhase flowphase;
        //流程当前阶段与指针所指向的阶段不一致，只完成当前阶段，返回指针指向阶段作为下一阶段
        if(!RelativeFlowPhase.equals(RelativeFlowObject.RelativeFlowPhase)){
            finish(EndTime, PhaseAction, PhaseOpinion1);
            flowphase = RelativeFlowObject.RelativeFlowPhase;
        }else{
            flowphase = getNextFlowPhase(PhaseAction, PhaseOpinion1);
            if(flowphase != null && !flowphase.PhaseNo.equals("")){
	        	 //流程当前阶段和配置的下一阶段一致或者当前阶段存在多个处理人时，只完成本阶段task即可
	        	 if(RelativeFlowPhase.equals(flowphase)||this.getComradeTaskCount()>0){
	                 finish(EndTime, PhaseAction, PhaseOpinion1);
	             }else{
	                 finish(EndTime, PhaseAction, PhaseOpinion1);
	                 RelativeFlowObject.changePhase(flowphase, this);
	             }
            }
        }
        return flowphase;
    }

    public FlowPhase getNextFlowPhase(String s)
        throws Exception
    {
        FlowPhase flowphase = null;
        String as[][] = getConstantList();
        StringFunction.setAttribute(as, "#PhaseAction", "'" + s + "'");
        String s1 = RelativeFlowPhase.executeScript("PostScript", as).toStringValue();
        if(s1 != null && s1.trim().length() > 0)
        {
            s1 = s1.trim();
            String s4 = StringFunction.getSeparate(s1, " ", 2);
            s1 = StringFunction.getSeparate(s1, " ", 1);
            String sFlowNo = StringFunction.getSeparate(s1, ".", 1);
            String s3 = StringFunction.getSeparate(s1, ".", 2);
            if(sFlowNo.equalsIgnoreCase("Null"))
            {
                s3 = "Null";
                flowphase = new FlowPhase(sFlowNo, s3, s4);
            } else
            {
                if(s3.equals(""))
                {
                    s3 = sFlowNo;
                    sFlowNo = FlowNo;
                }
                flowphase = new FlowPhase(sFlowNo, s3, s4, Sqlca);
            }
        }
        return flowphase;
    }

    public FlowPhase getNextFlowPhase(String PhaseAction, String PhaseOpinion1)
        throws Exception
    {
        FlowPhase flowphase = null;
        String as[][] = getConstantList();
        StringFunction.setAttribute(as, "#PhaseAction", "'" + PhaseAction + "'");
        StringFunction.setAttribute(as, "#PhaseOpinion1", "'" + PhaseOpinion1 + "'");
        String s2 = RelativeFlowPhase.executeScript("PostScript", as).toStringValue();
        if(s2 != null && s2.trim().length() > 0)
        {
            s2 = s2.trim();
            String s3 = StringFunction.getSeparate(s2, " ", 2);
            s2 = StringFunction.getSeparate(s2, " ", 1);
            String sFlowNo = StringFunction.getSeparate(s2, ".", 1);
            String sPhaseNo = StringFunction.getSeparate(s2, ".", 2);
            if(sFlowNo.equalsIgnoreCase("Null"))
            {
                sPhaseNo = "Null";
                flowphase = new FlowPhase(sFlowNo, sPhaseNo, s3);
            } else
            {
                if(sPhaseNo.equals(""))
                {
                    sPhaseNo = sFlowNo;
                    sFlowNo = FlowNo;
                }
                flowphase = new FlowPhase(sFlowNo, sPhaseNo, s3, Sqlca);
            }
        }
        return flowphase;
    }

    public void finish(String s, String s1)
        throws Exception
    {
        EndTime = s;
        PhaseAction = s1;
        Sqlca.executeSQL("update FLOW_TASK set EndTime='" + s + "',PhaseAction='" + s1 + "' where SerialNo='" + SerialNo + "'");
    }

    private void finish(String s, String s1, String s2)
        throws Exception
    {
        EndTime = s;
        PhaseAction = s1;
        PhaseOpinion1 = s2;
        Sqlca.executeSQL("update FLOW_TASK set EndTime='" + s + "',PhaseAction='" + s1 + "',PhaseOpinion1='" + s2 + "'  where SerialNo='" + SerialNo + "'");
    }

    public ReturnMessage cancel(ASUser asuser)
        throws Exception
    {
        if(EndTime != null && !EndTime.trim().equals(""))
            return new ReturnMessage(-1, "\u5DF2\u63D0\u4EA4\u7684\u4EFB\u52A1\u4E0D\u80FD\u9000\u56DE");
        if(RelativeSerialNo == null || RelativeSerialNo.trim().equals(""))
            return new ReturnMessage(-2, "\u65E0\u7236\u4EFB\u52A1\u4E0D\u80FD\u9000\u56DE");
        FlowTask flowtask = new FlowTask(RelativeSerialNo, Sqlca);
        if(flowtask.getChildTaskCount() > 1)
        {
            return new ReturnMessage(-3, "\u672C\u9636\u6BB5\u8FD8\u6709\u5176\u4ED6\u627F\u529E\u4EBA,\u4E0D\u80FD\u9000\u56DE");
        } else
        {
            flowtask.finish("", "");
            RelativeFlowObject.updatePhase(flowtask.RelativeFlowPhase);
            deleteTask(SerialNo, Sqlca);
            asuser.addLog("\u6D41\u7A0B\u4EFB\u52A1\u9000\u56DE", "\u5C06" + UserName + "\u4E8E" + BeginTime + "\u6536\u5230\u7684" + PhaseName + "\u4EFB\u52A1\u9000\u56DE\u5230" + flowtask.UserName + "\u7ECF\u529E\u7684" + flowtask.PhaseName + "\u9636\u6BB5\uFF0C\u6D41\u6C34\u53F7\u4E3A" + flowtask.SerialNo, Sqlca);
            return new ReturnMessage(0, "\u9000\u56DE\u5B8C\u6210");
        }
    }

    public ReturnMessage takeBack(ASUser asuser)
        throws Exception
    {
        int i = 0;
        ASResultSet asresultset = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '" + SerialNo + "'and " + "((EndTime is not null) or (PhaseChoice is not null) or (PhaseOpinion1 is not null) " + " or (PhaseOpinion2 is not null) or (PhaseOpinion3 is not null) or (UserID ='system'))");
        if(asresultset.next())
            i = asresultset.getInt(1);
        asresultset.getStatement().close();
        if(i > 0)
        {
            return new ReturnMessage(-1, "\u4E0B\u9636\u6BB5\u4EFB\u52A1\u5DF2\u63D0\u4EA4\u6216\u5DF2\u7B7E\u7F72\u610F\u89C1\uFF0C\u4E0D\u80FD\u6536\u56DE");
        } else
        {
            int j = getChildTaskCount();
            asuser.addLog("\u6D41\u7A0B\u4EFB\u52A1\u6536\u56DE", "\u5C06" + UserName + "\u4E8E" + EndTime + "\u63D0\u4EA4\u7684" + PhaseName + "\u4EFB\u52A1\u91CD\u65B0\u6536\u56DE,\u540C\u65F6\u64A4\u9500\u5B50\u4EFB\u52A1" + j + "\u4EF6", Sqlca);
            Sqlca.executeSQL("delete from FLOW_TASK where RelativeSerialNo = '" + SerialNo + "'");
            finish("", "");
            RelativeFlowObject.updatePhase(RelativeFlowPhase);
            return new ReturnMessage(0, "\u6536\u56DE\u5B8C\u6210");
        }
    }

    public int getChildTaskCount()
        throws Exception
    {
        int i = 0;
        ASResultSet asresultset = Sqlca.getASResultSet("select count(*) from FLOW_TASK where RelativeSerialNo = '" + SerialNo + "'");
        if(asresultset.next())
            i = asresultset.getInt(1);
        asresultset.getStatement().close();
        return i;
    }
    public int getComradeTaskCount() throws Exception{
        int i = 0;
        String sSql="select count(1) from FLOW_TASK " +
					" where ObjectType='"+this.ObjectType+"'" +
					" and ObjectNo = '" + this.ObjectNo + "'" +
					" and RelativeSerialNo = '" + this.RelativeSerialNo + "'" +
					" and SerialNo<>'"+this.SerialNo+"'" +
					" and nvl(EndTime,'')='' ";
        ASResultSet asresultset = Sqlca.getASResultSet(sSql);
        if(asresultset.next()){
        	i = asresultset.getInt(1);
        }
        asresultset.getStatement().close();
        return i;
    }
    public String getChoiceDescribe()
        throws Exception
    {
        return RelativeFlowPhase.executeScript("ChoiceDescribe", getConstantList()).toStringValue();
    }

    public String getActionDescribe()
        throws Exception
    {
        return RelativeFlowPhase.executeScript("ActionDescribe", getConstantList()).toStringValue();
    }

    public String[] getChoiceList()
        throws Exception
    {
        Any any;
        try
        {
            any = RelativeFlowPhase.executeScript("ChoiceScript", getConstantList());
        }
        catch(Exception exception)
        {
            throw new FlowException(exception.toString() + " \u53D6\u610F\u89C1\u5217\u8868\u51FA\u9519\uFF01");
        }
        if(any == null)
        {
            return null;
        } else
        {
            String as[] = any.toStringArray();
            return as;
        }
    }

    public String[] getActionList()
        throws Exception
    {
        Any any = null;
        String as[] = null;
        any = RelativeFlowPhase.executeScript("ActionScript", getConstantList());
        if(any != null)
            as = any.toStringArray();
        return as;
    }

    public String[] getActionList(String s) throws Exception{
        String as[][] = getConstantList();
        StringFunction.setAttribute(as, "#PhaseOpinion1", "'" + s + "'");
        return RelativeFlowPhase.executeScript("ActionScript", as).toStringArray();
    }

    public String[][] getConstantList()
        throws Exception
    {
        Object obj = null;
        String as[][] = {
            {
                "#SerialNo", SerialNo
            }, {
                "#ObjectType", ObjectType
            }, {
                "#ObjectNo", ObjectNo
            }, {
                "#FlowNo", FlowNo
            }, {
                "#FlowName", FlowName
            }, {
                "#PhaseNo", PhaseNo
            }, {
                "#PhaseName", PhaseName
            }, {
                "#PhaseType", PhaseType
            }, {
                "#ApplyType", ApplyType
            }, {
                "#PhaseChoice", PhaseChoice
            }, {
                "#PhaseAction", PhaseAction
            }, {
                "#PhaseOpinion1", PhaseOpinion1
            }, {
                "#BeginTime", BeginTime
            }, {
                "#EndTime", EndTime
            }, {
                "#UserID", UserID
            }, {
                "#UserName", UserName
            }, {
                "#OrgID", OrgID
            }, {
                "#OrgName", OrgName
            }, {
                "#LastFlowNo", ""
            }, {
                "#LastFlowName", ""
            }, {
                "#LastPhaseNo", ""
            }, {
                "#LastPhaseName", ""
            }, {
                "#LastPhaseType", ""
            }, {
                "#LastApplyType", ""
            }, {
                "#LastPhaseChoice", ""
            }, {
                "#LastPhaseAction", ""
            }, {
                "#LastBeginTime", ""
            }, {
                "#LastEndTime", ""
            }, {
                "#LastUserID", ""
            }, {
                "#LastUserName", ""
            }, {
                "#LastOrgID", ""
            }, {
                "#LastOrgName", ""
            }
        };
        if(RelativeSerialNo != null && !RelativeSerialNo.equals(""))
        {
            FlowTask flowtask = new FlowTask(RelativeSerialNo, Sqlca);
            StringFunction.setAttribute(as, "#LastFlowNo", flowtask.FlowNo);
            StringFunction.setAttribute(as, "#LastFlowName", flowtask.FlowName);
            StringFunction.setAttribute(as, "#LastPhaseNo", flowtask.PhaseNo);
            StringFunction.setAttribute(as, "#LastPhaseName", flowtask.PhaseName);
            StringFunction.setAttribute(as, "#LastPhaseType", flowtask.PhaseType);
            StringFunction.setAttribute(as, "#LastApplyType", flowtask.ApplyType);
            StringFunction.setAttribute(as, "#LastPhaseChoice", flowtask.PhaseChoice);
            StringFunction.setAttribute(as, "#LastPhaseAction", flowtask.PhaseAction);
            StringFunction.setAttribute(as, "#LastBeginTime", flowtask.BeginTime);
            StringFunction.setAttribute(as, "#LastEndTime", flowtask.EndTime);
            StringFunction.setAttribute(as, "#LastUserID", flowtask.UserID);
            StringFunction.setAttribute(as, "#LastUserName", flowtask.UserName);
            StringFunction.setAttribute(as, "#LastOrgID", flowtask.OrgID);
            StringFunction.setAttribute(as, "#LastOrgName", flowtask.OrgName);
        }
        return as;
    }

    public static String newTask(String RelativeSerialNo, String ObjectType, String ObjectNo, String FlowNo, String PhaseNo, String s5, String UserID, String BeginTime, 
            Transaction transaction)
        throws Exception
    {
        String UserName = transaction.getString("select UserName from USER_INFO where UserID = '" + UserID + "'");
        String OrgID = transaction.getString("select BelongOrg from USER_INFO where UserID = '" + UserID + "'");
        String OrgName = transaction.getString("select OrgName from ORG_INFO where OrgID = '" + OrgID + "'");
        FlowPhase flowphase = new FlowPhase(FlowNo, PhaseNo, transaction);
        String PhaseName = flowphase.PhaseName;
        String PhaseType = flowphase.PhaseType;
        FlowCatalog flowcatalog = new FlowCatalog(FlowNo, transaction);
        String FlowName = flowcatalog.FlowName;
        String SerialNo = DBFunction.getSerialNo("FLOW_TASK", "SerialNo", transaction);
        String s15 = "INSERT INTO FLOW_TASK(SerialNo,RelativeSerialNo,ObjectType,ObjectNo,FlowNo,FlowName,PhaseNo,PhaseName,PhaseType,ApplyType,BeginTime,EndTime,UserID,UserName,OrgID,OrgName,PhaseChoice,PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3,PhaseAction) VALUES ( '" + SerialNo + "','" + RelativeSerialNo + "','" + ObjectType + "','" + ObjectNo + "','" + FlowNo + "','" + FlowName + "','" + PhaseNo + "','" + PhaseName + "','" + PhaseType + "','" + s5 + "','" + BeginTime + "',null,'" + UserID + "','" + UserName + "','" + OrgID + "','" + OrgName + "',null,null,null,null,null,null)";
        transaction.executeSQL(s15);
        return SerialNo;
    }

    public static void deleteTask(String s, Transaction transaction)
        throws Exception
    {
        String s1 = "delete from  FLOW_TASK where SerialNo= '" + s + "'";
        transaction.executeSQL(s1);
    }

    public String SerialNo;
    public String RelativeSerialNo;
    public String ObjectType;
    public String ObjectNo;
    public String FlowNo;
    public String PhaseNo;
    public String PhaseType;
    public String ApplyType;
    public String UserID;
    public String OrgID;
    public String BeginTime;
    public String EndTime;
    public String PhaseAction;
    public String FlowName;
    public String UserName;
    public String OrgName;
    public String PhaseName;
    public String PhaseChoice;
    public String PhaseOpinion;
    public String PhaseOpinion1;
    public String PhaseOpinion2;
    public String PhaseOpinion3;
    public String PhaseOpinion4;
    public FlowPhase RelativeFlowPhase;
    public FlowObject RelativeFlowObject;
    Transaction Sqlca;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\workspace\ALS6\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 31 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/