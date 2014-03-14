package com.lmt.frameapp.web;
import java.io.Serializable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;

public class ASComponentSession
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String ID;
  public Vector ASComponents = new Vector();
  public Vector parameterList = new Vector();

  public ASComponentSession() {
    this.ID = (StringFunction.getMathRandom() + StringFunction.getNow());
  }

  public ASComponentSession(String sComponentSessionID) {
    this.ID = sComponentSessionID;
  }

  public ASComponent creatComponent(String sComponentID, String sComponentName, ASUser asuserTmp, HttpServletRequest reqTmp) throws Exception
  {
    ASComponent tmpComp = new ASComponent(sComponentID, sComponentName, asuserTmp, reqTmp);
    this.ASComponents.addElement(tmpComp);
    return tmpComp;
  }

  public ASComponent lookUp(String sClientID)
  {
    for (int i = this.ASComponents.size() - 1; i >= 0; i--) {
      ASComponent compTemp = (ASComponent)this.ASComponents.get(i);
      if (compTemp.ClientID.equals(sClientID)) return (ASComponent)this.ASComponents.get(i);
    }
    return null;
  }

  public void lookUpAndDestroy(String sClientID)
  {
    for (int i = this.ASComponents.size() - 1; i >= 0; i--) {
      ASComponent compTemp = (ASComponent)this.ASComponents.get(i);
      if (compTemp.ClientID.equals(sClientID)) {
        destroy(i);
        return;
      }
    }
  }

  public void destroyChild(ASComponent compParent, int iParentAddress)
  {
    for (int i = this.ASComponents.size() - 1; i >= iParentAddress; i--) {
      ASComponent compTemp = (ASComponent)this.ASComponents.get(i);
      if (compTemp.compParentComponent == compParent)
        destroy(i);
    }
  }

  public void destroy(int iAddress)
  {
    ASComponent compTemp = (ASComponent)this.ASComponents.get(iAddress);
    destroyChild(compTemp, iAddress);
    this.ASComponents.remove(iAddress);
  }

  public String getComponentsID()
  {
    StringBuffer sbf = new StringBuffer();

    for (int i = this.ASComponents.size() - 1; i >= 0; i--) {
      ASComponent tcomp = (ASComponent)this.ASComponents.get(i);
      if (i == 0) {
        sbf.append(tcomp.getClientID());
        sbf.append("|");
        sbf.append(tcomp.getCompURL());
      } else {
        sbf.append(i);
        sbf.append("|");
        sbf.append(tcomp.getClientID());
        sbf.append("|");
        sbf.append(tcomp.getCompURL());
        sbf.append(",");
      }
    }
    return sbf.toString();
  }

  public void lookUpAndDestroy(String sClientID, HttpSession session)
  {
    for (int i = this.ASComponents.size() - 1; i >= 0; i--) {
      ASComponent compTemp = (ASComponent)this.ASComponents.get(i);
      if (compTemp.ClientID.equals(sClientID)) {
        destroy(i, session);
        return;
      }
    }
  }

  public void destroyChild(ASComponent compParent, int iParentAddress, HttpSession session)
  {
    for (int i = this.ASComponents.size() - 1; i >= iParentAddress; i--) {
      ASComponent compTemp = (ASComponent)this.ASComponents.get(i);
      if (compTemp.compParentComponent == compParent)
        destroy(i, session);
    }
  }

  public void destroy(int iAddress, HttpSession session)
  {
    ASComponent compTemp = (ASComponent)this.ASComponents.get(iAddress);

    ARE.getLog().debug("...clear...destroy(" + iAddress + "," + session.getId() + ")..." + compTemp.dataWindows.size());
    for (int i = 0; i < compTemp.dataWindows.size(); i++) {
    	ARE.getLog().debug("...clear..." + (String)compTemp.dataWindows.get(i));
    	session.removeAttribute((String)compTemp.dataWindows.get(i));
    }

    destroyChild(compTemp, iAddress, session);
    this.ASComponents.remove(iAddress);
  }

  public void clear(HttpSession session)
  {
    for (int i = 0; this.ASComponents.size() > 0; destroy(i, session));
  }

  public void clear() {
    for (int i = this.ASComponents.size() - 1; i >= 0; i--) this.ASComponents.remove(i);
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

  public void removeAttribute(String sParaName) throws Exception
  {
    for (int i = this.parameterList.size() - 1; i >= 0; i--) {
      ASParameter tmpPara = (ASParameter)this.parameterList.get(i);
      if (tmpPara.paraName.equals(sParaName)) {
        this.parameterList.remove(i);
        return;
      }
    }
  }
}