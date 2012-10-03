<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 额度日常管理;
		Input Param:
					sDealType：010生效的额度业务
						020实效的额度业务
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度日常管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//定义变量
	String sSql1="";
	String sCondition ="";

	//获得页面参数
	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	//out.println(sDealType+"@@@"+sReinforceFlag+"###"+sBusinessType);
	if (sReinforceFlag==null) sReinforceFlag="";
	//out.println(sBusinessType);
	if (sBusinessType == null) sBusinessType ="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","额度流水号"},
							{"CustomerName","客户名称"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"ArtificialNo","文本协议编号"},
							{"OtherAreaLoanName","授信方式"},
							{"OccurTypeName","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","额度协议金额(元)"},
							{"Balance","额度可用金额(元)"},
							{"CreditFreezeFlag","额度是否冻结"},
							//{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"OperateOrgName","经办机构"},
						  };
	String sSql =   " select SerialNo,CustomerName,CustomerID,"+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
					" ArtificialNo,"+
					" OtherAreaLoan,getItemName('CreditLineType',OtherAreaLoan) as OtherAreaLoanName,"+
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('YesOrNo',CreditFreezeFlag) as CreditFreezeFlag,"+
					" BusinessSum,PutOutDate,Maturity,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where InputUserID ='"+CurUser.UserID+"' and SerialNo like 'BC%' ";

	if(sDealType.equals("010"))  //modified by cli 2006-05-14 in Nanjing   考虑补登额度的情况
	{
		if (sReinforceFlag.equals("01"))
		{
			sSql1 =" and BusinessType = '"+sBusinessType+"' and (FinishDate ='' or FinishDate is null ) ";
		}
		else
		{
			sSql1 =" and BusinessType = '"+sBusinessType+"' and (FinishDate='' or FinishDate is null) and Maturity <> '' and Maturity is not null and days(current date) <= days(substr(maturity,1,4)||'-'||substr(maturity,6,2)||'-'||substr(maturity,9,2))";
		}
	}else if(sDealType.equals("020"))
	{
		sSql1 =" and BusinessType = '"+sBusinessType+"' and Maturity <> '' and Maturity is not null and ((FinishDate !='' and FinishDate is not null ) or days(current date) > days(substr(maturity,1,4)||'-'||substr(maturity,6,2)||'-'||substr(maturity,9,2)))";
	}
	sSql = sSql + sSql1;
	//out.println(:sSql);
	//out.println(sBusinessType+"@@@@@@@@@@@@"+sReinforceFlag+"##########"+sSql);

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("CreditFreezeFlag,CustomerID,BusinessType,OtherAreaLoan,OccurType,BusinessCurrency,VouchType,OperateOrgID,OtherAreaLoanName",false);
	doTemp.setVisible("OccurTypeName",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,BusinessTypeName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo,BusinessSum,Balance"," style={width:120px} ");
	doTemp.setHTMLStyle("OccurTypeName,OtherAreaLoanName"," style={width:60px} ");
	
    	//生成查询框
	doTemp.setColumnAttribute("SerialNo,CustomerName,ArtificialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.setPageSize(15);
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(15);  //服务器分页 2005/02/25 by ybhe

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

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
	String sBtns = "";
	if(sDealType.equals("020"))
	{

			sBtns = "额度详情,加入重点合同连接,五级分类,授信转移,贷后工作笔记,抵质押物管理,担保合同管理,移交保全部";

	}
	else
	{
		if (sReinforceFlag.equals("01"))
		{
			sBtns = "额度详情,新增授信额度,删除";
		}
		else
		{
			sBtns = "额度详情,加入重点合同连接,五级分类,终止,授信转移,贷后工作笔记,抵质押物管理,担保合同管理,移交保全部,管户移交";
		}
		
	}

	String sButtons[][] = {
		{(sBtns.indexOf("额度详情")>=0?"true":"false"),"","Button","额度详情","额度详情","viewAndEdit()",sResourcesPath},
		//{(sBtns.indexOf("加入重点合同连接")>=0?"true":"false"),"","Button","加入重点合同连接","加入重点合同连接","AddUserDefine()",sResourcesPath},
		//{(sBtns.indexOf("五级分类")>=0?"true":"false"),"","Button","五级分类","五级分类","Classify()",sResourcesPath},
		{(sBtns.indexOf("冻结")>=0?"true":"false"),"","Button","冻结","冻结","freeze()",sResourcesPath},
		{(sBtns.indexOf("解冻")>=0?"true":"false"),"","Button","解冻","解冻","thaw()",sResourcesPath},
		{(sBtns.indexOf("新增授信额度")>=0?"true":"false"),"","Button","新增授信额度","新增授信额度","NewContract()",sResourcesPath},
		{(sBtns.indexOf("授信转移")>=0?"false":"false"),"","Button","授信转移","授信转移","CreditLineShift()",sResourcesPath},
		{(sBtns.indexOf("贷后工作笔记")>=0?"true":"false"),"","Button","贷后工作笔记","贷后工作笔记","WorkRecord()",sResourcesPath},
		{(sBtns.indexOf("抵质押物管理")>=0?"true":"false"),"","Button","抵质押物管理","抵质押物管理","Guaranty()",sResourcesPath},
		{(sBtns.indexOf("担保合同管理")>=0?"true":"false"),"","Button","担保合同管理","担保合同管理","Assure()",sResourcesPath},
		{(sBtns.indexOf("终止")>=0?"true":"false"),"","Button","终止","终止","finished()",sResourcesPath},
		{(sBtns.indexOf("删除")>=0?"true":"false"),"","Button","删除","删除","Delete()",sResourcesPath},
		
//		{(sBtns.indexOf("移交保全部")>=0?"true":"false"),"","Button","移交保全部","将不良资产移交保全部管理","ShiftRMDepart()",sResourcesPath},
//		{(sBtns.indexOf("管户移交")>=0?"true":"false"),"","Button","管户移交","管户机构和管户人变更","doShift()",sResourcesPath}
	};
	/*
	String sButtons2[][] = {	{(sBtns.indexOf("授信转移")>=0?"false":"false"),"","Button","授信转移","授信转移","CreditLineShift()",sResourcesPath},
		{(sBtns.indexOf("贷后工作笔记")>=0?"true":"false"),"","Button","贷后工作笔记","贷后工作笔记","WorkRecord()",sResourcesPath},
		{(sBtns.indexOf("抵质押物管理")>=0?"true":"false"),"","Button","抵质押物管理","抵质押物管理","Guaranty()",sResourcesPath},
		{(sBtns.indexOf("担保合同管理")>=0?"true":"false"),"","Button","担保合同管理","担保合同管理","Assure()",sResourcesPath},
		{(sBtns.indexOf("移交保全部")>=0?"true":"false"),"","Button","移交保全部","将不良资产移交保全部管理","ShiftRMDepart()",sResourcesPath},
		{(sBtns.indexOf("管户移交")>=0?"true":"false"),"","Button","管户移交","管户机构和管户人变更","doShift()",sResourcesPath}
		};
	CurPage.setAttribute("Buttons2",sButtons2);
	*/
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		/*
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		*/
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		openObject("ReinforceContract",sObjectNo,"001");
		reloadSelf();	
	}


	/*~[Describe=贷后工作笔记;InputParam=无;OutPutParam=无;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=贷后工作笔记&NoteType=BUSINESS_CONTRACT&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增合同;InputParam=无;OutPutParam=无;]~*/
	function NewContract()
	{
		sCompID	 = "ReinforceCreation";
		sCompURL = "/InfoManage/DataInput/ReinforceCreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"BusinessType=<%=sBusinessType%>","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(!(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") )
		{
			sReturn = sReturn.split("@");
			var sObjectNo = sReturn[0];
			/*var sObjectType = "ReinforceContract";
			
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			*/
			openObject("ReinforceContract",sObjectNo,"001");			
		}
		else
		{
			return;
		}
		reloadSelf();
	}

	/*~[Describe=授信转移;InputParam=无;OutPutParam=无;]~*/
	function CreditLineShift()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			sShiftCreditLineNo = selectObjectInfo("BusinessContract","BusinessType=in ('9010')~CustomerID="+sCustomerID+"~Finished=N");
			if(typeof(sShiftCreditLineNo)=="undefined" || length(sShiftCreditLineNo)==0)
				return;
			sReturn = PopPage("/CreditManage/CreditCheck/ShiftCreditLineAction.jsp?SerialNo="+sSerialNo+"&ShiftCreditLineNo="+sShiftCreditLineNo,"","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=五级分类;InputParam=无;OutPutParam=无;]~*/
	function Classify()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("ContractClassifyMain","/CreditManage/CreditCheck/ContractClassifyMain.jsp","ComponentName=五级分类&SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=加入重点合同连接;InputParam=无;OutPutParam=无;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		if(confirm(getBusinessMessage('433'))) 
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}

	/*~[Describe=冻结额度;InputParam=无;OutPutParam=无;]~*/
	function freeze()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			sReturn = PopPage("/CreditManage/CreditCheck/CreditFreezeAction.jsp?SerialNo="+sSerialNo+"&FreezeType=010","","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=解冻额度;InputParam=无;OutPutParam=无;]~*/
	function thaw()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			sReturn = PopPage("/CreditManage/CreditCheck/CreditFreezeAction.jsp?SerialNo="+sSerialNo+"&FreezeType=020","","");
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('191'));
			}
			self.location.reload();
		}
	}

	/*~[Describe=合同终结;InputParam=无;OutPutParam=无;]~*/
	function finished()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
			OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function Delete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}   
		//该额度是否生效
	    var sColName = "serialno";
		var sTableName = "Business_contract";
		var sWhereClause = "String@SerialNo@"+sSerialNo+"@String@InUseFlag@01";
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("额度已生效，不能删除！");
			return;
			
		}else
		{
			if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			{
				as_del('myiframe0');
	            as_save('myiframe0');  //如果单个删除，则要调用此语句
				//reloadSelf();
			}
		}
	}

	
	/*~[Describe=担保合同管理;InputParam=无;OutPutParam=无;]~*/
	function Assure()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=担保合同管理&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=抵质押物管理;InputParam=无;OutPutParam=无;]~*/
	function Guaranty()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenComp("GuarantyList","/CreditManage/CreditPutOut/GuarantyList.jsp","ComponentName=抵质押物管理&ObjectType=BusinessContract&WhereType=020&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	/*~[Describe=移交保全部门;InputParam=无;OutPutParam=无;]~*/
	function ShiftRMDepart()
	{
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{       
		
			var sTrace= PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
			if(typeof(sTrace)!="undefined" && sTrace.length!=0)
			{
				
				var sTrace=sTrace.split("@");
				
				//获得移交类型、保全机构
				var sShiftType = sTrace[0];
				var sTraceOrgID = sTrace[1];
				var sTraceOrgName = sTrace[2];
				
				if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
				{
					var sReturn = PopPage("/RecoveryManage/Public/NPAShiftAction.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"","","");
					if(sReturn == "true") //刷新页面
					{
						alert("该不良资产成功移交到『"+sTraceOrgName+"』"); 
						self.location.reload();
					}
					else
					{
						alert("该不良资产已经移交，不能再次移交！"); 
						self.location.reload();
					}
				}
			}
	
		}
	}

	/*~[Describe=业务转移;InputParam=无;OutPutParam=无;]~*/
	function doShift()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
    	{
			alert(getHtmlMessage('1'));//请选择一条信息！
    	}else
    	{
			sReturn = selectObjectInfo("User","OrgID=<%=CurOrg.OrgID%>");
			var sss = sReturn.split("@");
			sUserID = sss[0];
			sOrgID = sss[2];
			if(sReturn=="_CANCEL_" && typeof(sReturn)=="undefined") return;
			sReturn = PopPage("/SystemManage/GeneralSetup/ContractShiftAction.jsp?SerialNo="+sSerialNo+"&UserID="+sUserID+"&OrgID="+sOrgID,"","resizable=yes;dialogWidth=48;dialogHeight=30;center:yes;status:no;statusbar:no");
	    	if(sReturn=='true')  
	    	{
	    	    alert("转移成功！");
				self.location.reload();
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

<%@	include file="/IncludeEnd.jsp"%>
