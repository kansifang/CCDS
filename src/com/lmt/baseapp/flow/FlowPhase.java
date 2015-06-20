package com.lmt.baseapp.flow;

import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.script.Expression;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.biz.workflow:
//            FlowException

public class FlowPhase
{

    public FlowPhase(String s, String s1)
    {
        PreScript = "";
        InitScript = "";
        ChoiceScript = "";
        ActionScript = "";
        PostScript = "";
        FlowNo = s;
        PhaseNo = s1;
    }

    public FlowPhase(String s, String s1, String s2)
    {
        PreScript = "";
        InitScript = "";
        ChoiceScript = "";
        ActionScript = "";
        PostScript = "";
        FlowNo = s;
        PhaseNo = s1;
        Tips = s2;
    }

    public FlowPhase(String s, String s1, Transaction transaction)
        throws Exception
    {
        PreScript = "";
        InitScript = "";
        ChoiceScript = "";
        ActionScript = "";
        PostScript = "";
        initFlowPhase(s, s1, "", transaction);
    }

    public FlowPhase(String s, String s1, String s2, Transaction transaction)
        throws Exception
    {
        PreScript = "";
        InitScript = "";
        ChoiceScript = "";
        ActionScript = "";
        PostScript = "";
        initFlowPhase(s, s1, s2, transaction);
    }

    public void initFlowPhase(String s, String s1, String s2, Transaction transaction)
        throws Exception
    {
        FlowNo = s;
        PhaseNo = s1;
        Tips = s2;
        Sqlca = transaction;
        ASResultSet asresultset = Sqlca.getASResultSet("select FLOW_MODEL.* from FLOW_MODEL where FlowNo='" + s + "' and PhaseNo='" + s1 + "'");
        if(asresultset.next())
        {
            PhaseType = asresultset.getString("PhaseType");
            PhaseName = asresultset.getString("PhaseName");
            PhaseDescribe = asresultset.getString("PhaseDescribe");
            PhaseAttribute = asresultset.getString("PhaseAttribute");
            PreScript = asresultset.getString("PreScript");
            InitScript = asresultset.getString("InitScript");
            ChoiceDescribe = asresultset.getString("ChoiceDescribe");
            ChoiceScript = asresultset.getString("ChoiceScript");
            ActionDescribe = asresultset.getString("ActionDescribe");
            ActionScript = asresultset.getString("ActionScript");
            PostScript = asresultset.getString("PostScript");
        } else
        {
            asresultset.getStatement().close();
            throw new FlowException("FlowPhase:FlowNo:" + s + " PhaseNo:" + s1 + " not Exist");
        }
        asresultset.getStatement().close();
    }

    public boolean equals(FlowPhase flowphase)
    {
        if(flowphase == null)
            return false;
        return FlowNo.equalsIgnoreCase(flowphase.FlowNo) && PhaseNo.equalsIgnoreCase(flowphase.PhaseNo);
    }

    public Any executeScript(String s, String as[][])
        throws Exception
    {
        String s1 = null;
        Object obj = null;
        if(s.equalsIgnoreCase("PreScript"))
            s1 = PreScript;
        else
        if(s.equalsIgnoreCase("InitScript"))
            s1 = InitScript;
        else
        if(s.equalsIgnoreCase("ChoiceDescribe"))
            s1 = ChoiceDescribe;
        else
        if(s.equalsIgnoreCase("ChoiceScript"))
            s1 = ChoiceScript;
        else
        if(s.equalsIgnoreCase("ActionDescribe"))
            s1 = ActionDescribe;
        else
        if(s.equalsIgnoreCase("ActionScript"))
            s1 = ActionScript;
        else
        if(s.equalsIgnoreCase("PostScript"))
            s1 = PostScript;
        else
            new FlowException("FlowPhase.executeScript():ScriptType:" + s + " not Exist");
        if(s1 != null && !s1.equals("") && s1.trim().length() > 0)
        {
            Any any;
            try
            {
                s1 = Expression.pretreatConstant(s1, as);
                any = Expression.getExpressionValue(s1, Sqlca);
            }
            catch(Exception exception)
            {
                throw new Exception(exception.toString() + " " + s + "\u5B9A\u4E49\u9519\u8BEF\uFF01" + s + ":" + s1);
            }
            if(any==null){
            	throw new Exception("没有找到被提交角色的用户！");
            }
            return any;
        } else
        {
            return null;
        }
    }

    public String FlowNo;
    public String PhaseNo;
    public String PhaseType;
    public String PhaseName;
    public String PhaseDescribe;
    public String PhaseAttribute;
    public String PreScript;
    public String InitScript;
    public String ChoiceDescribe;
    public String ChoiceScript;
    public String ActionDescribe;
    public String ActionScript;
    public String PostScript;
    public String Tips;
    public Transaction Sqlca;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\workspace\ALS6\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 0 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/