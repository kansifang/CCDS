<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: 合同项下借据
		Input Param:
			ObjectType: 阶段编号
			ObjectNo：业务流水号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同项下借据"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数

	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	String sHeaders[][] = 	{
								{"CustomerName","客户名称"},
								{"SerialNo","借据流水号"},
								{"RelativeSerialNo1","相关出帐流水号"},
								{"Currency","币种"},
								{"BusinessSum","金额"},
								{"OccurDate","发生日期"},
								{"OperateOrgName","经办机构"},
			      			};


	String sSql =   " select"+
					" CustomerID,CustomerName,"+
					" SerialNo,"+
					" RelativeSerialNo1,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from  BUSINESS_DUEBILL "+
					" where RelativeSerialNo2='"+sObjectNo+"'  ";
					

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("CustomerID,BusinessCurrency,OperateOrgID",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum","3");
	doTemp.setCheckFormat("BusinessSum","2");
	
	//设置html格式
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency,OccurDate"," style={width:80px} ");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"true","","Button","详情","查看业务详情","viewAndEdit()",sResourcesPath},
			{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","变更关联合同","变更借据的关联合同","ChangeContract()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			openObject("BusinessDueBill",sSerialNo,"002");
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=变更借据的关联合同;InputParam=无;OutPutParam=无;]~*/
	function ChangeContract()
	{
		//借据流水号、原合同编号、客户编号
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sOldContractNo   = "<%=sObjectNo%>";
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else 
		{
			sParaString = "SerialNo"+","+sOldContractNo+",CustomerID"+","+sCustomerID;	
			sContractNo = setObjectValue("SelectChangeContract",sParaString,"",0,0,"");
			if (!(sContractNo=='_CANCEL_' || typeof(sContractNo)=="undefined" || sContractNo.length==0 || sContractNo=='_CLEAR_' || sContractNo=='_NONE_'))
			{
				if(confirm(getBusinessMessage('487'))) //确实要变更借据的关联合同吗？
				{
					sContractNo = sContractNo.split('@');
					sContractSerialNo = sContractNo[0];					
					var sReturn = PopPage("/InfoManage/DataInput/ChangeContractAction.jsp?ContractNo="+sContractSerialNo+"&DueBillNo="+sSerialNo+"&OldContractNo="+sOldContractNo,"","");
					if(sReturn == "true")
					{
						alert("合同『"+sOldContractNo+"』下的借据『"+sSerialNo+"』已经成功变更到合同『"+sContractNo+"』下!");
						reloadSelf();
					}
				}					
			}			 	
		}
	}

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
