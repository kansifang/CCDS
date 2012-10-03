<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004/12/7
		Tester:
		Content: 出帐详情
		Input Param:
		Output param:
		History Log:  fXie 2005-03-13   增加校验关系、账号查询
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出账详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得组件参数：对象类型和对象编号
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//定义变量：SQL语句、出帐业务品种、出帐显示模版、对象主表、暂存标志
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "",sTempSaveFlag="";
	//定义变量：发生类型、合同起始日、合同到期日、合同业务品种、合同利率调整方式
	String sBCOccurType = "",sBCPutOutDate = "",sBCMaturity = "",sBCBusinessType = "",sBCAdjustRateType = "";
	//定义变量：合同金额
	double dBCBusinessSum = 0.0;	
	//定义变量：查询结果集
	ASResultSet rs = null;
	

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType = '"+sObjectType+"' ";
	sMainTable = Sqlca.getString(sSql);	
	
	//获取出帐业务品种
	sSql = 	" select BusinessType from "+sMainTable+" "+
			" where SerialNo ='"+sObjectNo+"' ";
	sBusinessType = Sqlca.getString(sSql);	
	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//获取该出帐信息的发生类型
	sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.AdjustRateType "+
			" from BUSINESS_CONTRACT BC "+
			" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
			" where BP.SerialNo = '"+sObjectNo+"' "+
			" and BP.ContractSerialNo = BC.SerialNo) ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sBCOccurType = rs.getString("OccurType");
		sBCPutOutDate = rs.getString("PutOutDate");
		sBCMaturity = rs.getString("Maturity");
		sBCBusinessType = rs.getString("BusinessType");
		dBCBusinessSum = rs.getDouble("BusinessSum");
		sBCAdjustRateType = rs.getString("AdjustRateType");
		//将空值转化为空字符串
		if(sBCOccurType == null) sBCOccurType = "";
		if(sBCPutOutDate == null) sBCPutOutDate = "";
		if(sBCMaturity == null) sBCMaturity = "";
		if(sBCBusinessType == null) sBCBusinessType = "";
		if(sBCAdjustRateType == null) sBCAdjustRateType = "";
	}
	rs.getStatement().close();
	
	if(sBCOccurType.equals("015")) //展期
		sDisplayTemplet = "PutOutInfo0";
	else
	{
		//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
		sSql = " select DisplayTemplet from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' ";
		sDisplayTemplet = Sqlca.getString(sSql);
		if(sDisplayTemplet==null)sDisplayTemplet="";
	}
	
	//从出账表获得暂存标志
	sSql = "select TempSaveFlag from " + sMainTable + " where SerialNo='" + sObjectNo + "'";
	sTempSaveFlag = Sqlca.getString(sSql);
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = sMainTable;
	doTemp.setKey("SerialNo",true);
	
	//当业务品种为银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现，不能修改票面金额
	if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030"))
	{
		doTemp.setReadOnly("BusinessSum",true);
	}
	
	//当业务品种为表外业务时，不显示支付方式 add by bqliu 2011-05-19
	if(sBusinessType.startsWith("2"))
	{
		doTemp.setRequired("SelfPayMethod",false);
		doTemp.setVisible("SelfPayMethod",false);
	}
	
	//设置格式,后面小数点4位
	doTemp.setCheckFormat("RateFloat,BackRate,RiskRate","14");
	//设置利率格式,后面小数点6位
	doTemp.setCheckFormat("BaseRate,BusinessRate,OverdueRate,TARate","16");
	
	//设置固定周期输入范围
	if(sDisplayTemplet.equals("PutOutInfo1") || sDisplayTemplet.equals("PutOutInfo2") || sDisplayTemplet.equals("PutOutInfo3") || sDisplayTemplet.equals("PutOutInfo8")){
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=2 && parseFloat(myobj.value,10)<=12 \" mymsg=\"固定周期输入范围为[2,12]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo9")){
		doTemp.appendHTMLStyle("CDate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=31 \" mymsg=\"扣款日输入范围为[0,31]\" ");
	}
	if(sDisplayTemplet.equals("PutOutInfo11")||sDisplayTemplet.equals("PutOutInfo12"))
	{
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
	}
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
	
	if("2050010".equals(sBusinessType) || "2050020".equals(sBusinessType) || "2050030".equals(sBusinessType) || "2050040".equals(sBusinessType)){
		doTemp.setRequired("BusinessRate,ICCyc,CorpusPayMethod",false);
		doTemp.setVisible("BusinessRate,ICCyc,CorpusPayMethod",false);
	}
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
			{"true","","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
		};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(vI_all("myiframe0")){
			if("2110020" != "<%=sBusinessType%>" )
			{
			//录入数据有效性检查
			if (!ValidityCheck()) return;
			}
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			sOccurType = "<%=sBCOccurType%>";
			sBCAdjustRateType = "<%=sBCAdjustRateType%>";//利率调整方式
			if(sOccurType != "015" && sBCAdjustRateType != "1")
			{
				getNewBaseRate();
			}
			if("PutOutInfo5" == "<%=sDisplayTemplet%>" || "PutOutInfo14" == "<%=sDisplayTemplet%>" || "PutOutInfo15" == "<%=sDisplayTemplet%>" )
			{
			    setBailRatio();//根据出账模板使用 计算保证金比例
			}
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）			
			as_save("myiframe0");
		}
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp()
	{
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来		
	}		
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//发生类型
		sOccurType = "<%=sBCOccurType%>";
		//出帐起始日
		sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
		//出帐到期日
		sMaturity = getItemValue(0,getRow(),"Maturity");	
		//业务品种
		sBusinessType = getItemValue(0,getRow(),"BusinessType");	
		//结息方式
		sICCyc = getItemValue(0,getRow(),"ICCyc");	
		//客户编号
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sSmallEntFlag = RunMethod("BusinessManage","GetSmallEntFlag","CustomerID,"+sCustomerID);
		if(typeof(sSmallEntFlag) != "undefined" && sSmallEntFlag != "" && sSmallEntFlag != null && "NULL" != sSmallEntFlag){
			if(sSmallEntFlag == "1" &&(sICCyc !="102" || sICCyc !="103")){
				alert("微小企业贷款结息周期必需为按月结息或按季结息！");
				return;
			}
		}

		if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
		&& typeof(sMaturity) != "undefined" && sMaturity != "")
		{
			
			if(sMaturity < sPutOutDate)
			{
				if(sOccurType == "015") //展期业务
				{
					alert(getBusinessMessage('578'));//展期到期日必须晚于展期起始日！
					return false;
				}else
				{
					if(sBusinessType == '2030010' || sBusinessType == '2030020'
					|| sBusinessType == '2030030' || sBusinessType == '2030040'
					|| sBusinessType == '2030050' || sBusinessType == '2030060'
					|| sBusinessType == '2030070' || sBusinessType == '2040010'
					|| sBusinessType == '2040020' || sBusinessType == '2040030'
					|| sBusinessType == '2040040' || sBusinessType == '2040050'
					|| sBusinessType == '2040060' || sBusinessType == '2040070'
					|| sBusinessType == '2040080' || sBusinessType == '2040090'
					|| sBusinessType == '2040100' || sBusinessType == '2040110'				
					|| sBusinessType == '1110140' || sBusinessType == '1110170'
					|| sBusinessType == '3030020' || sBusinessType == '1110160'
					|| sBusinessType == '1110150' || sBusinessType == '1110130'
					|| sBusinessType == '1110027' || sBusinessType == '1110120'
					|| sBusinessType == '2100' || sBusinessType == '2090020'
					|| sBusinessType == '1110110' || sBusinessType == '2090010'
					|| sBusinessType == '1110100' || sBusinessType == '1110090'
					|| sBusinessType == '2080010' || sBusinessType == '1110080'
					|| sBusinessType == '2110050' || sBusinessType == '2060040'				
					|| sBusinessType == '2110040' || sBusinessType == '1110050'
					|| sBusinessType == '2060010' || sBusinessType == '1110040'
					|| sBusinessType == '2050040' || sBusinessType == '2050030'
					|| sBusinessType == '1110030' || sBusinessType == '2050020'
					|| sBusinessType == '2050010' || sBusinessType == '1110020'
					|| sBusinessType == '1110010' || sBusinessType == '2060020'
					|| sBusinessType == '2060030' || sBusinessType == '1100010'
					|| sBusinessType == '2060050' || sBusinessType == '2060060'
					|| sBusinessType == '1110070' || sBusinessType == '1090030'				
					|| sBusinessType == '2080020' || sBusinessType == '2080030'
					|| sBusinessType == '1090020' || sBusinessType == '1090010') 
					//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
					//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
					//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
					//加工装配业务进口保函、其他非融资性保函、商业助学贷款、个人经营贷款、
					//个人住房装修贷款、国家助学贷款、个人消费汽车贷款、个人住房公积金贷款、
					//个人营运汽车贷款、买入返售业务、有价证券发行担保、个人抵押贷款、贷款担保、
					//个人保证贷款、个人质押贷款、贷款承诺函、个人经营循环贷款、 个人付款保函、
					//转贷买方信贷、个人小额信用贷款、个人委托贷款、个人自助质押贷款、
					//转贷外国政府贷款、个人再交易商业用房贷款、对外保函、进口信用证、
					//个人商业用房按贷款、备用信用证、提货担保、转贷国际金融组织贷款、
					//国家外汇储备转贷款、个人再交易住房贷款、发行债券转贷款、其他转贷款、
					//个人抵押循环贷款、个人住房贷款、黄金租赁业务、贷款意向书、银行信贷证明、
					//出口保理、进口保理、国内保理
					{
						alert(getBusinessMessage('584'));//失效日期必须晚于生效日期！
						return false;
					}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
					|| sBusinessType == '1020030' || sBusinessType == '1020040')
					//银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现、商业承兑汇票保贴
					{
						alert(getBusinessMessage('589'));//到期日必须晚于起息日！
						return false;
					}else if(sBusinessType == '2020')//国内信用证
					{
						alert(getBusinessMessage('590'));//信用证有效期必须晚于业务日期！
						return false;
					}else if(sBusinessType == '2010')//银行承兑汇票
					{
						alert(getBusinessMessage('582'));//到期付款日必须晚于签发日！
						return false;
					}else
					{
						alert(getBusinessMessage('588'));//到期日必须晚于起贷日！
						return false;
					}
					
				}
			}
			
			//合同业务品种
			sBCBusinessType = "<%=sBCBusinessType%>";
			//合同起始日
			sBCPutOutDate = "<%=sBCPutOutDate%>";
			//合同到期日
			sBCMaturity = "<%=sBCMaturity%>";	
			//校验出帐起始日是否早于合同起始日			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sBCPutOutDate) != "undefined" && sBCPutOutDate != "")
			{
				if(sPutOutDate < sBCPutOutDate)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('592'));//出帐的展期起始日必须晚于或等于合同的展期起始日！
						return false;
					}else
					{
						if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110027' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '2110050' || sBusinessType == '2060040'				
						|| sBusinessType == '2110040' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '2050040' || sBusinessType == '2050030'
						|| sBusinessType == '1110030' || sBusinessType == '2050020'
						|| sBusinessType == '2050010' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030' || sBusinessType == '1100010'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1090030'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1090020' || sBusinessType == '1090010') 
						//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
						//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
						//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
						//加工装配业务进口保函、其他非融资性保函、商业助学贷款、个人经营贷款、
						//个人住房装修贷款、国家助学贷款、个人消费汽车贷款、个人住房公积金贷款、
						//个人营运汽车贷款、买入返售业务、有价证券发行担保、个人抵押贷款、贷款担保、
						//个人保证贷款、个人质押贷款、贷款承诺函、个人经营循环贷款、 个人付款保函、
						//转贷买方信贷、个人小额信用贷款、个人委托贷款、个人自助质押贷款、
						//转贷外国政府贷款、个人再交易商业用房贷款、对外保函、进口信用证、
						//个人商业用房按贷款、备用信用证、提货担保、转贷国际金融组织贷款、
						//国家外汇储备转贷款、个人再交易住房贷款、发行债券转贷款、其他转贷款、
						//个人抵押循环贷款、个人住房贷款、黄金租赁业务、贷款意向书、银行信贷证明、
						//出口保理、进口保理、国内保理
						{
							if(sBCBusinessType == '2050030') //进口信用证
							{
								alert(getBusinessMessage('594'));//出帐的生效日期必须晚于或等于合同的开证日！
								return false;
							}else if(sBCBusinessType == '2050010' || sBCBusinessType == '2050020' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020') 
							//提货担保、备用信用证、贷款担保、银行信贷证明、贷款意向书
							{
								alert(getBusinessMessage('595'));//出帐的生效日期必须晚于或等于合同的发放日！
								return false;
							}else if(sBCBusinessType == '2050040') //对外保函
							{
								alert(getBusinessMessage('596'));//出帐的生效日期必须晚于或等于合同的签发日！
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
							//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
							//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
							//加工装配业务进口保函、其他非融资性保函
							{
								alert(getBusinessMessage('597'));//出帐的生效日期必须晚于或等于合同的生效日期！
								return false;
							}else
							{
								alert(getBusinessMessage('598'));//出帐的生效日期必须晚于或等于合同的起始日！
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现、商业承兑汇票保贴
						{
							alert(getBusinessMessage('599'));//出帐的起息日必须晚于或等于合同的起始日！
							return false;
						}else if(sBusinessType == '2020')//国内信用证
						{
							alert(getBusinessMessage('600'));//出帐的业务日期必须晚于或等于合同的开证日！
							return false;
						}else if(sBusinessType == '2010')//银行承兑汇票
						{
							alert(getBusinessMessage('601'));//出帐的签发日必须晚于或等于合同的出票日！
							return false;
						}else
						{
							alert(getBusinessMessage('593'));//出帐的起贷日必须晚于或等于合同的起始日！
							return false;	
						}
					}
				}
			}
			
			//校验出帐到期日是否晚于合同到期日
			if(typeof(sMaturity) != "undefined" && sMaturity != ""
			&& typeof(sBCMaturity) != "undefined" && sBCMaturity != "")
			{
				if(sMaturity > sBCMaturity && sBusinessType!="1110027" && sBusinessType!="2110020")
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('602'));//出帐的展期到期日必须早于或等于合同的展期到期日！
						return false;
					}else
					{
						if(sBusinessType == '2030010' || sBusinessType == '2030020'
						|| sBusinessType == '2030030' || sBusinessType == '2030040'
						|| sBusinessType == '2030050' || sBusinessType == '2030060'
						|| sBusinessType == '2030070' || sBusinessType == '2040010'
						|| sBusinessType == '2040020' || sBusinessType == '2040030'
						|| sBusinessType == '2040040' || sBusinessType == '2040050'
						|| sBusinessType == '2040060' || sBusinessType == '2040070'
						|| sBusinessType == '2040080' || sBusinessType == '2040090'
						|| sBusinessType == '2040100' || sBusinessType == '2040110'				
						|| sBusinessType == '1110140' || sBusinessType == '1110170'
						|| sBusinessType == '3030020' || sBusinessType == '1110160'
						|| sBusinessType == '1110150' || sBusinessType == '1110130'
						|| sBusinessType == '1110027' || sBusinessType == '1110120'
						|| sBusinessType == '2100' || sBusinessType == '2090020'
						|| sBusinessType == '1110110' || sBusinessType == '2090010'
						|| sBusinessType == '1110100' || sBusinessType == '1110090'
						|| sBusinessType == '2080010' || sBusinessType == '1110080'
						|| sBusinessType == '2110050' || sBusinessType == '2060040'				
						|| sBusinessType == '2110040' || sBusinessType == '1110050'
						|| sBusinessType == '2060010' || sBusinessType == '1110040'
						|| sBusinessType == '2050040' || sBusinessType == '2050030'
						|| sBusinessType == '1110030' || sBusinessType == '2050020'
						|| sBusinessType == '2050010' || sBusinessType == '1110020'
						|| sBusinessType == '1110010' || sBusinessType == '2060020'
						|| sBusinessType == '2060030' || sBusinessType == '1100010'
						|| sBusinessType == '2060050' || sBusinessType == '2060060'
						|| sBusinessType == '1110070' || sBusinessType == '1090030'				
						|| sBusinessType == '2080020' || sBusinessType == '2080030'
						|| sBusinessType == '1090020' || sBusinessType == '1090010') 
						//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
						//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
						//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
						//加工装配业务进口保函、其他非融资性保函、商业助学贷款、个人经营贷款、
						//个人住房装修贷款、国家助学贷款、个人消费汽车贷款、个人住房公积金贷款、
						//个人营运汽车贷款、买入返售业务、有价证券发行担保、个人抵押贷款、贷款担保、
						//个人保证贷款、个人质押贷款、贷款承诺函、个人经营循环贷款、 个人付款保函、
						//转贷买方信贷、个人小额信用贷款、个人委托贷款、个人自助质押贷款、
						//转贷外国政府贷款、个人再交易商业用房贷款、对外保函、进口信用证、
						//个人商业用房按贷款、备用信用证、提货担保、转贷国际金融组织贷款、
						//国家外汇储备转贷款、个人再交易住房贷款、发行债券转贷款、其他转贷款、
						//个人抵押循环贷款、个人住房贷款、黄金租赁业务、贷款意向书、银行信贷证明、
						//出口保理、进口保理、国内保理
						{
							if(sBCBusinessType == '2050010' || sBCBusinessType == '2050020' 
							|| sBCBusinessType == '2090010' || sBCBusinessType == '2080030'
							|| sBCBusinessType == '2080020' || sBCBusinessType == '2050030') 
							//提货担保、备用信用证、贷款担保、银行信贷证明、贷款意向书、进口信用证
							{
								alert(getBusinessMessage('604'));//出帐的失效日期必须早于或等于合同的到期日！
								return false;
							}else if(sBCBusinessType == '2050040') //对外保函
							{
								alert(getBusinessMessage('605'));//出帐的失效日期必须早于或等于合同的到期付款日！
								return false;
							}else if(sBCBusinessType == '2030010' || sBCBusinessType == '2030020'
							|| sBCBusinessType == '2030030' || sBCBusinessType == '2030040'
							|| sBCBusinessType == '2030050' || sBCBusinessType == '2030060'
							|| sBCBusinessType == '2030070' || sBCBusinessType == '2040010'
							|| sBCBusinessType == '2040020' || sBCBusinessType == '2040030'
							|| sBCBusinessType == '2040040' || sBCBusinessType == '2040050'
							|| sBCBusinessType == '2040060' || sBCBusinessType == '2040070'
							|| sBCBusinessType == '2040080' || sBCBusinessType == '2040090'
							|| sBCBusinessType == '2040100' || sBCBusinessType == '2040110') 
							//借款偿还保函、租金偿还保函、透支归还保函、关税保付保函、补偿贸易保函、
							//付款保函、其他融资性保函、投标保函、履约保函、预付款保函、承包工程保函
							//质量维修保函、海事保函、补偿贸易保函、诉讼保函、留置金保函、
							//加工装配业务进口保函、其他非融资性保函
							{
								alert(getBusinessMessage('606'));//出帐的失效日期必须早于或等于合同的失效日期！
								return false;
							}else
							{
								alert(getBusinessMessage('604'));//出帐的失效日期必须早于或等于合同的到期日！
								return false;
							}
						}else if(sBusinessType == '1020010' || sBusinessType == '1020020'
						|| sBusinessType == '1020030' || sBusinessType == '1020040')
						//银行承兑汇票贴现、商业承兑汇票贴现、协议付息票据贴现、商业承兑汇票保贴
						{
							alert(getBusinessMessage('603'));//出帐的到期日必须早于或等于合同的到期日！
							return false;
						}else if(sBusinessType == '2020')//国内信用证
						{
							alert(getBusinessMessage('607'));//出帐的信用证有效期必须早于或等于合同的信用证有效期！
							return false;
						}else if(sBusinessType == '2010')//银行承兑汇票
						{
							alert(getBusinessMessage('608'));//出帐的到期付款日必须早于或等于合同的到期日！
							return false;
						}else
						{
							alert(getBusinessMessage('603'));//出帐的到期日必须早于或等于合同的到期日！
							return false;	
						}
						
					}
				}
			}							
		}
		
		//出帐金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");	
		//合同金额
		dBCBusinessSum = "<%=dBCBusinessSum%>";
		//判断累计出帐金额是否已超过了合同金额
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBCBusinessSum) >= 0)
		{
			//获取合同项下可出帐的金额
			//出帐流水号
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			//合同流水号
			sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");	
			sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sContractSerialNo+","+sSerialNo);
			if(parseFloat(sSurplusPutOutSum) > 0)
			{
				if(parseFloat(dBusinessSum) > parseFloat(sSurplusPutOutSum))
				{
					alert(getBusinessMessage('572'));//出帐中录入的金额必须小于或等于合同的可用金额！
					return false;
				}
			}else
			{
				alert(getBusinessMessage('573'));//此业务合同已没有可用金额，不能进行放贷申请！
				return false;
			}			
		}
		
		if(sBusinessType == '1040010' || sBusinessType == '1040020' 
		|| sBusinessType == '1040030' || sBusinessType == '1040040') 
		//法人购房贷款、汽车法人按揭、设备法人按揭、其他法人按揭
		{
			//当扣款周期选择按固定月数计息时,此项必须输入,输入范围为2-12.
			//扣款周期
			sICCyc = getItemValue(0,getRow(),"ICCyc");
			//固定月数
			sFixCyc = getItemValue(0,getRow(),"FixCyc");
			if(typeof(sICCyc) != "undefined" && sICCyc != "")
			{
				if(sICCyc == '1')
				{
					if(typeof(sFixCyc) == "undefined" || sFixCyc.length==0 
					|| parseInt(sFixCyc) < 2 || parseInt(sFixCyc) > 12)
					{
						alert(getBusinessMessage('611'));//当扣款周期选择按固定月数计息时,固定月数必须输入,输入范围为2-12！
						return false;
					}
				}
			}
		}else
		{
			//当计息周期选择按固定月数计息时,此项必须输入,输入范围为2-12.
			//计息周期
			sICCyc = getItemValue(0,getRow(),"ICCyc");
			//固定周期
			sFixCyc = getItemValue(0,getRow(),"FixCyc");
			if(typeof(sICCyc) != "undefined" && sICCyc != "")
			{
				if(sICCyc == '5')
				{
					if(typeof(sFixCyc) == "undefined" || sFixCyc.length==0 
					|| parseInt(sFixCyc) < 2 || parseInt(sFixCyc) > 12)
					{
						alert(getBusinessMessage('609'));//当计息周期选择按固定月数计息时,固定周期必须输入,输入范围为2-12！
						return false;
					}
				}
			}
		}
		
		//当贴现付息方式选择协议付息时输入买方付息比例
		//贴现付息方式
		sAcceptIntType = getItemValue(0,getRow(),"AcceptIntType");
		//买方付息比例(%)
		sBillRisk = getItemValue(0,getRow(),"BillRisk");
		if(typeof(sAcceptIntType) != "undefined" && sAcceptIntType != "")
		{
			if(sAcceptIntType == '2')
			{
				if(typeof(sBillRisk) == "undefined" || sBillRisk.length==0 
				|| parseInt(parseFloat) <= 0)
				{
					alert(getBusinessMessage('610'));//当贴现付息方式选择协议付息时输入买方付息比例！
					return false;
				}
			}
		}
		
		return true;
	}
	
	/*~[Describe=获取保证金;InputParam=无;OutPutParam=无;]~*/
	function getBailSum(){
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBailAccount = getItemValue(0,getRow(),"BailAccount");
		//为了将保证金账号作为参数传至交易页面
		sObjectType = sObjectType+"@"+sBailAccount;
		//进行保证金信息交互 add by xlyu 
		sTradeType = "798015";
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("核心系统提示："+sReturn[1]+",错误编号["+sReturn[0]+"]");//如果失败抛错出来错
		    return;
		}else
		{
		    alert("发送核心成功！"+sReturn[1]);
		    reloadSelf();
		    
		}
		
	}
	
	/*~[Describe=弹出损益入帐机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getPutOutOrg()
	{		
		sParaString = "OrgID"+","+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@AboutBankID3@0@AboutBankID3Name@1",0,0,"");		
	}
	
	/*~[Describe=弹出记账机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectPutOutOrg()
	{		
		sParaString = "SortNo"+","+"<%=CurOrg.SortNo%>";
		setObjectValue("SelectBelongOrgCode",sParaString,"@PutOutOrgID@0@PutOutOrgIDName@1",0,0,"");		
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
	
	//取得基准年利率
	function selectBaseRateType(){
		sCurDate = "<%=StringFunction.getToday()%>"
		sParaString = "CurDate"+","+sCurDate;
	    sReturn = setObjectValue("selectBaseRateType",sParaString,"@BaseRateType@0@BaseRate@1",0,0,"");
		getBusinessRate("M");
	}
	//自动获取利率类型 2009-12-24 
	function getBaseRateType(){
		 var sOccurType = "<%=sBCOccurType%>";
		 var sBusinessType = <%=sBusinessType%>
		 dTermDay = getItemValue(0,getRow(),"TermDay");
		 dTermMonth = getItemValue(0,getRow(),"TermMonth");
		 sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
		 sBaseRateID = "";
	 
		  if(sBusinessCurrency=="01")//人民币
		 {
			  if(typeof(dTermDay) != "undefined" && dTermDay != "" && dTermDay>0)
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
	
	/*~[Describe=挤占/挪用利率InputParam=无;OutPutParam=无;]~*/
	function getTARate()
	{
		//挤占/挪用浮动比例
		dTARateFloat = getItemValue(0,getRow(),"TARateFloat");
		//执行月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//挤占/挪用利率＝执行利率*（1+挤占/挪用浮动比例）
		dTARate = parseFloat(dBusinessRate)*(1+parseFloat(dTARateFloat)/100.00);
		setItemValue(0,getRow(),"TARate",roundOff(dTARate,6));
	}
	/*~[Describe=计算逾期利率;InputParam=无;OutPutParam=无;]~*/
	function getOverdueRate()
	{
		//逾期浮动比例
		dOverdueRateFloat = getItemValue(0,getRow(),"OverdueRateFloat");
		//执行月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//逾期利率＝执行利率*（1+逾期浮动比例）
		dOverdueRate = parseFloat(dBusinessRate)*(1+parseFloat(dOverdueRateFloat)/100.00);
		setItemValue(0,getRow(),"OverdueRate",roundOff(dOverdueRate,6));
	}
	
	//出账阶段，重新获取基准利率 
	function getNewBaseRate(){
		sBaseRateID = getItemValue(0,getRow(),"BaseRateType");
		sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//币种
		if("2110020" == "<%=sBusinessType%>"){//如果是纯公积金贷款
			sReturn = RunMethod("BusinessManage","getAFBaseRate",sBaseRateID);
		    if(typeof(sReturn) != "undefined" && sReturn != ""){
		    	setItemValue(0,0,"BaseRate",sReturn);
		    }
		}else{
			//sReturn = RunMethod("BusinessManage","getBaseRate",sBaseRateID);
			sReturn = RunMethod("BusinessManage","getCurrencyBaseRate",sBaseRateID+","+sBusinessCurrency);
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				setItemValue(0,0,"BaseRate",sReturn);
			} 	
		}    
		getBusinessRate("M");
		getTARate();
		getOverdueRate();
	}
	
	/*~[Describe=计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function setBailRatio()
	{
			sERateDate = getItemValue(0,getRow(),"ERateDate");//汇率日期
	    	sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//业务币种
			sBailCurrency = getItemValue(0,getRow(),"BailCurrency");//保证金币种
			dBailSum = getItemValue(0,getRow(),"BailSum");//保证金金额
			sBailDate = getItemValue(0,getRow(),"BailDate");//保证金开户日期
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//出账金额
			var dBailRatio=0.0;
			if(sBusinessCurrency == sBailCurrency)
			{
		    	dBailRatio = parseFloat(dBailSum)*100/parseFloat(dBusinessSum);     
			}else
			{    
	    		dBailRateRatio = RunMethod("BusinessManage","getErateRatio1",sBailCurrency+",01,"+sBailDate);
	    		dERateRatio = RunMethod("BusinessManage","getErateRatio1",sBusinessCurrency+",01,"+sERateDate);
	        	dBailRatio = parseFloat(dBailSum*dBailRateRatio*100)/parseFloat(dBusinessSum*dERateRatio);
	        	
	    	}
	    	setItemValue(0,getRow(),"BPBailRatio",dBailRatio);
	}
	</SCRIPT>
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