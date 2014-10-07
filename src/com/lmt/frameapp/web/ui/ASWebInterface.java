
package com.lmt.frameapp.web.ui;

import com.lmt.frameapp.ARE;
import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.sql.Transaction;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.web.ASComponent;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.dal.ASConfigLoaderFactory;
import com.lmt.frameapp.config.dal.IConfigLoader;

public class ASWebInterface
{

    public ASWebInterface()
    {
    }

    public static String generateControl(Transaction transaction, ASComponent ascomponent, String s, String s1, String s2, String s3, String s4, String s5, 
            String s6)
        throws Exception{
        ASValuePool LSValuePool = null;
        Object obj = null;
        String s7 = "";
        String s8 = StringFunction.getToday() + " " + StringFunction.getNow();
        if(ascomponent == null)
            return generateControl(s2, s3, s4, s5, s6);
        LSValuePool = ASConfigure.getSysConfig("ASFuncSet", transaction);
        String s9 = "";
        String s10 = "";
        String s12 = "";
        if(s1 == null || s1.equals(""))
        {
            s9 = ascomponent.ID + "-" + s3;
            s1 = s9;
        } else
        {
            s9 = s1;
        }
        Object obj1 = LSValuePool.getAttribute(s9);
        if(obj1 != null)
        {
            s12 = (String)obj1;
        } else
        {
            String s13 = s9;
            ASUser asuser = ascomponent.CurUser;
            String s11 = " insert into REG_FUNCTION_DEF(FunctionID,FunctionName,RightID,CompID,PageID,DefaultForm,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime)  values('" + s9 + "','" + s3 + "','" + s9 + "','" + ascomponent.ID + "','" + s + "','" + s2 + "','" + s8 + "','" + asuser.UserID + "','" + asuser.OrgID + "','" + asuser.UserID + "','" + s8 + "')";
            ARE.getLog().info("\u6CE8\u518C\u6309\u94AE\uFF1A" + s9);
            try
            {
                transaction.executeSQL(s11);
            }
            catch(Exception exception)
            {
                ARE.getLog().error("ASWebInterface \u6CE8\u518C\u6309\u94AE", exception);
            }
            s11 = "insert into RIGHT_INFO(RightID,RightName,RightStatus,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime)  values('" + s13 + "','" + s13 + "','1','" + s8 + "','" + asuser.UserID + "','" + asuser.OrgID + "','" + asuser.UserID + "','" + s8 + "')";
            ARE.getLog().info("\u6CE8\u518C\u6743\u9650\u70B9\uFF1A" + s13);
            try
            {
                transaction.executeSQL(s11);
            }
            catch(Exception exception1)
            {
                ARE.getLog().error("ASWebInterface \u6CE8\u518C\u6743\u9650\u70B9", exception1);
            }
            s11 = "insert into ROLE_RIGHT(RoleID,RightID,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime)  values('800','" + s13 + "','" + s8 + "','" + asuser.UserID + "','" + asuser.OrgID + "','" + asuser.UserID + "','" + s8 + "')";
            ARE.getLog().info("\u5C06\u6743\u9650\u9ED8\u8BA4\u8D4B\u7ED9\u666E\u901A\u7528\u6237\uFF1A" + s13);
            try
            {
                transaction.executeSQL(s11);
            }
            catch(Exception exception2)
            {
                ARE.getLog().error("ASWebInterface \u5C06\u6743\u9650\u9ED8\u8BA4\u8D4B\u7ED9\u666E\u901A\u7528\u6237", exception2);
            }
            ASConfigLoaderFactory.getInstance().createLoader("ASFuncSet").loadConfig(transaction);
            ASConfigLoaderFactory.getInstance().createLoader("ASRoleSet").loadConfig(transaction);
            ascomponent.CurUser.initUser(ascomponent.CurUser.UserID, transaction);
        }
        if(!ascomponent.CurUser.hasRight(s1))
        {
            ARE.getLog().trace("\u6CA1\u6709\u7CFB\u7EDF\u6743\u9650\uFF1A" + s1);
            return "";
        }
        s7 = (String)ascomponent.getAttribute("RightType");
        String s14 = (String)ascomponent.getAttribute("RightTypeOf_" + s1);
        if(s14 == null)
            s14 = "";
        if(!s14.equals("") && s7 != null && s14.indexOf(s7) < 0)
        {
            ARE.getLog().debug("\u6CA1\u6709\u5BF9\u8C61\u6743\u9650\uFF1A" + s1);
            return generateControl("Blank", s3, s4, s5, s6);
        } else
        {
            return generateControl(s2, s3, s4, s5, s6);
        }
    }

    public static String generateControl(String s, String s1, String s2, String s3, String s4)
    {
        if(s == null)
            s = "";
        if(s.equalsIgnoreCase("Button"))
            return HTMLControls.generateButton(s1, s2, s3, s4);
        if(s.equalsIgnoreCase("ButtonWithNoAction"))
            return HTMLControls.generateButton("<font color=\"#CCCCCC\">" + s1 + "</font>", s2, "", s4);
        if(s.equalsIgnoreCase("HyperLinkText"))
            return "<a href=\"" + s3 + "\" Title=\"\">" + s1 + "</a>";
        if(s.equalsIgnoreCase("TreeviewItem"))
            return s3;
        if(s.equalsIgnoreCase("PlainText"))
            return "<font title=\"" + s2 + "\"" + s3 + " >" + s1 + "</font>";
        if(s.equalsIgnoreCase("Blank"))
            return "";
        else
            return s3;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 184 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/