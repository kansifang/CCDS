<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2010/10/14
		Tester:
		Describe:补登借据基本信息
		Input Param:
			SerialNo:    借据编号
			ObjectNo:	 合同流水号
		Output Param:

		HistoryLog: pliu 2011.08.12
		            xlyu 2011.10.27
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "借据基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
    
	String sSql = "";//Sql语句
	ASResultSet rs = null;//结果集
	String sCustomerID = "",sCustomerName = "";
	String sBusinessType= "";//业务品种
	double dBusinessSum = 0.0;
	String sMfCustomerID = "";
	String sBusinessCurrency = "";
	String sRelativeOrgSortNo = "100";//上级机构排序号
	//获得组件参数
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	//获得页面参数
	String sFinishDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FinishDate"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	if(sFinishDate == null) sFinishDate = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得合同信息
	sSql =  " select CustomerID,CustomerName,BusinessSum,BusinessCurrency,BusinessType,getMfCustomerID(customerID) as MfCustomerID  "+
			" from BUSINESS_CONTRACT  "+
			" where SerialNo ='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		dBusinessSum = rs.getDouble("BusinessSum");
		sBusinessType = rs.getString("BusinessType");
		sMfCustomerID  = rs.getString("MfCustomerID");
		sBusinessCurrency  = rs.getString("BusinessCurrency");
		if(sMfCustomerID==null) sMfCustomerID = "";
	}
	rs.getStatement().close();
	//取上级机构SortNo
	sSql =  " select SortNo "+
			" from ORG_INFO  "+
			" where OrgID ='"+CurOrg.RelativeOrgID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sRelativeOrgSortNo = rs.getString("SortNo");
		if(sRelativeOrgSortNo==null) sRelativeOrgSortNo="100";
	}
	rs.getStatement().close();
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = null; 
	if(sBusinessType.equals("2010"))//银行承兑汇票
	{ 
		sTempletNo ="MendHPInfo";     
	}else if(sBusinessType.startsWith("2020") || sBusinessType.equals("2050030") || sBusinessType.equals("2050020"))//国内信用证、进口信用证、备用信用证
    { 
		sTempletNo ="MendLCInfo";
    }else if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.equals("2050040"))//融资性保函和非融资性保函、对外保函
    { 
    	sTempletNo ="MendBHInfo";  
    }else { sTempletNo ="MendDuebillInfo"; }//其他的表外业务
	
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//out.println(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	//设置是否只读 1:只读 0:可写
	if (!"".equals(sFinishDate) && sBusinessType.equals("2010"))
   	{
		dwTemp.ReadOnly = "1"; 
		
  	}else{
  		dwTemp.ReadOnly = "0";
  	}
 	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//System.out.println("#########source:"+doTemp.SourceSql);
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath}
		};
	if (!"".equals(sFinishDate) && sBusinessType.equals("2010"))
   	{
		sButtons[0][0]="false";
   	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		
		if(vI_all("myiframe0"))
		{	            
			//录入数据有效性检查
			if (!ValidityCheck()) return;
			if(bIsInsert)
			{
				beforeInsert();
				bIsInsert = false;
			}
				beforeUpdate();
			    as_save("myiframe0",sPostEvents);	
					
		}
	}

	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditPutOut/MendDueBillList.jsp","_self","");
	}
    	
 	

