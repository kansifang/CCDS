<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	String sNodeNo = "";
	int countApplay=0;
	
	WhereCase=	" from RISK_SIGNAL RS, FLOW_TASK FT "+
				" where RS.SerialNo = FT.ObjectNo "+
				" and FT.ObjectType ='RiskSignalApply' "+
				" and FT.UserID='"+CurUser.UserID+"' "+
				" and (FT.EndTime is null "+
				" or FT.EndTime = '') "+
				" and (FT.PhaseAction is null "+
				" or FT.PhaseAction = '')";
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(RS.SerialNo) ";
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	else if(sFlag.equals("1"))
	{
		sSql= 	" select getItemName('SignalType',RS.SignalType)||'['||getItemName('SignalLevel',RS.SignalLevel)||']'||'['||getCustomerName(RS.ObjectNo)||']'||'&nbsp;['||FT.PhaseName||']', "+
				" FT.ApplyType,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType,getNodeNo(FlowNo,PhaseNo) as NodeNo,RS.SignalType ";
		sSql = sSql+ WhereCase;	
	
		rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next())
		{
				if (rsTips.getString(3).substring(0,10).equals(StringFunction.getToday()))
					sTipsFlag="&nbsp;&nbsp;";
				else
					sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
			%>
	                      	<tr>
	         <%
	                      	if(rsTips.getString(5).equals("0010") || rsTips.getString(5).equals("3000"))
	                      	{
	         %>
	                      	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditAlarmApplyMain','/CreditManage/CreditAlarm/CreditAlarmApplyMain.jsp','ComponentName=风险预警&ComponentType=MainWindow&NodeNo=<%=rsTips.getString("NodeNo")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
	         <%
	                     	}else
	                     	{//待审查审批				                        	
	         %>
	                     		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('RiskSinalApproveMain','/CreditManage/CreditAlarm/RiskSinalApproveMain.jsp','ApproveType=ApproveRiskSignalApply@ApproveRiskSignalFApply&NodeNo=<%=rsTips.getString("NodeNo")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
	         <%
	                     	}
	      	%>
	                     	<br/></tr>
			<%
		}
	}
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>