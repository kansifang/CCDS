<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		       
		Tester:	
		Content: 客户信息列表
		Input Param:
			CustomerType：客户类型
				01：公司客户；
				0201：一类集团客户；
				0202：二类集团客户；
				03：个人客户
            CustomerListTemplet：客户列表模板代码
            sCustomerScale：公司客户规模 CustomerScale 010 大型企业 020 中型企业 022 小型企业 024 微型企业
		以上参数统一由代码表:--MainMenu主菜单得到配置
		Output param:
		   CustomerID：客户编号
           CustomerType：客户类型		                				
           CustomerName：客户名称
           CertType：客户证件类型						                
           CertID：客户证件号码
		History Log: 
			DATE	CHANGER		CONTENT
			2005-07-20	fbkang	页面重整
			2005/09/10 zywei 重检代码
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户信息列表"   ; // 浏览器窗口标题 <title> PG_TITLE </title>  
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句	
	String sUserID = CurUser.UserID; //用户ID
	String sOrgID = CurOrg.OrgID; //机构ID
	
	//获得组件参数	：客户类型、客户显示模版号
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	String sTempletNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerListTemplet"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	
	//将空值转化为空字符串
	if(sCustomerType == null) sCustomerType = "";
	if(sTempletNo == null) sTempletNo = "";
	if(sCustomerScale == null) sCustomerScale = "";
	//获得页面参数
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCustomerType.substring(0,2).equals("02"))//集团客户
		doTemp.setKeyFilter("EI.CustomerID||CB.CustomerID||CB.OrgID||CB.UserID");	
	else
		doTemp.setKeyFilter("CI.CustomerID||CB.CustomerID||CB.OrgID||CB.UserID");//add by hxd in 2005/02/20 for 加快速度
	doTemp.setHTMLStyle("OrgName","style={width=200px}");
	doTemp.setHTMLStyle("UserName","style={width=80px}");	
	//增加过滤器	
	doTemp.setColumnAttribute("CustomerName,CustomerID,CertID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(10); //add by hxd in 2005/02/20 for 加快速度
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID+","+sCustomerType+","+sOrgID+","+sCustomerScale);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
	
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{((!sCustomerScale.equals("")&&sCustomerScale.substring(0,2).equals("02"))?"false":"true"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{((!sCustomerScale.equals("")&&sCustomerScale.substring(0,2).equals("02"))?"true":"false"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{(sCustomerType.substring(0,2).equals("01")?"true":"false"),"","Button","客户信息预警","客户信息预警","alarmCustInfo()",sResourcesPath},
			//modify by xhyong 2009/08/10
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.equals("0401")||sCustomerType.equals("0501"))?"false":"true"),"","Button","加入重点客户连接","加入重点客户连接","addUserDefine()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.substring(0,2).equals("04")||sCustomerType.substring(0,2).equals("05"))?"false":"true"),"","Button","权限申请","权限申请","ApplyRole()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.substring(0,2).equals("04")||sCustomerType.substring(0,2).equals("05"))?"false":"true"),"","Button","收回权限申请","收回权限申请","BackApplyRole()",sResourcesPath},
			//end
			{(sCustomerType.substring(0,2).equals("01")&&!sCustomerType.equals("0107")?"true":"false"),"","Button","改变客户类型","改变客户类型","changeCustomerType()",sResourcesPath},
			{(sCustomerType.substring(0,2).equals("01")?"false":"false"),"","Button","认定客户规模","认定客户规模","confirmScale()",sResourcesPath},
			{"false","","Button","客户概览","查看客户基本信息和授信业务信息","viewCustomerInfo()",sResourcesPath},
			{((sCustomerType.substring(0,2).equals("02")||sCustomerType.equals("0401")||sCustomerType.equals("0501")||sCustomerType.equals("0107"))?"false":"true"),"","Button","获取核心客户号","获取核心客户号","getMFCustomerID()",sResourcesPath},
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		var sCustomerType='<%=sCustomerType%>';//--客户类型
		var sCustomerScale='<%=sCustomerScale%>';//--客户规模
		var sCustomerID ='';//--客户代码
		var sReturn ='';//--返回值，客户的录入信息是否成功
		var sReturnStatus = '';//--存放客户信息检查结果
		var sStatus = '';//--存放客户信息检查状态		
		var sReturnValue = '';//--存放客户输入信息
		//客户信息录入模态框调用	
		//这里区分客户类型，仅为控制对话框的展示大小
		if(sCustomerType == "01"||sCustomerType == "03"||sCustomerType == "0107") 
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		else
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		//判断是否返回有效信息
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_')
		{
			sReturnValue = sReturnValue.split("@");
			//得到客户输入信息
			sCustomerType = sReturnValue[0];
			sCustomerName = sReturnValue[1];
			sCertType = sReturnValue[2];
			sCertID = sReturnValue[3];
		
			//检查客户信息存在状态
			sReturnStatus = PopPage("/CustomerManage/CheckCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			//得到客户信息检查结果和客户号
			sReturnStatus = sReturnStatus.split("@");

			sStatus = sReturnStatus[0];
			sCustomerID = sReturnStatus[1];
  			//02为当前用户以与该客户建立有效关联
			if(sStatus == "02")
			{
				alert(getBusinessMessage('105')); //该客户已被自己引入过，请确认！
				return;
			}
			//01为该客户不存在本系统中
			if(sStatus == "01")
			{				
				//取得客户编号
				sCustomerID = PopPage("/CustomerManage/GetCustomerIDAction.jsp","","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			}
			
			//当检查结果为无该客户、没有和任何客户建立主办权、和其他客户建立主办权时进行对数据库操作
			if(sStatus == "01" || sStatus == "04" || sStatus == "05")
			{
				sReturn = PopPage("/CustomerManage/AddCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&ReturnStatus="+sStatus+"&CustomerID="+sCustomerID+"&CustomerScale="+sCustomerScale+"","","");
				//当该客户与其他用户建立有效关联且为企业客户和关联集团 ,需要向系统管理员申请权限
				if(sReturn == "succeed" && sStatus == "05" )
				{
					if(confirm(getBusinessMessage('103'))) //客户已成功引入，要立即申请该客户的管户权吗？
					    popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");					
				//当该客户没有与任何用户建立有效关联、当前用户以与该客户建立无效关联、该客户与其他用户建立有效关联（个人客户/个体工商户/农户/联保小组）已经引入客户
				}else if(sReturn == "succeed" && (sStatus == "04"))
				{
					alert(getBusinessMessage('108')); //客户引入成功
				//已经新增客户
				}else if(sReturn == "succeed" && sStatus == "01")
				{
					alert(getBusinessMessage('109')); //新增客户成功
				}
			}
			
			if(sStatus == "01" || sStatus == "04")
			{
				openObject("Customer",sCustomerID,"001");
				
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=新增中小企业记录;InputParam=无;OutPutParam=无;]~*/
	function newSMERecord()
	{
		var sCustomerType='<%=sCustomerType%>';//--客户类型
		var sCustomerScale='<%=sCustomerScale%>';//--客户规模
		var sCustomerID ='';//--客户代码
		var sReturn ='';//--返回值，客户的录入信息是否成功
		var sReturnStatus = '';//--存放客户信息检查结果
		var sStatus = '';//--存放客户信息检查状态		
		var sReturnValue = '';//--存放客户输入信息
		
		//客户信息录入模态框调用	
		//这里区分客户类型，仅为控制对话框的展示大小
		if(sCustomerType == "01"||sCustomerType == "03") 
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
		else
			sReturnValue = PopPage("/CustomerManage/AddCustomerDialog.jsp?CustomerType="+sCustomerType,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		//判断是否返回有效信息
		if(typeof(sReturnValue) != "undefined" && sReturnValue.length != 0 && sReturnValue != '_CANCEL_')
		{
			sReturnValue = sReturnValue.split("@");
			//得到客户输入信息
			sCustomerType = sReturnValue[0];
			sCustomerName = sReturnValue[1];
			sCertType = sReturnValue[2];
			sCertID = sReturnValue[3];
		
			//检查客户信息存在状态
			sReturnStatus = PopPage("/CustomerManage/CheckCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
			//得到客户信息检查结果和客户号
			sReturnStatus = sReturnStatus.split("@");

			sStatus = sReturnStatus[0];
			sCustomerID = sReturnStatus[1];
			
  			//02为当前用户以与该客户建立有效关联
			if(sStatus == "02")
			{
				alert(getBusinessMessage('105')); //该客户已被自己引入过，请确认！
				return;
			}
			
			//当检查结果为无该客户、没有和任何客户建立主办权、和其他客户建立主办权时进行对数据库操作
			if(sStatus == "04" || sStatus == "05")
			{
				sReturn = PopPage("/CustomerManage/AddCustomerAction.jsp?CustomerType="+sCustomerType+"&CustomerName="+sCustomerName+"&CertType="+sCertType+"&CertID="+sCertID+"&ReturnStatus="+sStatus+"&CustomerID="+sCustomerID+"&CustomerScale="+sCustomerScale+"","","");
				//当该客户与其他用户建立有效关联且为企业客户和关联集团 ,需要向系统管理员申请权限
				if(sReturn == "succeed" && sStatus == "05" )
				{
					if(confirm(getBusinessMessage('103'))) //客户已成功引入，要立即申请该客户的管户权吗？
					    popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");					
				//当该客户没有与任何用户建立有效关联、当前用户以与该客户建立无效关联、该客户与其他用户建立有效关联（个人客户/个体工商户/农户/联保小组）已经引入客户
				}else if(sReturn == "succeed" && (sStatus == "04"))
				{
					alert(getBusinessMessage('108')); //客户引入成功
				//已经新增客户
				}else if(sReturn == "succeed" && sStatus == "01")
				{
					alert(getBusinessMessage('109')); //新增客户成功
				}
			}
			
			if(sStatus == "01" || sStatus == "04")
			{
				openObject("Customer",sCustomerID,"001");
				
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			sReturn = PopPage("/CustomerManage/DelCustomerBelongAction.jsp?CustomerID="+sCustomerID+"","","");
			if(sReturn == "ExistApply")
			{
				alert(getBusinessMessage('113'));//该客户所属申请业务未终结，不能删除！
	 			return;
			}
			if(sReturn == "ExistApprove")
			{
				alert(getBusinessMessage('112'));//该客户所属最终审批意见业务未终结，不能删除！
	 			return;
			}
			if(sReturn == "ExistContract")
			{
				alert(getBusinessMessage('111'));//该客户所属合同业务未终结，不能删除！
	 			return;
			}
			if(sReturn == "DelSuccess")
			{
				alert(getBusinessMessage('110'));//该客户所属信息已删除！
	 			reloadSelf();
			}
		}
	}
	
	//客户信息预警
	function alarmCustInfo()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
		}else 
		{					
			popComp("ScenarioAlarm.jsp","/PublicInfo/ScenarioAlarm.jsp","OneStepRun=no&ScenarioNo=005&ObjectType=CustomerID&ObjectNo="+sCustomerID,"dialogWidth=50;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
		}		
	}
	
	/*~[Describe=改变客户类型;InputParam=无;OutPutParam=无;]~*/
	function changeCustomerType()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue3 == "Y2")
        {    		
    		sCustomerType = PopPage("/CustomerManage/ChangeCustomerTypeDialog.jsp","","dialogWidth=20;dialogHeight=8;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sCustomerType == "" || sCustomerType == "_CANCEL_" || typeof(sCustomerType) == "undefined") return;
			sReturn = PopPage("/CustomerManage/ChangeCustomerTypeAction.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			if(sReturn == "_TRUE_")
			{
				alert(getBusinessMessage('106'));//改变客户类型成功！"
				reloadSelf();
				return;
			}else
			{
				alert(getBusinessMessage('107'));//改变客户类型失败，请重新操作！
				return;
			}
    		
		}else
		{
		    alert(getBusinessMessage('249'));//你无权更改该客户的权限！
		}
				
	}
	/*~[Describe=认定客户规模;InputParam=无;OutPutParam=无;]~*/
	function confirmScale()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		alert("待完成!")				
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID) == "undefined" || sCustomerID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2")
        {    		
    		openObject("Customer",sCustomerID+"&<%=sCustomerScale%>","001");
    		reloadSelf();
		}else
		{
		    alert(getBusinessMessage('115'));//对不起，你没有查看该客户的权限！
		}
	}
	
	/*~[Describe=加入重点信息链接;InputParam=CustomerID,ObjectType=Customer;OutPutParam=无;]~*/
	function addUserDefine()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getBusinessMessage('114'))) //把这个客户信息加入重点客户链接中吗?
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=Customer&ObjectNo="+sCustomerID,"","");
		}
	}
		
	/*~[Describe=权限申请;InputParam=CustomerID,ObjectType=Customer;OutPutParam=无;]~*/			
	function ApplyRole()
	{   
        //获得客户编号
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//获得申请状态
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus == "1")
        {
            alert(getBusinessMessage('116'));//已提交申请,不能再次提交！
            return;
        }
        //获得客户主办权、信息查看权、信息维护权、业务申办权
        sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");        
        sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");
        sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");
        sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");        
        if(sBelongAttribute == "有" && sBelongAttribute1 == "有" && sBelongAttribute2 == "有" && sBelongAttribute3 == "有")
        {
            alert(getBusinessMessage('117'));//您已经拥有该客户的所有权限！
            return;
        }
        
		popComp("RoleApplyInfo","/CustomerManage/RoleApplyInfo.jsp","CustomerID="+sCustomerID+"&UserID=<%=CurUser.UserID%>&OrgID=<%=CurOrg.OrgID%>","");
		reloadSelf();
	}
	
	function BackApplyRole()
	{
	    //获得客户编号
        sCustomerID = getItemValue(0,getRow(),"CustomerID");
        sUserID = getItemValue(0,getRow(),"UserID");	
        sOrgID = getItemValue(0,getRow(),"OrgID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		//获得申请状态
		sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");           
        if(sApplyStatus != "1")
        {
            alert('不存在已提交但尚未批准/否决的权限申请！');
            return;
        }
        RunMethod("CustomerManage","UpdateApplyRole",sCustomerID+","+sOrgID+","+sUserID);
        reloadSelf();
	}
	
	function viewCustomerInfo()
	{
		//获得客户编号
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		popComp("EntInfo","/CustomerManage/EntManage/EntInfo.jsp","CustomerID="+sCustomerID,"");
	}
	
	function getMFCustomerID()
	{
		//获得客户编号
        sCustomerID = getItemValue(0,getRow(),"CustomerID");		
        sTradeType = "798001";	
        sObjectNo = sCustomerID;
        sObjectType = "Customer";
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("取得核心客户号成功["+sReturn[1]+"]");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>