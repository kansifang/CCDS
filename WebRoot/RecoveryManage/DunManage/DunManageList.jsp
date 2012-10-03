<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	不良资产列表(List页面)
		Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：不良资产列表
				PropertyType	资产类型：不良资产/正常资产								
				ObjectType	对象类型：BUSINESS_CONTRACT
						上述两个参数的目的是保持扩展性,将来可能不仅仅用户不良资产的催收函管理.
			        
		Output param:
		                ContractID	资产编号
		History Log: 		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sSql ="";
	
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc,outer Dun_Info di" +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					"  and (bc.SerialNo=di.ObjectNo) "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//考虑核销的资产。
	}else if(sDBName.startsWith("ORACLE")) 
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc,Dun_Info di" +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					"  and bc.SerialNo=di.ObjectNo(+) "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//考虑核销的资产。
	}else if(sDBName.startsWith("DB2")) 
	{
			sSql =	" select bc.SerialNo as SerialNo,"+					
					" bc.PutOutDate as PutOutDate,"+
					" bc.Maturity as Maturity,"+
					" bc.CustomerName as CustomerName,"+
					" getBusinessName(bc.BusinessType) as BusinessType, " +
					" getItemName('Currency',bc.BusinessCurrency) as BusinessCurrency, " +
					" bc.BusinessSum as BusinessSum," +
					" bc.Balance as Balance, "+
					" Count(di.ObjectNo) as Counter,"+
					" Max(di.DunDate) as DunDate "+			
					" from  BUSINESS_CONTRACT bc left outer join  Dun_Info di on(bc.SerialNo=di.ObjectNo) " +
					" where bc.RecoveryUserID='"+CurUser.UserID+
					"' and bc.Balance >0 "+
					" AND(( bc.FinishDate is  NULL)or(bc.FinishDate ='') or (bc.FinishType='060'))  and bc.ShiftType='02' "+
					" Group by bc.SerialNo, bc.ArtificialNo, bc.OccurDate, "+
					" bc.Maturity,bc.CustomerName,bc.BusinessType,"+
					" bc.BusinessCurrency,bc.BusinessSum,bc.Balance,PutOutDate"+
					" order by bc.SerialNo desc";//考虑核销的资产。
	}
    //out.println(sSql);  			
   	String sHeaders[][] = {
										{"SerialNo","合同流水号"},										
										{"PutOutDate","合同起始日"},
										{"Maturity","合同到期日"},
										{"CustomerName","客户名称"},
										{"BusinessType","业务品种"},
										{"BusinessCurrency","币种"},
										{"BusinessSum","合同金额"},
										{"Balance","合同余额"},	
										{"Counter","催收次数"},				
										{"DunDate","最近催收日期"}				
									};  
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);	 	   
	//设置显示文本框的长度
	doTemp.setHTMLStyle("SerialNo,DunLetterNo"," style={width:90px} ");
	doTemp.setHTMLStyle("PutOutDate,DunDate,Maturity"," style={width:70px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessType"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate"," style={width:80px} ");
	doTemp.setHTMLStyle("BusinessCurrency,Counter"," style={width:60px} ");
	doTemp.setHTMLStyle("BusinessSum,Balance,BusinessRate"," style={width:80px} ");
	//设置对齐方式
	doTemp.setAlign("BusinessSum,Balance,BusinessRate,counter","3");
	doTemp.setAlign("BusinessCurrency","2");
	//设置小数显示状态,
	doTemp.setType("BusinessSum,BusinessRate,Balance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("counter","5");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	doTemp.setCheckFormat("BusinessRate","16");
	//生成查询框
	doTemp.setColumnAttribute("SerialNo,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(16);  //服务器分页
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
		{"true","","Button","合同详情","合同详情","viewTab()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
		/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
		function viewTab()
		{
			sObjectType = "AfterLoan";
			sObjectNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			sApproveType = getItemValue(0,getRow(),"ApproveType");
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		
		/*~[Describe=选中某笔合同,自动显示相关的催收列表;InputParam=无;OutPutParam=无;]~*/
		function mySelectRow()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");//合同编号
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				//alert(getHtmlMessage('1'));//请选择一条信息！
			}else 
			{
				OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo,"DetailFrame");
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
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的合同信息!","DetailFrame","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
