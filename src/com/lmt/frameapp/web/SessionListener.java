/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.lmt.baseapp.user.ASOrg;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;

public class SessionListener
    implements HttpSessionBindingListener, Serializable
{

    public SessionListener(HttpServletRequest httpservletrequest, HttpSession httpsession, ASUser asuser, ASOrg asorg)
    {
        asc = ASConfigure.getASConfigure();
        sServerName = httpservletrequest.getServerName();
        sServerPort = String.valueOf(httpservletrequest.getServerPort());
        sSessionID = httpsession.getId();
        sRemoteAddr = httpservletrequest.getRemoteAddr();
        sRemoteHost = httpservletrequest.getRemoteAddr();
        sUserID = asuser.UserID;
        sUserName = asuser.UserName;
        sOrgID = asorg.OrgID;
        sOrgName = asorg.OrgName;
    }

    public int getCount()
    {
        return count;
    }

    public void valueBound(HttpSessionBindingEvent httpsessionbindingevent)
    {
        count++;
        try
        {
            Date date = new Date();
            SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            sBeginTime = simpledateformat.format(date);
            String s = "insert into USER_LIST(sessionid,userid,username,orgid,orgname,begintime,servername,serverport,remoteaddr,remotehost)  values('" + sSessionID + "','" + sUserID + "','" + sUserName + "','" + sOrgID + "','" + sOrgName + "','" + sBeginTime + "','" + sServerName + "','" + sServerPort + "','" + sRemoteAddr + "','" + sRemoteHost + "')";
            if(Sqlca == null)
                Sqlca = getSqlca();
            Sqlca.executeSQL(s);
            Sqlca.conn.commit();
            Sqlca.disConnect();
            Sqlca = null;
            ARE.getLog().info("SessionListener:Logon Session[" + sSessionID + "] User[" + sUserID + "] UserName[" + sUserName + "]");
        }
        catch(Exception exception)
        {
            ARE.getLog().info("SessionListener:valueBound():" + exception);
            try
            {
                if(Sqlca != null)
                {
                    Sqlca.disConnect();
                    Sqlca = null;
                }
            }
            catch(Exception exception1) { }
        }
    }

    public void valueUnbound(HttpSessionBindingEvent httpsessionbindingevent)
    {
        count--;
        try
        {
            Date date = new Date();
            SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            sEndTime = simpledateformat.format(date);
            String s = "Update User_List Set Endtime='" + sEndTime + "' Where sessionid='" + sSessionID + "' And Userid='" + sUserID + "' and begintime='" + sBeginTime + "'";
            if(Sqlca == null)
                Sqlca = getSqlca();
            Sqlca.executeSQL(s);
            Sqlca.conn.commit();
            Sqlca.disConnect();
            Sqlca = null;
            ARE.getLog().info("SessionListener:Logout Session[" + sSessionID + "] User[" + sUserID + "] UserName[" + sUserName + "]");
        }
        catch(Exception exception)
        {
            ARE.getLog().error("SessionListener:valueUnbound():" + exception);
            try
            {
                if(Sqlca != null)
                {
                    Sqlca.disConnect();
                    Sqlca = null;
                }
            }
            catch(Exception exception1) { }
        }
    }

    private Transaction getSqlca()
    {
        try
        {
            return Sqlca = ConnectionManager.getTransaction(asc.getConfigure("DataSource"));
        }
        catch(Exception exception)
        {
            ARE.getLog().error("SessionListener:getSqlca():" + exception);
        }
        return null;
    }

    private static final long serialVersionUID = 1L;
    private static int count = 0;
    private String sBeginTime;
    private String sEndTime;
    private String sSessionID;
    private String sRemoteAddr;
    private String sRemoteHost;
    private String sServerName;
    private String sServerPort;
    private String sUserID;
    private String sUserName;
    private String sOrgID;
    private String sOrgName;
    private ASConfigure asc;
    private Transaction Sqlca;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 189 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/