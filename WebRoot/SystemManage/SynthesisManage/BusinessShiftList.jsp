<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 待处理业务转授权列表界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待处理业务转授权"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%		
	//定义变量
	String sSql;
	ASResultSet rs = null;
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String sHeaders[][] = {
								{"Status","是否转授权"},
								{"SerialNo","任务流水号"},
								{"ObjectTypeName","对象类型"},
								{"ObjectNo","对象编号"},
								{"OrgName","机构名称"},
								{"UserName","用户名称"},		
								{"FlowName","流程"},								
								{"PhaseName","当前阶段"},
								{"BeginTime","开始日期"}	
				            };
		
	 sSql = " Select '  ' as Status ,getObjectName(ObjectType) as ObjectTypeName,ObjectType,SerialNo, "+
	 		" ObjectNo,OrgID,OrgName,UserID,UserName,FlowNo,FlowName,PhaseNo,PhaseName,BeginTime "+
			" from FLOW_TASK where  OrgID In (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
		    " and (EndTime is null or EndTime = '') and PhaseNo not in('0010','3000','1000','8000') ";  

	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	
	doTemp.setAlign("Status","2");
	//设置字段不可见
	doTemp.setVisible("ObjectType,OrgID,UserID,FlowNo,PhaseNo",false);
	//设置字段显示宽度	
	doTemp.setHTMLStyle("Status","style={width:80px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");
		
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置为Grid风格
	dwTemp.Style="1";
	//设置为只读
	dwTemp.ReadOnly = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","查看业务详情","查看业务详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","转授权","待处理业务转授权信息","transferTask()",sResourcesPath}	,
		   {"true","","PlainText","(双击左键选择/取消 是否转授权)","(双击左键选择或取消 是否转授权)","style={color:red}",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//检查是否存在已选中的记录
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		//获取对象类型和对象编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		OpenObject(sObjectType,sObjectNo,"002");		
	}
	
	/*~[Describe=待处理业务转授权;InputParam=无;OutPutParam=无;]~*/	
	function transferTask()
    {    	
    	//检查是否存在已选中的记录
    	var j = 0;
		var a = getRowCount(0);
		for(var i = 0 ; i < a ; i++)
		{				
			var sStatus = getItemValue(0,i,"Status");
			if(sStatus == "√")
				j=j+1;
		}
		if(j <= 0)
		{
			alert(getBusinessMessage('918'));//请选择待处理业务！
			return;
		}
    	if (confirm(getBusinessMessage('920')))//确认转移该待处理业务吗？
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//获取当前机构
			var sOrgID = "<%=CurOrg.OrgID%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('921'));//请选择转授权后的用户！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//需判定是否至少有一个合同被选定待交接了。把有的找出来
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "√")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"OrgID");
						sFromOrgName = getItemValue(0,i,"OrgName");
						sFromUserID = getItemValue(0,i,"UserID");
						sFromUserName = getItemValue(0,i,"UserName");	
						if(sFromUserID == sToUserID)
						{
							alert(getBusinessMessage('922'));//不允许待处理业务转授权在同一用户间进行，请重新选择转授权后的用户！
							return;
						}										
						//调用页面更新
						sReturn = PopPage("/SystemManage/SynthesisManage/BusinessShiftAction.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("任务流水号("+sSerialNo+"),"+"业务转授权成功！");
						else if(sReturn == "FALSE")
							alert("任务流水号("+sSerialNo+"),"+"业务转授权失败！");						
					}
				}				
				reloadSelf();
				
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=右击选择记录;InputParam=无;OutPutParam=无;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus) == "undefined" || sStatus == "")
			setItemValue(0,getRow(),"Status","√");
		else
			setItemValue(0,getRow(),"Status","");

	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
