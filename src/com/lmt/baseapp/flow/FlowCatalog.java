package com.lmt.baseapp.flow;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class FlowCatalog
{
  public String FlowNo;
  public String FlowName;
  public String FlowType;
  public String FlowDescribe;
  public String InitPhase;
  public Transaction Sqlca;

  public FlowCatalog(String paramString, Transaction paramTransaction)
    throws Exception
  {
    initFlowPhase(paramString, paramTransaction);
  }

  public void initFlowPhase(String paramString, Transaction paramTransaction)
    throws Exception
  {
    this.FlowNo = paramString;
    this.Sqlca = paramTransaction;
    ASResultSet localASResultSet = this.Sqlca.getASResultSet("select FLOW_CATALOG.* from FLOW_CATALOG where FlowNo='" + paramString + "'");
    if (localASResultSet.next())
    {
      this.FlowName = localASResultSet.getString("FlowName");
      this.FlowDescribe = localASResultSet.getString("FlowDescribe");
      this.FlowType = localASResultSet.getString("FlowType");
      this.InitPhase = localASResultSet.getString("InitPhase");
    }
    else
    {
      localASResultSet.getStatement().close();
      throw new FlowException("FlowCatalog:FlowNo:" + paramString + " not Exist");
    }
    localASResultSet.getStatement().close();
  }

  public boolean equals(FlowCatalog paramFlowCatalog)
  {
    if (paramFlowCatalog == null)
      return false;
    return this.FlowNo.equalsIgnoreCase(paramFlowCatalog.FlowNo);
  }
}