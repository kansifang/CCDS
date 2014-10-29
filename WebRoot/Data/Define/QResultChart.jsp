<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.app.display.*" %>
<%@page import="org.jfree.chart.ChartFactory,org.jfree.chart.ChartUtilities,org.jfree.chart.plot.*,
org.jfree.chart.JFreeChart,
com.sun.org.apache.xerces.internal.impl.dv.util.Base64,
com.lmt.app.cms.explain.AmarMethod
"%>
<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql="";
	iPostChange=5;
	//获得页面参数	
	
	
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AttachmentNo")));
	//01列表 02 饼状图 03柱状图04折线图 
	String sOneKey =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OneKey")));
	String sHandlerFlag =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("HandlerFlag")));
	String sDimension =   DataConvert.toString(DataConvert.toRealString(1,(String)CurPage.getParameter("Dimension")));
	
	//String sSelectName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F2")));
	//String sKeyColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F6")));
	
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	//1、通过数据库查询出查询语句来执行查询
	StringBuffer sb=null;
	ASResultSet rs1 = Sqlca.getResultSet("select AttachmentNo,ContentLength,Remark,FileName,Attribute2,Attribute3,FullPath"+
			" from Doc_Attachment"+
			" where AttachmentNo in('"+sAttachmentNo.replaceAll("@", "','")+"')");
	String tabName="",sDisplayType="",IsUpdate="",sFilterColumn="",sKeyColumn="";
	while(rs1.next()){	
		String subAttachmentNo=rs1.getString("AttachmentNo");
		tabName=DataConvert.toString(rs1.getString("FileName"));
		PG_TITLE=tabName+"@PageTitle";//WindowTitle
		sDisplayType=DataConvert.toString(rs1.getString("Attribute2"));
		IsUpdate=DataConvert.toString(rs1.getString("Attribute3"));
		sKeyColumn=DataConvert.toString(rs1.getString("FullPath"));
		sFilterColumn=DataConvert.toString(rs1.getString("Remark"));
		int iContentLength=rs1.getInt("ContentLength");
		if(iContentLength>0){
			byte bb[] = new byte[iContentLength];
			int iByte = 0;		
			java.io.InputStream inStream = null;
			ASResultSet rs2 = Sqlca.getResultSet2("select DocContent from Doc_Attachment"+
										" where AttachmentNo='"+subAttachmentNo+"'");//注意是getResultSet2
			if(rs2.next()){
				inStream = rs2.getBinaryStream("DocContent");
				sb=new StringBuffer("");
				while(true){
					iByte = inStream.read(bb);
					if(iByte<=0)
						break;
					sb.append(new String(bb,"GBK"));
				}
			}
			rs2.getStatement().close();
			//对SQL进行处理
			sSql=sb.toString().replaceAll("<.+?>", " ");
			sSql=sSql.replaceAll("&nbsp;", " ");
			sSql=sSql.replaceAll("\\s", " ");
			sSql=sSql.replaceAll("&lt;", "<");
			sSql=sSql.replaceAll("&gt;", ">");
				//2、形如 ~s借据明细@归属条线e~ 的变量替换
			sSql=StringUtils.replaceWithConfig(sSql,Sqlca);
				//更新last1yearend（上年末） last1month 上个月之类为真正的日期
			sSql=StringUtils.replaceWithRealDate(sSql, sOneKey);
			sSql =StringFunction.replace(sSql, "~YH~", "\"");
			sSql =StringFunction.replace(sSql, "#OneKey",sOneKey);
			sSql =StringFunction.replace(sSql, "#HandlerFlag",sHandlerFlag.toUpperCase());
			sSql =StringFunction.replace(sSql, "#Dimension",sDimension);
			//有了SQL就可以生成表格和图表了
			if("01".equals(sDisplayType)){//统计表
				ASDataObject doTemp = new ASDataObject(sSql);
				if(!"".equals(sKeyColumn)){
					doTemp.setKey(sKeyColumn,true);
				}
				//doTemp.setHeader(sHeaders);
				//doTemp.setHTMLStyle(0," style={width:260px} ");
				//doTemp.setCheckFormat(sNumberColumn,"3");
				//doTemp.setType(sStringColumn,"1");
				doTemp.setHTMLStyle(0,"style={width:280px}");//第一列项目加宽
				//查询框
				if(!"".equals(sFilterColumn)){
					doTemp.setColumnAttribute(sFilterColumn,"IsFilter","1");
					doTemp.generateFilters(Sqlca);
					doTemp.parseFilterData(request,iPostChange);
					CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
				}
				//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
				ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
				dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
				dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
				dwTemp.setPageSize(40);
				
				//生成HTMLDataWindow
				Vector vTemp = dwTemp.genHTMLDataWindow("");
			%>
			<div style="position:absolute; overflow:auto;">
			<%
				for(int i=0;i<vTemp.size();i++) 
					out.print((String)vTemp.get(i));
			%>
			</div>
			<%//依次为：
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
			if("02".equals(sDisplayType)){
				sButtons[0][0]="false";
				sButtons[1][0]="false";
				sButtons[2][0]="false";
			}
			%>
			<%@include file="/Resources/CodeParts/List05.jsp"%>
			<%
			}else{
				JFreeChart jf=null;
				if("02".equals(sDisplayType)){//饼状图
					// 创建饼状图对象
					//JFreeChart jf = ChartFactory.createPieChart("", PieChart.getDataSet(sSql,Sqlca), true, true, true);
					jf = PieChart.getJfreeChart(sSql, Sqlca);
				}else if("03".equals(sDisplayType)){//柱状图
					// 创建柱状图对象
					jf =BarChart.getJfreeChart(sSql, Sqlca);
				}else if("04".equals(sDisplayType)){//折线图
					// 创建折线图对象
					//JFreeChart jf = LineChart.createChart(sSql, Sqlca);
					jf =LineChart.getJfreeChart(sSql, Sqlca);
				}
				%>
				<div style="position:absolute;overflow:auto;">
				<%
				response.setContentType("image/jpeg");
				//输出图片
				ChartUtilities.writeChartAsJPEG(response.getOutputStream(), jf, 700, 450);
				%>
				</div>
				<%
				//把图生成字节数组，保存到数据库，作为输出到Word时查询使用
				//判断是否已保存图像数据
			    String sWhere="HandlerFlag=upper('"+sHandlerFlag+"') and OneKey='"+sOneKey+"'"+" and Dimension='"+sDimension+"' and DimensionValue='"+tabName+"'";
			    String sOneOneKey=Sqlca.getString("select OneKey from Batch_Import_Process where "+sWhere);
			    if(!sOneKey.equals(sOneOneKey)){
					Sqlca.executeSQL("insert into Batch_Import_Process "+
			 				"(HandlerFlag,OneKey,Dimension,DimensionValue)"+
			 				"values(upper('"+sHandlerFlag+"'),'"+sOneKey+"','"+sDimension+"','"+tabName+"')");
				}
				if("1".equals(IsUpdate)){
					ByteArrayOutputStream outBA = new ByteArrayOutputStream();  
					ChartUtilities.writeChartAsPNG(outBA, jf, 600, 600);  
				    String base63string=Base64.encode(outBA.toByteArray());
					AmarMethod am=new AmarMethod("PublicMethod","HandleBlobContent",null,Sqlca);
					am.execute("U,Contentlength,Content,Batch_Import_Process,"+sWhere+","+base63string);
				}
			}
		}
	}
	rs1.getStatement().close();	
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
	<%
		
	%> 
<%
 	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
	
%>
	
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------
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
		OpenComp("TMetaDatabase","/Common/Configurator/MetaDataManage/DatabaseList.jsp","style="+styleValue,"right","");
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
	hideFilterArea();
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
