<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: 还款方式补登提示信息
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款方式补登提示信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//定义变量	    
	String sSql = "";
	//定义变量：SQL语句,查询结果集,机构直属、区县标志
	//获得组件参数
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//定义标题
	String sHeaders[][] = {
							{"SerialNo","还款流水号"},
							{"RelativeContractNo","合同流水号"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"OccurDate","发生日期"},
							{"TransactionFlag","交易标志"},
							{"OccurDirection","发生方向"},
							{"OccurType","发生类型"},
							{"VouchTypeName","主要担保方式"},
							{"BusinessCurrencyName","币种"},
							{"BusinessSum","金额"},
							{"Balance","余额"},
							{"PutOutDate","起始日"},
							{"Maturity","到期日"},
							{"OccurSubject","发生摘要"},
							{"BusinessDesc","交易描述"},
							{"ActualSum","实际发生额"}
						}; 

 	sSql = " select BW.SerialNo as SerialNo," + 	
		   " BW.RelativeContractNo as RelativeContractNo,BW.CustomerName as CustomerName," + 
		   " getBusinessName(BC.BusinessType) as BusinessTypeName,"+
		   " BW.OccurDate as OccurDate,BW.TransactionFlag as TransactionFlag,"+
		   " BW.OccurDirection as OccurDirection,getItemName('OccurType',BC.OccurType) as OccurType,"+
		   " getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
		   " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
		   " BC.BusinessSum as BusinessSum,BC.Balance as Balance,"+
		   " BC.PutOutDate as PutOutDate,BC.Maturity as Maturity,"+
		   " BW.OccurSubject as OccurSubject,BC.BusinessType as BusinessType," + 
		   " BW.BusinessDesc as BusinessDesc,BW.ActualSum as ActualSum " +  
		   " from BUSINESS_WASTEBOOK BW,BUSINESS_CONTRACT BC "+
		   " where BW.RelativeContractNo=BC.SerialNo and BC.RecoveryUserID='"+CurUser.UserID+"'"+
		   " and BC.RecoveryOrgID ='"+CurOrg.OrgID+"'"+
		   " and substr(BC.ClassifyResult,1,2)>'02'"+
		   " and (BW.ManageFlag1 is  null or BW.ManageFlag1 ='')";
		   
	//利用Sql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//设置共用格式
	//设置隐藏
	doTemp.setVisible("ActualSum,BusinessDesc,OccurSubject,OccurDirection,TransactionFlag,OccurDate,BusinessType",false);	
    
	//设置行宽
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("ActualSum"," style={width:95px} ");;


	//设置金额为三位一逗数字
	doTemp.setType("ActualSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("ActualSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("ActualSum","3");
	
	//生成查询框
	doTemp.setColumnAttribute("CustomerName,RelativeContractNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setPageSize(20); 	//服务器分页
	
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		};

%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=查看及修改合同详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得合同流水号
		var sContractNo=getItemValue(0,getRow(),"RelativeContractNo");  		
		//获得业务品种
		var sBusinessType=getItemValue(0,getRow(),"BusinessType"); 
		if (typeof(sContractNo)=="undefined" || sContractNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			
			if(sBusinessType=="8010" || sBusinessType=="8020" || sBusinessType=="8030")
			{
				OpenComp("DataInputDetailInfo","/InfoManage/DataInput/DataInputDetailInfo.jsp","ComponentName=列表&ComponentType=MainWindow&SerialNo="+sContractNo+"&Flag=Y&CurItemDescribe3="+sBusinessType+"","_blank",OpenStyle);
			}else
			{
			  sObjectType = "AfterLoan";
				sObjectNo = sContractNo;
				sViewID = "002";
				sCompID = "CreditTab";
				sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
				sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ViewID="+sViewID;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
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

<%@include file="/IncludeEnd.jsp"%>