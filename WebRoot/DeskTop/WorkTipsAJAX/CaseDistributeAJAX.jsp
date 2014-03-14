<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<%
		//µã»÷Êó±ê£¬sFlag ="1"
		String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
		String sSql;
		ASResultSet rsTips=null;
		String sTipsFlag,WhereCase;
		int countLoan=0;
		WhereCase=	" from Batch_Case BC, FLOW_Object FO "+
					" where BC.SerialNo=FO.ObjectNo "+
					" and FO.ObjectType='ApplyCaseDistOT' "+
					" and FO.UserID='"+CurUser.UserID+"' "+
					" and FO.PhaseNo='0010' ";
		if(sFlag.equals("0")){
			sSql = 	" select count(1) ";
			sSql = sSql+ WhereCase;	
			rsTips = Sqlca.getResultSet(sSql);
			if(rsTips.next())  countLoan = rsTips.getInt(1);
			out.println(countLoan);
		}else if(sFlag.equals("1")){
			sSql = 	" select BC.LCustomerName||'&nbsp;['||BC.DCustomerName||']'||'&nbsp;['||FO.PhaseName||']', "+
						" FO.PhaseName,FO.PhaseNo,FO.PhaseType ";
			sSql = sSql+ WhereCase;	
			rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next()){
	%>
                    <tr>
                     	  <td align="left" ><a href="javascript:OpenComp('ApplyMain','/Common/BusinessFlow/Apply/ApplyMain.jsp','ApplyType=ApplyCaseDist&PhaseType=<%=rsTips.getString(4)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a>
                     	  </td>
                    	<br>
                    </tr>
<%
			}
	}        
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>