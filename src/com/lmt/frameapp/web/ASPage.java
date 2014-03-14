package com.lmt.frameapp.web;

import java.io.Serializable;
import java.util.Enumeration;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.lmt.baseapp.util.StringFunction;

public class ASPage
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String Name;
  public String ClientID;
  public Vector parameterList = new Vector();
  public String PageURL;
  public String appID;
  public ASComponent CurComp;

  public ASPage(ASComponent acArgComp)
    throws Exception
  {
    this.ClientID = StringFunction.getMathRandom();
    this.CurComp = acArgComp;
    this.CurComp.setPage(this);
  }

  public void setRequestAttribute(HttpServletRequest reqTmp)
    throws Exception
  {
    this.PageURL = (reqTmp.getContextPath() + reqTmp.getServletPath());
    Enumeration e = reqTmp.getParameterNames();

    while (e.hasMoreElements()) {
      String sParaName = (String)e.nextElement();

      setAttribute(sParaName, reqTmp.getParameter(sParaName));
    }
  }

  public void setAttribute(String sParaName, Object oParaValue)
    throws Exception
  {
    removeAttribute(sParaName);
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
    return this.CurComp.getAttribute(sParaName);
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
    return this.CurComp.getAttribute(sParaName, iGenerations);
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
}