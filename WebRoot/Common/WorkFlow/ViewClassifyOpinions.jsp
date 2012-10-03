<%
/* 
 *Author: xhyong 2009/08/24
 * Content: 查看风险分类认定意见
 * Input Param:
 * Output param:
 *
 * History Log: 
	 bqliu 2011-06-16
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
	String sResult1 = "";
	String sClassifyLevel1 = "";
	String sClassifyLevel2 = "";
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sPhaseAction="";
	boolean bRolePrivilege = false; //哪些阶段能看
	boolean bPhasePrivilege = false;//
	boolean bPhaseMatch = false;//判断当前意见所处阶段是否在对应的特权阶段

	int iCountRecord=0;//用于判断记录是否有审批意见

	ASResultSet rs = null;
	//获得申请相关信息:初分结果
	sSql = 	" select getItemName('ClassifyResult',Result1) as Result1,getItemName('ClassifyResult',ClassifyLevel) as ClassifyLevel, "+
			" getItemName('ClassifyResult',ClassifyLevel2) as ClassifyLevel2 "+
	        " from CLASSIFY_RECORD "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sResult1 = rs.getString("Result1");
		sClassifyLevel1 = rs.getString("ClassifyLevel");
		sClassifyLevel2 = rs.getString("ClassifyLevel2");
		//将空值转化为空字符串
		if(sResult1 == null) sResult1 = "";
		if(sClassifyLevel1 == null) sClassifyLevel1 = "";
		if(sClassifyLevel2 == null) sClassifyLevel2 = "";
	}
	rs.getStatement().close();
	
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute3,
	sSql = 	" select FO.CustomerName, "+//客户名称
			" FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
			" FT.BeginTime,FT.EndTime,FT.PhaseChoice,"+
			" FO.PhaseOpinion,FO.PhaseOpinion6,getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1, "+
			" getItemName('ClassifyResult',FO.PhaseOpinion2) as PhaseOpinion2,getItemName('ClassifyResult',FO.PhaseOpinion3) as PhaseOpinion3, "+//认定意见，系统评定得分，系统评定结果，人工结果
			" getItemName('ClassifyResult',FO.PhaseOpinion4) as PhaseOpinion4,getItemName('ClassifyResult',FO.PhaseOpinion5) as PhaseOpinion5,"+
			" getItemName('ClassifyResult',FO.phasechoice) as phasechoice1,getItemName('ClassifyResult',FO.phasechoice2) as phasechoice2,"+
			" FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
			" from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
			" where FT.Serialno=FO.SerialNo "+
			" and FT.FlowNo=FM.FlowNo "+
			" and FT.PhaseNo=FM.PhaseNo "+
			" and (FO.PhaseOpinion is not null) "+
			" and FT.ObjectNo='" + sObjectNo + "' "+
			" and FT.ObjectType='"+ sObjectType +"'"+
		    " ORDER BY FT.BeginTime";
	rs=Sqlca.getASResultSet(sSql);
%>
<html>
<head>
<title>审批详情</title>
</head>
<body leftmargin="0" topmargin="0" class="pagebackground">
  <table width="100%" cellpadding="3" cellspacing="0" border="0" >
    <%
        int n = 1;
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
				
				String sTempFlowPhase;
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
			iCountRecord++;	
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr>            
			<td width=50%><b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%></td>
            <td width=50%><b>处理人:</b><%=DataConvert.toString(rs.getString("UserName"))%></td>
        </tr>
        <tr>            
			<td width=50%><b>处理人所属机构:</b><%=DataConvert.toString(rs.getString("OrgName"))%></td>
            <td width=50%><b>客户名称:</b><%=DataConvert.toString(rs.getString("CustomerName"))%></td>
        </tr>
        <tr>   
        	<td width=50%><b>系统批量初分结果:</b><%=DataConvert.toString(rs.getString("PhaseOpinion2"))%></td>   
        	<td width=50%> </td>      
        </tr>
        <tr>   
            <td width=50%><b>客户经理分类初分结果（账面）:</b><%=DataConvert.toString(rs.getString("PhaseOpinion3"))%></td>
            <td width=50%><b>客户经理分类初分结果（实际）:</b><%=DataConvert.toString(rs.getString("PhaseOpinion4"))%></td>
        </tr>
        <% if(n>2){%>
        <tr>   
        	<td width=50%><b>风险分类复核结果（账面）:</b><%=DataConvert.toString(rs.getString("phasechoice1"))%></td>  
        	<td width=50%><b>风险分类复核结果（实际）:</b><%=DataConvert.toString(rs.getString("phasechoice2"))%></td>       
        </tr>
        <% }%>
        <%if(n>1){%>
        <tr>   
            <td width=50%><b>分类认定结果（账面）:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%></td>
            <td width=50%><b>分类认定结果（实际）:</b><%=DataConvert.toString(rs.getString("PhaseOpinion5"))%></td>
        </tr>
        <% }%>
        <tr>
            <td width=50%><b>开始时间:</b><%=DataConvert.toString(rs.getString("BeginTime"))%></td>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(rs.getString("EndTime"))%></td>
        </tr>
        
        <tr>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style={width:100%;height=170px}>
                     <%="\r\n【分类调整意见（账面）】"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n")
                     %>
                     <%="\r\n【分类调整意见（实际）】"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion6")).trim(),"\\r\\n","\r\n")
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
    n++;
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
    alert("目前此风险分类还没有您可以查看的认定意见！");
</script>
<%
	}
%>
<%@ include file="/IncludeEnd.jsp"%>