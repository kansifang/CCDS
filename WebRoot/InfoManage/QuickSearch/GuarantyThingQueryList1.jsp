<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-26
			Tester:
			Content: 担保物信息快速查询
			Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：担保物信息快速查询
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "软抵押物快速查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--存放组件名称
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//定义表头文件
	String sHeaders[][] =	{ 							
						{"customername","借款人"},
						{"SerialNo","合同流水号"},
						{"businesssum","合同金额"},
						{"balance","合同余额"},
						{"putoutdate","发放日"},
						{"maturity","到期日"},
						{"maturity","到期日"},
						{"businesstypename","业务品种"},
						{"OwnerName","权利人名称"},
						{"GuarantyID","软抵质押物编号"},
						{"GuarantyName","软抵质押物名称"},
						{"GuarantyType","软抵质押物类型"},
						{"GuarantyTypeName","软抵质押物类型"},
						{"OwnerType","权属人类型"},
						{"EvalCurrencyName","软抵质押物评估币种"},
						{"EvalNetValue","软抵质押物评估价值"},
						{"GuarantyCurrencyName","软抵质押物认定币种"},
						{"ConfirmValue","软抵质押物认定价值"},
						{"InputOrgID","登记机构"},
						{"InputOrgIDName","登记机构"},
						{"GuarantyRightID","权证号"}
					}; 
	
	sSql =	
	"`select  bc.customername,bc.SerialNo,bc.businesssum,bc.balance,bc.putoutdate,bc.maturity,getbusinessname(bc.businesstype) as businesstypename,"+
	" gi.InputOrgID,getOrgName(gi.InputOrgID) as InputOrgIDName, "+
	" gi.GuarantyID,gi.GuarantyName,gi.GuarantyType,getItemName('GuarantyList',gi.GuarantyType) as GuarantyTypeName,gi.GuarantyRightID,gi.OwnerName, " +
	" getItemName('SecurityType',gi.OwnerType) as OwnerType," +
	" getItemName('Currency',gi.EvalCurrency) as EvalCurrencyName,gi.EvalNetValue,"+
	" getItemName('Currency',gi.GuarantyCurrency) as GuarantyCurrencyName,gi.ConfirmValue" +
	" from GUARANTY_INFO gi,guaranty_relative gr ,business_contract bc "+
	" where gi.InputOrgID in  (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') "+
	" and gr.objecttype in ('BusinessContract','ReinforceContract') "+
	" and gi.guarantyid=gr.guarantyid and gr.objectno=bc.serialno and bc.Flag9 = '1' ";

	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("gi.GuarantyID");
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_INFO";	
	//设置关键字
	doTemp.setKey("GuarantyID",true);
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("OwnerName","style={width:250px} ");  
	//设置不可见项
	doTemp.setVisible("GuarantyType,InputOrgID",false);		
	//设置对齐方式
	doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	doTemp.setType("businesssum,balance,EvalNetValue,ConfirmValue","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("businesssum,balance,EvalNetValue,ConfirmValue","2");	
	//设置下拉框
	doTemp.setDDDWSql("GuarantyType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyList' and ItemNo not like '030%' and length(ItemNo) > 3");

	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","GuarantyName","");
	//doTemp.setFilter(Sqlca,"2","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","EvalNetValue","");
	doTemp.setFilter(Sqlca,"4","GuarantyID","");
	doTemp.setFilter(Sqlca,"5","InputOrgIDName","");
	doTemp.setFilter(Sqlca,"6","SerialNo","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
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
			{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
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

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得担保物流水号
		sGuarantyID    =getItemValue(0,getRow(),"GuarantyID");	
		sGuarantyType=getItemValue(0,getRow(),"GuarantyType");
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
		    popComp("GuarantyThingQueryInfo","/InfoManage/QuickSearch/GuarantyThingQueryInfo.jsp","GuarantyType="+sGuarantyType+"&GuarantyID="+sGuarantyID,"","");
		}			 
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
