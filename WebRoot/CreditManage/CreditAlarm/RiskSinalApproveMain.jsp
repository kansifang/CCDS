<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2011/03/18
		Tester:
		Content: 预警审查审批工作台_Main
		Input Param:
			ApproveType：审批类型
				—ApproveRiskSignalApply/预警信号发起审查审批
			ApproveType1：审批类型1
				—ApproveRiskSignalFApply/预警信号解除审查审批	
		Output param: 
		      
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警信号认定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;预警信号认定&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量：查询结果集
	ASResultSet rs = null,rs1 = null;
	//定义变量：SQL语句、当前工作、已完成工作
	String sSql = "",sSql1="",sFolder1 = "",sFolder11 = "",sFolder12 = "",sFolder2 = "";
	//定义变量：阶段编号、阶段名称、工作数、工作数显示标签、文件夹标记
	String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
	//定义变量：流程编号、阶段类型、组件编号、组件名称
	String sFlowNo = "",sPhaseType = "",sFlowName="";
	//定义变量：审批类型名称、流程对象类型
	String sItemName = "",sObjectType = "",sCurNodeNo="";
	//定义变量:计数器
	int iCount = 0;
	//定义变量：树型菜单页数
	int iLeaf = 1,i = 0,i1 = 0,i2 = 0,j = 0,k = 0;
	String[] h={"0","0","0","0","0","0","0","0","0","0"};
	String[] sCompID={"","","","","","","","","",""};
	String[] sCompName={"","","","","","","","","",""};
	//获得组件参数：审批类型
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sNodeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NodeNo"));
	//将空值转换成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sNodeNo == null) sNodeNo = "";
	//如果sNodeNo为空则取默认值
	if("".equals(sNodeNo))
	{
		sSql = 	" select 1  " +//查询当前工作是否有发起的预警信号申请
			"from RISK_SIGNAL RS, FLOW_TASK FT "+
			" where RS.SerialNo = FT.ObjectNo "+
			" and FT.ObjectType ='RiskSignalApply' "+
			" and FT.UserID='"+CurUser.UserID+"' "+
			" and SignalType ='01' "+
			" and (FT.EndTime is null "+
			" or FT.EndTime = '') "+
			" and (FT.PhaseAction is null "+
			" or FT.PhaseAction = '')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			//有则默认为预警发起当前工作
			sNodeNo="3";
		}else{
			iCount=6;
			//查询发起预警信号当前工作总数
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (EndTime is null or EndTime = '')"+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			//查询发起预警信号已完成工作总数
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null and EndTime <> '' "+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			sNodeNo = ""+iCount;
		}
		rs.getStatement().close();
	}else{
		if("6".equals(sNodeNo))
		{
			iCount=Integer.parseInt(sNodeNo);
			//查询发起预警信号当前工作总数
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and (EndTime is null or EndTime = '')"+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			//查询发起预警信号已完成工作总数
			sSql1 = " select count(*) "+
				" from FLOW_TASK "+
				" where ObjectType = 'RiskSignalApply' and ApplyType='RiskSignalApply' "+
				" and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null and EndTime <> '' "+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName ";
			rs1 = Sqlca.getASResultSet(sSql1);
			while(rs1.next())
			{
				iCount=iCount+1;
			}
			rs1.getStatement().close();
			sNodeNo = ""+iCount;
		}
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//out.println(sTempFlowNo);
	HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	String[] sApproveTypeTemp = sApproveType.split("@");
	while(j<sApproveTypeTemp.length)
	{
		sApproveType = sApproveTypeTemp[j];
		//根据申请类型从代码表CODE_LIBRARY中获得审批类型名称、审批模型编号、流程对象类型、组件编号、组件名称
		sSql = 	" select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 from CODE_LIBRARY where "+
				" CodeNo = 'ApproveType' and ItemNo = '"+sApproveType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sItemName = rs.getString("ItemName");
			sFlowNo = rs.getString("Attribute2");
			sObjectType = rs.getString("ItemAttribute");
			sCompID[j] = rs.getString("Attribute7");
			sCompName[j] = rs.getString("Attribute8");
			//将空值转换成空字符串
			if(sItemName == null) sItemName = "";
			if(sFlowNo == null) sFlowNo = "";
			if(sObjectType == null) sObjectType = "";
			if(sCompID[j] == null) sCompID[j] = "";
			if(sCompName == null) sCompName[j] = "";
			
			//设置窗口标题
			PG_TITLE = sItemName;
			//PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
		}else
		{
			throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
		}	
		rs.getStatement().close();
	
		//把FlowNo拆开，为了加上单引号
		String sTempFlowNo = "(";
		StringTokenizer st = new StringTokenizer(sFlowNo,",");
		while(st.hasMoreTokens())
		{
			sTempFlowNo += "'"+ st.nextToken()+"',";
		}
	
		if(!sTempFlowNo.equals(""))
		{
			sTempFlowNo = sTempFlowNo.substring(0,sTempFlowNo.length()-1)+")";
		}
		
		
	
		//设置当前用户对于该类对象的当前工作菜单项
		sFolder1 = tviTemp.insertFolder("root",PG_TITLE,"",i++);
		h[k] = sFolder1;
		k++;
		sFolder11 = tviTemp.insertFolder(sFolder1,"当前工作","",i1++);
		h[k] = sFolder11;
		k++;
		//从流程任务表FLOW_TASK中查询出当前用户的待审查审批工作信息
		sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,getNodeNo(FlowNo,PhaseNo) as NodeNo,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK "+
				" where ObjectType = '"+sObjectType+"'  and PhaseType <>'1010' and PhaseType <>'1030' ";
				sSql += " and FlowNo in "+sTempFlowNo+" ";
		sSql += " and UserID = '"+CurUser.UserID+"' "+
				" and (EndTime is  null or EndTime =' ' or EndTime ='') "+
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName "+
				" Order by FlowNo,PhaseNo ";
		//out.println(sSql);
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next())
		{	
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));	
			sFlowName = DataConvert.toString(rs.getString("FlowName"));	
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			sCurNodeNo = DataConvert.toString(rs.getString("NodeNo"));   
			 
			//将空值转换成空字符串		
			if(sFlowName == null) sFlowName = ""; 
			if(sPhaseType == null) sPhaseType = ""; 
			if(sPhaseNo == null) sPhaseNo = ""; 		
			if(sPhaseName == null) sPhaseName = ""; 
			if(sWorkCount == null) sWorkCount = "";
			if(sCurNodeNo == null) sCurNodeNo= "";
			if(sWorkCount.equals(""))
				sPageShow  = sPhaseName+" 0 件";	
			else
				sPageShow  = "【"+sFlowName+"】"+sPhaseName+" "+sWorkCount+" 件";	
			//if(!"".equals(sNodeNo)){
				//tviTemp.insertPage(sCurNodeNo,sFolder1,sPageShow,"","javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++,"");
			//}else
			//{
				tviTemp.insertPage(sFolder11,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
			//}
		}
		rs.getStatement().close();
	
		//4、设置当前用户对于该类对象的已完成工作菜单项
		sFolder12 = tviTemp.insertFolder(sFolder1,"已完成工作","",i1++);
		sSql = 	" select FlowNo,FlowName,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK FT "+
				" where ObjectType = '"+sObjectType+"' ";
			sSql += " and FlowNo in "+sTempFlowNo+" ";
		sSql += " and UserID = '"+CurUser.UserID+"' "+
				" and EndTime is not null "+	
				" and EndTime <> ' ' and EndTime <> '' and PhaseType <>'1010' "+	
				" Group by FlowNo,FlowName,PhaseType,PhaseNo,PhaseName "+
				" Order by FlowNo,PhaseNo ";
		
		rs = Sqlca.getASResultSet(sSql);
		rs.beforeFirst();
		while (rs.next())
		{		 
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));
			sFlowName = DataConvert.toString(rs.getString("FlowName"));	
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  		  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			
			//将空值转换成空字符串		
			if(sFlowName == null) sFlowName = ""; 
			if(sPhaseType == null) sPhaseType = ""; 
			if(sPhaseNo == null) sPhaseNo = ""; 		
			if(sPhaseName == null) sPhaseName = ""; 
			if(sWorkCount == null) sWorkCount = "";
			
			if(sWorkCount.equals(""))
				sPageShow  = sPhaseName+" 0 件";	
			else
				sPageShow  = "【"+sFlowName+"】"+sPhaseName+" "+sWorkCount+" 件";		
			
			tviTemp.insertPage(sFolder12,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
		}
		rs.getStatement().close();
		j += 1;
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function openPhase(sApproveType,sPhaseType,sFlowNo,sPhaseNo,sFinishFlag)
	{
		if(sFlowNo=="RiskSignalFlow")//预警发起
		{
			sTempApproveType="ApproveRiskSignalApply";
			//打开对应的审批界面
			OpenComp("<%=sCompID[0]%>","<%=sCompName[0]%>","ApproveType="+sTempApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		}else{//预警解除
			sTempApproveType="ApproveRiskSignalFApply";
			//打开对应的审批界面
			OpenComp("<%=sCompID[1]%>","<%=sCompName[1]%>","ApproveType="+sTempApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		}
		setTitle(getCurTVItem().name);
	}
    
	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle)
	{
		//document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
		
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>;
	}
	
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	<%
		int j1 = 0;
		while(j1<10)
		{
	%>
			expandNode('<%=h[j1]%>');
	<%
			j1++;
		}
	%>
	if("<%=sNodeNo%>" !="")
	{ 
		selectItem('<%=sNodeNo%>');
	}else{
		selectItem('3');
	}

	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
