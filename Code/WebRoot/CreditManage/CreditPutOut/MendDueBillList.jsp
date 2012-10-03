<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: xhyong 2010/10/14
		Tester:
		Describe: 补登借据列表
		Input Param:
			ObjectType: 阶段编号
			ObjectNo：业务流水号
		Output Param:
			
		HistoryLog:xlyu
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

    String ssSql = "";//Sql语句
    ASResultSet rs = null;//结果集
    String sBusinessType="" ;
   
	//获得页面参数

	//获得组件参数
	//String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));//合同流水号
	//取得合同信息
	ssSql =  " select BusinessType from BUSINESS_CONTRACT  where SerialNo ='"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(ssSql);
	if(rs.next())
	{
		sBusinessType=rs.getString("BusinessType");
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	

    String sHeaders[][] = 	{
								{"CustomerName","客户名称"},
								{"SerialNo","借据流水号"},
								{"BillNo","票据号"},
								{"RelativeSerialNo1","相关出帐流水号"},
								{"Currency","币种"},
								{"BusinessSum","金额"},
								{"OccurDate","发生日期"},
								{"FinishDate","终结日期"},
								{"OperateOrgName","经办机构"},
			      			};


	String sSql =   " select Maturity,"+
					" CustomerID,CustomerName,"+
					" SerialNo,BillNo,"+
					" RelativeSerialNo1,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,OccurDate,FinishDate,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from  BUSINESS_DUEBILL "+
					" where RelativeSerialNo2='"+sObjectNo+"'  ";
					

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "BUSINESS_DUEBILL";
    //设置主键
	doTemp.setKey("SerialNo",true);
	//设置不可见项
	doTemp.setVisible("CustomerID,BusinessCurrency,OperateOrgID,Maturity,Balance",false);
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setVisible("RelativeSerialNo1,OccurDate",false);
		sHeaders[1][1]="业务流水号";
		doTemp.setHeader(sHeaders);
	}
	if(sBusinessType.startsWith("1"))
	{
		doTemp.setVisible("BillNo,FinishDate",false);
	}
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
			{"true","","Button","新增","新增","newAndEdit()",sResourcesPath},
			{"true","","Button","详情","查看业务详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"false","","Button","解付","解付","removeRecord()",sResourcesPath},
			{"false","","Button","变更借据的关联合同","变更借据的关联合同","ChangeContract()",sResourcesPath}
		};
	if(sBusinessType.equals("2010"))//银行承兑汇票
    { 
         sButtons[3][0]="true";  
    }
	if(sBusinessType.startsWith("2"))//所有表外补登业务不要删除按钮
	{
		if(CurUser.hasRole("000"))//总行系统数据维护员
		 sButtons[2][0]="true";
		else  sButtons[2][0]="false";
	}
	if(CurUser.hasRole("299"))
	{
		sButtons[0][0]="false";
		sButtons[3][0]="false";
	}
	%>

<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newAndEdit()
	{
		OpenPage("/CreditManage/CreditPutOut/MendDueBillInfo.jsp?","_self","");
	}
	
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--流水号
	    sFinishDate = getItemValue(0,getRow(),"FinishDate");
	 	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CreditManage/CreditPutOut/MendDueBillInfo.jsp?SerialNo="+sSerialNo+"&FinishDate="+sFinishDate, "_self","");
		}
	}
	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}
	}
	
	/*~[Describe=解付记录;InputParam=无;OutPutParam=无;]~*/
	function removeRecord()
	{
	   	 sSerialNo   = getItemValue(0,getRow(),"SerialNo");//借据流水号
	   	 sMaturity   = getItemValue(0,getRow(),"Maturity"); //汇票到期日
	   	 
	     if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		 {
			alert(getHtmlMessage('1'));//请选择一条信息！
		 }else if(confirm("您确定解付吗?解付后该借据信息将无法修改"))//您真的想解付该信息吗？
			{
			    sFinishDate=PopPage("/Common/ToolsA/SelectDate.jsp","","dialogWidth=20;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		        if(typeof(sFinishDate) != "undefined"  && sFinishDate != "_CANCEL_" && sFinishDate!= "_NONE_" )
		        {
		            if(sFinishDate < sMaturity)
		            {
		              alert("解付日需大于或等于汇票到期日！");
		              return false;
		            }
	              sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@FinishDate@"+sFinishDate+"@Number@Balance@0,BUSINESS_DUEBILL,String@SerialNo@"+sSerialNo);
	              reloadSelf(); 
	          }
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
