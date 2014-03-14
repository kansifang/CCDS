package com.lmt.frameapp.web;

import java.io.Serializable;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.config.dal.ASCompDefinition;
import com.lmt.frameapp.sql.Transaction;

public class ASComponent implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String ID;
  public String Name;
  public String ClientID;
  public ASUser CurUser;
  public ASComponent compParentComponent;
  public HttpServletRequest request;
  public Vector parameterList = new Vector();
  public Vector pages = new Vector();
  public String CompURL;
  public String CompType;
  public String appID;
  public boolean logSelect = false;
  public boolean logExecute = false;
  public ASCompDefinition compDef = null;

  public Vector dataWindows = new Vector();

  public ASComponent(String sComponentID, String sComponentName, ASUser asuserUser)
    throws Exception
  {
    this.ID = sComponentID;
    this.Name = sComponentName;
    this.CurUser = asuserUser;

    setCompDef("sComponentID");
  }

  public ASComponent(String sComponentID, String sComponentName, ASUser asuserUser, HttpServletRequest reqTmp)
    throws Exception
  {
    this.ID = sComponentID;
    this.Name = sComponentName;
    this.CurUser = asuserUser;
    this.request = reqTmp;
    this.CompURL = (reqTmp.getContextPath() + reqTmp.getServletPath());
    this.ClientID = (StringFunction.getMathRandom() + sComponentID + StringFunction.getNow());
    setRequestAttribute(reqTmp);

    setCompDef(sComponentID);
  }

  public void setRequestAttribute(HttpServletRequest reqTmp)
    throws Exception
  {
    Enumeration e = reqTmp.getParameterNames();

    while (e.hasMoreElements()) {
      String sParaName = (String)e.nextElement();
      setAttribute(sParaName, reqTmp.getParameter(sParaName));
    }
  }

  public void setCompDef(String sComponentID) throws Exception
  {
    ASValuePool CompSet = (ASValuePool)ASConfigure.getSysConfig("ASCompSet");
    this.compDef = ((ASCompDefinition)CompSet.getAttribute(sComponentID));
    if (this.compDef != null) {
      String sLogSelect = (String)this.compDef.getAttribute("LogSelect");
      String sLogExecute = (String)this.compDef.getAttribute("LogExecute");
      if ((sLogSelect != null) && (sLogSelect.equals("1"))) this.logSelect = true;
      if ((sLogExecute != null) && (sLogExecute.equals("1"))) this.logExecute = true;
      this.Name = ((String)this.compDef.getAttribute("CompName"));
    }
  }

  public void setAttribute(String sParaName, Object oParaValue)
    throws Exception
  {
    this.parameterList.addElement(new ASParameter(sParaName, oParaValue));
  }

  public Object getAttribute(String sParaName)
    throws Exception
  {
    for (int i = this.parameterList.size() - 1; i >= 0; i--) {
      ASParameter tmpPara = (ASParameter)this.parameterList.get(i);
      if (tmpPara.paraName.equals(sParaName)) {
        return tmpPara.paraValue;
      }
    }

    return null;
  }

  public Object getAttribute(String sParaName, int iGenerations)
    throws Exception
  {
    for (int i = this.parameterList.size() - 1; i >= 0; i--) {
      ASParameter tmpPara = (ASParameter)this.parameterList.get(i);
      if (tmpPara.paraName.equals(sParaName)) {
        return tmpPara.paraValue;
      }

    }

    if (iGenerations < 1) return null;

    if (this.compParentComponent != null) {
      Object oTemp = null;
      oTemp = this.compParentComponent.getAttribute(sParaName, iGenerations - 1);
      return oTemp;
    }

    return null;
  }

  public String getParameter(String sParaName)
    throws Exception
  {
    return (String)getAttribute(sParaName);
  }

  public String getParameter(String sParaName, int iGenerations)
    throws Exception
  {
    return (String)getAttribute(sParaName, iGenerations);
  }

  public void removeAttribute(String sParaName)
    throws Exception
  {
    for (int i = this.parameterList.size() - 1; i >= 0; i--)
    {
      ASParameter tmpPara = (ASParameter)this.parameterList.get(i);
      if (!tmpPara.paraName.equals(sParaName))
        continue;
      this.parameterList.remove(i);
      return;
    }
  }

  public void setPage(ASPage argPage)
    throws Exception
  {
    this.pages.addElement(argPage);
  }

  public ASPage lookUpPage(String sPageClientID)
    throws Exception
  {
    for (int i = this.pages.size() - 1; i >= 0; i--)
    {
      ASPage pageTemp = (ASPage)this.pages.get(i);
      if (pageTemp.ClientID.equals(sPageClientID)) return (ASPage)this.pages.get(i);
    }
    return null;
  }

  public void lookUpAndDestroyPage(String sPageClientID)
  {
    for (int i = this.pages.size() - 1; i >= 0; i--)
    {
      ASPage pageTemp = (ASPage)this.pages.get(i);
      if (!pageTemp.ClientID.equals(sPageClientID))
        continue;
      this.pages.remove(i);
      return;
    }
  }

  public String getDBConnectionID(Transaction Sqlca, String sType)
    throws Exception
  {
    if ((this.appID == null) || (this.appID.equals(""))) return null;
    if (sType.equals("ConnectByOrgID"))
    {
      String sReturn = getDBConnectionIDWithOrgID(Sqlca, this.CurUser.OrgID);
      if ((sReturn == null) || (sReturn.equals(""))) return getDBConnectionID(Sqlca, "ConnectByAppID");
      return sReturn;
    }if (sType.equals("ConnectByAppID")) {
      String sSql = "select DBConnectionID from REG_APP_DEF where AppID='" + this.appID + "'";
      String sReturn = Sqlca.getString(sSql);
      return sReturn;
    }
    return null;
  }

  private String getDBConnectionIDWithOrgID(Transaction Sqlca, String sOrgID)
    throws Exception
  {
    String sSql = "select DBConnectionID from REG_ORG_APP_CONN where OrgID='" + sOrgID + "' and AppID='" + this.appID + "'";
    String sReturn = Sqlca.getString(sSql);
    if (sReturn != null) {
      return sReturn;
    }

    sSql = "select SortNo from ORG_INFO where OrgID='" + sOrgID + "'";
    String sSortNo = Sqlca.getString(sSql);
    sSql = "select OrgID from ORG_INFO where LENGTH(SortNo)<LENGTH('" + sSortNo + "') and SortNo=SUBSTR('" + sSortNo + "',1,LENGTH(SortNo)) order by SortNo DESC";
    String sParentOrgID = Sqlca.getString(sSql);
    if ((sParentOrgID != null) && (!sParentOrgID.equals(""))) {
      return getDBConnectionIDWithOrgID(Sqlca, sParentOrgID);
    }
    return null;
  }

	public String getClientID() {
		return ClientID;
	}
	
	public void setClientID(String clientID) {
		ClientID = clientID;
	}
	
	public String getCompURL() {
		return CompURL;
	}
	
	public void setCompURL(String compURL) {
		CompURL = compURL;
	}
	
	public String getAppID() {
		return appID;
	}
	
	public void setAppID(String appID) {
		this.appID = appID;
	}
	  
}