<%@ page import="com.amarsoft.are.util.StringFunction" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: �ҵĹ���̨
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%
     String sSql ;
     ASResultSet rs;
%>
<script language=javascript>

	function newTask(){
		popComp("NewWork","/DeskTop/WorkRecordInfo.jsp","NoteType=All&PlanDate=<%=StringFunction.getToday()%>","dialogwidth:640px;dialogheight:480;");
	}
	function editWork(sSerialNo,sNoteType,sObjectNo){ 
		popComp("NewWork","/DeskTop/WorkRecordInfo.jsp","SerialNo="+sSerialNo,"dialogwidth:640px;dialogheight:480;");
	}
		
	function Inspect1()
	{
	    OpenComp("BusinessInspectMain","/CreditManage/CreditCheck/BusinessInspectMain.jsp","ComponentName=������&ComponentType=MainWindow&TreeviewTemplet=BusinessInspectMain","_top","");
	}
	function Inspect2()
	{
	    OpenComp("BusinessInspectMain","/CreditManage/CreditCheck/BusinessInspectMain.jsp","ComponentName=������&ComponentType=MainWindow&TreeviewTemplet=BusinessInspectMain","_top","");
	}
</script>
<html>
<head>
<title>�ճ�������ʾ</title>

<link rel="stylesheet" href="Style.css">

