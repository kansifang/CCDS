<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql="";
	iPostChange=5;
	//获得页面参数	
	String sSelectName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F2")));
	String sStyle =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F3")));
	String sColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F4")));
	String sTableName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F5")));
	String sKeyColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F6")));
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("type")));
	String sFilterColumn=sKeyColumn;
	String PG_TITLE = sSelectName+"@WindowTitle"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	if("01".equals(sStyle)){
		ASResultSet rs=Sqlca.getASResultSet("select * from "+sTableName);
		int CCount=rs.getColumnCount();
		StringBuffer sb=new StringBuffer("Select ");
		for(int i=1;i<=CCount;i++){
			sb.append(rs.getColumnName(i)+",");
		}
		sb.delete(sb.lastIndexOf(","),sb.length());
		sb.append(" from "+sTableName+" where 1=1");
		rs.getStatement().close();	
		sSql = sb.toString();
	}else if("02".equals(sStyle)){
		sSql=sColumn.replaceAll("<.+?>", " ");
		sSql=sSql.replaceAll("&nbsp;", " ");
		sSql=sSql.replaceAll("\\s", " ");
		sSql=sSql.replaceAll("&lt;", "<");
		sSql=sSql.replaceAll("&gt;", ">");
	}else{//通过数据库查询出查询语句来执行查询
		StringBuffer sb=new StringBuffer("");
		ASResultSet rs1 = Sqlca.getResultSet("select ContentLength,Remark from Doc_Attachment"+
								" where AttachmentNo='"+sAttachmentNo+"'");
		
		if(rs1.next()){	
			String sFilterC=DataConvert.toString(rs1.getString("Remark"));
			if(!"".equals(sFilterC)){
				if(!"".equals(sFilterColumn)){
					sFilterColumn+=","+sFilterC;
				}else{
					sFilterColumn=sFilterC;
				}
			}
			int iContentLength=DataConvert.toInt(rs1.getString("ContentLength"));
			if (iContentLength>0){
				byte bb[] = new byte[iContentLength];
				int iByte = 0;		
				java.io.InputStream inStream = null;
				ASResultSet rs2 = Sqlca.getResultSet2("select DocContent from Doc_Attachment"+
						" where AttachmentNo='"+sAttachmentNo+"'");//注意是getResultSet2
				if(rs2.next()){
					inStream = rs2.getBinaryStream("DocContent");
					while(true){
						iByte = inStream.read(bb);
						if(iByte<=0)
							break;
						sb.append(new String(bb,"GBK"));
					}
				}
				rs2.getStatement().close();
			}
		}
		rs1.getStatement().close();	
		sSql=sb.toString().replaceAll("\"", "'");
		sSql=sb.toString().replaceAll("&nbsp;", " ");
	}
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable=sTableName;
	doTemp.setKey(sKeyColumn,true);
	//doTemp.setHeader(sHeaders);
	//doTemp.setHTMLStyle("DatabaseID"," style={width:160px} ");
	//doTemp.setCheckFormat(sNumberColumn,"3");
	//doTemp.setType(sStringColumn,"1");
	//查询
 	doTemp.setColumnAttribute(sFilterColumn,"IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);
	
	//生成HTMLDataWindow
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
		String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			//{"false","","Button","更新","更新数据库","convertStyle()",sResourcesPath},
			//{"true","","Button","保存","保存所有修改,并返回列表页面","save()",sResourcesPath},
			};
		if("02".equals(sStyle)){
			sButtons[0][0]="false";
			sButtons[1][0]="false";
			sButtons[2][0]="false";
		}
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
		popComp("QResultInfo","/Common/Configurator/MetaDataManage/QResultInfo.jsp","tableName=<%=sTableName%>&keyColumn=<%=sKeyColumn%>","");
		reloadSelf();
	}
	function save(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sKeyC="<%=sKeyColumn%>";
		var sKeyCs=sKeyC.split(",");
		var key1 = getItemValue(0,getRow(),sKeyCs[0].toUpperCase());
		if (typeof(key1)=="undefined" || key1.length==0)
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
		var sKeyIDs="<%=sKeyColumn%>".split(",");
		var keyID1 = getItemValue(0,getRow(),sKeyIDs[0].toUpperCase());
		if (typeof(keyID1)=="undefined" || keyID1.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var KeyValues="";
		for(var i=0;i<sKeyIDs.length;i++){
			KeyValues+=getItemValue(0,getRow(),sKeyIDs[i].toUpperCase())+"@";
		}
		KeyValues=KeyValues.substring(0,KeyValues.length-1);
		popComp("QResultInfo","/Common/Configurator/MetaDataManage/QResultInfo.jsp","tableName=<%=sTableName%>&keyColumn=<%=sKeyColumn%>&KeyValues="+KeyValues,"");
		reloadSelf();
	}
	

	/*~[Describe=转换数据库样式：01单表维护 02统计查询  ;InputParam=无;OutPutParam=无;]~*/
	function convertStyle(){
		sDatabaseID=getItemValue(0,getRow(),"DatabaseID");
		if (typeof(sDatabaseID)=="undefined" || sDatabaseID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//01@tablename@keycolumn
		//02@columns@tablename@whereclause
		var styleValue=PopPage("/Common/Configurator/MetaDataManage/DatabaseStyleConvert.jsp?DatabaseID="+sDatabaseID,"","");
		OpenComp("TMetaDatabase","/Common/Configurator/MetaDataManage/DatabaseList.jsp","style="+styleValue,"right","")
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
