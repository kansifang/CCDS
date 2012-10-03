<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase=	" from BADBIZ_APPLY BA, FLOW_TASK FT "+
				" where BA.SerialNo = FT.ObjectNo "+
				" and FT.ObjectType='BadBizApply' "+
				" and PhaseType='1020'"+
				" and FT.UserID='"+CurUser.UserID+"' "+
				" and (FT.EndTime is null "+
				" or FT.EndTime = '') "+
				" and (FT.PhaseAction is null "+
				" or FT.PhaseAction = '') ";
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(BA.SerialNo) ";
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	else if(sFlag.equals("1"))
	{
		sSql= 	" select '&nbsp;['||getItemName('BadBizApplyType',BA.ApplyType)||']'||'&nbsp;['||FT.PhaseName||']', "+
				" FT.ApplyType,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType,getNodeNo(FT.FlowNo,FT.PhaseNo) as NodeNo ";
		sSql = sSql+ WhereCase;	
	
		rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next())
		{
				if (rsTips.getString("3").substring(0,10).equals(StringFunction.getToday()))
					sTipsFlag="&nbsp;&nbsp;";
				else
					sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
			%>
	                      	<tr>
	 
	                     		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('BadBizApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=BadBizApprove&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>&NodeNo=<%=rsTips.getString("NodeNo")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>

	                     	<br/></tr>
			<%
		}
	}
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>