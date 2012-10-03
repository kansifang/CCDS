<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: xhyong 2011/03/28
 * Tester:
 *
 * Content: 查看审批意见
 * Input Param:
 *      ObjectType: 对象类型
 *      ObjectNo:   对象编号
 *		FlowNo：流程号
 *		PhaseNo：阶段号
 * Output param:
 *
 * History Log: 
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
	boolean bRolePrivilege = false; //哪些阶段能看
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//判断当前意见所处阶段是否在对应的特权阶段

	String sFlowNo = "";
	String FOPhaseChoice = "";
	String sSelfOpinionPhase = "";
	String sSelfOpinion = "";
	String sPhaseName = "";
	String sUserName = "";
	String sOrgName = "";
	String sBeginTime = "";
	String sEndTime = "";
	String sCustomerName = "";
	String sBusinessCurrencyName = "";
	String sRateFloatTypeName = "";
	String sCognResult = "";
	int iCountRecord=0;//用于判断记录是否有审批意见

	ASResultSet rs = null;
	//获取仅查看自己签署的意见所对应的阶段
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo = '"+sCurFlowNo+"' "+
			" and PhaseNo = '"+sCurPhaseNo+"' ";
	sSelfOpinionPhase = Sqlca.getString(sSql);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//获取仅查看自己签署的意见信息
	if(!sSelfOpinionPhase.equals(""))
	{
		sSql =  " select getItemName('PhaseChoice',RO.ConfirmType) as FOPhaseChoice,"+
				" RO.SignalLevel,RO.Opinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime "+
				" from FLOW_TASK FT,RISKSIGNAL_OPINION RO "+
				" where FT.Serialno=RO.SerialNo "+				
				" and (RO.Opinion is not null) "+
				" and RO.CheckUser = '"+CurUser.UserID+"' "+
				" and FT.ObjectNo='" + sObjectNo + "' "+
				" and FT.ObjectType='"+ sObjectType +"'"+
				" and FT.FlowNo = '"+sCurFlowNo+"' "+
				" and FT.PhaseNo= '"+sCurPhaseNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
			sSelfOpinion = rs.getString("Opinion");
			sPhaseName = rs.getString("PhaseName");
			sUserName = rs.getString("UserName");
			sOrgName = rs.getString("OrgName");
			sBeginTime = rs.getString("BeginTime");
			sEndTime = rs.getString("EndTime");
			FOPhaseChoice = rs.getString("FOPhaseChoice");
			iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2,
	sSql = 	" select getItemName('PhaseChoice',RO.ConfirmType) as FOPhaseChoice,RO.Opinion, "+
			" RO.SignalLevel,FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,FT.EndTime, "+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
			" from FLOW_TASK FT,RISKSIGNAL_OPINION RO,FLOW_MODEL FM "+
			" where FT.Serialno=RO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (RO.Opinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'";
	
	if(CurUser.hasRole("2A5")||CurUser.hasRole("2J4")||CurUser.hasRole("2D3")||CurUser.hasRole("080")||CurUser.hasRole("280")||CurUser.hasRole("480")){
		sSql += "and (FT.UserID='"+CurUser.UserID+"' or FT.PhaseNo='3000' or FT.PhaseNo='0010' or FT.PhaseAction='否决'  or FT.PhaseAction='退回补充资料' or FT.PhaseAction='批准') ";
	}
	sSql +=	" and ( FT.PhaseNo<='"+sCurPhaseNo+"' or FT.PhaseNo='3000' or FT.PhaseAction='否决' or FT.PhaseAction='退回补充资料' or FT.PhaseAction='批准') ";//只能查看下级意见，不能看上级意见,可以看补充资料和批准意见 add by zrli 
			
	if(sSelfOpinionPhase.equals(""))
		sSql += " ORDER BY FT.SerialNo";
	else
		sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY FT.SerialNo";
	rs=Sqlca.getASResultSet(sSql);
%>
<html>
<head>
<title>审批详情</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        
        while (rs.next())
        {
			sOpinionRightType = rs.getString("OpinionRightType");    //查看意见方式 all_except(排除一些阶段) none_except(选择一些阶段)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//不同查看意见方式对应的阶段
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //意见查看特权角色
			sPhaseAction = rs.getString("PhaseAction");
			//将空值转化为空字符串
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";
			
			//1、判断该用户是否拥有特权角色
			if(sOpinionRightRoles.equals("")) bRolePrivilege = false;
			else{
				Object[] roles = CurUser.roles.getKeys();
				for(int i=0;i<roles.length;i++){
					if(sOpinionRightRoles.indexOf((String)roles[i])>=0){
						bRolePrivilege = true;
						break;
					}
				}
			}
			
			//2、判断当前意见所处阶段是否在模型对应的特权阶段
			if(sOpinionRightPhases.equals("")) bPhaseMatch = false;			
			else{
				int iCountPhases = StringFunction.getSeparateSum(sOpinionRightPhases,",");
				
				String sTempFlowPhase,sTempFlow,sTempPhase;
				for(int i=0;i<iCountPhases;i++){
					sTempFlowPhase = StringFunction.getSeparate(sOpinionRightPhases,",",i+1);					
					if(sTempFlowPhase.indexOf(".")<0) sTempFlowPhase = sCurFlowNo + "." + sTempFlowPhase;					
					if(sTempFlowPhase.equals(sCurFlowNo+"."+sCurPhaseNo)){
						bPhaseMatch = true;
						break;
					}
				}
			}
			
			//3、根据查看意见方式的不同，判断是否可以显示
			if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
				bPhasePrivilege = bPhaseMatch;
			}else{
				bPhasePrivilege = !bPhaseMatch;				
			}
			
			//bPhasePrivilege = true; bRolePrivilege = true;
			//4、最终判断是否显示意见，如果不需要显示，则继续判断下一条意见
			//该用户是否具有特权角色、该阶段意见是否属于该意见可查看阶段、该阶段是否属于			
			if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("补充资料")<0) continue;
			iCountRecord++;						
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
	  <tr>
            <td width=50%><b>认定意见:</b><%=DataConvert.toString(rs.getString("FOPhaseChoice"))%></td>
            <td width=50%><b>预警级别:</b><%=DataConvert.toString(rs.getString("SignalLevel"))%></td>
        </tr>
	  	<tr>            
			<td width=50%><b>认定机构:</b><%=DataConvert.toString(rs.getString("OrgName"))%></td>
            <td width=50%><b>认定人:</b><%=DataConvert.toString(rs.getString("UserName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>认定时间:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
            <td width=50%><b></b></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【认定意见】"+ StringFunction.replace(DataConvert.toString(rs.getString("Opinion")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();
    %>
 
  </table>
</body>
</html>
<%
	//如果没有意见或者没有找到对应的对象，则自动关闭
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<script>
    alert("目前此业务还没有您可以查看的审批意见！");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>