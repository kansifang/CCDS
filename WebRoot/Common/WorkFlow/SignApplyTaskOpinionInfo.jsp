<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: lpzhang 增加信用等级评估认定信息 2009-8-25 
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//定义变量
	String sSql = "",sFlowNo = "",sPhaseNo = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sOccurType = "",sBusinessSum = "",sPdgSum="", sBailSum ="";
	double dBusinessSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0,dOldTermMonth = 0,dOldTermDay = 0;
	String sCustomerType ="",sEvaluateSerialNo="",sApplyType="";
	//信用等级信息
	String sEvaluateResult="",sCognResult="",sModelNo="",sTransformMethod ="",sModelDescribe="",Sql1="",sSmallEntFlag="";
	double dCognScore =0.0,dEvaluateScore=0.0;
	ASResultSet rs = null,rs1 = null;
	
	//获取组件参数：任务流水号、对象编号、对象类型
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
  <%	
	//根据对象类型和对象编号获取相应的业务信息
	sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,ApplyType "+
			" from BUSINESS_APPLY "+
			" where SerialNo = '"+sObjectNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		sBusinessCurrency = rs.getString("BusinessCurrency");
		dBusinessSum = rs.getDouble("BusinessSum");
		dBaseRate = rs.getDouble("BaseRate");
		sRateFloatType = rs.getString("RateFloatType");
		dRateFloat = rs.getDouble("RateFloat");
		dBusinessRate = rs.getDouble("BusinessRate");
		sBailCurrency = rs.getString("BailCurrency");
		dBailSum = rs.getDouble("BailSum");
		dBailRatio = rs.getDouble("BailRatio");
		dPdgRatio = rs.getDouble("PdgRatio");
		dPdgSum = rs.getDouble("PdgSum");
		sBusinessType = rs.getString("BusinessType");
		iTermYear = rs.getInt("TermYear");
		iTermMonth = rs.getInt("TermMonth");
		iTermDay = rs.getInt("TermDay");
		sOccurType = rs.getString("OccurType");
		sApplyType = rs.getString("ApplyType");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		if(sRateFloatType == null) sRateFloatType = "";
		if(sBailCurrency == null) sBailCurrency = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		//转化金额的显示格式
		if(dBusinessSum > 0)
			sBusinessSum = DataConvert.toMoney(dBusinessSum);
		if(dBailSum > 0)
			sBailSum = DataConvert.toMoney(dBailSum);
		if(dPdgSum > 0)
			sPdgSum = DataConvert.toMoney(dPdgSum);						
	}
	rs.getStatement().close();
	
	
	//取得客户信用等级评估信息 add by lpzhang 2009-8-24
	sSql = "select CustomerType from Customer_Info where CustomerID ='"+sCustomerID+"'";
	sCustomerType = Sqlca.getString(sSql);
	if(sCustomerType == null) sCustomerType="";
	
	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") && sObjectType.equals("CreditApply"))
	{
		String sCustomerFlag="";
		if(sCustomerType.startsWith("03"))
		{
			sCustomerFlag = "IND_INFO";
			sModelNo = Sqlca.getString("select CreditBelong from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'");
			
		}else{
			sCustomerFlag = "ENT_INFO";
			sSql ="select CreditBelong,SmallEntFlag from "+sCustomerFlag+" where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sModelNo = rs.getString("CreditBelong");
				sSmallEntFlag  = rs.getString("SmallEntFlag");
				
				if(sModelNo == null) sModelNo ="";
				if(sSmallEntFlag == null) sSmallEntFlag ="";
			}
			rs.getStatement().close();
		}
		
		if (sModelNo != null  && !sModelNo.equals("")) 
		{
			Sql1 = "select TransformMethod,ModelDescribe from EVALUATE_CATALOG where ModelNo = '"+sModelNo+"'";
			rs1 = Sqlca.getASResultSet2(Sql1);
			if(rs1.next())
			{
				sTransformMethod = rs1.getString("TransformMethod");
				sModelDescribe = rs1.getString("ModelDescribe");
				if(sTransformMethod == null) sTransformMethod ="";
				if(sModelDescribe == null) sModelDescribe ="";
			}
			rs1.getStatement().close();
		}
		
	}
	//取展期原合同期限和天数
	if(sOccurType.equals("015")){
		sSql = "select TermMonth,TermDay from BUSINESS_CONTRACT "+
			" where SerialNo = (select relativeserialno2 from BUSINESS_DUEBILL "+
			" where SerialNo=(select ObjectNo from APPLY_RELATIVE  where ObjectType = 'BusinessDueBill' "+ 
			" and SerialNo = '"+sObjectNo+"'))";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			dOldTermMonth = rs.getInt("TermMonth");
			dOldTermDay = rs.getInt("TermDay");
		}
		rs.getStatement().close();
	}
	String sHeaders[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","业务币种"},
	                        {"BusinessSum","审批金额"},
	                        {"TermMonth","期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","执行月利率(‰)"},
	                        {"BailCurrency","保证金币种"},
	                        {"BailRatio","保证金比例(%)"},	
	                       	{"BailSum","保证金金额"},                         
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"SystemScore","系统评估得分"},
	                        {"SystemResult","系统评估结果"},
	                        {"CognScore","人工评定得分"},
	                        {"CognResult","人工评定结果"},
	                        {"PhaseChoice","审查审批意见"},
	                        {"PhaseOpinion","意见说明"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        };                    
	String sHeaders1[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","业务币种"},
	                        {"BusinessSum","审批金额"},
	                        {"TermMonth","期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","执行月利率(‰)"},
	                        {"BailCurrency","保证金币种"},
	                        {"BailRatio","保证金比例(%)"},	                        
	                        {"BailSum","保证金金额"},	                        
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"SystemScore","系统评估得分"},
	                        {"SystemResult","系统评估结果"},
	                        {"CognScore","人工评定得分"},
	                        {"CognResult","人工评定结果"},
	                        {"PhaseChoice","审查审批意见"},
	                        {"PhaseOpinion","意见说明"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        }; 	
    String sHeaders2[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","展期币种"},
	                        {"BusinessSum","展期金额"},
	                        {"TermMonth","展期期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","展期执行月利率(‰)"},
	                        {"BailCurrency","保证金币种"},
	                        {"BailRatio","保证金比例(%)"},		                        
	                        {"BailSum","保证金金额"},                        
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"SystemScore","系统评估得分"},
	                        {"SystemResult","系统评估结果"},
	                        {"CognScore","人工评定得分"},
	                        {"CognResult","人工评定结果"},
	                        {"PhaseChoice","审查审批意见"},
	                        {"PhaseOpinion","意见说明"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        }; 	
    String sHeaders3[][]={                       
				    		{"PhaseChoice","审查意见"},
				            {"PhaseOpinion","意见说明"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        };  
	//定义SQL语句
	sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
			" CustomerName,BusinessCurrency,BusinessSum,TermYear,TermMonth, "+
			" TermDay,BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailRatio,BailSum,PdgRatio,PdgSum,"+
			" SystemScore as SystemScore,SystemResult as SystemResult,"+//系统评估得分，系统评估结果
 			" CognScore as CognScore,CognResult as CognResult,"+//人工评分，人工评定结果
			" PhaseChoice,PhaseOpinion,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputUser, "+
			" getUserName(InputUser) as InputUserName,InputTime, "+
			" UpdateUser,UpdateTime "+
			" from FLOW_OPINION " +
			" where SerialNo='"+sSerialNo+"' ";

	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//定义列表表头	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //申请初始阶段和发回补充资料阶段
	{
		doTemp.setHeader(sHeaders3); 
	}else
	{
		if(sOccurType.equals("015"))//发生类型为展期
		{
			doTemp.setHeader(sHeaders2); 
		}else
		{
			doTemp.setHeader(sHeaders); 
		}
	}
	
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	doTemp.setUnit("TermMonth","月");
	doTemp.setUnit("TermDay","天");
	doTemp.setReadOnly("BaseRate,BusinessCurrency,BailCurrency,RateFloatType,CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime",true);
	doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
	doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
	doTemp.setHTMLStyle("BusinessSum"," onchange=parent.getBailPdgSum() ");
	
	//设置字段是否可见和必输项	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //申请初始阶段和发回补充资料阶段
	{
		doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setHeader("PhaseChoice","调查意见");
		doTemp.setRequired("PhaseOpinion",true);
	}else
	{
		if(sOccurType.equals("015"))//发生类型为展期
		{
			doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PhaseOpinion",true);
	//		doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}else
		{
			if(sPhaseNo.equals("0020"))
			{
				doTemp.setHeader("BusinessSum","申请金额");
				doTemp.setHeader("PhaseChoice","调查意见");
			}
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum,PhaseChoice,PhaseOpinion",true);
			//备用信用证，进口信用证,对外保函,
			if(sBusinessType.equals("2050020") || sBusinessType.equals("2050030")|| sBusinessType.equals("2050010")
												|| sBusinessType.equals("2050040")){
				doTemp.setVisible("TermMonth",false);
				doTemp.setRequired("TermMonth",false);
			}
			//非融资性保函,融资性保函,提货担保,进口信用证,对外保函
			if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040")|| sBusinessType.equals("2050010") 
												|| sBusinessType.equals("2050030") || sBusinessType.equals("2050040")
												|| sBusinessType.equals("2050020")){
				doTemp.setVisible("TermDay",false);
				doTemp.setRequired("TermDay",false);
			}
			//个人住房公积金贷款
			if("1110027".equals(sBusinessType)){
				doTemp.setVisible("RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setReadOnly("BusinessSum,TermMonth,TermDay",true);
			}
			//银行承兑汇票,国内信用证,融资性保函,非融资性保函,国际贸易融资,贷款承诺,担保
			if(sBusinessType.startsWith("2030") || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050")
												|| sBusinessType.startsWith("2080") || sBusinessType.startsWith("2090") 
												|| sBusinessType.equals("2010") || sBusinessType.equals("2020") ){
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("BaseRate,RateFloatType,RateFloat,BusinessRate",false);										
			}
			//1110010
			/*if(sBusinessType.startsWith("1010") || sBusinessType.startsWith("1020") || sBusinessType.startsWith("1030")
												|| sBusinessType.startsWith("1040") || sBusinessType.startsWith("1050") 
												|| sBusinessType.equals("1056") || sBusinessType.equals("1054")
												|| sBusinessType.equals("1060") || sBusinessType.startsWith("1080")
												|| sBusinessType.startsWith("1090") || sBusinessType.startsWith("1100")
												|| (sBusinessType.startsWith("1110") && !(sBusinessType.equals("1110070")))
												|| sBusinessType.startsWith("1140")
												|| sBusinessType.startsWith("2060") || sBusinessType.equals("2070") 
												|| sBusinessType.equals("2100") || (sBusinessType.startsWith("1150")&& !sBusinessType.equals("1150020") )){
				doTemp.setVisible("BailSum,BailRatio",false);
				doTemp.setRequired("BailSum,BailRatio",false);								
			}
			*/
			//国内保理
			if("1090010".equals(sBusinessType)){
				doTemp.setVisible("PdgSum",false);
				doTemp.setRequired("PdgSum",false);
			}
			
			//
			/*if(!(sBusinessType.equals("2010") || sBusinessType.equals("2020") || sBusinessType.startsWith("2030")
											  || sBusinessType.startsWith("2040") || sBusinessType.startsWith("2050") 
											  || sBusinessType.startsWith("2060") || sBusinessType.equals("2070")
											  || sBusinessType.startsWith("2080") || sBusinessType.startsWith("2090")
											  || sBusinessType.equals("2110040") || sBusinessType.equals("2110050")
											  )){
				doTemp.setVisible("PdgSum,PdgRatio",false);
				doTemp.setRequired("PdgSum,PdgRatio",false);							
			}
			*/
			if(sBusinessType.startsWith("30"))//综合授信额度
				doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);//BusinessRate,BaseRate,RateFloatType,RateFloat
				doTemp.setRequired("BailSum,BailRatio,PdgRatio,PdgSum",false);
		}
	}

	doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
	
	//有信用评估的时候才显示等
	doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
	if(("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") 
		&& sObjectType.equals("CreditApply"))
	{
		doTemp.setReadOnly("SystemScore,SystemResult,CognResult",true);
		if(!(sBusinessType.equals("1056") || sBusinessType.equals("1054")) && !sSmallEntFlag.equals("1") && !sCustomerType.startsWith("03"))
			doTemp.setRequired("CognScore,CognResult,SystemScore,SystemResult",true);
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",true);
		//人工认定分数
		doTemp.setHTMLStyle("CognScore","	onChange=\"javascript:parent.setResult()\"	");
		doTemp.setAlign("SystemScore,CognScore","3");
		doTemp.setType("SystemScore,CognScore","Number");
	}

	//同业额度时，只显示授信额度及期限等 2009-12-23 lpzhang
	if(sBusinessType.equals("3015"))
	{
		doTemp.setVisible("SystemScore,CognScore,SystemResult,CognResult",false);
		doTemp.setReadOnly("RateFloatType",false);
	}
	
	//个人综合授信/公司综合授信额度，不显示 2010/06/22 xhyong
	if(sBusinessType.equals("3040")||sBusinessType.equals("3060")||sBusinessType.equals("3010"))
	{
		doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
		doTemp.setRequired("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
	}
	//针对保函业务手续费金额为可修改
	if(sBusinessType.startsWith("2030")||sBusinessType.startsWith("2040"))
	{
		doTemp.setReadOnly("PdgSum",false);
	}else{
		doTemp.setReadOnly("PdgSum",true);
	}
	doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//设置不可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//设置下拉框内容
	doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	doTemp.setDDDWCode("PhaseChoice","PhaseChoice");
	//编辑形式为备注栏
	doTemp.setEditStyle("PhaseOpinion","3");
	//设置意见
	doTemp.setRequired("PhaseChoice",true);
	//设置字段格式
	doTemp.setType("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","Number");
	doTemp.setCheckFormat("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","2");
	doTemp.setAlign("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","3");	
	
	doTemp.setType("TermMonth,TermDay","Number");
	doTemp.setCheckFormat("TermMonth,TermDay","5");
	doTemp.setAlign("TermMonth,TermDay","3");
	//设置html格式
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:30%;overflow:scroll;font-size:9pt;} ");
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"基准年利率必须大于等于0,小于等于100！\" ");
	//doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"利率浮动值必须大于等于0,小于等于100！\" ");
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");	
	doTemp.setReadOnly("BailSum",true);
	//设置显示小数位数为6位
	doTemp.setCheckFormat("BusinessRate","16");
	//自动获取利率类型和利率值
	if(!sBusinessType.startsWith("3")){
		doTemp.appendHTMLStyle("TermMonth,TermDay","onBlur=\"javascript:parent.getBaseRateType()\" ");
	}
	if((sFlowNo.equals("EntCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1) || (sFlowNo.equals("IndCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1))
	{
		doTemp.setReadOnly("PhaseChoice",true);
	}
	
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
			{"false","","Button","获取信用评级","获取信用评级","getEvaluate()",sResourcesPath},
			{"false","","Button","意见汇总","意见汇总","OpinionSummary()",sResourcesPath},
		};

	if( ("3015,3050,3060").indexOf(sBusinessType) == -1 && !sApplyType.equals("DependentApply") && 
		sObjectType.equals("CreditApply"))
		{
			sButtons[2][0] = "true";
		}
	
	if((sFlowNo.equals("EntCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1) || (sFlowNo.equals("IndCreditFlowTJ01")&&("0050,0170,0300").indexOf(sPhaseNo)>-1))
	{
		sButtons[3][0] = "true";
	}
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language="javascript">
	var iCount = 0;
	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		//支行审批小组组长、区县合行贷审会主任、市合行贷审会主任才进入此检查。lpzhang
		sPhaseNo = "<%=sPhaseNo%>";
		sFlowNo = "<%=sFlowNo%>";
		
		if((sFlowNo == "CreditFlow03" && sPhaseNo =="0270") || 
		   (sFlowNo == "EntCreditFlowTJ01" || sFlowNo == "IndCreditFlowTJ01")&& (sPhaseNo =="0050" || sPhaseNo =="0170" || sPhaseNo =="0300"))
		{
			if (!ValidityCheck()) return;
		}
		//董事长/理事长、市合行行长才进入此检查！
		/*
		if((sFlowNo == "EntCreditFlowTJ01" || sFlowNo == "IndCreditFlowTJ01")&& (sPhaseNo =="0060" || sPhaseNo =="0180" || sPhaseNo =="0310")){
			if(!ValidityCheck1()) return;
		}
		*/
		//审批金额，审批期限不能为0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		iTermDay = getItemValue(0,getRow(),"TermDay");
		sBusinessType ="<%=sBusinessType%>";
		if(sBusinessType!="2050020" && sBusinessType !="2050030" && sBusinessType!="2050010"  && sBusinessType.substring(0,4)!="2030" && sBusinessType.substring(0,4)!="2040" )
		{
			if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000")
			{
				if(dBusinessSum<=0 || iTermMonth+iTermDay<=0)
				{
					alert(getBusinessMessage('679'));//审批金额，审批期限不能为0！
					//alert("审批期限和审批金额必须大于0！");
					return;
				}
			}
		}
		
		var sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			var sTaskNo = "<%=sSerialNo%>";
			var sReturn = RunMethod("WorkFlowEngine","CheckOpinionInfo",sTaskNo);
			if(!(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null" || sReturn == "null" || sReturn == "NULL")){
				alert("此笔业务已签署意见，请刷新页面再签署意见！");
				return;
			}
			initOpinionNo();
		}
		
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
	}
	//检查审查小组或者贷审会成员是否都提交意见
	function ValidityCheck()
	{
		sSerialNo = "<%=sSerialNo%>";
		sPhaseNo = "<%=sPhaseNo%>";
		sObjectType = "<%=sObjectType%>";
		sObjectNo = "<%=sObjectNo%>";
		sPhaseChoice = getItemValue(0,getRow(),"PhaseChoice");
		
		sNoSubmitUser=RunMethod("WorkFlowEngine","GetNoTaskSubmit",sSerialNo+","+sObjectType+","+sObjectNo);
	
		if(typeof(sNoSubmitUser)!="undefined" && sNoSubmitUser.length!=0) {
			sNoSubmitUser = sNoSubmitUser.substr(1,sNoSubmitUser.length);
			alert("对不起，该审批业务还有小组成员【"+sNoSubmitUser+"】未提交，您不能签署意见！");
			return false;
		}
		//取得上阶段号
		sSuperPhaseNo = RunMethod("WorkFlowEngine","GetSuperPhaseNo",sPhaseNo+","+sObjectType+","+sObjectNo);
		//上阶段同意数量
		dAgreeNum=RunMethod("WorkFlowEngine","GetAgreeNum",sSuperPhaseNo+","+sObjectType+","+sObjectNo);
		//上阶段分发总数
		dDispenseTotalNum=RunMethod("WorkFlowEngine","GetDispenseTotalNum",sSuperPhaseNo+","+sObjectType+","+sObjectNo);
		if(parseFloat(dAgreeNum)/parseFloat(dDispenseTotalNum) < 2/3) {  //不同意
			if(sPhaseChoice == "01")
			{
				alert("审批成员不同意此笔业务申请，您不能签署“同意”！");
				getASObject(0,0,"PhaseChoice").focus();
				return false;
			}
		}
		return true;
	}
	/*~[Describe=意见汇总;InputParam=无;OutPutParam=无;]~*/
	function OpinionSummary()
	{
		sFlowNo="<%=sFlowNo%>";
		sPhaseNo="<%=sPhaseNo%>";
		sObjectNo = "<%=sObjectNo%>";
		sCompID = "OpinionSummaryList";
		sCompURL = "/Common/WorkFlow/OpinionSummaryList.jsp";
		sReturn = popComp(sCompID,sCompURL,"FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
			if(sReturn=="不同意")
			{	
				setItemValue(0,getRow(),"PhaseChoice","02");
				setItemDisabled(0,0,"PhaseChoice",true);
      			getASObject(0,0,"PhaseChoice").style.background ="#efefef";
			}else if(sReturn=="同意"){
				setItemValue(0,getRow(),"PhaseChoice","01");
      			setItemDisabled(0,0,"PhaseChoice",false);
	  		    getASObject(0,0,"PhaseChoice").style.background ="WHITE";
			}
			
		}
	}
	
	//董事长/理事长、市合行行长 检查前一阶段的意见
	function ValidityCheck1(){
		sPhaseChoice = getItemValue(0,getRow(),"PhaseChoice");
		sPhaseNo = "<%=sPhaseNo%>";
		sObjectType = "<%=sObjectType%>";
		sObjectNo = "<%=sObjectNo%>";
		sReturn = RunMethod("WorkFlowEngine","GetAgreement",sPhaseNo+","+sObjectType+","+sObjectNo);
		if(sPhaseChoice == "01" && sReturn !="01"){
			alert("信审会不同意此笔业务申请，您不能签署“同意”！");
			getASObject(0,0,"PhaseChoice").focus();
			return false;
		}
		return true;
	}
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
	 	{
	   		alert(getHtmlMessage("您还没有签署意见，不能做删除意见操作！"));
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
		}
		reloadSelf();
	} 
	
	/*~[Describe=获取信用评价信息;InputParam=无;OutPutParam=无;]~*/
    function getEvaluate()
    {
    	EvaluateResult = PopPage("/Common/WorkFlow/getEvaluateResult.jsp?rand="+randomNumber()+"&CustomerID=<%=sCustomerID%>","","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
    	
    	if(typeof(EvaluateResult) == "undefined" || EvaluateResult == "")
	 	{
	   		alert("该客户没有任何信用等级评估记录，请先进行信用等级评估！");
	   		return;
	 	}else
	 	{
	    	EvaluateResultMember = EvaluateResult.split('@');
			dEvaluateScore = EvaluateResultMember[0];
			sEvaluateResult = EvaluateResultMember[1];
			dCognScore = EvaluateResultMember[2];
			sCognResult = EvaluateResultMember[3];
	   
	 		setItemValue(0,getRow(),"SystemScore",roundOff(dEvaluateScore,2));
	 		setItemValue(0,getRow(),"SystemResult",sEvaluateResult);
	 		setItemValue(0,getRow(),"CognScore",roundOff(dCognScore,2));
	 		setItemValue(0,getRow(),"CognResult",sCognResult);
	 	}
	 	
	} 
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="2050030") || !(sBusinessType=="2020"))
	        alert("“零”天数必须大于等于0,小于等于30！");
	    }
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
		var sOpinionNo ="";						
		//使用GetSerialNo.jsp来抢占一个流水号
		sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if((typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0 || sOpinionNo== 'Null' || sOpinionNo== 'null') )
		{
			alert("请降低IE浏览器安全设置！");
			return;
		}
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sOpinionNo);
	}
	
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
			setItemValue(0,getRow(),"BusinessSum","<%=sBusinessSum%>");
			setItemValue(0,getRow(),"TermMonth","<%=iTermMonth%>");
			setItemValue(0,getRow(),"TermDay","<%=iTermDay%>");
			setItemValue(0,getRow(),"BaseRate","<%=DataConvert.toMoney(dBaseRate)%>");
			setItemValue(0,getRow(),"RateFloatType","<%=sRateFloatType%>");
			setItemValue(0,getRow(),"RateFloat","<%=DataConvert.toMoney(dRateFloat)%>");
			setItemValue(0,getRow(),"BusinessRate","<%=dBusinessRate%>");
			setItemValue(0,getRow(),"BailCurrency","<%=sBailCurrency%>");
			setItemValue(0,getRow(),"BailRatio","<%=dBailRatio%>");
			setItemValue(0,getRow(),"BailSum","<%=sBailSum%>");
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=sPdgSum%>");
			
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
		}        
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{
		if("<%=sObjectType%>" == "ReinforceContract")
		{
			return;
		}
	
		//业务类型
		sBusinessType = "<%=sBusinessType%>";
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 )
		{			
			if(sRateFloatType=="0")	//浮动百分比
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //执行月利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:浮动点数
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //执行月利率
					dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
			}
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
		}
		if(sBusinessType == "1020010" || sBusinessType == "1020020")
		{
			dBusinessRate = parseFloat(dBaseRate)/1.2;
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);
		}
	}
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum"); //获取申请金额
	    if(parseFloat(dBusinessSum) >= 0)
	    {
			dPdgRatio = getItemValue(0,getRow(),"PdgRatio");//获取手续费比例
	    	if(parseFloat(dPdgRatio) >= 0)
	    	{
	    		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");		
	    		sFeeCurrency = getItemValue(0,getRow(),"FeeCurrency");
	    		if(typeof(sFeeCurrency) == "undefined" || sFeeCurrency == "" ){
		        	sFeeCurrency = "01";
		        }
	        	dErateRatio =  RunMethod("BusinessManage","getErateRatio",sBusinessCurrency+","+sFeeCurrency+",''");
		    	dPdgRatio = roundOff(dPdgRatio,2);
			    dPdgSum = (parseFloat(dBusinessSum)*dErateRatio)*parseFloat(dPdgRatio)/1000;
			    dPdgSum = roundOff(dPdgSum,2);
			    if(dPdgSum<300 && ("<%=sBusinessType%>" == "2050030" || "<%=sBusinessType%>" == "2050010"))
					dPdgSum = 300.00;	
			    setItemValue(0,getRow(),"PdgSum",dPdgSum);
			}
		}
	}
	
	/*~[Describe=根据分值换算评级结果;InputParam=无;OutPutParam=无;]~*/
	function setResult(){		
		//评估分值结果换算
		//需要根据具体情况进行调整
		var CognScore = getItemValue(0,getRow(),"CognScore");
		if(CognScore<0 || CognScore>100){
			alert("调整分请在0至100之间！");
			setItemValue(0,getRow(),"CognScore","");
			setItemValue(0,getRow(),"CognResult","");
			setItemFocus(0,getRow(),"CognScore");
			return;
		}
		sModelDescribe = "<%=sModelDescribe%>";
		if(typeof(sModelDescribe) != "undefined" && sModelDescribe != "") 
		{			
			var my_array = new Array();
			var str_array = new Array();
			my_array = sModelDescribe.split(",");
			for(var i=0;i<my_array.length;i++)
			{ 
				str_array = my_array[i].split("&");
				if(checkResult(str_array[0],str_array[1],CognScore))
				{
					result = str_array[2];
					setItemValue(0,getRow(),"CognResult",result);
					return;
				}
			}
			
		}else
		{
			alert("评估模板配置错误，请联系管理员！");
		}			

	}
	//计算信用等级评级测试结果
	function checkResult(sSign,dNum,dCognScore)
	{
		if(sSign == "=")
		{
			if(dCognScore == dNum)
				return true;
			else
				return false;
		}else if(sSign == ">")
		{
			if(dCognScore > dNum)
				return true;
			else
				return false;
		}else if(sSign == ">=")
		{
			if(dCognScore >= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<")
		{
			if(dCognScore < dNum)
				return true;
			else
				return false;
		}else if(sSign == "<=")
		{
			if(dCognScore <= dNum)
				return true;
			else
				return false;
		}else if(sSign == "<>")
		{
			if(dCognScore != dNum)
				return true;
			else
				return false;
		}else 
			return false;
		
	}
	
	function getBailPdgSum(){
		getpdgsum();
		getBailSum();
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType="<%=sBusinessType%>";
	    if(parseFloat(dBusinessSum) >= 0 && sBusinessType.substring(0,4)!="2040" && sBusinessType.substring(0,4)!="2030")
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
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
	        }
	    }	    
	}
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio()
	{
	  //  sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	  //  sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
	        }
	    }
	}
	
	//自动获取利率类型 
	function getBaseRateType(){
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		 sBaseRateID = "";
		 if(sBusinessCurrency=='01')//人民币
		 {
			 if("<%=sOccurType%>" == "015"){
			 	if(typeof(dTermDay) == "undefined" && dTermDay == "" ){
			 		dTermDay = 0;
			 	}
			 	dTermDay = dTermDay + <%=dOldTermDay%>;
			 	if(dTermDay/30 >1){
			 		dTermMonth = dTermMonth + 2;
			 	}
			 	else if(dTermDay>0){
			 		dTermMonth = dTermMonth + 1;
			 	}
			 	dTermMonth = dTermMonth + <%=dOldTermMonth%>;
			 }else if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
			 {
			 	dTermMonth = dTermMonth+1; 
			 }
			 if(dTermMonth <= 6){
			 	sBaseRateID = "10010";
			 }else if(dTermMonth > 6 && dTermMonth <= 12){
			 	sBaseRateID = "10020";
			 }else if(dTermMonth > 12 && dTermMonth <= 36){
			 	sBaseRateID = "10040";
			 }else if(dTermMonth > 36 && dTermMonth <= 60){
			 	sBaseRateID = "10050";
			 }else{
			 	sBaseRateID = "10030";
			 }
		 }else{//外币
		 	if(dTermDay < 7 && dTermMonth==0){
			 	sBaseRateID = "20010";//隔夜
			 }else if(dTermDay < 14 && dTermMonth==0){
			 	sBaseRateID = "20020";//一周
			 }else if(dTermMonth==0 ){
			 	sBaseRateID = "20030";//二周
			 }else if(dTermMonth <3){
			 	sBaseRateID = "20040";//一个月
			 }else if(dTermMonth <6){
			 	sBaseRateID = "20050";//三个月
			 }else if(dTermMonth <12){
			 	sBaseRateID = "20060";//六个月
			 }else{
			 	sBaseRateID = "20070";//十二个月
			 }
		 }
		 setItemValue(0,0,"BaseRateType",sBaseRateID);
		 
		 //sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
		 sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
	     if(typeof(sReturn) != "undefined" && sReturn != ""){
	     	setItemValue(0,0,"BaseRate",sReturn);
	     } 	    
		getBusinessRate("M");
	}	
	
	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	</script>
<%/*~END~*/%>


<script language=javascript>	
	AsOne.AsInit();
	init();
//bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>