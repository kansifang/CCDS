<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:lpzhang 2009-8-5
		Tester:
		Content: 工程机械按揭额度
		Input Param:
			
		Output param:
		History Log: 
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "工程机械按揭额度"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","200");
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//申请编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));//申请编号
	String ESerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ESerialNo"));//主协议编号
	String sModel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Model"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sModel == null) sModel = "";
	if(ESerialNo == null) ESerialNo = "";
	if(sObjectType == null) sObjectType = "";
	//担保信息项下的抵押物	
	//PG_TITLE = "<font color='blue'>按揭额度主协议["+sObjectNo+"]项下的从协议</font>@PageTitle";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	String sMainTable="";
	
	if("Credit".equals(sModel)){
		if(sObjectType.equals("BusinessContract"))
			sMainTable = "Contract_Relative";
		else
			sMainTable = "Apply_Relative";
			
		ESerialNo = Sqlca.getString("select ObjectNo from "+sMainTable+" where SerialNo ='"+sObjectNo+"' and ObjectType ='ProjectAgreement'");
	}
	//显示标题				
	String[][] sHeaders = {		
							{"SerialNo","从协议流水号"},              	
							{"DealerName","经销商名称"},              
							{"LoanTypeName","工程机械类型"},            
							{"Currency","币种"},                    
							{"BailRatio","缴存保证金比例(%)"}, 
							{"CompanyBailRatio","其中制造商比例(%)"},    	
							{"DealerBailRatio","其中经销商比例(%)"},   	
							{"CreditSum","从协议额度金额"},           	
							{"TermMonth","期限(月)"},            	
							{"LimitSum","最高贷款金额"},           	
							{"LimitLoanTerm","最高贷款期限(月)"},    	
							{"LimitLoanRatio","最高贷款比例(%)"},      	
							{"Remark","备注"},                    
							{"InputUserName","登记人"},                  
							{"InputOrgName","登记机构"},                
							{"InputDate","登记日期"},                
							{"UpdateDate","更新日期"},    
						 };
	

	sSql =  " select SerialNo,DealerName,LoanType,getItemName('AgreementLoanType',LoanType) as LoanTypeName,CreditSum,"+
			" getItemName('Currency',Currency) as Currency,LimitSum,LimitLoanTerm,LimitLoanRatio, "+
			" getUserName(InputUserID) as InputUserName,UpdateDate "+
			" from Dealer_Agreement DA where ObjectNo = '"+ESerialNo+"'  order by SerialNo desc";
	
			
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="Dealer_Agreement";
	doTemp.setKey("SerialNo",true);	
	doTemp.setHeader(sHeaders);
	
	doTemp.setAlign("Currency","2");
	doTemp.setVisible("LoanType",false);
	doTemp.setType("CreditSum,LimitSum,LimitLoanTerm,LimitLoanRatio","Number");
	doTemp.setHTMLStyle("DealerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","查询","查询","payBackCheck()",sResourcesPath},
		{"true","","Button","协议项下业务","协议项下业务","AgreementBusiness()",sResourcesPath},
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
		sInputDate = getItemValue(0,getRow(),"InputDate");
		OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","_blank",OpenStyle);
		reloadSelf();
	}
	
	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
       		as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
			reloadSelf();
   		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","SerialNo="+sSerialNo+"&ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","_blank",OpenStyle);
			reloadSelf();
		}
	}
	/*~[Describe=协议项下业务;InputParam=无;OutPutParam=无;]~*/
	function AgreementBusiness()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAgreementType   = "ConstructContractNo";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AgreementBusiness","/CreditManage/CreditLine/AgreementBusiness.jsp","SerialNo="+sSerialNo+"&AgreementType="+sAgreementType,"_blank",OpenStyle);
		}
	}
	/*~[Describe=,联动显示主协议下面的的子协议;InputParam=无;OutPutParam=无;]~*/
	/*function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码RAGREEMENT
		sInputDate = getItemValue(0,getRow(),"InputDate");
		OpenComp("DealerAgreementInfo","/CreditManage/CreditLine/DealerAgreementInfo.jsp","SerialNo="+sSerialNo+"&ESerialNo=<%=ESerialNo%>&ObjectNo=<%=sObjectNo%>","DetailFrame","");
	}
    */
	
	/*~[Describe=余额查询;InputParam=无;OutPutParam=无;]~*/
	function payBackCheck()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = sSerialNo;
		sObjectType = "EntAgreement";
		sTradeType = "6003";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("个贷系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
			return;
		}else{
			alert("发送个贷系统成功！日间还款总额为["+parseFloat(sReturn[1])+"]");
			//reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	//if("<%=sObjectNo%>".length == 0 || typeof("<%=sObjectNo%>") == "undefined")
	//{
	//	alert("请先保存工程机械按揭额度主协议！");
	//}
	//var bHighlightFirst = true;//自动选中第一条记录
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>