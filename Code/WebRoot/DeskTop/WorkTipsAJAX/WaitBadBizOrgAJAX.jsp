<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int accountType1=0,accountType2=0,accountType3=0,accountType4=0,accountType5=0;
	
	WhereCase=	" from BADBIZ_ACCOUNT  " +
		"where (RecoverOrgID is null or RecoverOrgID='') "+
		" and BelongOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
		" and StateFlag='10' "+
        "   group  by accountType";	
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select case when accountType='010' then count(serialno) end as accountType1,"+
				" case when accountType='020' then count(serialno) end as accountType2,"+
				" case when accountType='030' then count(serialno) end as accountType3,"+
				" case when accountType='040' then count(serialno) end as accountType4,"+
				" case when accountType='050' then count(serialno) end as accountType5 "
				;
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		while(rsTips.next())  
		{
			if(accountType1==0) accountType1 = rsTips.getInt(1);
			if(accountType2==0) accountType2 = rsTips.getInt(2);
			if(accountType3==0) accountType3 = rsTips.getInt(3);
			if(accountType4==0) accountType4 = rsTips.getInt(4);
			if(accountType5==0) accountType5 = rsTips.getInt(5);
		}
		if(accountType1>0)
		{
			out.println("表内不良贷款 "+accountType1+" 笔；");
		}
		if(accountType2>0)
		{
			out.println("票据置换不良贷款 "+accountType2+" 笔；");
		}
		if(accountType3>0)
		{
			out.println("已核销不良贷款 "+accountType3+" 笔；");
		}
		if(accountType4>0)
		{
			out.println("资金置换不良贷款 "+accountType4+" 笔；");
		}
		if(accountType5>0)
		{
			out.println("抵债资产 "+accountType5+" 笔；");
		}
	}
	rsTips.getStatement().close();
%>
<%@ include file="/IncludeEndAJAX.jsp"%>