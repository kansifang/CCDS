<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   cwzhan  2003-9-19
 * Tester:
 * Content: ����ͳ��--�Ա�����������������Ҫ���Ǻ�����ɲ��ǵ�ҵ�����ͳ��
 * Input Param:
 * Output param:
 *                  
 * History Log:     
 *                  
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>����ͳ��</title> 
</head>
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" >
<center>
<p>&nbsp;</p>
<%
    String sSql="";
    ASResultSet rs=null;
    String sReinforce = "";
    String sCurOrgID = CurOrg.OrgID;
    
    int iReinforce1=0,iReinforce2=0,iReinforce3=0,iReinforce4=0,iReinforce=0;
    int iSumReinforce1=0,iSumReinforce2=0,iSumReinforce3=0,iSumReinforce4=0,iSumReinforce=0;
   	double dbReinforce1=0,dbReinforce2=0,dbReinforce3=0,dbReinforce4=0,dbReinforce=0;
	String [] sWorkCount;
    double dbScale = 0.00;
%>
<table border="2" width="100%"  cellspacing="0" cellpadding="0">
<tr>
    <td colspan=8 align=center><b>����ͳ����Ϣ</b></td>
</tr>
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td width=8% align="center"><b>��������</b></td>
    <td width=19% align="center"><b>��������</b></td>
    <td width=13% align="center"><b>�貹���Ŵ�ҵ��</b></td>
    <td width=13% align="center"><b>��������Ŵ�ҵ��</b></td>    
    <td width=8% align="center"><b>����</b></td>
    <td width=13% align="center"><b>��ɲ��Ǳ���</b></td>
</tr>

<%
    sSql =  " select OrgID,getOrgName(OrgID), "+
            " getReinforceCount(OrgID,'010') as Reinforce1, "+
            " getReinforceCount(OrgID,'020') as Reinforce2,SortNo "+
            " from Org_Info "+
            " where  "+
            " OrgID in (select BelongOrgId from ORG_BELONG where OrgID='"+sCurOrgID+"') "+
            " group by OrgID,SortNo "+
            " order by SortNo with ur";
    rs=Sqlca.getASResultSet(sSql);
	//out.println(sSql);
    
    String sOrgID = "";
    while(rs.next())
    {
    	dbReinforce1=0.0;
    	dbReinforce2=0.0;
    	iReinforce1=0;
    	iReinforce2=0;
    	iReinforce3=0;
    	dbReinforce4=0.0;
        sOrgID = rs.getString(1);
        dbReinforce1 = rs.getDouble("Reinforce1");
        dbReinforce2 = rs.getDouble("Reinforce2");
		iReinforce1 = rs.getInt("Reinforce1");
        iReinforce2 = rs.getInt("Reinforce2");
        iReinforce3 = iReinforce1 + iReinforce2;
        if(iReinforce3 > 0)
        	dbReinforce4 = 100*(dbReinforce2/(dbReinforce1+dbReinforce2));
       
   
%>
<tr height=1 valign=top bgcolor='#DCDCDC'>
    <td width=8%><%=DataConvert.toString(rs.getString(1))%></td>
    <td width=19%><%=DataConvert.toString(rs.getString(2))%></td>
    <td width=13%><%=iReinforce1%></td>
    <td width=13%><%=iReinforce2%></td>
    <td width=13%><%=iReinforce3%></td>   
    <td width=13%><%if (dbReinforce4 == 0) 
                        out.println("0%"); 
                    else
                        out.println(DataConvert.toMoney(Double.toString(dbReinforce4))+"%");
                    %></td>
</tr>
<%}
	rs.getStatement().close();  
 %>
</table>
</center>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
