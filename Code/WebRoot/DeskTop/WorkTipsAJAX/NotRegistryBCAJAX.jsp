<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//µã»÷Êó±ê£¬sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	int countApplay=0;
	
	WhereCase=	" From BUSINESS_APPLY BA where (BA.ApproveDate is not null and BA.ApproveDate<>'') "+
			" and BA.OrgFlag not like '%1' "+
			" and BA.OperateUserID ='"+CurUser.UserID+"' and (BA.ContractExsitFlag is null OR BA.ContractExsitFlag='')"+
			" and BA.Businesstype not like '30%'  AND (BA.PigeonholeDate is Null or BA.PigeonholeDate='')  "+
			" and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and"+
			" ObjectType ='BusinessReApply' )";
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(BA.SerialNo) " ;
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>