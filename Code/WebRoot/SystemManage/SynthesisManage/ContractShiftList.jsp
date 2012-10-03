<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 合同转移列表界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同转移"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%		
	//定义变量
	String sSql;	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String sHeaders[][] = {
			                    {"BCFlag","是否转移"},
			                    {"SerialNo","合同流水号"},
						        {"CustomerName","客户名称"},
						        {"ManageOrgName","合同所属机构"},
						        {"ManageUserName","管户客户经理"},
						        {"BusinessTypeName","业务品种"},
						        {"OccurTypeName","发生类型"},
						        {"CurrencyName","币种"},
						        {"BusinessSum","金额"}						        
			               };
		
	sSql = " select '' as BCFlag,SerialNo,CustomerName,getOrgName(ManageOrgID) as ManageOrgName,ManageOrgID, "+
		   " getUserName(ManageUserID) as ManageUserName,ManageUserID,getBusinessName(BusinessType) as BusinessTypeName, "+
           " getItemName('OccurType',OccurType) as OccurTypeName,getItemName('Currency',BusinessCurrency) "+
		   " as CurrencyName,BusinessSum from BUSINESS_CONTRACT where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//如果是直属支行管理员
	if(CurUser.hasRole("0M2"))
	{
		sSql += " AND ManageOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	//总行业务中心系统管理员
	if(CurUser.hasRole("0J2"))
	{
		sSql += " AND exists(select 1 from user_role where UserID=BUSINESS_CONTRACT.ManageUserID and roleid in('080'))  ";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setType("BusinessSum","Number");
    doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BCFlag","2");
	//设置字段不可见
	doTemp.setVisible("ManageOrgID,ManageUserID",false);
	//设置字段显示宽度
	doTemp.setHTMLStyle("BusinessTypeName,CustomerName,ManageOrgName"," style={width:200px} ");	
	doTemp.setHTMLStyle("OccurTypeName,CurrencyName,ManageUserName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BCFlag","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");

	//置字段是否可更新
	doTemp.setUpdateable("BusinessTypeName,OccurTypeName,CurrencyName",false);
	
	//生成查询条件	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
		
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
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
		{"true","","Button","转移","转移合同信息","transferContract()",sResourcesPath}	,
		{"true","","PlainText","(双击左键选择/取消 是否转移)","(双击左键选择/取消 是否转移)","style={color:red}",sResourcesPath},
		{"true","","Button","全选","全选","SelectedAll()",sResourcesPath},
		{"true","","Button","反选","反选","SelectedBack()",sResourcesPath},
		{"true","","Button","恢复","取消全选","SelectedCancel()",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=转移合同;InputParam=无;OutPutParam=无;]~*/	
	function transferContract()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("936")))//确认转移该合同吗？
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//获取当前机构
			sSortNo = "<%=CurOrg.SortNo%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("937"));//请选择转移后的客户经理！
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//获取更新信息类型,对于同时选择多条记录交接的，此处选择只出现一次	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/ContractShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 													
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//需判定是否至少有一个合同被选定待交接了。把有的找出来
					var b = getRowCount(0);				
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"BCFlag");
						if(a == "√")
						{
							sSerialNo = getItemValue(0,i,"SerialNo");	
							sFromOrgID = getItemValue(0,i,"ManageOrgID");
							sFromOrgName = getItemValue(0,i,"ManageOrgName");
							sFromUserID = getItemValue(0,i,"ManageUserID");
							sFromUserName = getItemValue(0,i,"ManageUserName");	
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("938"));//不允许合同转移在同一客户经理间进行，请重新选择转移后的客户经理！
								return;
							}	
						
							//调用页面更新
							sReturn = PopPage("/SystemManage/SynthesisManage/ContractShiftAction.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("939"));//合同转移成功！
							else if(sReturn == "FALSE")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("940"));//合同转移失败！
							else if(sReturn == "NOT")
								alert("合同流水号("+sSerialNo+"),"+getBusinessMessage("941"));//接受客户经理对该合同的客户没有业务办理权，不能转移！
							else if(sReturn == "UNFINISHRISKSIGNAL")
								alert("合同流水号("+sSerialNo+")的借款人还存在在途的预警信号发起或解除申请,不能转移！");
						}
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
		sBCFlag = getItemValue(0,getRow(),"BCFlag") ;
		if (typeof(sBCFlag) == "undefined" || sBCFlag == "")
			setItemValue(0,getRow(),"BCFlag","√");
		else
			setItemValue(0,getRow(),"BCFlag","");

	}
	
	/*~[Describe=选择记录;InputParam=无;OutPutParam=无;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"BCFlag");
			if(a == "√")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//请至少选择一条信息！
			return false;
		}
		
		return true;
	}
	/*~[Describe=全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"BCFlag","√");
			}
		}
	}
	
	
	/*~[Describe=反选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"BCFlag","√");
			}else{
				setItemValue(0,iMSR,"BCFlag","");
			}
		}
	}
	
	/*~[Describe=取消全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != ""){
				setItemValue(0,iMSR,"BCFlag","");
			}
		}
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
