<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: 机构授权维护
			Input Param:
					OrgID:		机构号
					RoleID:		角色号
					ObjectNo:	授权方案序列号
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "业务品种确定"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	
	
	//获得页面参数
	//授权号
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	//控制方法序号（控制方法下面有多个控制条件）
	String sAuthorizeMethodSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthorizeMethodSerialNo"));
	//控制条件序号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//要展示的内容--可维护的控制条件
	String sDisplayContent = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DispayContent"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sAuthorizeMethodSerialNo == null) sAuthorizeMethodSerialNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sDisplayContent == null) sDisplayContent = "";
	//1、新增时插进选择的维度
	if(!"".equals(sDisplayContent)&&sDisplayContent.length()>0){
		int iDisplaySum=0;
		sSerialNo=DBFunction.getSerialNo("Config_Info","SerialNo","yyyyMMdd","000000",new java.util.Date(),Sqlca);
		StringBuffer table=new StringBuffer("Config_Info(SerialNo,");
		StringBuffer value=new StringBuffer("Values('"+sSerialNo+"',");
		String []aDispayContents =sDisplayContent.split("~");
		if(aDispayContents.length>1){
	String[] aValue=aDispayContents[0].split(";");
	String[] aText=aDispayContents[1].split(";");
	iDisplaySum=aValue.length;
	for(int i=0;i<iDisplaySum&&iDisplaySum==aText.length;i++){
		if(!"".equals(aValue[i])&&!"".equals(aText[i])){
			table.append("ItemNo"+(i+1)+","+"ItemName"+(i+1)+",");
			value.append("'"+aValue[i]+"','"+aText[i]+"',");
		}
	}
		}
		
		table.append("ItemExistSum,");
		value.append(iDisplaySum+",");
		table.append("Attribute1,");
		value.append("'"+sAuthorizeMethodSerialNo+"',");
		table.append("InputOrgID,InputUserID,InputDate,UpdateOrgID,UpdateUserID,UpdateDate");
		value.append("'"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+StringFunction.getToday()+"'");
		sSql="insert into "+table.toString()+")"+value.toString()+")";
		Sqlca.executeSQL(sSql);
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		//2、根据已插入的维度，展示出来
		int iItemExistSum=0;//维度数目
		int iExtent=0;//在页面中除了要展示的维度之外要展示的其他要素
		int iBeginIndex=0;//维度开始展示标题下标
		String sHeaders[][]=null;
		String[] aItemNo=null;//存储维度ID，下面查询code_library设置弹出框要用
		StringBuffer sItemValues=new StringBuffer("");
		ASResultSet rs=Sqlca.getASResultSet("select * from Config_Info where SerialNo='"+sSerialNo+"'");
		if(rs.next()){
			iItemExistSum=rs.getInt("ItemExistSum");
			aItemNo =new String[iItemExistSum];
			iExtent=5;//额外展示5个要素
			sHeaders =new String[2*iItemExistSum+iExtent][2];
			sHeaders[iBeginIndex][0]="Describe1";
			sHeaders[iBeginIndex++][1]="控制条件描述";
			for(int i=0;i<iItemExistSum;i++){
		sHeaders[(iBeginIndex)][0]="ItemValue"+(i+1);
		sHeaders[(iBeginIndex++)][1]=rs.getString("ItemName"+(i+1));
		sHeaders[(iBeginIndex)][0]="ItemValueDes"+(i+1);
		sHeaders[(iBeginIndex++)][1]=rs.getString("ItemName"+(i+1));
		sItemValues.append("ItemValue"+(i+1)+","+"ItemValueDes"+(i+1)+",");//（维度值）//sItemValues.append("CAST(ItemValue"+(i+1)+" AS VARCHAR(32672)) AS ItemValue"+(i+1)+","+"CAST(ItemValueDes"+(i+1)+" AS VARCHAR(32672)) AS ItemValueDes"+(i+1)+",");//动态查询字段（维度值） 使用CAST是对 long varchar 比较安全的写法
		aItemNo[i]=rs.getString("ItemNo"+(i+1));//维度号，对应code_library中的ItemNo
			}
			sHeaders[(iBeginIndex)][0]="InputDate";
			sHeaders[(iBeginIndex++)][1]="授权开始日期";
			sHeaders[(iBeginIndex)][0]="UpdateDate";
			sHeaders[(iBeginIndex++)][1]="授权截止日期";
			sHeaders[(iBeginIndex)][0]="InputOrgName";
			sHeaders[(iBeginIndex++)][1]="授权机构";
			sHeaders[(iBeginIndex)][0]="InputUserName";
			sHeaders[(iBeginIndex++)][1]="授权人";
		}
		rs.getStatement().close();
		sSql =  " select SerialNo,Describe1,"+
		  sItemValues.toString()+
		" InputDate,UpdateDate,"+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,"+
		" getOrgName(UpdateOrgID) as UpdateOrgName,getUserName(UpdateUserID) as UpdateUserName"+
		" from Config_Info "+
		" Where SerialNo ='"+sSerialNo+"'";
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable="Config_Info";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,UpdateOrgName,UpdateUserName",false);
		doTemp.setType("Balance1,Balance2","Number");
		doTemp.setCheckFormat("Balance1,Balance2","2");
		doTemp.setRequired("Describe1",true);
		doTemp.setCheckFormat("InputDate,UpdateDate","3");
		doTemp.setReadOnly("InputOrgName,InputUserName",true);
		
		doTemp.setVisible("SerialNo,InputOrgID,InputUserID,UpdateOrgID,UpdateOrgName,UpdateUserID,UpdateUserName",false);
		doTemp.setEditStyle("Describe1","3");
		doTemp.setHTMLStyle("Describe1"," style={height:100px;width:600px} ");
		doTemp.setDDDWCode("IsInUse","YesNo");
		//设置维度值的输入方式
		for(int i=0;i<aItemNo.length;i++){
			rs=Sqlca.getASResultSet("select ItemDescribe,RelativeCode from Code_Library where CodeNo='AuthorizeControlType' and ItemNo='"+aItemNo[i]+"'and IsInUse='1'");
			if(rs.next()){
		String sSelectType=rs.getString(1);
		String sParaString=rs.getString(2);
		if(sSelectType==null)sSelectType="01";
		if(sParaString==null)sParaString=" ";
		sParaString = StringFunction.replace(sParaString,"#SerialNo",sSerialNo);
		sParaString = StringFunction.replace(sParaString,"#CurOrg",CurOrg.OrgID);
		sParaString = StringFunction.replace(sParaString,"#CurUser",CurUser.UserID);
		if("01".equals(sSelectType)){//单选下拉菜单
			doTemp.setVisible("ItemValue"+(i+1),true);
			doTemp.setRequired("ItemValue"+(i+1),true);
			doTemp.setDDDWSql("ItemValue"+(i+1),sParaString);
			doTemp.setVisible("ItemValueDes"+(i+1),false);
		}else if("02".equals(sSelectType)){//多选下拉菜单
			doTemp.setVisible("ItemValue"+(i+1),false);
			doTemp.setReadOnly("ItemValueDes"+(i+1),true);
			doTemp.setRequired("ItemValueDes"+(i+1),true);
			doTemp.setEditStyle("ItemValueDes"+(i+1),"3");
			doTemp.setLimit("ItemValueDes"+(i+1),32672);//这是varchar的最大长度，也是查询语句允许的最大长度
			doTemp.setHTMLStyle("ItemValueDes"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setUnit("ItemValueDes"+(i+1)," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomizeOnDialogue(\""+sParaString+"\",\"ItemValue"+(i+1)+"\",\"ItemValueDes"+(i+1)+"\")>");
		}else if("03".equals(sSelectType)){//弹出页面
			doTemp.setVisible("ItemValue"+(i+1),false);
			doTemp.setReadOnly("ItemValueDes"+(i+1),true);
			doTemp.setRequired("ItemValueDes"+(i+1),true);
			doTemp.setEditStyle("ItemValueDes"+(i+1),"3");
			doTemp.setLimit("ItemValueDes"+(i+1),32672);//这是varchar的最大长度，也是查询语句允许的最大长度
			doTemp.setHTMLStyle("ItemValueDes"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setUnit("ItemValueDes"+(i+1)," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCustomizeOnPage(\""+sParaString+"\",\"ItemValue"+(i+1)+"\",\"ItemValueDes"+(i+1)+"\")>");
		}else if("04".equals(sSelectType)){//大文本框
			doTemp.setVisible("ItemValue"+(i+1),true);
			doTemp.setRequired("ItemValue"+(i+1),true);
			doTemp.setEditStyle("ItemValue"+(i+1),"3");
			doTemp.setLimit("ItemValue"+(i+1),32672);//这是varchar的最大长度，也是查询语句允许的最大长度
			doTemp.setHTMLStyle("ItemValue"+(i+1)," style={height:100px;width:600px} ");
			doTemp.setVisible("ItemValueDes"+(i+1),false);
		}
			}
		}
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="2";      //设置为Grid风格
		
		//生成HTMLDataWindow
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
			{"true","","Button","保存","保存信息","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","goBack()",sResourcesPath}
			};
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
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/PublicInfo/ConfigList.jsp?ObjectNo=<%=sObjectNo%>"+"&AuthorizeMethodSerialNo=<%=sAuthorizeMethodSerialNo%>","DetailFrame",OpenStyle);
	}
	
	/*~[Describe=选择支行机构;InputParam=无;OutPutParam=无;]~*/
	function selectFinalOrg()
	{
			
		//setObjectValue("SelectSubOrg",sParaString,"@FinalOrg@0@FinalOrgName@1",0,0,"");
		setObjectValue("SelectAllOrg","","@OrgID@0@FinalOrgName@1",0,0,"");
		
	}
	 /*~[Describe=弹出选择框，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]
	 	*输入参数：
		*Selects=Column1(显示名称),Column2（返回值）...@TableName@WhereClause~Column1(显示名称),Column2（返回值）...@TableName@WhereClause
	*/
	function selectCustomizeOnDialogue(ParaString,TypeValue,TypeName)
	{
		
		var sTypeValues="",sTypeNames="";
		ParaString =ParaString.replace(/SPACE/g," ");
		var sReturn = PopPage("/PublicInfo/MultiSelectDialogue.jsp?"+ParaString,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_none_")
		{
			var sTypeInfo = sReturn.split("~");
			if(sTypeInfo.length>1){
				//var aTypeInfo=sTypeInfo[1].match(/;/gi);//返回sTypeInfo中";"组成的数组
				setItemValue(0,getRow(),TypeValue,sTypeInfo[0]);
				setItemValue(0,getRow(),TypeName,sTypeInfo[1]);					
			}
						
		}
	}
	/*校验中文（2个字节）英文混合字符串的长度
	var aTypeInfo0=sTypeInfo[0].split(";");
				var aTypeInfo1=sTypeInfo[1].split(";");
				var iLength=0,i=0;
				for(i=0;i<aTypeInfo1.length;i++){
					iLength +=aTypeInfo1[i].length*2+1;
					if(iLength<700){
						continue;
					}else{
						alert(aTypeInfo1[i]+"及之后内容由于长度限制无法选择，请新增授权进行补充！");
						break;
					}
				}
				if(i===aTypeInfo1.length){
					setItemValue(0,getRow(),TypeValue,sTypeInfo[0]);
					setItemValue(0,getRow(),TypeName,sTypeInfo[1]);
				}else{
					setItemValue(0,getRow(),TypeValue,sTypeInfo[0].substr(0,sTypeInfo[0].indexOf(aTypeInfo0[i])));
					setItemValue(0,getRow(),TypeName,sTypeInfo[1].substr(0,sTypeInfo[1].indexOf(aTypeInfo1[i])));
				}
	*/
	/*~[Describe=弹出选择页面选择（支持多选）;InputParam=无;OutPutParam=无;]
 	*输入参数：
		*#Columns Column1:###@Column2:###...
		*#Table 表明
		*#WhereClause 查询条件 
		*#FieldName 弹出页面标题 格式：Column1(标题),Column2(标题)...
		*#ReturnValue 返回值 格式：Column1,Column2...
		*#FilterValue  查询条件 格式：Column1,Column2...
		*#Compart 返回值分隔符
	*/
	function selectCustomizeOnPage(sParaString,TypeValue,TypeName)
	{
		var sTypeValues="",sTypeNames="";
		sParaString =sParaString.replace(/SPACE/g," ");
		var sReturn=setObjectValue("SelectCustomizeWithMulti",sParaString,"",0,0,"");
		if(typeof(sReturn)!=='undefined'&&sReturn!=='_CLEAR_'){
			var sTypeInfo = sReturn.split(';');
			for(var i=0;i<sTypeInfo.length;i=i+2){
				sTypeValues=sTypeValues+sTypeInfo[i]+";";
			}
			for(i=1;i<sTypeInfo.length;i=i+2){
				sTypeNames = sTypeNames + sTypeInfo[i]+";";
			}
			setItemValue(0,getRow(),TypeValue,sTypeValues);
			setItemValue(0,getRow(),TypeName,sTypeNames);
		}
	}
	//重写common.js中的方法,以选择MultiSelectDialogBefore.jsp作为新的弹出页面，此弹出框支持通过参数设置 标题、返回值、查询条件等
	function selectObjectValue(sObjectType,sParaString,sStyle)
	{
		if(typeof(sStyle)=="undefined" || sStyle=="") 
			sStyle = "dialogWidth:680px;dialogHeight:540px;resizable:yes;scrollbars:no;status:no;help:no";
		var sObjectNoString = PopPage("/PublicInfo/MultiSelectPageBefore.jsp?SelName="+sObjectType+"&ParaString="+sParaString,"",sStyle);
		return sObjectNoString;
	}	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>
	<script language=javascript>	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{	
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			bIsInsert = true;
		}
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
    }
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>
//bFreeFormMultiCol=true;
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
