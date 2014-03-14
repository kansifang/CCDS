<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	boolean isInsepctRole=false;
	if(CurUser.hasRole("440")||CurUser.hasRole("240")||CurUser.hasRole("040")){
		isInsepctRole=true;
	}
	WhereCase=	" from Inspect_Info II,Business_Contract BC"+
		" where II.ObjectType='BusinessContract'"+
		" and II.ObjectNo=BC.SerialNo"+
		" and (II.InputOrgID='"+CurUser.OrgID+"' and II.InputUserID='"+CurUser.UserID+"'"+
				" or "+
			(isInsepctRole?"exists(select OrgID from Org_Info where OrgID=II.InputOrgID and SortNo like '"+CurOrg.SortNo+"%'))":"1<>1)")+
		" and coalesce(II.FinishDate,'') = ''";
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(II.SerialNo) ";
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	else if(sFlag.equals("1"))
	{
		sSql= 	" select getBusinessName(BC.BusinessType)||'&nbsp;['||BC.CustomerName||']'||'&nbsp;['||II.UpDateDate||']', "+
		" BC.BusinessSum,II.InspectType,II.UpDateDate ";
		sSql = sSql+ WhereCase;	
	
		rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next())
		{
	if (rsTips.getString(4).substring(0,10).equals(StringFunction.getToday()))
		sTipsFlag="&nbsp;&nbsp;";
	else
		sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
%>
               	<tr>
              		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('AfterLoanInspectMain','/CreditManage/CreditCheck/AfterLoanInspectMain.jsp','ComponentName=贷后检查&ComponentType=MainWindow&TreeviewTemplet=AfterLoanInspectMain&DefaultTVItemID=<%=rsTips.getString("InspectType")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
              		<td align="right" valign="bottom"><%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
              	<br/>
              	</tr>
		<%
			}
			}
			rsTips.getStatement().close();
		%>
<%@ include file="/IncludeEndAJAX.jsp"%>