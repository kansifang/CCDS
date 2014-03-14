package com.lmt.baseapp.user;

import java.io.Serializable;
import java.sql.PreparedStatement;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.Transaction;

public class ASPreference
    implements Serializable
{

    public ASPreference(Transaction transaction, String s)
        throws Exception
    {
        vpUserPref = null;
        vpPrefDef = null;
        sCurUserID = null;
        bAutoCommit = true;
        vpUserPref = new ASValuePool(100);
        sCurUserID = s;
        init(transaction);
    }

    public void setAutoCommit(boolean flag)
    {
        bAutoCommit = flag;
    }

    public boolean getAutoCommit()
    {
        return bAutoCommit;
    }

    public void init(Transaction transaction)
        throws Exception
    {
        boolean flag = false;
        Object obj = null;
        Object obj1 = null;
        //用户登录属性定义
        vpPrefDef = ASConfigure.getSysConfig("ASPrefSet", transaction);
        //用户登录属性具体值
        String s2 = "select c.PreferenceId,c.PreferenceValue from User_Pref c where c.UserId = '" + sCurUserID + "'";
        String as[][] = transaction.getStringMatrix(s2);
        vpUserPref.resetPool();
        for(int i = 0; i < as.length; i++)
        {
            String s = as[i][0];
            String s1;
            if(as[i][1] == null || as[i][1].trim().length() == 0)
            {
                String s3 = (String)vpPrefDef.getAttribute(s);
                if(s3 == null)
                    s1 = "";
                else
                    s1 = s3;
            } else
            {
                s1 = as[i][1].trim();
            }
            vpUserPref.setAttribute(s, s1, false);
        }

    }

    public String getUserPreference(String s)
        throws Exception
    {
        Object obj = vpUserPref.getAttribute(s);
        if(obj == null)
            return "";
        else
            return obj.toString().trim();
    }

    public String getUserPreference(Transaction transaction, String s)
        throws Exception
    {
        String s1 = getUserPreference(s);
        if(!s1.equals(""))
            return s1;
        String s2 = "select PreferenceValue from User_Pref where UserId = '" + sCurUserID + "' And PreferenceId = '" + s + "'";
        String s3 = transaction.getString(s2);
        if(s3 == null || s3.trim().length() == 0)
        {
            String s4 = (String)vpPrefDef.getAttribute(s);
            if(s4 == null)
                s1 = "";
            else
                s1 = s4;
        } else
        {
            s1 = s3;
        }
        setUserPreference(s, s1);
        if(s3 == null)
            vpUserPref.setVarNodeNew(s);
        else
            vpUserPref.setVarNodeChange(s);
        return s1;
    }

    public void setUserPreference(String s, String s1)
        throws Exception
    {
        if(s1 == null)
            return;
        if(!vpUserPref.containsKey(s))
            vpUserPref.setAttribute(s, s1, true);
        else if(vpUserPref.getAttribute(s) != null && !s1.equals(vpUserPref.getAttribute(s)))
            vpUserPref.setAttribute(s, s1);
    }

    public void setUserPreference(Transaction transaction, String s, String s1)
        throws Exception
    {
        if(s1 == null)
            return;
        int i = 0;
        if(bAutoCommit)
        {
            String s2 = transaction.getString("select PreferenceId from User_Pref where PreferenceId = '" + s + "' And UserID = '" + sCurUserID + "'");
            Object obj = null;
            if(s2 == null)
            {
                String s3 = "insert into User_Pref (PreferenceId,UserId,PreferenceValue,InputTime) values('" + s + "','" + sCurUserID + "','" + s1 + "','" + StringFunction.getToday() + " " + StringFunction.getNow() + "')";
                try
                {
                    i = transaction.executeSQL(s3);
                }
                catch(Exception exception)
                {
                    i = transaction.executeSQL("insert into User_Pref_Def (PreferenceId,PreferenceName,DefaultValue,EnableCache,InputUser,InputTime) values('" + s + "','" + s + "','','1','" + sCurUserID + "','" + StringFunction.getToday() + " " + StringFunction.getNow() + "')");
                    i += transaction.executeSQL(s3);
                }
            } else
            {
                String s4 = "update User_Pref set PreferenceValue = '" + s1 + "', UpdateTime = '" + StringFunction.getToday() + " " + StringFunction.getNow() + "' where PreferenceId = '" + s + "' And UserID = '" + sCurUserID + "'";
                try
                {
                    i += transaction.executeSQL(s4);
                }
                catch(Exception exception1)
                {
                    ARE.getLog().error("update UserPreference [" + s + "] error: ", exception1);
                }
            }
        } else
        {
            i++;
        }
        if(i > 0)
            setUserPreference(s, s1);
    }

    protected void initPreferenceDefination(Transaction transaction)
        throws Exception
    {
        boolean flag = false;
        Object obj = null;
        Object obj1 = null;
        vpPrefDef = new ASValuePool(100);
        String s2 = "select PreferenceId,DefaultValue from User_Pref_Def ";
        String as[][] = transaction.getStringMatrix(s2);
        vpPrefDef.resetPool();
        for(int i = 0; i < as.length; i++)
        {
            String s = as[i][0];
            String s1;
            if(as[i][1] == null)
                s1 = "";
            else
                s1 = as[i][1].trim();
            vpPrefDef.setAttribute(s, s1, false);
        }

    }

    public void commitPreference(Transaction transaction)
        throws Exception
    {
        int i = 0;
        int j = 0;
        Object obj = null;
        Object obj1 = null;
        Object aobj[] = vpUserPref.getKeys();
        String s2 = StringFunction.getToday() + " " + StringFunction.getNow();
        String s3 = "update User_Pref set PreferenceValue = ?, UpdateTime = ? where PreferenceId = ? And UserID = ?";
        PreparedStatement preparedstatement = transaction.conn.prepareStatement(s3);
        int k = 0;
        for(k = 0; k < aobj.length; k++)
        {
            String s = (String)aobj[k];
            String s1 = (String)vpUserPref.getAttribute(s);
            if(vpUserPref.isVarNodeChange(s))
            {
                preparedstatement.setString(1, transaction.convertAmarStr2DBStr(s1));
                preparedstatement.setString(2, s2);
                preparedstatement.setString(3, s);
                preparedstatement.setString(4, sCurUserID);
                preparedstatement.addBatch();
                j++;
            } else if(vpUserPref.isVarNodeNew(s))
                try
                {
                    if(!vpPrefDef.containsKey(s))
                    {
                        i = transaction.executeSQL("insert into User_Pref_Def (PreferenceId,PreferenceName,DefaultValue,EnableCache,InputUser,InputTime) values('" + s + "','" + s + "','','1','" + sCurUserID + "','" + s2 + "')");
                        vpPrefDef.setAttribute(s, "", false);
                    }
                    String s4 = null;
                    s4 = "insert into User_Pref (PreferenceId,UserId,PreferenceValue,InputTime) values('" + s + "','" + sCurUserID + "','" + s1 + "','" + s2 + "')";
                    i += transaction.executeSQL(s4);
                }
                catch(Exception exception)
                {
                    ARE.getLog().error("Insert UserPreference Error:" + s + "@@" + s1, exception);
                }
            vpUserPref.setVarNodeNoChange(s);
        }

        ARE.getLog().debug("Auto commit Preference runing...[" + j + "/" + k + "]");
        if(j > 0)
            preparedstatement.executeBatch();
        preparedstatement.close();
    }

    private static final long serialVersionUID = 1L;
    private ASValuePool vpUserPref;
    private ASValuePool vpPrefDef;
    private String sCurUserID;
    private boolean bAutoCommit;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360云盘\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 162 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/