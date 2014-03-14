<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: 企业债券发行信息_List
			Input Param:
		                CustomerID：客户编号
		                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
			Output param:
			                CustomerID：当前客户对象的客户号
			              	Issuedate:发行日期
			              	BondType:债券类型
			                CustomerRight:权限代码
			                EditRight:编辑权限代码----01查看权，02编辑权
			History Log: 
			                 2003.08.20 CYHui
			                 2003.08.28 CYHui
			                 2003.09.08 CYHui 
		 */
	%>
<%
	/*~END~*/
%>





<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	String PG_TITLE = "查询历史@WindowTitle"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql;
	
	//获得页面参数	
	//01@tablename@keycolumn 或  02@columns@tablename@whereclause
	String sDocNo=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("docNo")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sTempletNo = "QDefinition";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.setEditStyle("FileName,Column,TableName,KeyColumn,Remark", "1");
	doTemp.setHTMLStyle("FileName,Column,TableName,KeyColumn,Remark", "");
	//查询
 	//doTemp.setColumnAttribute(sKeyColumn,"IsFilter","1");
	doTemp.generateFilters(Sqlca);
	
	doTemp.parseFilterData(request,iPostChange);
	ASDataObjectFilter adof=(ASDataObjectFilter)doTemp.Filters.get(2);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
	String value=DataConvert.toString(adof.sFilterInputs[0][1]);
	if(value.length()>0){
		StringBuffer sb=new StringBuffer("(");
		ASResultSet rs1 = Sqlca.getResultSet("select ContentLength,AttachmentNo from Doc_Attachment"+
									" where DocNo='"+sDocNo+"'");
		while(rs1.next()){		
			int iContentLength=DataConvert.toInt(rs1.getString("ContentLength"));
			if (iContentLength>0){
				String sColumn="";
				String sAttachmentNo=rs1.getString("AttachmentNo");
				byte bb[] = new byte[iContentLength];
				int iByte = 0;		
				java.io.InputStream inStream = null;
				ASResultSet rs2 = Sqlca.getResultSet2("select DocContent from Doc_Attachment"+
															" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				if(rs2.next()){
					inStream = rs2.getBinaryStream("DocContent");
					while(true){
						iByte = inStream.read(bb);
						if(iByte<=0)
							break;
						sColumn = sColumn + new String(bb,"GBK");
					}
					sColumn=sColumn.replaceAll("\"", "'");
					if(StringFunction.isLike(sColumn, "%"+value+"%")){
						sb.append("'"+sAttachmentNo+"',");
					}
				}
				rs2.getStatement().close();
			}
		}
		rs1.getStatement().close();	
		if(sb.indexOf(",")!=-1){
			sb.deleteCharAt(sb.lastIndexOf(","));
		}else{//没有匹配
			sb.append("''");
		}
		sb.append(")");
		dwTemp.DataObject.WhereClause="where DocNo='"+sDocNo+"' and AttachmentNo in"+sb.toString();
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(""+sDocNo+",All");
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
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"false","","Button","维护","维护数据库","handleDatabase()",sResourcesPath}
			//{"true","","Button","保存","保存所有修改,并返回列表页面","save()",sResourcesPath},
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		//as_add("myiframe0");//新增记录
		popComp("QDefinitionInfo","/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp","docNo=<%=sDocNo%>","");
		reloadSelf();
	}
	function save(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");;
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		//RunMethod("公用方法","GetColValue","Flow_Task,PhaseOpinion");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("QDefinitionInfo","/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp","docNo=<%=sDocNo%>&attachmentNo="+sAttachmentNo+"&method=1","");
		//var styleValue=PopPage("/Common/Configurator/MetaDataManage/DatabaseStyleConvert.jsp?DatabaseID="+sDatabaseID,"","");
		//OpenComp("TMetaDatabase","/Common/Configurator/MetaDataManage/DatabaseList.jsp","style="+styleValue,"right","")
		reloadSelf();
	}
	function handleDatabase()
	{
		var sQStyle = getItemValue(0,getRow(),"QStyle");
		var sColumn1 = getItemValue(0,getRow(),"Column1");
		var sColumn2 = getItemValue(0,getRow(),"Column2");
		var sColumn3 = getItemValue(0,getRow(),"Column3");
		var sColumn4 = getItemValue(0,getRow(),"Column4");
		var sColumn5 = getItemValue(0,getRow(),"Column5");
		var sColumn6 = getItemValue(0,getRow(),"Column6");
		var sColumn7 = getItemValue(0,getRow(),"Column7");
		var sColumn8 = getItemValue(0,getRow(),"Column8");
		var sTableName = getItemValue(0,getRow(),"TableName");
		var sCondition1 = getItemValue(0,getRow(),"Condition1");
		var sCondition2 = getItemValue(0,getRow(),"Condition2");
		var sCondition3 = getItemValue(0,getRow(),"Condition3");
		var sCondition4 = getItemValue(0,getRow(),"Condition4");
		var sKeyColumn = getItemValue(0,getRow(),"KeyColumn");
		var sQName = getItemValue(0,getRow(),"QName");
		if (typeof(sQStyle)=="undefined" || sQStyle.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var paraString="style="+sQStyle+
				"&column1="+sColumn1+"&column2="+sColumn2+"&column3="+sColumn3+"&column4="+sColumn4+"&column5="+sColumn5+"&column6="+sColumn6+"&column7="+sColumn7+"&column8="+sColumn8+
				"&tableName="+sTableName+
				"&condition1="+sCondition1+"&condition2="+sCondition2+"&condition3="+sCondition3+"&condition4="+sCondition4+
				"&keyColumn="+sKeyColumn+"&selectName="+sQName;
		popComp("QResultList","/Common/Configurator/MetaDataManage/QResultList.jsp",paraString,"");
		//var styleValue=PopPage("/Common/Configurator/MetaDataManage/DatabaseStyleConvert.jsp?DatabaseID="+sDatabaseID,"","");
		//OpenComp("TMetaDatabase","/Common/Configurator/MetaDataManage/DatabaseList.jsp","style="+styleValue,"right","")
		reloadSelf();
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	
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
