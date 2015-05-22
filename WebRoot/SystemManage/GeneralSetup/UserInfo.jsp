<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-15
			Tester:
			Content: 代码表信息详情
			Input Param:
	                    UserID：    代码表编号
	                    ItemNo：    项目编号（新增是不传入）
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
		String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获得组件参数	
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.compParentComponent.getParameter("OrgID"));
	if(sUserID==null) sUserID="";
	String sOrgName = Sqlca.getString("Select OrgName From Org_Info Where OrgID='"+sOrgID+"' ");
	//设置初始密码000000als6
	String sPassword=MessageDigest.getDigestAsUpperHexString("MD5","oooo0000");
	
	//获得页面参数	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UserInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.appendHTMLStyle("UserID", " onBlur=\"javascript:parent.setLogID()\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);
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
			{((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","保存","保存修改","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回到列表界面","doReturn('Y')",sResourcesPath}		
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
    var sCurUserID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if (!ValidityCheck()) return;
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        sUserID = getItemValue(0,getRow(),"UserID");
        if(sUserID!="<%=sUserID%>"){
	        sReturnInfo = RunMethod("PublicMethod","GetColValue","Count(*),USER_INFO,String@UserID@"+sUserID);
	        sReturnInfo = sReturnInfo.split('@');
	        if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
			{
				if(sReturnInfo[1] >= 1)
				{
					alert("已有相同编号的用户存在！");
					return;
				}
				//如果是新增用户，设置初始密码000000als6
				if(bIsInsert)
				setItemValue(0,0,"Password","<%=sPassword%>");
			}
       }
       as_save("myiframe0","");
       bIsInsert=false;
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
        //OpenPage("/SystemManage/GeneralSetup/UserList.jsp","_self","");
		sObjectNo = getItemValue(0,getRow(),"UserID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	var bIsInsert = false;
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrg()
	{		
		sParaString = "OrgID,"+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
	}
	
	function setLogID()
	{
		sUserID = getItemValue(0,getRow(),"UserID");
	    setItemValue(0,0,"LoginID",sUserID);
	}
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"BelongOrg","<%=sOrgID%>");
            setItemValue(0,0,"BelongOrgName","<%=sOrgName%>");
            bIsInsert = true;
		}
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
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
		
		//2：校验住宅电话
		sCompanyTel = getItemValue(0,getRow(),"CompanyTel");//单位电话	
		if(typeof(sCompanyTel) != "undefined" && sCompanyTel != "" )
		{
			if(!CheckPhoneCode(sCompanyTel))
			{
				alert(getBusinessMessage('203'));//单位电话有误！
				return false;
			}
		}
		
		//3：校验手机号码
		sMobileTel = getItemValue(0,getRow(),"MobileTel");//手机号码
		if(typeof(sMobileTel) != "undefined" && sMobileTel != "" )
		{
			if(!CheckPhoneCode(sMobileTel))
			{
				alert(getBusinessMessage('204'));//手机号码有误！
				return false;
			}
		}
		
		//4：校验电子邮箱
		sEmail = getItemValue(0,getRow(),"Email");//电子邮箱	
		if(typeof(sEmail) != "undefined" && sEmail != "" )
		{
			if(!CheckEMail(sEmail))
			{
				alert(getBusinessMessage('205'));//电子邮箱有误！
				return false;
			}
		}		
		return true;	
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	var bFreeFormMultiCol=true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>