</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		ddBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //本笔借据金额
		if("<%=sBusinessType%>"=="2010")//银行承兑汇票
		{
			setItemValue(0,0,"Balance",ddBusinessSum);
		}
	}
    
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"BusinessType","<%=sBusinessType%>");
			setItemValue(0,0,"MfCustomerID","<%=sMfCustomerID%>");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"BusinessSum",amarMoney("<%=dBusinessSum%>",2));
			setItemValue(0,0,"BusinessCurrency","<%=sBusinessCurrency%>");	
			setItemValue(0,0,"RelativeSerialNo2","<%=sObjectNo%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");		
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");	
			bIsInsert = true;
		}
    }
	
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_DUEBILL";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "BD";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {	
	    	dBailRatio = getItemValue(0,getRow(),"BailRatio"); //获取保证金比例
	        if(parseFloat(dBailRatio) >= 0)
	        {	
	        	dBailRatio = roundOff(dBailRatio,2);	        	
	        	sBusinessType = "<%=sBusinessType%>";
		        sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//获取申请币种
		        sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//获取保证金币种
		        ddBailSum = 0.00;
		        dERateRatio = 1.00;
		        if(typeof(sBailCurrency) == "undefined" || sBailCurrency == "" ){
		        	sBailCurrency = "01";
		        }
		        if(sBusinessCurrency == sBailCurrency){
		           	dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
		        }
	 			else{
	    			dERateRatio = RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sBailCurrency+",''");
	            	dBailSum = parseFloat(dBusinessSum*dERateRatio)*parseFloat(dBailRatio)/100;
	            }		        
           		dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	            //银行承兑汇票、融资性保函、非融资性保函
			    if(sBusinessType == "2010" || sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0)
			    {	
			    	setItemValue(0,getRow(),"ExposureSum",roundOff((dBusinessSum-dBailSum/dERateRatio),2));
			    }
	        }
	    }	  
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		dBusinessSum = "<%=dBusinessSum%>";//合同金额
		sObjectNo = "<%=sObjectNo%>";//合同流水号
		ddBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //本笔借据金额
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--借据流水号
		sMaturity = getItemValue(0,getRow(),"Maturity"); //汇票到期日
		sPutoutDate = getItemValue(0,getRow(),"PutoutDate"); //汇票承兑日
		sBusinessType = "<%=sBusinessType%>";
		sCustomerID =  getItemValue(0,getRow(),"CustomerID");
		if(sBusinessType == "2010")
		{
			dReturn = RunMethod("WorkFlowEngine","DateExcute",sPutoutDate+",5,0");
			if(sMaturity > dReturn)
			{
				alert("承兑期限需不超过6个月！");
				return false;
			}
		}
		dBalance = getItemValue(0,getRow(),"Balance"); //获取余额
		if(ddBusinessSum < dBalance)
		{
			if(sBusinessType=="2020" || sBusinessType=="2050030" || sBusinessType=="2050020")//信用证
			{
				alert("信用证余额需小于开证金额！");
				return false;
			}else if(sBusinessType.indexOf("2030") == 0 || sBusinessType.indexOf("2040") == 0 || sBusinessType == "2050040")
			{
				alert("余额需小于保函金额！");
				return false;
			}
		}
		//所有的借据金额的和必须小于合同金额，否则不能新增该借据信息
		if(sBusinessType.indexOf("2") == 0)//所有的表外补登业务
		{
		    //获得借据金额之和
          	sReturn=RunMethod("BusinessManage","GetColSumValue",sObjectNo+","+sSerialNo);
          	if(typeof(sReturn) == "undefined" || sReturn.length==0 || sReturn=="Null" ) sReturn=0;
		    if(parseFloat(dBusinessSum) < (parseFloat(sReturn)+parseFloat(ddBusinessSum)))
		    {
		    	alert("所有业务金额之和需小于等于合同金额！");
		    	return false;
		    }
		    
			//检验票据编号唯一性
			sBillNo = getItemValue(0,getRow(),"BillNo");//票据号
			sReturn=RunMethod("BusinessManage","CheckBusinessBillNo",sSerialNo+","+sBillNo+","+sCustomerID+","+sObjectNo);
			if(typeof(sReturn) != "undefined" && sReturn.length!=0 && sReturn!="Null")
			{
				alert("票据号重复,请重新录入！");
		    	return false;
			}
	    }
	    //提示:业务的起始日应该早于等于今天
	    if(sPutoutDate > "<%=StringFunction.getToday()%>")
	    {
	    	alert("提示:业务的起始日应早于等于今天！");
	    }
		return true;
	}

	/*~[Describe=弹出记账机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectMFOrg()
	{	
		if("<%=sBusinessType%>"=="2050030")//进口信用证
		{
			sParaString = "SortNo,100900";
			setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");
		}else{
			if("<%=CurOrg.OrgLevel%>"=="6")//二级支行
			{
				sParaString = "SortNo,<%=sRelativeOrgSortNo%>";
				setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");
			}else{
				sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
				setObjectValue("SelectBelongWholeOrg",sParaString,"@MFOrgID@0@MFOrgName@1",0,0,"");	
			}
		}
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
