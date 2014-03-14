<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
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
		History Log: zywei 2005/07/31 重检页面
		*/
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "签署意见";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "",sFlowNo = "",sPhaseNo = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sOccurType = "",sBusinessSum = "",sBusinessSubType = "",sInputOrgID="",sTasksFirstBatch="",sTotalSumFirstBatch="";
	double dBusinessSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0,dTotalSumFirstBatch=0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0 ,dPromisesFeeSum=0.0,dPromisesFeeRatio=0.0 ;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0,iTasksFirstBatch=0;
	ASResultSet rs = null;
	
	//获取组件参数：任务流水号、对象编号、对象类型
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
	<%
		//根据对象类型和对象编号获取流程号
		sSql = 	" select PhaseNo from FLOW_OBJECT "+
		" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		sPhaseNo = Sqlca.getString(sSql);
		if(sPhaseNo == null) sPhaseNo = "";
		
		sSql = "select BusinessSum from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"'";
		double dApplyBusinessSum = Sqlca.getDouble(sSql).doubleValue();
			
		//根据对象类型和对象编号获取相应的业务信息
		//--modified by wwhe 2009-09-07 for:展示上级审批金额	
		if(sPhaseNo.equals("3000")){
			sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum,PromisesFeeRatio,PromisesFeeSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,BusinessSubType,InputOrgID "+
			" TasksFirstBatch,TotalSumFirstBatch "+
			" from BUSINESS_APPLY "+
			" where SerialNo = '"+sObjectNo+"' ";
		}else{
			sSql = 	" select BA.CustomerID,BA.CustomerName,BA.BusinessCurrency,FO.BusinessSum,FO.PromisesFeeRatio,FO.PromisesFeeSum, "+
			" FO.BaseRate,FO.RateFloatType,FO.RateFloat,FO.BusinessRate,FO.BailCurrency, "+
			" FO.BailSum,FO.BailRatio,FO.PdgRatio,FO.PdgSum,BA.BusinessType,FO.TermYear, "+
			" FO.TermMonth,FO.TermDay,BA.OccurType,FO.TasksFirstBatch,FO.TotalSumFirstBatch,FO.BusinessSubType,BA.InputOrgID "+
			" from BUSINESS_APPLY BA,FLOW_OPINION FO "+
			" where BA.SerialNo = '"+sObjectNo+"' and FO.ObjectType='CreditApply' and BA.SerialNo = FO.ObjectNo order by FO.OpinionNo DESC";
		}
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
			dPromisesFeeSum = rs.getDouble("PromisesFeeSum");
			dPromisesFeeRatio = rs.getDouble("PromisesFeeRatio");
			dPdgRatio = rs.getDouble("PdgRatio");
			dPdgSum = rs.getDouble("PdgSum");
			sBusinessType = rs.getString("BusinessType");
			iTermYear = rs.getInt("TermYear");
			iTermMonth = rs.getInt("TermMonth");
			iTermDay = rs.getInt("TermDay");
			sOccurType = rs.getString("OccurType");
			sBusinessSubType = rs.getString("BusinessSubType");//--added by wwhe 2009-06-08
			sInputOrgID = rs.getString("InputOrgID");//--added by wwhe 2009-06-08
			iTasksFirstBatch = rs.getInt("TasksFirstBatch");// --added by ymwu 2012-02-27  首批项下业务笔数
			dTotalSumFirstBatch = rs.getDouble("TotalSumFirstBatch");//--added by ymwu 2012-02-27 首批最大额度
			//将空值转化为空字符串
			if(sCustomerID == null) sCustomerID = "";
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessCurrency == null) sBusinessCurrency = "";
			if(sRateFloatType == null) sRateFloatType = "";
			if(sBailCurrency == null) sBailCurrency = "";
			if(sBusinessType == null) sBusinessType = "";
			if(sOccurType == null) sOccurType = "";
			if(sBusinessSubType == null) sBusinessSubType = "";//--added by wwhe 2009-06-08
			if(sInputOrgID == null) sInputOrgID = "";//--added by wwhe 2009-06-08
			//转化金额的显示格式
			if(dBusinessSum > 0)
		sBusinessSum = DataConvert.toMoney(dBusinessSum);
			if(iTasksFirstBatch > 0)
		sTasksFirstBatch = DataConvert.toMoney(iTasksFirstBatch);
			if(dTotalSumFirstBatch > 0)
		sTotalSumFirstBatch = DataConvert.toMoney(dTotalSumFirstBatch);
		}
		rs.getStatement().close();
		
		String sHeaders[][]={                       
		                        {"CustomerID","客户编号"},
		                        {"CustomerName","客户名称"},
		                        {"BusinessCurrency","业务币种"},
		                        {"BusinessSum","批准金额(元)"},
		                        {"TermMonth","批准期限"},
		                        {"TermDay","零"},
		                        {"TasksFirstBatch","首次用款项下业务笔数"},
		                        {"TotalSumFirstBatch","首次用款项下业务总额度"},
		                        {"BaseRate","基准年利率(%)"},
		                        {"RateFloatType","利率浮动方式"},
		                        {"RateFloat","批准利率浮动值"},
		                        {"BusinessRate","批准执行年利率(%)"},
		                        {"BailCurrency","保证金币种"},
		                        {"BailSum","保证金金额"},
		                        {"BailRatio","保证金比例(%)"},	                        
		                        {"PromisesFeeRatio","承诺费率(%)"},	                        
		                        {"PromisesFeeSum","承诺费"},
		                        {"PdgRatio","手续费率(‰)"},
		                        {"PdgSum","手续费金额(元)"},
		                        {"PhaseOpinion","意见"},
		                        {"PhaseOpinion1","补充意见1"},
		                        {"PhaseOpinion2","补充意见2"},
		                        {"PhaseOpinion3","补充意见3"},
		                        {"InputOrgName","登记机构"}, 
		                        {"InputUserName","登记人"}, 
		                        {"InputTime","登记日期"},
		                        {"BusinessSubType","授信分类"}//--added by wwhe 2009-06-08
	                        };                    
		String sHeaders1[][]={                       
		                        {"CustomerID","客户编号"},
		                        {"CustomerName","客户名称"},
		                        {"BusinessCurrency","业务币种"},
		                        {"BusinessSum","批准金额(元)"},
		                        {"TermMonth","批准期限"},
		                        {"TermDay","零"},
		                        {"BaseRate","基准年利率(%)"},
		                        {"RateFloatType","利率浮动方式"},
		                        {"RateFloat","批准利率浮动值"},
		                        {"BusinessRate","批准执行年利率(%)"},
		                        {"BailCurrency","保证金币种"},
		                        {"BailSum","保证金金额"},
		                        {"BailRatio","保证金比例(%)"},
		                        {"PromisesFeeRatio","承诺费率(%)"},	                        
		                        {"PromisesFeeSum","承诺费"},
		                        {"PdgRatio","手续费率(‰)"},
		                        {"PdgSum","手续费金额(元)"},
		                        {"PhaseOpinion","意见"},
		                        {"PhaseOpinion1","补充意见1"},
		                        {"PhaseOpinion2","补充意见2"},
		                        {"PhaseOpinion3","补充意见3"},
		                        {"InputOrgName","登记机构"}, 
		                        {"InputUserName","登记人"}, 
		                        {"InputTime","登记日期"}                      
	                        }; 	
	    String sHeaders2[][]={                       
		                        {"CustomerID","客户编号"},
		                        {"CustomerName","客户名称"},
		                        {"BusinessCurrency","展期币种"},
		                        {"BusinessSum","批准展期金额(元)"},
		                        {"TermMonth","批准展期期限"},
		                        {"TermDay","零"},
		                        {"BaseRate","基准年利率(%)"},
		                        {"RateFloatType","利率浮动方式"},
		                        {"RateFloat","批准利率浮动值"},
		                        {"BusinessRate","批准展期执行年利率(%)"},
		                        {"BailCurrency","保证金币种"},
		                        {"BailSum","保证金金额(元)"},
		                        {"BailRatio","保证金比例(%)"},
		                        {"PromisesFeeRatio","承诺费率(%)"},	                        
		                        {"PromisesFeeSum","承诺费"},
		                        {"PdgRatio","手续费率(‰)"},
		                        {"PdgSum","手续费金额(元)"},
		                        {"PhaseOpinion","意见"},
		                        {"PhaseOpinion1","补充意见1"},
		                        {"PhaseOpinion2","补充意见2"},
		                        {"PhaseOpinion3","补充意见3"},
		                        {"InputOrgName","登记机构"}, 
		                        {"InputUserName","登记人"}, 
		                        {"InputTime","登记日期"}                      
	                        }; 	
	    String sHeaders3[][]={                       
		                        {"PhaseOpinion","意见"},
		                        {"InputOrgName","登记机构"}, 
		                        {"InputUserName","登记人"}, 
		                        {"InputTime","登记日期"}                      
	                        };  
		//定义SQL语句
		sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
		" CustomerName,BusinessSubType,BusinessCurrency,BusinessSum,TermYear,TermMonth, "+
		" TermDay,TasksFirstBatch,TotalSumFirstBatch,BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
		" BailSum,BailRatio,PromisesFeeRatio,PromisesFeeSum,PdgRatio,PdgSum,PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3,InputOrg, "+
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
		//业务品种为商业承兑汇票贴现、协议付息票据贴现、个人经营循环贷款、个人质押贷款、
		//个人保证贷款、个人抵押贷款、个人营运汽车贷款、个人消费汽车贷款、商业助学贷款、
		//国家助学贷款、银行承兑汇票贴现、个人住房装修贷款、个人付款保函、个人经营贷款、
		//个人抵押循环贷款、个人小额信用贷款、个人自助质押贷款、个人再交易商业用房贷款、
		//个人商业用房按贷款、个人再交易住房贷款、个人住房贷款、买入返售业务、个人委托贷款
		//是执行月利率
		if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
		 || sBusinessType.equals("1110080") || sBusinessType.equals("1110090")
		 || sBusinessType.equals("1110100") || sBusinessType.equals("1110110")
		 || sBusinessType.equals("1110120") || sBusinessType.equals("1110130")
		 || sBusinessType.equals("1110140") || sBusinessType.equals("1110150")
		 || sBusinessType.equals("1020010") || sBusinessType.equals("1110160")	 
		 || sBusinessType.equals("2110050") || sBusinessType.equals("1110170")
		 || sBusinessType.equals("1110070") || sBusinessType.equals("1110060")
		 || sBusinessType.equals("1110050") || sBusinessType.equals("1110040")
		 || sBusinessType.equals("1110030") || sBusinessType.equals("1110020")
		 || sBusinessType.equals("1110010") || sBusinessType.equals("2100")
		 || sBusinessType.equals("2110040"))
			doTemp.setHeader(sHeaders1); 
		else //反之执行年利率
			doTemp.setHeader(sHeaders); 
			}
		}
		
		//对表进行更新、插入、删除操作时需要定义表对象、主键   
		doTemp.UpdateTable = "FLOW_OPINION";
		doTemp.setKey("SerialNo,OpinionNo",true);		
		doTemp.setUnit("TermMonth","月");
		doTemp.setUnit("TermDay","天"); 
		doTemp.setVisible("BusinessSubType,TasksFirstBatch,TotalSumFirstBatch",false);
		
		//设置字段是否可见和必输项	
		if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //申请初始阶段和发回补充资料阶段
		{
			doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("PhaseOpinion",true);
		}else
		{
			if(sOccurType.equals("015"))//发生类型为展期
			{
		doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PhaseOpinion",true);
		doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
			}else
			{
		//业务品种为个人付款保函、发行债券转贷款、个人委托贷款、国家外汇储备转贷款、其他转贷款、
		//转贷国际金融组织贷款、转贷买方信贷、转贷外国政府贷款
		if(sBusinessType.equals("2110050") || sBusinessType.equals("2060050")
		 || sBusinessType.equals("2110040") || sBusinessType.equals("2060030")
		 || sBusinessType.equals("2060060") || sBusinessType.equals("2060020")
		 || sBusinessType.equals("2060040") || sBusinessType.equals("2060010"))  
		{
			doTemp.setVisible("BailSum,BailRatio,,PromisesFeeRatio,PromisesFeeSum",false);	
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PdgRatio,PdgSum,PhaseOpinion",true);
			if(sBusinessType.equals("2110050") || sBusinessType.equals("2110040"))
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			else
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");	
		}
		//业务品种为备用信用证、补偿贸易保函（融资类）、补偿贸易保函（非融资类）、承包工程保函
		//贷款承诺函、贷款担保、贷款意向书、对外保函、付款保函、关税保付保函、国内信用证、
		//海事保函、加工装配业务进口保函、借款偿还保函、进口信用证、留置金保函、履约保函、
		//其他非融资性保函、其他融资性保函、诉讼保函、提货担保、投标保函、透支归还保函、
		//银行承兑汇票、银行信贷证明、有价证券发行担保、预付款保函、质量维修保函、租金偿还保函
		else if(sBusinessType.equals("2050020") || sBusinessType.equals("2030050")
		 || sBusinessType.equals("2040070") || sBusinessType.equals("2040040")
		 || sBusinessType.equals("2080010") || sBusinessType.equals("2090010")
		 || sBusinessType.equals("2080020") || sBusinessType.equals("2050040")
		 || sBusinessType.equals("2030060") || sBusinessType.equals("2030040")
		 || sBusinessType.equals("2020") || sBusinessType.equals("2040060")
		 || sBusinessType.equals("2040100") || sBusinessType.equals("2030010")	 
		 || sBusinessType.equals("2050030") || sBusinessType.equals("2040090")
		 || sBusinessType.equals("2040020") || sBusinessType.equals("2040110")
		 || sBusinessType.equals("2030070") || sBusinessType.equals("2040080")
		 || sBusinessType.equals("2050010") || sBusinessType.equals("2040010")	 
		 || sBusinessType.equals("2030030") || sBusinessType.equals("2010")
		 || sBusinessType.equals("2080030") || sBusinessType.equals("2090020")
		 || sBusinessType.equals("2040030") || sBusinessType.equals("2040050")
		 || sBusinessType.equals("2030020"))  
		{
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion,PromisesFeeRatio,PromisesFeeSum",true);	
			doTemp.setHTMLStyle("BusinessSum"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}
		//业务品种为个贷其它合作商、个人房屋贷款合作项目、汽车消费贷款合作经销商	
		else if(sBusinessType.equals("3030030") || sBusinessType.equals("3030010")
		 || sBusinessType.equals("3030020")) 
		{
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}	
		//业务品种为个人经营贷款、国家助学贷款、商业助学贷款
		else if(sBusinessType.equals("1110170") || sBusinessType.equals("1110150")
		 || sBusinessType.equals("1110140"))
		{
			doTemp.setVisible("PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}	
		else if(sBusinessType.equals("2110010"))  //业务品种为个人住房公积金贷款
		{
			doTemp.setVisible("RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);	
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,BailSum,BailRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}
		else if(sBusinessType.equals("1090010") || sBusinessType.equals("2070"))  //业务品种为国内保理、委托贷款
		{
			doTemp.setVisible("BailSum,BailRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,PdgRatio,PhaseOpinion",true);	
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
		}
		else //反之
		{
			if(sBusinessType.equals("3010")){//综合授信额度
				doTemp.setVisible("BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,BaseRate,RateFloatType,RateFloat,PromisesFeeRatio,PromisesFeeSum",false);
				//--added by wwhe 2009-06-08 for:授信分类展示
				doTemp.setVisible("BusinessSubType,TasksFirstBatch,TotalSumFirstBatch",true);
				doTemp.setRequired("TasksFirstBatch,TotalSumFirstBatch",true);
				doTemp.setDDDWCode("BusinessSubType","CreditLineType");
			}else{
				doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum",false);
			}
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,TermDay,PhaseOpinion",true);
			//业务品种为商业承兑汇票贴现、协议付息票据贴现、银行承兑汇票贴现、买入返售业务、
			//个人住房贷款、个人再交易住房贷款、个人商业用房按贷款、个人再交易商业用房贷款、
			//个人自助质押贷款、个人小额信用贷款、个人抵押循环贷款、个人经营循环贷款、
			//个人质押贷款、个人保证贷款、个人抵押贷款、个人营运汽车贷款、个人消费汽车贷款
			//个人住房装修贷款是执行月利率
			if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
			 || sBusinessType.equals("1020010")	|| sBusinessType.equals("2100")
			 || sBusinessType.equals("1110010") || sBusinessType.equals("1110020")
			 || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")
			 || sBusinessType.equals("1110050") || sBusinessType.equals("1110060")
			 || sBusinessType.equals("1110070") || sBusinessType.equals("1110080")
			 || sBusinessType.equals("1110090") || sBusinessType.equals("1110100") 
			 || sBusinessType.equals("1110110") || sBusinessType.equals("1110120") 
			 || sBusinessType.equals("1110130") || sBusinessType.equals("1110160"))
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			else//反之执行年利率
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}	
		// added bllou 2011-12-23 国际贸易融资类不显示承诺比率及费用
		if("2050".equals(sBusinessType.substring(0,4)))  
		{
			doTemp.setVisible("PromisesFeeRatio,PromisesFeeSum",false);
			doTemp.setRequired("PromisesFeeRatio,PromisesFeeSum",false);
		}
			}
		}
		
		doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
		//设置不可更新字段
		doTemp.setUpdateable("InputOrgName,InputUserName",false);
		//设置下拉框内容
		doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
		doTemp.setDDDWCode("RateFloatType","RateFloatType");
		//设置只读属性
		doTemp.setReadOnly("CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime,PdgSum",true);
		//编辑形式为备注栏
		doTemp.setEditStyle("PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3","3");
		//设置字段格式
		doTemp.setType("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,PromisesFeeRatio,PromisesFeeSum,TasksFirstBatch,TotalSumFirstBatch","Number");
		doTemp.setCheckFormat("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,TotalSumFirstBatch","2");
		doTemp.setAlign("BusinessSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,TasksFirstBatch,TotalSumFirstBatch","3");	
		doTemp.setType("TermMonth,TermDay","Number");
		doTemp.setCheckFormat("TermMonth,TermDay,TasksFirstBatch","5");
		doTemp.setAlign("TermMonth,TermDay","3");
		//设置html格式
		doTemp.setHTMLStyle("PhaseOpinion,PhaseOpinion1,PhaseOpinion2,PhaseOpinion3"," style={height:100px;width:30%;overflow:scroll;font-size:9pt;} ");
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
		doTemp.appendHTMLStyle("PromisesFeeRatio","onchange=parent.getPromisesFreeRatio()");
		doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"基准年利率必须大于等于0,小于等于100！\" ");
		//doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"利率浮动值必须大于等于0,小于等于100！\" ");
		doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");
		//--added by wwhe 2010-01-20 for:根据期限自动获取基准利率
		if(!sBusinessType.startsWith("2")){
			doTemp.appendHTMLStyle("TermMonth", " onBlur=\"javascript:parent.getApplyRate()\" ");
		}
		doTemp.setReadOnly("BailSum,BusinessCurrency,PromisesFeeSum",true);
		//设置字段展示位数 added by wwhe 2009-05-04
		doTemp.setCheckFormat("BaseRate,BusinessRate","16");//--保留小数点后6位
		//生成ASDataWindow对象		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
		dwTemp.Style="2";//freeform形式
		
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
		{"false","","Button","额度分配查看/调整","额度分配查看/调整","reDistribute()",sResourcesPath}
			};
		
		if(sBusinessType.equals("3010")){
			sButtons[2][0] = "true";
		}
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language="javascript">

	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		//利率浮动方式
		var sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		var sRateFloat = getItemValue(0,getRow(),"RateFloat");
		
		if("<%=sInputOrgID%>"=='02'&& ((sRateFloatType=="0" && sRateFloat<50) || (sRateFloatType=="1" && sRateFloat<0.5)))
		{
			alert("中小企业金融服务中心的浮动利率必须大于50%");
		}
	
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//审批金额，审批期限不能为0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		iTermDay = getItemValue(0,getRow(),"TermDay");
		
		if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000"&&"<%=sBusinessType.startsWith("1020")%>"=="false"&&"<%=sBusinessType.startsWith("1130")%>"=="false")//--modified by wwhe 2009-05-04 for：贴现业务不校验
		{
			if(dBusinessSum<=0 || (iTermMonth<0 && iTermDay<0))
			{
				alert(getBusinessMessage('679'));//审批金额，审批期限不能为0！
				//alert("审批期限和审批金额必须大于0！");
				return;
			}
		}
		
		//--added by wwhe 2009-09-08 for:授信额度分配可用额度金额=批复金额校验
		if(!CheckCLSum())
			return;
		
		//--added by wwhe 2009-09-17 for：审批信息与申请信息校验
		if(parseFloat(dBusinessSum)>"<%=dApplyBusinessSum%>"){
			alert("审批金额不能大于申请金额");
			return false;
		}
		
		//--added by wwhe 2010-01-12 for:承兑汇票期限不能大于6个月
		if("<%=sBusinessType.startsWith("2010")%>"=="true"){
			if(parseFloat(iTermMonth)>6){
				alert("承兑汇票期限不能大于6个月");
				return false;
			}
		}
		
		
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0");
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
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="2050030") || !(sBusinessType=="2020"))
	        alert("“零”天数必须大于等于0,小于等于30！");
	        return false;
	    }
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
								
		//使用GetSerialNo.jsp来抢占一个流水号
		var sOpinionNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
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
			setItemValue(0,getRow(),"BailSum",parseFloat("<%=dBailSum%>"));
			setItemValue(0,getRow(),"PromisesFeeSum","<%=dPromisesFeeSum%>");
			setItemValue(0,getRow(),"PromisesFeeRatio",parseFloat("<%=dPromisesFeeRatio%>"));
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=dPdgSum%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.OrgID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"BusinessSubType","<%=sBusinessSubType%>");//--added by wwhe 2009-06-08 for:展示额度类型字段
			setItemValue(0,getRow(),"TasksFirstBatch","<%=sTasksFirstBatch%>");
			setItemValue(0,getRow(),"TotalSumFirstBatch","<%=sTotalSumFirstBatch%>");
			
		}        
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{		
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");		
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" )
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
	}
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
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
	
	/*~[Describe=根据敞口和承诺费比例计算承诺费金额;InputParam=无;OutPutParam=无;]~*/
	function getPromisesFreeRatio()
	{
	
		dBailSum = getItemValue(0,getRow(),"BailSum");
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBailSum) >= 0){
			dCKBalance = dBusinessSum - dBailSum ; 
		}
		
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPromisesFeeRatio = getItemValue(0,getRow(),"PromisesFeeRatio");
	        dPromisesFeeRatio = roundOff(dPromisesFeeRatio,2);
	        if(parseFloat(dPromisesFeeRatio) >= 0)
	        {	        
	            dPromisesFeeSum = parseFloat(dCKBalance)*parseFloat(dPromisesFeeRatio)/100;
	            dPromisesFeeSum = roundOff(dPromisesFeeSum,2);
	            setItemValue(0,getRow(),"PromisesFeeSum",dPromisesFeeSum);
	        }
	    }
	}
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
		/*默认与当前币种一样
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	    getPromisesFreeRatio();
	    getpdgsum();
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
	
	/*~[Describe=额度重新分配   added by wwhe  2009-09-08;InputParam=无;OutPutParam=无;]~*/
	function reDistribute()
	{
		sParentLineID = RunMethod("CreditLine","GetLineIDByApplyNo","<%=sObjectNo%>");
		OpenComp("SubCreditLineList","/CreditManage/CreditLine/SubCreditLineList.jsp","ParentLineID="+sParentLineID+"&ToInheritObj=y&IsOpinion=y","_blank");
	}
	
	//授信额度分配可用额度金额=批复金额    added by wwhe  2009-09-08
	function CheckCLSum(){
		if("<%=sBusinessType%>" == "3010"){
			sObjectNo = getItemValue(0,getRow(),"ObjectNo");
			fUsableSum=RunMethod("BusinessManage","GetUsableSum","<%=sObjectNo%>");
			sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			if(fUsableSum != sBusinessSum){
				alert("批复金额和授信额度分配可用额度金额不等！请重新分配授信额度！");
				return false;
			}
		}
		return true;
	}
	//--added by wwhe 2010-01-20 for:利率自动测算
	function getApplyRate()
	{
		var sRateType = getItemValue(0, getRow(), "RateType");
		if(sRateType != "010"){
			//只对业务币种是人民币的进行处理
		    var sBusinessCurrency = getItemValue(0, getRow(), "BusinessCurrency");
		    if (sBusinessCurrency != "01")
		        return;
	
		    sTermMonth = getItemValue(0, getRow(), "TermMonth");
		    sBusinessType = getItemValue(0,getRow(),"BusinessType");//--业务品种
		    if(sTermMonth<=0)
		    {
		    	alert("期限月应大于0");
		    	return;
		    }
		    if (typeof(sTermMonth) == "undefined" || sTermMonth.length == 0) sTermMonth = 0;
		    sTerm = sTermMonth;
		    if (sTerm > 0) {
		    	var sType = "dialogWidth=20;dialogHeight=15;center:yes;status:no;statusbar:no";
		    	sRate = PopPage("/CreditManage/CreditApply/GetApplyRate.jsp?Term=" + sTerm + "&RateType=010&rand=" + randomNumber(), "", sType);
				if (typeof(sRate) == "undefined" || sRate.length == 0 || sRate == "null")
		            setItemValue(0, getRow(), "BaseRate", "");
		        sPrintRate = sRate;
		        if (sPrintRate == null || sPrintRate == "")
		            sPrintRate = 0;
		        sPrintRate = roundOff(sPrintRate,6);
		        setItemValue(0, getRow(), "BaseRate", sPrintRate);
		        var sRateFloat = getItemValue(0, getRow(), "RateFloat");
		        if (isNaN(sRateFloat) || sRateFloat == "" || typeof(sRateFloat) == "undefined" || sRateFloat == null) {
		            setItemValue(0, getRow(), "BusinessRate", "");
		            setItemValue(0, getRow(), "FineBaseRate", "");
		        }else
		            getBusinessRate('Y');
			}
		}
	}
	
	</script>
<%
	/*~END~*/
%>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>