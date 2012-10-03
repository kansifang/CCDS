<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --客户概况
		Input Param:
			  CustomerID:--客户号
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         新版本的改写
		   2005.9.10 zywei         重检代码 
		   2005.12.15 jbai
		   2006.10.16 fhuang       重检代码
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sCustomerInfoTemplet = "";//--模板类型
    String sSql = "";//--存放sql语句
    String sCustomerType = "";//--存放客户类型   
    String sCustomerScale = "";//--中小客户规模   
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//暂存标志
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- 存放结果集
	String sIsUseSmallTemplet = ""; //--是否使用小企业评级模板
	
	//获得组件参数,客户代码
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//取得客户类型
	sSql = "select CustomerType,CertType,CertID,CustomerScale from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType");
		sCertID = rs.getString("CertID");
		sCustomerScale = rs.getString("CustomerScale");
	}
	rs.getStatement().close();

	if(sCustomerType == null) sCustomerType = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";	
	
	//取得视图模板类型
	sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//客户详情树图类型
		sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		//中小企业客户详情树图类型
	}
	rs.getStatement().close(); 
	
	if(sCustomerType.substring(0,2).equals("01")){
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		sTempSaveFlag = Sqlca.getString(sSql);
	}
	if(sCustomerType.substring(0,2).equals("03")){
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = '"+sCustomerID+"' ";
		sTempSaveFlag = Sqlca.getString(sSql);
	}
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02"))
	{
		//公司客户管理显示模板
		sCustomerInfoTemplet = sAttribute3;		//中小公司客户详情显示模板
	}else
	{
		//公司客户管理显示模板
		sCustomerInfoTemplet = sItemAttribute;		//公司客户详情显示模板
	}
	
	
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
		
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("客户信息不存在或客户类型未设置！"); 
	//录入公司客户信息时判断，该机构用户是否有权使用小企业评级模板
	if(sCustomerType.substring(0,2).equals("01"))
	{
		sIsUseSmallTemplet = Sqlca.getString(" select IsUseSmallTemplet from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ");
		if(sIsUseSmallTemplet == null) sIsUseSmallTemplet = "";
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08"))
	{
		doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//设置国内地区选择方式
	doTemp.appendHTMLStyle("RegionName"," style=cursor:hand; onClick=\"javascript:parent.getRegionCode()\" ");	
	
	//设置注册资本范围
	doTemp.appendHTMLStyle("RegisterCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"注册资本必须大于等于0！\" ");
	//设置职工人数范围
	if(sCustomerType.substring(0,2).equals("04"))
	{
		doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>0 \" mymsg=\"联保小组成员人数必须大于5！\" ");
	}else
	{
		doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"职工人数必须大于等于0！\" ");
	}
	//设置实收资本范围
	doTemp.appendHTMLStyle("PaiclUpCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"实收资本必须大于等于0！\" ");
	//设置经营场地面积（平方米）范围
	doTemp.appendHTMLStyle("WorkFieldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"经营场地面积（平方米）必须大于等于0！\" ");
	//设置家庭月收入(元)范围
	doTemp.appendHTMLStyle("FamilyMonthIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"家庭月收入(元)必须大于等于0！\" ");
	//设置个人年收入(元)范围
	doTemp.appendHTMLStyle("YearIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"个人年收入(元)必须大于等于0！\" ");
	
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置插入和更新事件，反方向插入和更新(更新客户的贷款卡编号) 
	if(sCustomerType.substring(0,2).equals("01")) //公司客户
	{
    	if(sCertType.equals("Ent01"))
    	{
    		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.UserID+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.UserID+")");
  		}
  		else
  		{
  			dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
  		}
  		
  }else if(sCustomerType.substring(0,2).equals("03"))//个人客户
  {
		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#FullName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
		dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#FullName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
  }
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(dwTemp.Name);
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
				{sTempSaveFlag.equals("2")?"false":"true","","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
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
		getEnterpriseScale();
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(vI_all("myiframe0")){
			//录入数据有效性检查
			if (!ValidityCheck()) return;
			beforeUpdate();
			setItemValue(0,getRow(),'TempSaveFlag',"2");//暂存标志（1：是；2：否）
			as_save("myiframe0","");		
			if(sCustomerType=='02')
			{
				afterUpdate();	
			}					
		}
	}
	
	function alertMsg(){
		alert("请继续录入其它信息！");
	}
		
	function saveRecordTemp()
	{
		var sCustomerType = "<%=sCustomerType%>";
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
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		//sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		// getEnterpriseScale();
	}
	//变更集团客户管户人信息
	function afterUpdate(){
		var sUserID=getItemValue(0,getRow(),"UserID");
		var sOrgID= getItemValue(0,getRow(),"OrgID");
		var scustomerID =getItemValue(0,getRow(),"CustomerID");
		sReturn = RunMethod("CustomerManage","UpdateCustomerBelong",sOrgID+","+sUserID+","+scustomerID);
	}

	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01') //公司客户
		{			
			//1：校验营业执照到期日是否小于营业执照起始日			
			sLicensedate = getItemValue(0,getRow(),"Licensedate");//营业执照登记日			
			sLicenseMaturity = getItemValue(0,getRow(),"LicenseMaturity");//营业执照到期日
			sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sLicensedate) != "undefined" && sLicensedate != "" && 
			typeof(sLicenseMaturity) != "undefined" && sLicenseMaturity != "")
			{
				if(sLicensedate >= sToday)
				{		    
					alert(getBusinessMessage('132'));//营业执照登记日必须早于当前日期！
					return false;		    
				}
				if(sLicenseMaturity <= sLicensedate)
				{		    
					alert(getBusinessMessage('118'));//营业执照到期日必须晚于营业执照登记日！
					return false;		    
				}
			}
			//2：校验当所在国家(地区)不为中华人民共和国时，客户英文名称不能为空			
			sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");//所在国家(地区)
			sEnglishName = getItemValue(0,getRow(),"EnglishName");//客户英文名称
			if(sCountryTypeValue != 'CHN')
			{
				if (typeof(sEnglishName) == "undefined" || sEnglishName == "" )
				{
					alert(getBusinessMessage('119')); //所在国家(地区)不为中华人民共和国时，客户英文名不能为空！
					return false;	
				}
			}
			//3：校验邮政编码
			sOfficeZip = getItemValue(0,getRow(),"OfficeZIP");//邮政编码
			if(typeof(sOfficeZip) != "undefined" && sOfficeZip != "" )
			{	
				if(!CheckPostalcode(sOfficeZip))
				{
					alert(getBusinessMessage('120'));//邮政编码有误！
					return false;
				}
			}
			//4：校验联系电话
			sOfficeTel = getItemValue(0,getRow(),"OfficeTel");//联系电话	
			if(typeof(sOfficeTel) != "undefined" && sOfficeTel != "" )
			{
				if(!CheckPhoneCode(sOfficeTel))
				{
					alert(getBusinessMessage('121'));//联系电话有误！
					return false;
				}
			}
			//5：校验传真电话
			sOfficeFax = getItemValue(0,getRow(),"OfficeFax");//传真电话	
			if(typeof(sOfficeFax) != "undefined" && sOfficeFax != "" )
			{
				if(!CheckPhoneCode(sOfficeFax))
				{
					alert(getBusinessMessage('124'));//传真电话有误！
					return false;
				}
			}
			//6：校验财务部联系电话
			sFinanceDeptTel = getItemValue(0,getRow(),"FinanceDeptTel");//财务部联系电话	
			if(typeof(sFinanceDeptTel) != "undefined" && sFinanceDeptTel != "" )
			{
				if(!CheckPhoneCode(sFinanceDeptTel))
				{
					alert(getBusinessMessage('125'));//财务部联系电话有误！
					return false;
				}
			}
			//7：校验电子邮件地址
			sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//电子邮件地址	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" )
			{
				if(!CheckEMail(sEmailAdd))
				{
					alert(getBusinessMessage('130'));//公司E－Mail有误！
					return false;
				}
			}
			
			//8：校验贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//贷款卡编号	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('101'));//贷款卡编号有误！							
					return false;
				}
				
				//检验贷款卡编号唯一性
				sCustomerName = getItemValue(0,getRow(),"EnterpriseName");//客户名称	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					//alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					//return false;
				}						
			}
			
			//9:校验当是否集团客户为是时，则需输入上级公司名称、上级公司组织机构代码或上级公司贷款卡编号
			sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//是否集团客户
			if(sECGroupFlag == '1')//是否集团客户（1：是；2：否）
			{
				sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//上级公司名称
				sSuperLoanCardNo = getItemValue(0,getRow(),"SuperLoanCardNo");//上级公司贷款卡编号
				sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//上级公司组织机构代码
				if(typeof(sSuperCorpName) == "undefined" || sSuperCorpName == "" )
				{
					alert(getBusinessMessage('126'));
					return false;
				}
				if((typeof(sSuperLoanCardNo) == "undefined" || sSuperLoanCardNo == "") && 
				(typeof(sSuperCertID) == "undefined" || sSuperCertID == "") )
				{
					alert(getBusinessMessage('127'));
					return false;
				}
				//如果录入了上级公司组织机构代码，则需要校验上级公司组织机构代码的合法性，同时将上级公司证件类型设置为组织机构代码证
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" )
				{
					if(!CheckORG(sSuperCertID))
					{
						alert(getBusinessMessage('128'));//上级公司组织机构代码有误！							
						return false;
					}
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}
				//如果录入了上级公司贷款卡编号，则需要校验上级公司贷款卡编号的合法性
				if(typeof(sSuperLoanCardNo) != "undefined" && sSuperLoanCardNo != "" )
				{
					if(!CheckLoanCardID(sSuperLoanCardNo))
					{
						alert(getBusinessMessage('129'));//上级公司贷款卡编号有误！							
						return false;
					}
					
					//检验上级公司贷款卡编号唯一性
					sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//上级公司客户名称	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sSuperCorpName+","+sSuperLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
					{
						//alert(getBusinessMessage('228'));//该上级公司贷款卡编号已被其他客户占用！							
						//return false;
					}						
				}
			}	
			
			//add by xhyong 2009/07/31
			//10：校验当企业规模选择为"小型企业"时，则"是否银监会口径小企业"不能为空
			sScope = getItemValue(0,getRow(),"Scope");//企业规模
			sSmallEntFlag = getItemValue(0,getRow(),"SmallEntFlag");//是否银监会口径小企业
			if(sScope == '4')
			{
				if ((typeof(sSmallEntFlag) == "undefined" || sSmallEntFlag == "") && sCustomerType != '0107')
				{
					alert("当企业规模选择为小型企业时，则是否本行认定微小企业不能为空!"); //当企业规模选择为小型企业时，则是否本行认定微小企业不能为空!
					return false;	
				}
			}
			//11："企业成立日期"不应晚于"营业执照登记日"，且不能晚于当前日期
			sSetupDate = getItemValue(0,getRow(),"SetupDate");//企业成立日期
			sLicensedate = getItemValue(0,getRow(),"Licensedate");//营业执照登记日
			sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sSetupDate) != "undefined" && sSetupDate != "" )
			{
				if(sSetupDate > sLicensedate)
				{
					alert("企业成立日期不应晚于营业执照登记日!");//"企业成立日期不应晚于营业执照登记日"
					return false;
				}
				if(sSetupDate > sToday)
				{
					alert("企业成立日期不能晚于当前日期!");//"企业成立日期不能晚于当前日期"
					return false;
				}
			}	
			//11：我行开户行账号和他行开户行账号不能相同
			sMybankAccount = getItemValue(0,getRow(),"MybankAccount");//我行开户行账号
			sOtherBankAccount = getItemValue(0,getRow(),"OtherBankAccount");//他行开户行账号
			if(typeof(sMybankAccount) != "undefined" && sMybankAccount != "" &&typeof(sOtherBankAccount) != "undefined" && sOtherBankAccount != ""  )
			{
				if(sMybankAccount == sOtherBankAccount)
				{
					alert("我行开户行账号和他行开户行账号不能相同!");//我行开户行账号和他行开户行账号不能相同
					return false;
				}
			}	
			//add end 		
		}
		
		if(sCustomerType == '02') //集团客户
		{
			//1：校验主管客户经理联系电话
			sRelativeType = getItemValue(0,getRow(),"RelativeType");//主管客户经理联系电话
			if(typeof(sRelativeType) != "undefined" && sRelativeType != "" )
			{
				if(!CheckPhoneCode(sRelativeType))
				{
					alert(getBusinessMessage('223'));//主管客户经理联系电话有误！
					return false;
				}
			}
			//2：校验当集团类型为紧密型时,集团总部所在地必输
			sGroupType = getItemValue(0,getRow(),"GroupType");//集团类型
			sRegionCodeName = getItemValue(0,getRow(),"RegionCodeName");//集团类型
			if(sGroupType == "010")
			{
				if (typeof(sRegionCodeName) == "undefined" || sRegionCodeName == "" )
				{
					alert("当集团类型为紧密型时，则集团总部所在地不能为空!"); //当集团类型为紧密型时，则集团总部所在地不能为空!
					return false;	
				}
			}
		}
		if(sCustomerType == '03') //个人客户
		{
			//1:校验证件类型为身份证或临时身份证时，出生日期是否同证件编号中的日期一致
			sCertType = getItemValue(0,getRow(),"CertType");//证件类型
			sCertID = getItemValue(0,getRow(),"CertID");//证件编号
			sBirthday = getItemValue(0,getRow(),"Birthday");//出生日期
			if(typeof(sBirthday) != "undefined" && sBirthday != "" )
			{			
				if(sCertType == 'Ind01' || sCertType == 'Ind08')
				{
					//将身份证中的日期自动赋给出生日期,把身份证中的性别赋给性别
					if(sCertID.length == 15)
					{
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18)
					{
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//奇男偶女
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID)
					{
						alert(getBusinessMessage('200'));//出生日期和身份证中的出生日期不一致！	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01')
				{
					alert(getBusinessMessage('201'));//出生日期必须晚于1900/01/01！	
					return false;
				}
			}
			
			//2：校验居住地址邮编
			sFamilyZIP = getItemValue(0,getRow(),"FamilyZIP");//居住地址邮编
			if(typeof(sFamilyZIP) != "undefined" && sFamilyZIP != "" )
			{	
				if(!CheckPostalcode(sFamilyZIP))
				{
					alert(getBusinessMessage('202'));//居住地址邮编有误！
					return false;
				}
			}
			
			//3：校验住宅电话
			sFamilyTel = getItemValue(0,getRow(),"FamilyTel");//住宅电话	
			if(typeof(sFamilyTel) != "undefined" && sFamilyTel != "" )
			{
				if(!CheckPhoneCode(sFamilyTel))
				{
					alert(getBusinessMessage('203'));//住宅电话有误！
					return false;
				}
			}
			
			//4：校验手机号码
			sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//手机号码
			if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone != "" )
			{
				if(!CheckPhoneCode(sMobileTelephone) || sMobileTelephone.length !=11)
				{
					alert(getBusinessMessage('204'));//手机号码有误！
					return false;
				}
				
			}
			
			//5：校验电子邮箱
			sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//电子邮箱	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" )
			{
				if(!CheckEMail(sEmailAdd))
				{
					alert(getBusinessMessage('205'));//电子邮箱有误！
					return false;
				}
			}
			
			//6：校验通讯地址邮编
			sCommZip = getItemValue(0,getRow(),"CommZip");//通讯地址邮编
			if(typeof(sCommZip) != "undefined" && sCommZip != "" )
			{	
				if(!CheckPostalcode(sCommZip))
				{
					alert(getBusinessMessage('206'));//通讯地址邮编有误！
					return false;
				}
			}
			
			//7：校验单位地址邮编
			sWorkZip = getItemValue(0,getRow(),"WorkZip");//单位地址邮编
			if(typeof(sWorkZip) != "undefined" && sWorkZip != "" )
			{	
				if(!CheckPostalcode(sWorkZip))
				{
					alert(getBusinessMessage('207'));//单位地址邮编有误！
					return false;
				}
			}
			
			//8：校验单位电话
			sWorkTel = getItemValue(0,getRow(),"WorkTel");//单位电话	
			if(typeof(sWorkTel) != "undefined" && sWorkTel != "" )
			{
				if(!CheckPhoneCode(sWorkTel))
				{
					alert(getBusinessMessage('208'));//单位电话有误！
					return false;
				}
			}
			
			//9：校验本单位工作起始日
			sWorkBeginDate = getItemValue(0,getRow(),"WorkBeginDate");//本单位工作起始日
			sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sWorkBeginDate) != "undefined" && sWorkBeginDate != "" )
			{
				if(sWorkBeginDate >= sToday)
				{
					alert(getBusinessMessage('209'));//本单位工作起始日必须早于当前日期！
					return false;
				}
				
				if(sWorkBeginDate <= sBirthday)
				{
					alert(getBusinessMessage('210'));//本单位工作起始日必须晚于出生日期！
					return false;
				}
			}	
			
			//add by xhyong 2009/07/31
			//10：校验 若户籍类型选择为"农户"，则为必输项
			sIndRPRType = getItemValue(0,getRow(),"IndRPRType");//户籍类型
			sHousemasterFlag = getItemValue(0,getRow(),"HousemasterFlag");//是否户主
			if(sIndRPRType == '010')
			{
				if (typeof(sHousemasterFlag) == "undefined" || sHousemasterFlag == "" )
				{
					alert("当户籍类型选择为农户时,是否户主不能为空!"); //当户籍类型选择为农户时,是否户主不能为空!
					return false;	
				}
			}
			
			//add end 
			//11：校验贷款卡编号
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//贷款卡编号	
			sCertID = getItemValue(0,getRow(),"CertID");//贷款卡编号
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('101'));//贷款卡编号有误！							
					return false;
				}
				
				//检验贷款卡编号唯一性
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoByCertID",sCertType+","+sCertID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//该贷款卡编号已被其他客户占用！							
					return false;
				}						
			}				
		}
		
		if(sCustomerType == '04')//农户联保小组
		{
			//11："联保小组协议签订时间"不能晚于当前日期
			sSetupDate = getItemValue(0,getRow(),"SetupDate");//联保小组协议签订时间
			sToday = "<%=StringFunction.getToday()%>";//当前日期
			if(typeof(sSetupDate) != "undefined" && sSetupDate != "" )
			{
				if(sSetupDate > sToday)
				{
					alert("联保小组协议签订时间不能晚于当前日期!");//"联保小组协议签订时间不能晚于当前日期!"
					return false;
				}	
			}
		}
		// 检验公司客户评级模板
		if(sCustomerType.substring(0,2) == '01')//公司客户
		{
			sCreditBelong = getItemValue(0,getRow(),"CreditBelong");// 该客户对应评级模板
			if ("<%=sIsUseSmallTemplet%>" != "1" && sCreditBelong.indexOf("3") == 0)
		   	{
		   	    alert("请重新选择“信用等级评估模板名称”");
		   	    return false;
		   	}		   	
		}		
		return true;		
	}

    /*~[Describe=弹出企业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrgType()
	{
		sParaString = "CodeNo"+",OrgType";		
		setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
	}
	
	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode()
	{		
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- 所在国家(地区)代码
			if(sCountryCodeValue != 'CHN') //当所在国家(地区)不为中华人民共和国时，需清除省份、直辖市、自治区的数据
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
				setItemRequired(0,0,"RegionCodeName",false);//设置非必输
			}else{
				setItemRequired(0,0,"RegionCodeName",true);//设置必输
			}
		}
	}
	
	/*~[Describe=弹出信用等级评估模板选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditTempletType()
	{	
		if("<%=sCustomerType%>".substring(0,2)=='03')
		{
			sParaString = "CodeNo"+",IndCreditTempletType";
			setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
		}else{	
			sParaString = "CodeNo"+",CreditTempletType";
			if ("<%=sIsUseSmallTemplet%>" == "1")
			{
			    setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
			}else{
			    setObjectValue("SelectTemplet",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
			}
		}
	}
	
	/*~[Describe=弹出对应评分卡模型模板选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=弹出省份、直辖市、自治区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getRegionCode(flag)
	{
		//判断国家有没有选中国
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent")
		{
			if("<%=sCustomerType.substring(0,2)%>" == "01")//公司客户要求先选所在国家或地区，再选择具体省市
			{
				//判断国家是否已经选了
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )
				{
					if(sCountryTypeValue == "CHN")
					{
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
					}else
					{
						alert(getBusinessMessage('122'));//所选国家不是中国，无需选择地区
						return;
					}
				}else
				{
					alert(getBusinessMessage('123'));//尚未选择国家，无法选择地区
					return;
				}
			}else
			{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
			}
		}else 	//区分企业客户的行政区域和个人的籍贯
		{
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}	
	
	//add by xhyong 农户所在地 
	//modified  by zrli 20090914
	/*~[Describe=弹出省份、直辖市、自治区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getVillageCode(flag)
	{
		var sVillageCode = getItemValue(0,getRow(),"VillageCode");
		//由于乡村有几百项，分两步显示
		sVillageInfo = PopComp("VillageVFrame","/Common/ToolsA/VillageVFrame.jsp","Village="+sVillageCode,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		if(sVillageInfo == "NO")
		{
			setItemValue(0,getRow(),"VillageCode","");
			setItemValue(0,getRow(),"VillageName","");
		}else if(typeof(sVillageInfo) != "undefined" && sVillageInfo != "")
		{
			sVillageInfo = sVillageInfo.split('@');
			sVillageCode = sVillageInfo[0];//-- 县乡村代码
			sVillageName = sVillageInfo[1];//--县乡村名称
			setItemValue(0,getRow(),"VillageCode",sVillageCode);
			setItemValue(0,getRow(),"VillageName",sVillageName);					
		}
	}	
	
	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{

		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
		//根据‘贷款行业投向’动态设置‘企业规模划分行业分类’
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
        if(sIndustryType.indexOf("A") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","040"); // 农林牧鱼业
        }
        else if(sIndustryType.indexOf("B") == 0 || sIndustryType.indexOf("C") == 0 || sIndustryType.indexOf("D") == 0 ) 
        {
          	setItemValue(0,getRow(),"IndustryName","005"); // 工业
        }
        else if(sIndustryType.indexOf("E") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","010"); // 建筑业
        }
        else if(sIndustryType.indexOf("F51") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","015"); // 批发业
        }
        else if(sIndustryType.indexOf("F52") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","020"); // 零售业
        }
        else if(sIndustryType.indexOf("G54") == 0 || sIndustryType.indexOf("G55") == 0 || sIndustryType.indexOf("G56") == 0 || sIndustryType.indexOf("G57") == 0 || sIndustryType.indexOf("G58") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","025"); // 交通运输业
        }
        else if(sIndustryType.indexOf("G59") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","045"); // 仓储业
        }
        else if(sIndustryType.indexOf("G60") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","030"); // 邮政业
        }
        else if(sIndustryType.indexOf("H61") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","110"); // 住宿业
        }        
        else if(sIndustryType.indexOf("H62") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","100"); // 餐饮业
        }
        else if(sIndustryType.indexOf("I63") == 0 || sIndustryType.indexOf("I64") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","070"); // 信息传输业
        }
        else if(sIndustryType.indexOf("I65") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","075"); // 软件和信息技术服务业
        }
        else if(sIndustryType.indexOf("K7010") == 0 || sIndustryType.indexOf("K7040") == 0 || sIndustryType.indexOf("K7090") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","050"); // 房地产开发经营
        }
        else if(sIndustryType.indexOf("K7020") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","105"); // 物业管理
        }
        else if(sIndustryType.indexOf("L") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","080"); // 租赁和商务服务业
        }else
        {
            setItemValue(0,getRow(),"IndustryName","095"); // 其他未列明行业
        }             		        		
	}
		
	/*~[Describe=弹出国标行业类型金融业选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	//add by xhyong 2009/08/12 
	function getFinanceIndustryType()
	{
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue=J&IndustryType=&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
		setItemValue(0,getRow(),"IndustryName","095"); // 其他未列明行业
	}
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = "04";//信用共同体选择掌控人
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
		setObjectValue("SelectCustomer1",sParaString,"@SuperCertID@0@SuperCorpName@1",0,0,"");
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//请先选择管户机构！
		}
	}
						
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		var sListingCorpOrNot = getItemValue(0,getRow(),"ListingCorpOrNot");//上市情况
		var sIndustryName = getItemValue(0,getRow(),"IndustryName");//企业规模划分行业分类
		//设置字段默认值
		if (sCountryCode=="")
		{
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","中华人民共和国");
		}
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","011");			
			setItemValue(0,getRow(),"CreditBelongName","企业化管理的事业单位信用等级评估表");
		}
		if (sListingCorpOrNot=="") 
		{
			//默认为未上市
			setItemValue(0,getRow(),"ListingCorpOrNot","050");
		}
		if (sIndustryName==""&&"<%=sCustomerType%>"=="0107") 
		{
			//同业客户设置为金融企业
			setItemValue(0,getRow(),"IndustryName","055");
		}
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--证件类型	
		sCertID = getItemValue(0,0,"CertID");//--证件号码
		ssCustomerType = "<%=sCustomerType%>";
		if(ssCustomerType == '0101' || ssCustomerType == '0102' || ssCustomerType == '0107')
		{
			sRCCurrency = getItemValue(0,0,"RCCurrency");
			sPCCurrency = getItemValue(0,0,"PCCurrency");
			if(typeof(sRCCurrency)=="undefined" || sRCCurrency.length==0)
			{
		    	setItemValue(0,getRow(),"RCCurrency","01");	
		    }
		    if(typeof(sPCCurrency)=="undefined" || sPCCurrency.length==0)
			{
		    	setItemValue(0,getRow(),"PCCurrency","01");	
		    }
		}
		if(sCustomerType == '01')//公司客户
		{
			setItemValue(0,getRow(),"LoanFlag","1");
		}
		if(sCustomerType == '03') //个人客户
		{	
			//判断身份证合法性,个人身份证号码应该是15或18位！
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//将身份证中的日期自动赋给出生日期
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18)
				{
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//奇男偶女
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
		}
    }
    
	/*~[Describe=自动测算月还款额与收入比;InputParam=无;OutPutParam=无;]~*/
	function getIndRate()
	{	
		var dFamilyMonthIncome = getItemValue(0,getRow(),"FamilyMonthIncome");//家庭月收入
		var dMonthReturnSum = getItemValue(0,getRow(),"MonthReturnSum");//月还款额
		if (typeof(dFamilyMonthIncome) != "undefined" && dFamilyMonthIncome != "" )
		{
			IndRate = (dMonthReturnSum/dFamilyMonthIncome)*100;
			IndRate = Math.round(parseFloat(IndRate)*100)/100;
		}
		if(dFamilyMonthIncome==0 || dMonthReturnSum ==0 || IndRate<0) IndRate = "0";
		setItemValue(0,getRow(),"IndRate",IndRate);
	}
    //利用String.replace函数，将字符串左右两边的空格替换成空字符串
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//根据 行业类型、员工人数、销售额、资产总额确定中小企业规模
	function EntScope() 
	{
		/*
		方法说明：
		参见文档《统计上大中小型企业划分办法（暂行）》国家统计局设管司
		计算依赖的指标包括：行业类型、员工人数、销售额、资产总额
		*/
		var sIndustryName = getItemValue(0,getRow(),"IndustryName");//中小企业行业
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//年销售额
		var sCapitalAmount = getItemValue(0,getRow(),"TotalAssets");//资产总额
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//员工人数
		if(typeof(sIndustryName)=="undefined" || sIndustryName.length==0)
			sIndustryName=" ";
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			sLastYearSale=0;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			sCapitalAmount=0;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			sEmployeeNumber=0;
		if(sIndustryName=="005")
		{
		//工业类企业
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
			
		}	
		else if(sIndustryName=="010")
		{
		//建筑业企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="015")
		{
		//批发业企业
			if(sEmployeeNumber>=200&&sLastYearSale>=30000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","3");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="020")
		{
		//零售业企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="025")
		{
		//交通运输业企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<500||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="030")
		{
		//邮政业企业
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<400||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="035")
		{
		//住宿和餐饮业
			if(sEmployeeNumber>=800&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<400||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="040")
		{
		//农林牧渔企业
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<500||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="045")
		{
		//仓储企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="050")
		{
		//房地产企业
			if(sEmployeeNumber>=200&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="055")
		{
		//金融企业
			if(sEmployeeNumber>=500&&sLastYearSale>=50000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<5000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="060")
		{
		//地质勘查和水利环境管理企业
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<600||sLastYearSale<2000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="065")
		{
		//文体、娱乐企业
			if(sEmployeeNumber>=600&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<200||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="070")
		{
		//信息传输企业
			if(sEmployeeNumber>=400&&sLastYearSale>=30000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="075")
		{
		//计算机服务软件企业
			if(sEmployeeNumber>=300&&sLastYearSale>=30000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}

		}
		else if(sIndustryName=="080")
		{
		//租赁企业
			if(sEmployeeNumber>=300&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="085")
		{
		//商务及科技服务企业
			if(sEmployeeNumber>=400&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="090")
		{
		//居民服务企业
			if(sEmployeeNumber>=800&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<200||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else
		{
		//其他企业
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//大型
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//小型
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//中型
				setItemValue(0,getRow(),"Scope","3");
			}
		}		
	}
	//查找该客户的担保协议	
	function VouchAgreement()
	{
		sParaString = "";
		sReturn = selectObjectValue("SelectVouchCustomer",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn1 = sReturn.split("@");
		setItemValue(0,0,"VouchCorpName",sReturn1[0]);
	}
	//判定企业规模
	function getEnterpriseScale(){
	     sCustomerID = getItemValue(0,getRow(),"CustomerID");
		 sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");
		 sSellSum = getItemValue(0,getRow(),"SellSum");
		 sTotalAssets = getItemValue(0,getRow(),"TotalAssets");
		 sIndustryName = getItemValue(0,getRow(),"IndustryName");

         sReturn = RunMethod("CustomerManage","EnterpriseScale",sEmployeeNumber+","+sSellSum+","+sTotalAssets+","+sIndustryName+","+sCustomerID);
         if(sReturn == '2' || sReturn == '3'|| sReturn == '4' || sReturn == '5'){
              setItemValue(0,0,"Scope",sReturn);
         }else if(sReturn == 'NODATA'){
              alert("此行业分类未设定企业参数规模!");
              setItemValue(0,0,"Scope","9");
         }

	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
