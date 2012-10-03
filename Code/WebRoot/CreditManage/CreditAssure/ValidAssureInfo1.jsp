<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-9
		Tester:
		Describe: 担保合同信息（有效的）（一个保证合同对应一个保证人）;
		Input Param:			
			SerialNo：担保合同号	
			GuarantyType：担保方式		
		Output Param:

		HistoryLog:
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "一般担保合同信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	
	String sTempletFilter = "";//过滤条件
	String sSql = "";
	
	//获得组件参数
	
	//获得页面参数：担保合同编号
    String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	if(sSerialNo == null) sSerialNo = "";
	if(sGuarantyType == null) sGuarantyType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//过滤条件
	sTempletFilter = " (ColAttribute like '%BC%' ) ";
	    
	//根据担保类型取得显示模版号
	sSql="select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);

	//通过显示模版和过滤条件产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置只读属性
	doTemp.setReadOnly("GuarantorName,CertType,CertID,LoanCardNo",true);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	
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
		if(!ValidityCheck()) return;
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	function ValidityCheck()
	{		
		ssTempletNo	= "<%=sTempletNo%>";
		sCommonDate = getItemValue(0,getRow(),"CommonDate");
		sSignDate = getItemValue(0,getRow(),"SignDate");
		sBeginDate = getItemValue(0,getRow(),"BeginDate");			
		sEndDate = getItemValue(0,getRow(),"EndDate");
			
		if(ssTempletNo=="Guaranty011" || ssTempletNo=="Guaranty050" || ssTempletNo=="Guaranty060" || ssTempletNo=="Guaranty070" )
		{
			//检查输入的日期的逻辑
			if (typeof(sSignDate)!="undefined" && sSignDate.length > 0)
			{
				if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
				{	
					if (typeof(sEndDate)!="undefined" && sEndDate.length > 0)
					{
						if(!(( sSignDate <= sBeginDate ) && (sBeginDate <= sEndDate)))
						{		    
							alert("合同签订日应该小于等于合同生效日，并且合同生效日应该小于等于合同到期日!");
							return false;		    
						}
					}
				}
			}
		}else if(ssTempletNo=="Guaranty012" || ssTempletNo=="Guaranty013" )
		{
			//检查输入的日期的逻辑
			if (typeof(sSignDate)!="undefined" && sSignDate.length > 0)
			{
				if (typeof(sCommonDate)!="undefined" && sCommonDate.length > 0)
				{
					if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
					{	
						if (typeof(sEndDate)!="undefined" && sEndDate.length > 0)
						{
							if(!(( sSignDate <= sCommonDate ) && ( sCommonDate <= sBeginDate ) && (sBeginDate <= sEndDate)))
							{	
								if(ssTempletNo=="Guaranty012")
								{	    
									alert("合同签订日应该小于等于保险交费日，保险交费日应该小于等于保险生效日，保险生效日应该小于等于保险到期日!");
									return false;
								}else		    
								{
									alert("合同签订日应该小于等于保函签发日，保函签发日应该小于等于保函生效日，保函生效日应该小于等于保函到期日!");
									return false;
								}
							}
						}
					}
				}
			}
		}
		return true;
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAssure/ValidAssureList1.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