</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="4">
                      <tr>
                        <td width="20%" valign="top" align="center">
                          <p><br>
                          <%
	                          String sPic = StringFunction.getNow().substring(7);
	                          sPic+=".gif";
                          %>
                          <img src="<%=sResourcesPath%>/DailyPics/<%=sPic%>">
                          </p>
                          <p><a href="javascript:self.location.reload();">ˢ��</a></p>
                          
                        </td>
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="4" bordercolordark="#FFFFFF" width="100%" >
							<!-------------------���Լ����ŵĹ���------------------------------------------------->
                            <tr>
                              <td align="left" colspan="2" background="<%=sResourcesPath%>/workTipLine.gif" ><b>���Լ����ŵĹ����ƻ�</b>
                              </td>
                            </tr>
							<%
								String sWorkBrief="";
								sSql = 	" select W.SerialNo,GetItemName('WorkType',WorkType)  as WorkType,W.WorkBrief,W.PlanFinishDate,W.ActualFinishDate,"+
										" getOrgName(W.OperateOrgID) as OrgName,getUserName(W.OperateUserID) as UserName,Importance,Urgency "+
										" from WORK_RECORD W "+
										" where W.PromptBeginDate <= '"+StringFunction.getToday()+"' "+
										" and W.PromptEndDate >= '"+StringFunction.getToday()+"' "+				
										" and (W.ActualFinishDate is null or W.ActualFinishDate='') "+
										" and W.OperateUserID = '"+CurUser.UserID+"'  ";
										
								rs = Sqlca.getResultSet(sSql);
								int iWorks=1;
							  	if(rs.next())
							  	{
									do
									{
										sWorkBrief = DataConvert.toString(rs.getString("WorkBrief"));
							%>
	        	    		<tr>
                              <td align="left" title="<%=sWorkBrief%>" >
                            <%
										String sImportance = DataConvert.toString(rs.getString("Importance"));
										if(!sImportance.equals("01"))//������Ҫ�ԣ�01��һ�㣻02����Ҫ��03���ǳ���Ҫ��
										{
                            %>
                              <img  width=12 height=12 src="<%=sResourcesPath%>/alarm/icon4.gif">
                            <%
										}else
										{
                            %>
                              &nbsp;&nbsp;
                            <%
										}
                            %>
                              	<a href="javascript:editWork('<%=rs.getString("SerialNo")%>')">
							 		<%=iWorks%><%=". ["+DataConvert.toString(rs.getString("WorkType"))+"]"%>&nbsp;&nbsp;
							<%
										if(sWorkBrief.length()>10) sWorkBrief = sWorkBrief.substring(0,10)+"...";
										out.println(sWorkBrief);
							%>
                              	</a>
                              </td>
                              <td align="right" valign="bottom">
                              	<a href="javascript:editWork('<%=rs.getString("SerialNo")%>')">����</a>
                              </td>
                            </tr>
							<%
							     		iWorks++;
								    }while (rs.next());
								}else
								{
							%>
                            <tr>
                              <td align="left"> ��&nbsp;</td>
                              <td align="right" valign="bottom"><a href="javascript:newTask()">����</a>&nbsp;</td>
                            </tr>
							<%
								}
								rs.getStatement().close();
							%>

							<%
								ASResultSet rsTips=null;
								String sTipsFlag;
								sSql= 	" select getBusinessName(BA.BusinessType)||'&nbsp;['||BA.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
										" BA.BusinessSum,FT.ApplyType,FT.BeginTime,FT.PhaseName,FT.PhaseNo "+
										" from BUSINESS_APPLY BA, FLOW_TASK FT "+
										" where BA.SerialNo = FT.ObjectNo "+
										" and FT.ObjectType='CreditApply' "+
										" and FT.UserID='"+CurUser.UserID+"' "+
										" and (FT.EndTime is null "+
										" or FT.EndTime = '') "+
										" and (FT.PhaseAction is null "+
										" or FT.PhaseAction = '') "+
										" order by FT.BeginTime";
								
								rsTips = Sqlca.getResultSet(sSql);
								if(rsTips.next())
								{
							%>
	                        <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        <tr >
	                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
                  	                <b>��������Ŵ�ҵ������</b>&nbsp;
	                        	</td>
	                        </tr>
							<%							
									do
									{
										if (rsTips.getString(4).substring(0,10).equals(StringFunction.getToday()))
											sTipsFlag="&nbsp;&nbsp;";
										else
											sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='�ù�����������ѳ���1��'>&nbsp;";
							%>
				                         	<tr>
				            <%
				                         	if(rsTips.getString(6).equals("0010") || rsTips.getString(6).equals("3000"))
				                         	{//������δ�ύ�򷢻ز�������
				            %>
				                         	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=<%=rsTips.getString(3)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
				            <%
				                        	}else
				                        	{//���������				                        	
				            %>
				                        		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApproveCreditApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
				            <%
				                        	}
				         	%>
				                        		<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
				                        	</tr>
							<%
				 					}while (rsTips.next());
					 			}
				                rsTips.getStatement().close();
							%>

							<%
								sSql= 	" select getBusinessName(BA.BusinessType)||'&nbsp;['||BA.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
										" BA.BusinessSum,FT.BeginTime,FT.PhaseName,FT.PhaseNo "+
										" from BUSINESS_APPROVE BA, FLOW_TASK FT "+
										" where BA.SerialNo=FT.ObjectNo "+
										" and FT.ApplyType='ApproveApply' "+
										" and FT.UserID='"+CurUser.UserID+"' "+
										" and (FT.EndTime is null "+
										" or FT.EndTime = '') "+
										" and (FT.PhaseAction is null "+
										" or FT.PhaseAction = '') ";
							
								rsTips = Sqlca.getResultSet(sSql);
								if(rsTips.next())
								{
							%>
	                        <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        <tr >
	                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
	                          	<b>�����������</b>&nbsp;
	                        	</td>
	                        </tr>
							
							<%
							
									do 
									{
										if (rsTips.getString(3).substring(0,10).equals(StringFunction.getToday()))
											sTipsFlag="&nbsp;&nbsp;";
										else
											sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='�ù�����������ѳ���1��'>&nbsp;";
							%>
				                         	<tr>
				            <%
			                         	if(rsTips.getString(5).equals("0010") || rsTips.getString(5).equals("3000"))
			                         	{//������δ�ύ�򷢻ز�������
				            %>
				                         	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=ApproveApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
				            <%
			                        	}else
			                        	{//������
				            %>
				                         	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApproveApprovalApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%></a>&nbsp;</td>
				            <%
				                        }
				            %>
				                        	   <td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
				                        	</tr>
							<%
				 					}while(rsTips.next());
				 				}
				                rsTips.getStatement().close();
							%>

							<%
								sSql = 	" select getBusinessName(BP.BusinessType)||'&nbsp;['||BP.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
										" BP.BusinessSum,FT.BeginTime,FT.PhaseName,FT.PhaseNo "+
										" from BUSINESS_PUTOUT BP, FLOW_TASK FT "+
										" where BP.SerialNo=FT.ObjectNo "+
										" and FT.ObjectType='PutOutApply' "+
										" and FT.UserID='"+CurUser.UserID+"' "+
										" and (FT.EndTime is null "+
										" or FT.EndTime = '') "+
										" and (FT.PhaseAction is null "+
										" or FT.PhaseAction = '') ";
						
								rsTips = Sqlca.getResultSet(sSql);
								
								if(rsTips.next()) 
								{
							%>
	                        <tr>
	                        	<td align="left" colspan="2">&nbsp; </td>
	                        </tr>
	                        <tr >
	                        	<td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif">
	                          	<b>������ķſ�</b>&nbsp;
	                        	</td>
	                        </tr>

							<%
									do
									{
										if (rsTips.getString(3).substring(0,10).equals(StringFunction.getToday()))
										{
											sTipsFlag="&nbsp;&nbsp;";
										}else{
											sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='�ù�����������ѳ���1��'>&nbsp;";
										}
							%>
				                         	<tr>
			                <%
			                         	if(rsTips.getString(5).equals("0010") || rsTips.getString(5).equals("3000"))
			                         	{//������δ�ύ�򷢻ز�������
			                %>
				                         	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=PutOutApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                        	<%
                        				}else
                        				{//������
                        	%>
				                         	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('PutOutApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApprovePutOutApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%></a>&nbsp;</td>
                        	<%
                        				}
                        	%>
				                        	   <td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
				                        	</tr>
			                     
							<%
									}while(rsTips.next());
				 				}
				                rsTips.getStatement().close();
								
								//����֧�пͻ��������пͻ��������пͻ������ɫ���û����Դ��ճ�������ʾ��ֱ�ӽ�������鱨��
							    if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("480"))
							    {
							%> 
						        <tr>
						 	      <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect1()><font color=blue>���ռ�鱨��</font>&nbsp;</td>	   
							    </tr>
							<%   
							    }
							    //����֧���Ŵ����մ�����Ա�������Ŵ����մ�����Ա�������Ŵ����մ�����Ա��ɫ���û����Դ��ճ�������ʾ��ֱ�ӽ�������鱨��
							    else if(CurUser.hasRole("040") || CurUser.hasRole("240") || CurUser.hasRole("440"))
							    {
							%>
						        <tr>
						 	      <td align="left" >&nbsp;&nbsp;<a href="#" onClick=Inspect2()><font color=blue>���ռ�鱨��</font>&nbsp;</td>	   
							    </tr>
							<%
						   		}
						    %>							
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>

</body>
</html>


<%@ include file="IncludeEnd.jsp"%>