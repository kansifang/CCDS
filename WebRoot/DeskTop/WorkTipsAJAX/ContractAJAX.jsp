<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<%
		//点击鼠标，sFlag ="1"
		String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
		String sSql;
		ASResultSet rsTips=null;
		String sTipsFlag,WhereCase;
		int countLoan=0;
		WhereCase=	" from BUSINESS_APPROVE where "+
			"("+
				"(select InputUserID from Business_Apply BA "+
				"where BA.SerialNo=BUSINESS_APPROVE.RelativeSerialNo and BA.InputOrgID='14')='"+CurUser.UserID+"'"+
				" or "+
				"InputOrgID<>'14' and OperateUserID ='"+CurUser.UserID+"'"+
			")"+//added by bllou 2012-03-09 微小企业部登记人员来登记合同
			" and ApproveType = '01'  and "+
			" SerialNo in (select ObjectNo from FLOW_OBJECT FO where FlowNo='ApproveFlow'  and PhaseNo='1000') "+
			" and SerialNo not in (select RelativeSerialNo from  BUSINESS_CONTRACT BC where RelativeSerialNo is not null)";
		
		if(sFlag.equals("0"))
		{
			sSql = 	" select count(SerialNo)  ";
			sSql = sSql+ WhereCase;	
			rsTips = Sqlca.getResultSet(sSql);
			if(rsTips.next())  countLoan = rsTips.getInt(1);
			out.println(countLoan);
		}
		else if(sFlag.equals("1"))
		{
			sSql= 	" select getBusinessName(BusinessType)||'&nbsp;['||CustomerName||']'||'&nbsp;', "+
			" BusinessSum  ";
			sSql = sSql+ WhereCase;	
			rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next())
		{
			sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
	%>				<tr>
          			<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('BookInContractMain','/CreditManage/CreditPutOut/BookInContractMain.jsp','ComponentName=待登记合同的最终审批意见&TreeviewTemplet=BookInContractMain','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                		<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                    	<br/></tr>
<%
	}
	}        
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>