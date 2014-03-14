package com.lmt.baseapp.user;

import java.io.Serializable;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ASOrg
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  public String OrgID;
  public String OrgName;
  public String OrgLevel;
  public String RelativeOrgID;
  public String OrgProperty;
  public String Status;
  public String SortNo;
  private Transaction Sqlca;

  public ASOrg(String paramString, Transaction paramTransaction)
    throws Exception
  {
    this.Sqlca = paramTransaction;
    ASResultSet localLSResultSet = this.Sqlca.getResultSet("select * from Org_INFO where OrgID = '" + paramString + "'");
    if (localLSResultSet.next())
    {
      this.OrgID = localLSResultSet.getString("OrgID");
      this.OrgName = localLSResultSet.getString("OrgName");
      this.OrgLevel = localLSResultSet.getString("OrgLevel");
      this.RelativeOrgID = localLSResultSet.getString("RelativeOrgID");
      this.OrgProperty = localLSResultSet.getString("OrgProperty");
      this.Status = localLSResultSet.getString("Status");
      this.SortNo = localLSResultSet.getString("SortNo");
    }
    else
    {
      throw new ASOrgException("ASOrg Constructor : Org " + paramString + " doesn't exist");
    }
    localLSResultSet.getStatement().close();
  }
}