<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:
			Tester:
			Describe: 变更客户信息
			Input Param:
			Output Param:
			HistoryLog: fbkang on 2005/08/14 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "变更客户信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//获得变量：客户编号
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//定义变量：sql语句
	String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//根据客户编号获取客户类型
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
	if(sCustomerType == null) sCustomerType = "";
	
	String sHeaders[][] = {
						{"CustomerID","客户代码"},
						{"CustomerName","客户名称"},	
						{"NewCustomerName","客户名称（新）"},								
						{"CustomerTypeName","客户类型"},
						{"CertType","证件类型"},
						{"NewCertType","证件类型（新）"},
						{"CertID","证件号码"},
						{"NewCertID","证件号码（新）"}	,
						{"LoanCardNo","贷款卡编号"},
						{"NewLoanCardNo","贷款卡编号（新）"}				
		      		};

	sSql = 	" select CI.CustomerID,CI.CustomerName,'' as NewCustomerName, "+
	" getItemName('CustomerType',CI.CustomerType) as CustomerTypeName, "+
	" CI.CertType,'' as NewCertType,CI.CertID,'' as NewCertID, " +
	" CI.LoanCardNo,'' as NewLoanCardNo "+
	" from CUSTOMER_INFO CI " +
	" where CI.CustomerID = '"+sCustomerID+"' ";
	              
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "CUSTOMER_INFO";
	//设置主键
	doTemp.setKey("CustomerID",true);	
	//设置下拉框
	doTemp.setDDDWCode("CertType","CertType");	
	doTemp.setDDDWCode("NewCertType","CertType");
	//设置编辑属性
	doTemp.setReadOnly("CustomerID,CustomerTypeName,CustomerName,CertType,CertID,LoanCardNo",true);
	//设置必输项和可见性
	if(sCustomerType.equals("03")) //个人
	{
		doTemp.setRequired("NewCustomerName,NewCertType,NewCertID",true);
		doTemp.setVisible("LoanCardNo,NewLoanCardNo",false);
	}
	else
		doTemp.setRequired("NewCustomerName,NewCertType,NewCertID",true);
		
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置为Grid风格
		
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
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
			   {"true","","Button","保存","保存变更客户信息","saveRecord()",sResourcesPath},
			   {"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sCustomerType = "<%=sCustomerType%>";
		//获取变更后的客户名称、证件类型、证件编号、贷款卡编号
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sOldCertType = getItemValue(0,getRow(),"CertType");
		sOldCertID = getItemValue(0,getRow(),"CertID");
		sNewCustomerName = getItemValue(0,getRow(),"NewCustomerName");
		sNewCertType = getItemValue(0,getRow(),"NewCertType");
		sNewCertID = getItemValue(0,getRow(),"NewCertID");
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");
		if(sCustomerType == '03') //个人
		{		
			if (typeof(sNewCustomerName) == "undefined" || sNewCustomerName == "" 
			|| typeof(sNewCertType) == "undefined" || sNewCertType == "" 
			|| typeof(sNewCertID) == "undefined" || sNewCertID == "")
			{
				alert(getBusinessMessage('923'));//请输入需变更的客户信息！
				return;
			}
		}else
		{
			if (typeof(sNewCustomerName) == "undefined" || sNewCustomerName == ""
			|| typeof(sNewCertType) == "undefined" || sNewCertType == ""
			|| typeof(sNewCertID) == "undefined" || sNewCertID == ""
			|| typeof(sNewLoanCardNo) == "undefined" || sNewLoanCardNo == "")
			{
				alert(getBusinessMessage('923'));//请输入需变更的客户信息！
				return;
			}
		}
		//录入数据有效性检查
		if (!ValidityCheck()) return;
							
		//变更客户信息
		sReturnValue = RunMethod("CustomerManage","UpdateCustomerInfo",sCustomerID+","+sOldCertType+","+sOldCertID+","+sNewCustomerName+","+sNewCertType+","+sNewCertID+","+sNewLoanCardNo);
	    if(typeof(sReturnValue) == "undefined" && sReturnValue == "") 
		{
			alert(getBusinessMessage('925'));//变更客户信息失败!
			return;
		}else if(sReturnValue == "AlreadyExist")
		{
			alert("相同证件类型和证件号码的客户已存在，请检查！");
			return;
		}else if(sReturnValue == "Success")
		{
			alert(getBusinessMessage('924'));//变更客户信息成功!
			return;
		}else
		{
			alert(getBusinessMessage('925'));//变更客户信息失败!
			return;
		}
					
	}	
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01') //公司客户
		{		
			//检查组织机构代码证的有效性	
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");
			//判断组织机构代码合法性
			if(sNewCertType =='Ent01')
			{			
				if(!CheckORG(sNewCertID))
				{
					alert(getBusinessMessage('102'));//组织机构代码有误！					
					return;
				}			
			}
			
			//检查贷款卡号的有效性
			sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");			
			if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" && sNewLoanCardNo != "000000000000000000")
			{
				if(!CheckLoanCardID(sNewLoanCardNo))
				{
					alert(getBusinessMessage('101'));//贷款卡编号有误！							
					return false;
				}
				
				//检验贷款卡编号唯一性
				sCustomerID = getItemValue(0,getRow(),"CustomerID");
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoChangeCustomer",sCustomerID+","+sNewLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					return false;
				}						
			}						
		}
				
		if(sCustomerType == '03') //个人客户
		{
			//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
			sNewCertType = getItemValue(0,getRow(),"NewCertType");
			sNewCertID = getItemValue(0,getRow(),"NewCertID");			
			//判断身份证合法性,个人身份证号码应该是15或18位！
			if(sNewCertType == 'Ind01' || sNewCertType =='Ind08')
			{
				if (!CheckLisince(sNewCertID))
				{
					alert(getBusinessMessage('156'));//身份证号码有误！					
					return;
				}
			}								
		}
		return true;	
	}
	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
