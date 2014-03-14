<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   wlu 2009-02-13
			Tester:
			Content: 机构管理列表
			Input Param:
	                  
			Output param:             


		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "授权管理列表"; // 浏览器窗口标题
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	
	//获取组件参数
	
	//获取页面参数
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = {	
					{"SerialNo","编号"},
					{"AuthorizationType","授权类型"},
					{"AuthorizationTypeName","授权类型"},
					{"UserID","用户名"},
					{"BusinessType","业务品种"},
					{"BusinessSumCurrency","授权金额币种"},
					{"BusinessSum","授权金额"},
					{"BusinessExposureCurrency","授权敞口金额币种"},
					{"BusinessExposure","授权敞口金额"}													
	                       }; 

	String sSql = " select SerialNo,AuthorizationType,getItemName('AuthorizationType',AuthorizationType) as AuthorizationTypeName, "+
		  " getUserName(UserID) as UserID, getBusinessName(BusinessType) as BusinessType,"+
		  " getItemName('Currency',BusinessSumCurrency) as BusinessSumCurrency, BusinessSum, "+
		  " getItemName('Currency',BusinessExposureCurrency) as BusinessExposureCurrency,BusinessExposure "+
		  " from USER_AUTHORIZATION "+
		  " where 1=1 order by SerialNo";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_AUTHORIZATION";
	doTemp.setKey("SerialNo",true);	 //为后面的删除

	//设置不可见项
	doTemp.setVisible("AuthorizationType",false);
	//设置下拉列表
	doTemp.setDDDWCode("AuthorizationType","AuthorizationType");	
	//设置显示项
	doTemp.setUpdateable("UserID,BusinessType",false);
	doTemp.setHTMLStyle("AuthorizationTypeName,BusinessSumCurrency,BusinessExposureCurrency"," style={width:80px} ");
	doTemp.setHTMLStyle("SerialNo,BusinessType,UserID,BusinessSum,BusinessExposure"," style={width:150px} ");
	doTemp.setType("BusinessSum,BusinessExposure","number");
	doTemp.setAlign("BusinessSum,BusinessExposure","3");
	doTemp.setAlign("AuthorizationTypeName,BusinessSumCurrency,BusinessExposureCurrency","2");

	//filter过滤条件
    doTemp.setFilter(Sqlca,"1","UserID","");
 	doTemp.setFilter(Sqlca,"2","BusinessType","");
 	doTemp.setFilter(Sqlca,"3","AuthorizationType","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

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
		String sButtons[][] = 
		{
			{"true","","Button","新增","新增授权","newRecord()",sResourcesPath},
			{"true","","Button","查看详情","查看详情/修改","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除该授权","deleteRecord()",sResourcesPath},
			
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

		/*~[Describe=新增授权记录;InputParam=无;OutPutParam=无;]~*/
		function newRecord(){
			sReturn = popComp("AuthorizationInfo","/Common/Configurator/Authorization/AuthorizationInfo.jsp","","");
			reloadSelf();
		}

		/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
		function viewAndEdit(){
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}

			sReturn = popComp("AuthorizationInfo","/Common/Configurator/Authorization/AuthorizationInfo.jsp","SerialNo="+sSerialNo,"");
			//修改数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				reloadSelf();
			}
		}
    
		/*~[Describe=从当前列表中删除该记录;InputParam=无;OutPutParam=无;]~*/
		function deleteRecord(){   
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			if(confirm(getHtmlMessage("2")))//您真的想删除该信息吗？
			{
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	function mySelectRow(){     
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
