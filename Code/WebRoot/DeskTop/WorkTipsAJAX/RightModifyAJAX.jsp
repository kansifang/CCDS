<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�����꣬sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase=	" from CUSTOMER_BELONG CB " +
        " where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
        " and ApplyRight = '"+CurOrg.OrgID+"' and ApplyStatus = '1'";	

		if(CurUser.hasRole("0A0"))//���и��˿ͻ�Ȩ�޹���Ա
		{
			WhereCase = WhereCase+" and exists(select 1 from CUSTOMER_INFO CI where CustomerID=CB.CustomerID and CustomerType like '03%')";
		}
		else if(CurUser.hasRole("0D0")){//���й�˾�ͻ�Ȩ�޹���Ա
			WhereCase = WhereCase+" and exists(select 1 from CUSTOMER_INFO CI where CustomerID=CB.CustomerID and CustomerType like '01%')";
		}
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(CustomerID) " ;
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	else if(sFlag.equals("1"))
	{
		sSql= 	" select '&nbsp;����ͻ�����:'||getUserName(UserID) as UserName||'&nbsp;�������:'||getOrgName(OrgID)||'&nbsp;�ͻ�'||CustomerName, ";
;
		sSql = sSql+ WhereCase;	
	
	rsTips = Sqlca.getResultSet(sSql);
	while(rsTips.next())
	{
		%>
                      <tr>
                      	 <td align="left" ><a href="javascript:OpenComp('RightModifyMain','/SystemManage/GeneralSetup/RightModifyMain.jsp','ComponentName=�ͻ��ܻ�Ȩ����&ComponentType=MainWindow&TreeviewTemplet=RightModifyMain%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                     <br/></tr>
		<%
	}
	}
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>