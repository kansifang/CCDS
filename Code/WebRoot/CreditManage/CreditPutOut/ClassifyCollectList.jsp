<%
/*
 * Author: hldu  2012-08-08
 * Tester:
 * Content: ���շ���ͳ�ƹ���
 * Input Param:
 * Output param:                 
 * History Log:                      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>���շ���ͳ�ƹ���</title> 
</head>
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" >
<center>
<%
    String sSql="";
    String sSql2="";
    String sOrgID = "";
    ASResultSet rs=null;
    ASResultSet rs2=null;
    String sCurOrgID = CurOrg.OrgID;
    String sAccountMonth = "" ;
    int iReinforce1=0;
    int iReinforce2=0;
    int iReinforce3=0;
    double dbReinforce1=0;
    double dbReinforce2=0;
   	double dbReinforce4=0;
   	int iSum1 = 0;
   	int iSum2 = 0;
   	int iSum3 = 0;
   	double dSum1 = 0.0;
   	double dSum2 = 0.0;
   	double dbReinforce5 = 0.0;
   	String sOrgName = "";
   	String sOrgName2 = "";
   	String sRoleID = "" ;
   	String sOrgFlag = "";
   	sOrgFlag = Sqlca.getString(" select OrgFlag from Org_Info where OrgID = '"+sCurOrgID+"' ");
   	if (sOrgFlag == null) sOrgFlag = "";
%>

<table border=2 width="100%" cellspacing=0 cellpadding=2 bgcolor="#DCDCDC" bordercolor=black >
<tr>
    <td class=td1 align=left colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa'>���շ���ͳ�ƹ���</font></td>
</tr>
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td colspan=1 align="center"><b>��������</b></td>
    <td colspan=2 align="center"><b>��������</b></td>
    <td colspan=2 align="center"><b>δ��ɷ����϶���ͬ</b></td>
    <td colspan=2 align="center"><b>����ɷ����϶���ͬ</b></td>    
    <td colspan=2 align="center"><b>����ɷ����϶���ͬ</b></td>
    <td colspan=1 align="center"><b>�����϶�����</b></td>
</tr>

<%
    // ��ǰ�·�
	sAccountMonth = StringFunction.getToday().substring(0,7);
    if(CurUser.hasRole("2D4") || CurUser.hasRole("2A4") || CurUser.hasRole("0J1")) 
    {
    	if (CurUser.hasRole("2D4")) 
    	{
    		sRoleID = "2D3" ;// 2D4-����֧����С��ҵ���ۺ�Ա 2D3-����֧����С��ҵ������ͻ�����
    		sOrgName2 = "��С��ҵ��";
    	}
    	if (CurUser.hasRole("2A4")) 
    	{
    		sRoleID = "2A5"; // 2A4-����֧�и��˽��ڲ��ۺ�Ա 2A5-����֧�и��˽��ڲ�����ͻ�����
    		sOrgName2 = "���˽��ڲ�";
    	}
    	if (CurUser.hasRole("0J1"))
    	{	
    		sRoleID = "080"; // 0J1-���м��ſͻ����ۺ�Ա     080-���м��ſͻ�������ͻ�����
    		sOrgName2 = "���ſͻ���";
    	}
    	sSql = " select Count(BC.SerialNo) "+
    	       " from BUSINESS_CONTRACT BC"+
    	       " where (BC.FinishDate is null or BC.FinishDate = '') "+
    	       " and BC.ApplyType <> 'CreditLineApply' "+
    	       " and BC.ManageUserID in (select userid from user_role where roleid = '"+sRoleID+"') "+
    	       " and BC.ManageOrgID = '"+sCurOrgID+"' "+
    	       " and BC.Balance>0 "+
    	       " and BC.BusinessType is not null "+
    	       " and BC.BusinessType<>'' "+
    	       " and BC.VouchType is not null "+
    	       " and BC.VouchType<>'' "+
    	       " and BC.PutOutDate is not null "+ 
    	       " and BC.PutOutDate<>'' " ; 
    	// ����ɷ����ͬ
    	iReinforce1 = DataConvert.toInt(Sqlca.getString(sSql));
    	dbReinforce1 = DataConvert.toDouble(Sqlca.getString(sSql));
    	// ����ɷ����ͬ
    	// (days(current date)-days(replace(CR.FinishDate,'/','-'))) <= 90 ��ǰ�������������ʱ��С�ڵ���90��
    	sSql2 = " select Count(CR.ObjectNo) "+
    	       " from CLASSIFY_RECORD CR "+
    	       " where CR.FinallyResult is not null "+
    	       " and CR.AccountMonth = '"+sAccountMonth+"' "+
    	       " and CR.ObjectType='BusinessContract' "+
    	       " and CR.OrgID = '"+sCurOrgID+"'"+
    	       " and CR.UserID in (select userid from user_role where roleid = '"+sRoleID+"') ";
    	iReinforce2 = DataConvert.toInt(Sqlca.getString(sSql2));
    	dbReinforce2 = DataConvert.toDouble(Sqlca.getString(sSql2));
        iReinforce3 = iReinforce1 - iReinforce2;
    	if(iReinforce1 > 0)
     	    dbReinforce4 = 100*(dbReinforce2/dbReinforce1); 
    	sSql = " select OrgID,OrgName from ORG_INFO where OrgID = '"+sCurOrgID+"'";
    	rs=Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
    		sOrgName = rs.getString("OrgName");
    		if(sOrgName == null) sOrgName = "";
    		sOrgName = sOrgName + sOrgName2 ;
    	}
    	rs.getStatement().close();
%>   	
    	<tr height=1 valign=top bgcolor='#DCDCDC'>
        <td colspan=1><%=sCurOrgID%></td>
        <td colspan=2><%=sOrgName%></td>
        <td colspan=2><%=iReinforce3%></td>
        <td colspan=2><%=iReinforce2%></td>
        <td colspan=2><%=iReinforce1%></td>   
        <td colspan=1><%if (dbReinforce4 == 0) 
                            out.println("0%"); 
                        else
                            out.println(DataConvert.toMoney(Double.toString(dbReinforce4))+"%");
                        %></td>
    </tr>
 <%
    }else{ 	
            sSql2 = " select BC.ManageOrgID as OrgID,getOrgName( BC.ManageOrgID) as OrgName,getSortNo(BC.ManageOrgID) as SortNo, "+
                    " count(case when  CR.FinallyResult is not null then CR.ObjectNo end) as Reinforce2, "+
                    " count(BC.serialno) as Reinforce1 "+
                    " from Business_Contract BC left join Classify_Record  CR on BC.SerialNO = CR.ObjectNo and CR.AccountMonth = '"+sAccountMonth+"' and CR.ObjectType='BusinessContract' "+
                    " where  BC.Balance>0 "+ 
                    " and BC.BusinessType is not null "+ 
                    " and BC.BusinessType<>'' "+
                    " and BC.VouchType is not null "+
                    " and BC.VouchType<>'' "+
                    " and BC.PutOutDate is not null "+ 
                    " and BC.PutOutDate<>'' "+ 
                    " and BC.ManageOrgID in (select BelongOrgID from Org_Belong  where OrgID = '"+sCurOrgID+"') "+
                    " group by BC.ManageOrgID order by SortNo with ur " ;
            rs2=Sqlca.getASResultSet(sSql2);
    		while(rs2.next())
    		{
    			sOrgID = rs2.getString("OrgID");
    			iReinforce1 = rs2.getInt("Reinforce1");   // �����
    			dbReinforce1 = rs2.getDouble("Reinforce1");
    	        iReinforce2 = rs2.getInt("Reinforce2");   // �����
    	        dbReinforce2 = rs2.getDouble("Reinforce2");
    	        iReinforce3 = iReinforce1 - iReinforce2;
    			sOrgName= rs2.getString("OrgName"); 
        	    if(iReinforce1 > 0)
                dbReinforce4 = 100*(dbReinforce2/dbReinforce1); 
    	    	iSum1 = iSum1 + iReinforce1;
    	    	iSum2 = iSum2 + iReinforce2;
    	    	dSum1 = dSum1 + dbReinforce1;
    	    	dSum2 = dSum2 + dbReinforce2;
%>
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td colspan=1><%=sOrgID%></td>
    <td colspan=2><%=sOrgName%></td>
    <td colspan=2><%=iReinforce3%></td>
    <td colspan=2><%=iReinforce2%></td>
    <td colspan=2><%=iReinforce1%></td>   
    <td colspan=1><%if (dbReinforce4 == 0) 
                        out.println("0%"); 
                    else
                        out.println(DataConvert.toMoney(Double.toString(dbReinforce4))+"%");
                    %></td>
</tr>
<%}
	rs2.getStatement().close();  
    if(sCurOrgID.equals("9900") || sOrgFlag.equals("020") || sOrgFlag.equals("040"))
    {   
    	if(iSum1 > 0)
            dbReinforce5 = 100*(dSum2/dSum1); 
    	iSum3 = iSum1 - iSum2;
%>        	    	
    	<tr height=1 valign=top bgcolor='#DCDCDC'>
        <td colspan=3>�ܼƣ�</td>
        <td colspan=2><%=iSum3%></td>
        <td colspan=2><%=iSum2%></td>
        <td colspan=2><%=iSum1%></td>   
        <td colspan=1><%if (dbReinforce5 == 0) 
                            out.println("0%"); 
                        else
                            out.println(DataConvert.toMoney(Double.toString(dbReinforce5))+"%");
                        %></td>
        </tr>
<%       	    	
    }
  }
%>
</table>
</center>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
