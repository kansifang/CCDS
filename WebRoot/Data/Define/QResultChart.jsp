<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.app.display.*" %>
<%@page import="org.jfree.chart.ChartFactory,org.jfree.chart.ChartUtilities,org.jfree.chart.plot.*,
org.jfree.chart.JFreeChart,
com.sun.org.apache.xerces.internal.impl.dv.util.Base64,
com.lmt.app.cms.explain.AmarMethod
"%>
<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";
	iPostChange=5;
	//���ҳ�����	
	
	
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AttachmentNo")));
	//01�б� 02 ��״ͼ 03��״ͼ04����ͼ 
	String sOneKey =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OneKey")));
	String sHandlerFlag =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("HandlerFlag")));
	String sDimension =   DataConvert.toString(DataConvert.toRealString(1,(String)CurPage.getParameter("Dimension")));
	
	//String sSelectName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F2")));
	//String sKeyColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F6")));
	
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//1��ͨ�����ݿ��ѯ����ѯ�����ִ�в�ѯ
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
										" where AttachmentNo='"+subAttachmentNo+"'");//ע����getResultSet2
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
			//��SQL���д���
			sSql=sb.toString().replaceAll("<.+?>", " ");
			sSql=sSql.replaceAll("&nbsp;", " ");
			sSql=sSql.replaceAll("\\s", " ");
			sSql=sSql.replaceAll("&lt;", "<");
			sSql=sSql.replaceAll("&gt;", ">");
				//2������ ~s�����ϸ@��������e~ �ı����滻
			sSql=StringUtils.replaceWithConfig(sSql,Sqlca);
				//����last1yearend������ĩ�� last1month �ϸ���֮��Ϊ����������
			sSql=StringUtils.replaceWithRealDate(sSql, sOneKey);
			sSql =StringFunction.replace(sSql, "~YH~", "\"");
			sSql =StringFunction.replace(sSql, "#OneKey",sOneKey);
			sSql =StringFunction.replace(sSql, "#HandlerFlag",sHandlerFlag.toUpperCase());
			sSql =StringFunction.replace(sSql, "#Dimension",sDimension);
			//����SQL�Ϳ������ɱ���ͼ����
			if("01".equals(sDisplayType)){//ͳ�Ʊ�
				ASDataObject doTemp = new ASDataObject(sSql);
				if(!"".equals(sKeyColumn)){
					doTemp.setKey(sKeyColumn,true);
				}
				//doTemp.setHeader(sHeaders);
				//doTemp.setHTMLStyle(0," style={width:260px} ");
				//doTemp.setCheckFormat(sNumberColumn,"3");
				//doTemp.setType(sStringColumn,"1");
				doTemp.setHTMLStyle(0,"style={width:280px}");//��һ����Ŀ�ӿ�
				//��ѯ��
				if(!"".equals(sFilterColumn)){
					doTemp.setColumnAttribute(sFilterColumn,"IsFilter","1");
					doTemp.generateFilters(Sqlca);
					doTemp.parseFilterData(request,iPostChange);
					CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
				}
				//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
				ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
				dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
				dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
				dwTemp.setPageSize(40);
				
				//����HTMLDataWindow
				Vector vTemp = dwTemp.genHTMLDataWindow("");
			%>
			<div style="position:absolute; overflow:auto;">
			<%
				for(int i=0;i<vTemp.size();i++) 
					out.print((String)vTemp.get(i));
			%>
			</div>
			<%//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��
			String sButtons[][] = {
				{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
				{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
				//{"false","","Button","����","�������ݿ�","convertStyle()",sResourcesPath},
				//{"true","","Button","����","���������޸�,�������б�ҳ��","save()",sResourcesPath},
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
				if("02".equals(sDisplayType)){//��״ͼ
					// ������״ͼ����
					//JFreeChart jf = ChartFactory.createPieChart("", PieChart.getDataSet(sSql,Sqlca), true, true, true);
					jf = PieChart.getJfreeChart(sSql, Sqlca);
				}else if("03".equals(sDisplayType)){//��״ͼ
					// ������״ͼ����
					jf =BarChart.getJfreeChart(sSql, Sqlca);
				}else if("04".equals(sDisplayType)){//����ͼ
					// ��������ͼ����
					//JFreeChart jf = LineChart.createChart(sSql, Sqlca);
					jf =LineChart.getJfreeChart(sSql, Sqlca);
				}
				%>
				<div style="position:absolute;overflow:auto;">
				<%
				response.setContentType("image/jpeg");
				//���ͼƬ
				ChartUtilities.writeChartAsJPEG(response.getOutputStream(), jf, 700, 450);
				%>
				</div>
				<%
				//��ͼ�����ֽ����飬���浽���ݿ⣬��Ϊ�����Wordʱ��ѯʹ��
				//�ж��Ƿ��ѱ���ͼ������
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
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
	<%
		
	%> 
<%
 	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
	
%>
	
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	function save(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sKeyC="<%=sKeyColumn%>";
		var sKeyCs=sKeyC.split(",");
		var key1 = getItemValue(0,getRow(),sKeyCs[0].toUpperCase());
		if (typeof(key1)=="undefined" || key1.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=ת�����ݿ���ʽ��01����ά�� 02ͳ�Ʋ�ѯ  ;InputParam=��;OutPutParam=��;]~*/
	function convertStyle(){
		sDatabaseID=getItemValue(0,getRow(),"DatabaseID");
		if (typeof(sDatabaseID)=="undefined" || sDatabaseID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
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
