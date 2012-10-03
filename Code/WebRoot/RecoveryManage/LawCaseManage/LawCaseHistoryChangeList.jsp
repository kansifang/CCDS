<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 管理人历次变更基本信息
		Change Param:
				ObjectNo: 对象编号或抵债资产编号
				ObjectType：对象类型
				
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "管理人历次变更基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sObjectNo;	//对象编号
	String sObjectType;	//对象类型
	
	
	//获得页面参数
	        	
    	//对象编号（案件编号或资产编号）,对象类型
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	String sHeaders[][] = { 		
    					{"SerialNo","历次变更记录流水号"},
    					{"OldUserName","原管理人"},
    					{"OldOrgName","原管理机构"},  					
						{"NewUserName","现管理人"},
						{"NewOrgName","现管理机构"}, 					
						{"ChangeReason","历次变更原因"},
						{"ChangeDate","历次变更日期"},
						{"Remark","备注"},
						{"ChangeUserName","变更人"},
						{"ChangeOrgName","变更机构"},
						{"ChangeTime","变更日期"}
						
					}; 

	sSql = 	" select SerialNo,ObjectNo,ObjectType, "+
			" OldUserID,getUserName(OldUserID) as OldUserName, "+
			" OldOrgID,getOrgName(OldOrgID) as OldOrgName, "+			
			" NewUserID,getUserName(NewUserID) as NewUserName, "+
			" NewOrgID,getOrgName(NewOrgID) as NewOrgName, "+
			" ChangeUserID,getUserName(ChangeUserID) as ChangeUserName, "+
			" ChangeOrgID,getOrgName(ChangeOrgID) as ChangeOrgName,ChangeTime "+
			" from MANAGE_CHANGE "+
			" where ObjectNo='"+sObjectNo+"'  "+	//对象编号（案件编号或抵债资产编号）
			" and ObjectType='"+sObjectType+"' "+
			" order by ChangeTime desc";	//对象类型（案件为LawCase_info、抵债资产为Asset_Info）
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "MANAGE_CHANGE";	
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //设置关键字
	
	//设置不可更新
	doTemp.setUpdateable("ChangeUserName,ChangeOrgName,NewOrgName,NewUserName",false);	

	//设置日期
	doTemp.setCheckFormat("ChangDate,ChangeDate","3");

	//设置共用格式
	doTemp.setVisible("OldUserID,OldOrgID,NewUserID,NewOrgID",false);
	doTemp.setVisible("ChangeUserID,ChangeOrgID",false);
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	
	//设置只读
	doTemp.setReadOnly("SerialNo,OldUserName,OldOrgName,ChangeUserName,ChangeOrgName,NewUserName,NewOrgName,ChangeTime",true);
	
	//设置选项行宽
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	
	
	//设置编辑形式如大文本框
	doTemp.setEditStyle("ChangeReason","3");
	doTemp.setEditStyle("Remark","3");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","查看详情","查看变更详细信息","viewAndEdit()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	//查看变更管理人历史详情	
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo"); //记录流水号
		sObjectNo=getItemValue(0,getRow(),"ObjectNo"); //对象编号
		sObjectType=getItemValue(0,getRow(),"ObjectType"); //对象类型
		
	       if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));//请选择一条信息！
			return false;
		}
		else
		{
			
			OpenPage("/RecoveryManage/LawCaseManage/ManagerChangeInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&Flag=Y","right",OpenStyle);

		}
		 
	}	
	
	
	/*~[Describe=返回列表页面;ChangeParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","_self","");
		
	}
    
	</script>
	
	

<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

