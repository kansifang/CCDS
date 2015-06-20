<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")));   
	String sSql;
	ASResultSet rs=null;
	String sWorkBrief="",WhereCase="";
	int countPlan=0;
	WhereCase=	" from Batch_Case W where W.Status like '%变更已申请' "+
					" and exists(select 1 "+
					" from User_Role UR,Role_Info RI,Code_Library CL "+
					" where UR.UserID='"+CurUser.UserID+"'"+
					" and UR.RoleID=RI.RoleID"+
					" and locate(CL.ItemNo,RI.RoleDescribe)>0"+
					" and CL.CodeNo='SystemType' "+
					" and CL.IsInUse='1'"+
					" and (locate(W.SystemName,CL.ItemDescribe)>0 or locate(CL.ItemDescribe,W.SystemName)>0)) ";
	if(sFlag.equals("0")){
		sSql = 	" select count(ChangeNo) ";
		sSql = sSql+ WhereCase;	
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())  
			countPlan = rs.getInt(1);
		out.println(countPlan);
	}else if(sFlag.equals("1")){
		sSql = 	" select W.ChangeNo,SystemName,"+
					"W.Summary,W.ChangeUser";
		sSql = sSql+ WhereCase+" order by SystemName,ChangeNo asc";	
		rs = Sqlca.getResultSet(sSql);
		int iWorks=1;
		while(rs.next()){
			sWorkBrief = DataConvert.toString(rs.getString("Summary"));
%>
  	    		<tr>
                    <td align="left" title="<%=sWorkBrief%>" >
	                     <%
	                     	String sSystemName = DataConvert.toString(rs.getString("SystemName"));
	                  		//工作重要性（01：一般；02：重要：03：非常重要）
	                     	if(!sSystemName.equals("01")){
	                     %>
	                       <img  width=12 height=12 src="<%=sResourcesPath%>/alarm/icon4.gif">
	                     <%
	                     	}else{
	                     %>
	                       &nbsp;&nbsp;
	                     <%
	                     	}
	                     %>
	                    <a href="javascript:popComp('CaseInfo','/BusinessManage/CaseInfo.jsp','ChangeNo=<%=rs.getString("ChangeNo")%>','')">
	 					<%=iWorks%>
	 					<%=". ["+DataConvert.toString(rs.getString("ChangeNo"))+":"+DataConvert.toString(rs.getString("SystemName"))+"]"%>&nbsp;
						<%
							if(sWorkBrief.length()>10) 
								sWorkBrief = sWorkBrief.substring(0,10)+"...";
								out.println(sWorkBrief);
						%>
                       	</a>
                     </td>
                 <br/>
                 </tr>
				<%
					iWorks++;
						}
				}
				rs.getStatement().close();
				%>
<%@ include file="/IncludeEndAJAX.jsp"%>