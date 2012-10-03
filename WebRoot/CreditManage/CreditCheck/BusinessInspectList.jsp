<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 贷后检查列表
		Input Param:
			InspectType：  报告类型 
				010     贷款用途检查报告
	            010010  未完成
	            010020  已完成
	            020     贷后检查报告
	            020010  未完成
	            020020  已完成
		Output Param:
			SerialNo:流水号
			ObjectType:对象类型
			ObjectNo：对象编号
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    if(sInspectType == null) sInspectType="020010";
    String sOrgFlag = Sqlca.getString("select OrgFlag from Org_Info where orgid = '"+CurOrg.OrgID+"'");
    if(sOrgFlag ==null) sOrgFlag = "";
    boolean bIsCheckUser = false;
    if (CurUser.hasRole("040") || CurUser.hasRole("240")|| CurUser.hasRole("000")){
    	bIsCheckUser = true;
    }
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASDataObject doTemp = null;
  	//首次检查报告列表
  	if(sInspectType.equals("010010") || sInspectType.equals("010020"))
  	{
	  	String sHeaders1[][] = {
								{"CustomerName","客户名称"},
								{"BusinessTypeName","业务品种"},
								{"BCSerialNo","合同流水号"},
								{"Currency","币种"},
								{"BusinessSum","合同金额"},
								{"PutOutDate","合同生效日期"},
								{"InspectType","检查类型"},
								{"UpDateDate","报告日期"},
								{"InputUser","检查人"},
								{"InputOrg","所属机构"},
								};

	  	String sSql1 =  " select II.SerialNo as SerialNo,II.ObjectNo as ObjectNo,II.ObjectType as ObjectType,"+
						" BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
						" getBusinessName(BusinessType) as BusinessTypeName,"+
						" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
			            " BC.BusinessType as BusinessType ,"+
			            " BC.SerialNo as BCSerialNo,"+
			            " BC.BusinessSum as BusinessSum,BC.PutOutDate,"+
						" getItemName('InspectType',II.InspectType) as InspectType,"+
						" II.UpdateDate as UpdateDate,"+
						" getUserName(II.InputUserID) as InputUser,"+
						" getOrgName(II.InputOrgId) as InputOrg"+
						" from INSPECT_INFO II,BUSINESS_CONTRACT BC "+
						" where II.ObjectType='BusinessContract' "+
		                " and II.InspectType like '010%' "+
		                " and II.ObjectNo=BC.SerialNo ";
		if(bIsCheckUser){
			sSql1 += " and II.InputOrgId in(select OrgId from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		}
		else{
			sSql1 += " and II.InputUserID='"+CurUser.UserID+"'";
		}                
	    String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sInspectType.equals("010010"))
		{
			if(sDBName.startsWith("INFORMIX"))
				sSql1=sSql1+" and (II.FinishDate = '' or II.FinishDate is null) order by II.UpDateDate desc";
			else if(sDBName.startsWith("ORACLE"))
				sSql1=sSql1+" and (II.FinishDate = ' ' or II.FinishDate is null) order by II.UpDateDate desc";
			else if(sDBName.startsWith("DB2"))
				sSql1=sSql1+" and (II.FinishDate = '' or II.FinishDate is null) order by II.UpDateDate desc";
		}
		else
		{
			if(sDBName.startsWith("INFORMIX"))
				sSql1=sSql1+" and II.FinishDate <> '' and II.FinishDate is not null order by II.FinishDate desc";
			else if(sDBName.startsWith("ORACLE"))
				sSql1=sSql1+" and II.FinishDate <> ' ' and II.FinishDate is not null order by II.FinishDate desc";
			else if(sDBName.startsWith("DB2"))
				sSql1=sSql1+" and II.FinishDate <> '' and II.FinishDate is not null order by II.FinishDate desc";
		}
		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql1);
		//设置可更新的表
		doTemp.UpdateTable = "INSPECT_INFO";
		//设置关键字
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders1);
		//设置不可见项
		doTemp.setVisible("SerialNo,ObjectNo,BusinessType,ObjectType,InspectType,CustomerID",false);
		doTemp.setUpdateable("BusinessTypeName,BusinessType,BusinessSum,CustomerName",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		
		doTemp.setColumnAttribute("BCSerialNo,CustomerName,BusinessSum,InputUser,InputOrg","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	  	//设置html格式
	  	//doTemp.setHTMLStyle("UpdateDate,BusinessSum"," style={width:80px} ");
	  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");
 	}
  	//贷后检查报告列表
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020") || sInspectType.equals("040010") || sInspectType.equals("040020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","客户名称"},
								{"ObjectNo","客户编号"},
								{"InspectType","检查类型"},
								{"UpdateDate","报告日期"},
								{"InputUserName","检查人"},
								{"InputOrgName","所属机构"}							
							  };
		String sSql2 = "";
		if(sInspectType.equals("020010") || sInspectType.equals("020020")){
		  	sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
							" getItemName('InspectType',InspectType) as InspectType,"+
				            " UpdateDate,InputUserID,InputOrgID,"+
				            " getUserName(InputUserID) as InputUserName,"+
				            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
							" from INSPECT_INFO"+
							" where ObjectType='Customer' "+
			                " and InspectType  like '020%' ";
		}else if(sInspectType.equals("040010") || sInspectType.equals("040020")){
		  	sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
							" getItemName('InspectType',InspectType) as InspectType,"+
				            " UpdateDate,InputUserID,InputOrgID,"+
				            " getUserName(InputUserID) as InputUserName,"+
				            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
							" from INSPECT_INFO"+
							" where ObjectType='Customer' "+
			                " and InspectType  like '040%' ";
		}
		if(bIsCheckUser || ((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410"))){
			sSql2 += " and InputOrgId in(select OrgId from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
		}
		else if(!((CurUser.hasRole("210") && "030".equals(sOrgFlag)) || CurUser.hasRole("410")) || sInspectType.equals("040010")){
				sSql2 += " and InputUserID='"+CurUser.UserID+"'";
		}
		
		if(sInspectType.equals("020010") || sInspectType.equals("040010"))
		{
			sSql2=sSql2+" and (FinishDate = '' or FinishDate is null) order by UpDateDate desc";
		}
		else
		{
			sSql2=sSql2+" and FinishDate is not null order by FinishDate desc";
		}
		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql2);
		//设置可更新的表
		doTemp.UpdateTable = "INSPECT_INFO";
		//设置关键字
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders2);
		//设置不可见项
		doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		
		//设置html格式
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("UpdateDate","3");
		
		doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate,InputUserName,InputOrgName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}
  	else if(sInspectType.equals("030010") || sInspectType.equals("030020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","客户名称"},
								{"ObjectNo","客户编号"},
								{"InspectType","检查类型"},
								{"UpdateDate","报告日期"},
								{"InputUserName","检查人"},
								{"InputOrgName","所属机构"}							
							  };

	  	String sSql2 =  " select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,"+
						" getItemName('InspectType',InspectType) as InspectType,"+
			            " UpdateDate,InputUserID,InputOrgID,"+
			            " getUserName(InputUserID) as InputUserName,"+
			            " getOrgName(InputOrgID) as InputOrgName,ReportType"+
						" from INSPECT_INFO"+
						" where ObjectType='CustomerRisk' "+
		                " and InspectType  like '030%' "+
		                " and InputUserID='"+CurUser.UserID+"'";
		                
		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql2);
		//设置可更新的表
		doTemp.UpdateTable = "INSPECT_INFO";
		//设置关键字
		doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
		doTemp.setHeader(sHeaders2);
		//设置不可见项
		doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,ReportType",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		
		//设置html格式
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("UpdateDate","3");
		
		doTemp.setColumnAttribute("ObjectNo,CustomerName,UpdateDate,InputUserName,InputOrgName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}  	
  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.setPageSize(16);
  	dwTemp.Style="1";      //设置为Grid风格
  	dwTemp.ReadOnly = "1"; //设置为只读
  
  
  	Vector vTemp = dwTemp.genHTMLDataWindow("");
  	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","新增","新增报告","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看报告详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除该报告","deleteRecord()",sResourcesPath},
		{"true","","Button","客户基本信息","查看客户基本信息","viewCustomer()",sResourcesPath},
		{"false","","Button","业务清单","查看业务清单","viewBusiness()",sResourcesPath},
		{"false","","Button","完成","完成报告","finished()",sResourcesPath},
		{"false","","Button","撤回","重新填写报告","ReEdit()",sResourcesPath}
		};
		
		if((sInspectType.equals("010010") || sInspectType.equals("020010") || sInspectType.equals("040010")) )
		{
			sButtons[5][0] = "true";
		}
		
		if(sInspectType.equals("010020") || sInspectType.equals("020020") || sInspectType.equals("040020"))
		{
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		    sButtons[6][0] = "true";
		}
		
		if(sInspectType.equals("030020") || sInspectType.equals("030010")){
			sButtons[0][0] = "false";
		    sButtons[4][0] = "false";
		}	
		if(bIsCheckUser){
			sButtons[6][0] = "false";
		}
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
		sInspectType = "<%=sInspectType%>";
		if(sInspectType == '010010')
		{
			//选择贷后的合同信息
			var sParaString = "ManageUserID" + "," + "<%=CurUser.UserID%>";
			sReturn = selectObjectValue("SelectInspectContract",sParaString,"",0,0);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") 
				return;
			sReturn = sReturn.split("@");
			//得到合同编号
			sContractNo=sReturn[0];
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sContractNo+"&InspectType="+sInspectType,"","");
			sCompID = "PurposeInspectTab";
			sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sContractNo+"&ObjectType=BusinessContract";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		else if(sInspectType == '020010')
		{
			sParaString = "UserID" + "," + "<%=CurUser.UserID%>" + "," +"ToDay" + "," + "<%=StringFunction.getToday()%>";
			sReturn = selectObjectValue("SelectInspectCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//得到客户输入信息
			sCustomerID=sReturn[0];
			dReturn = RunMethod("CustomerManage","IsSamllEnt",sCustomerID);
			if(dReturn == 1){
				alert("此客户是本行认定的微小企业客户，请做微小企业贷后检查报告！");
			}else{
				//向检查表中插记录
				sReportType = PopPage("/CreditManage/CreditCheck/SelectReportType.jsp","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
				if(sReportType=="" || sReportType=="_CANCEL_" || sReportType=="_CLEAR_" || sReportType=="_NONE_" || typeof(sReportType)=="undefined") 
					return;
				else{
					sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType+"&ReportType="+sReportType,"","");
					sCompID = "InspectTab";
					sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
					sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer&ReportType="+sReportType;
					OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				}
			}		
		}else if(sInspectType == '040010'){
			sToDay = "<%=StringFunction.getToday()%>";
			sParaString = "UserID" + "," + "<%=CurUser.UserID%>" + "," +"ToDay" + "," + "<%=StringFunction.getToday()%>";
			sReturn = selectObjectValue("SelectSmallEntCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//得到客户输入信息
			sCustomerID=sReturn[0];
			dReturn = RunMethod("CustomerManage","HasCheckFrequency",sCustomerID);
			if(dReturn == 0){
				PopPage("/CreditManage/CreditCheck/AddCheckFrequencyAction.jsp?ObjectNo="+sCustomerID+"&CheckFrequency="+"90","","");
				sReturnValue=RunMethod("CustomerManage","FinishCheckFre",sCustomerID+","+sToDay);
			}	
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType,"","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);		
		}
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{	
			sInspectType = "<%=sInspectType%>";
			if(sInspectType=="020010" || sInspectType=="020020" || sInspectType=="040010" || sInspectType=="040020"){
				sReturnValue = RunMethod("CustomerManage","DeleteInspectAction",sCustomerID);
			}	
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
			
		}	
		
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sInspectType = "<%=sInspectType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sReportType = getItemValue(0,getRow(),"ReportType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			if(sInspectType == '010010' || sInspectType == '010020')
			{
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;

				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else if(sInspectType == '020010' || sInspectType == '020020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&ReportType="+sReportType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '030010')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '040010' || sInspectType == '040020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}

  /*~[Describe=完成;InputParam=无;OutPutParam=无;]~*/
	function finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sInspectType = "<%=sInspectType%>";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getBusinessMessage('650')))//你真的想完成该报告吗？
		{
			sReturn=PopPage("/CreditManage/CreditCheck/FinishInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&InspectType="+sInspectType,"","");
			
			if(sReturn=="Inspectunfinish")
			{
				alert(getBusinessMessage('651'));//该贷后检查报告无法完成，请先完成风险分类！
				return;
			}
			if(sReturn=="finished")
			{
				if(sInspectType == '020010' || sInspectType == '020020' || sInspectType == '040010' || sInspectType == '040020' )
				{
					sReturnValue = RunMethod("CustomerManage","FinishInspectAction",sObjectNo);
				}	
				alert(getBusinessMessage('653'));//该报告已完成！
				reloadSelf();
			}
		}
		
	}
	 
    /*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		var sCustomerID;
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020" || "<%=sInspectType%>"=="040010" || "<%=sInspectType%>"=="040020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		else if("<%=sInspectType%>"=="030010")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=查看业务清单;InputParam=无;OutPutParam=无;]~*/
	function viewBusiness()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020" || "<%=sInspectType%>"=="040010" || "<%=sInspectType%>"=="040020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
		}
	}
	
	function ReEdit()
	{
	    sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");
		sInspectType = "<%=sInspectType%>";
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getBusinessMessage('654')))//你确定要撤回该报告吗？
		{
			sReturn=PopPage("/CreditManage/CreditCheck/ReEditInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&InspectType="+sInspectType,"","");
			reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>