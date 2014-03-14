package com.lmt.frameapp.web;

import java.io.Serializable;

import com.lmt.baseapp.user.ASPreference;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.ASValuePool;

public class ASRuntimeContext
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  private ASValuePool vpRunEnv = null;
  private ASUser user;
  private ASPreference pref;
  private String errCode;
  private String errInfo;
  private ASComponentSession compSession;

  public ASRuntimeContext()
  {
    this.vpRunEnv = new ASValuePool(30);
  }

  public void setAttribute(String sParaName, Object oParaValue)
    throws Exception
  {
    if ("CurCompSession".equals(sParaName)) {
      setCompSession((ASComponentSession)oParaValue);
    }
    else if ("CurUser".equals(sParaName)) {
      setUser((ASUser)oParaValue);
    }
    else if ("CurPref".equals(sParaName)) {
      setPref((ASPreference)oParaValue);
    }
    else
      this.vpRunEnv.setAttribute(sParaName, oParaValue);
  }

  public Object getAttribute(String sParaName)
    throws Exception
  {
    if ("CurCompSession".equals(sParaName)) {
      return getCompSession();
    }
    if ("CurUser".equals(sParaName)) {
      return getUser();
    }
    if ("CurPref".equals(sParaName)) {
      return getPref();
    }

    Object oValue = this.vpRunEnv.getAttribute(sParaName);
    return oValue;
  }

  public String getParameter(String sParaName)
    throws Exception
  {
    Object oValue = getAttribute(sParaName);
    if (oValue == null)
      throw new Exception("系统运行环境中无此参数[" + sParaName + "]");
    return oValue.toString();
  }

  public ASComponentSession getCompSession() {
    return this.compSession;
  }

  public void setCompSession(ASComponentSession compSession) {
    this.compSession = compSession;
  }

  public ASUser getUser() {
    return this.user;
  }

  public void setUser(ASUser user) {
    this.user = user;
  }

  public ASPreference getPref() {
    return this.pref;
  }

  public void setPref(ASPreference pref) {
    this.pref = pref;
  }

  public void setErrInfo(String errInfo) {
    this.errInfo = errInfo;
  }

  public String getErrInfo() {
    return this.errInfo;
  }

  public void setErrCode(String errCode) {
    this.errCode = errCode;
  }

  public String getErrCode() {
    return this.errCode;
  }
}