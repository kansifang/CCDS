<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.app.display.PieChart" %>
<%@page import="org.jfree.chart.ChartFactory,org.jfree.chart.ChartUtilities,
org.jfree.chart.JFreeChart"%>
<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";
	iPostChange=5;
	//���ҳ�����	
	String sSelectName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F2")));
	String sStyle =   DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F3")));
	String sColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F4")));
	String sTableName = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F5")));
	String sKeyColumn = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("R0F6")));
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AttachmentNo")));
	String sFilterColumn=sKeyColumn;
	String PG_TITLE = sSelectName+"@WindowTitle"; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//1��ͨ�����ݿ��ѯ����ѯ�����ִ�в�ѯ
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
					" where AttachmentNo='"+sAttachmentNo+"'");//ע����getResultSet2
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
	sSql=sb.toString().replaceAll("<.+?>", " ");
	sSql=sSql.replaceAll("&nbsp;", " ");
	sSql=sSql.replaceAll("\\s", " ");
	sSql=sSql.replaceAll("&lt;", "<");
	sSql=sSql.replaceAll("&gt;", ">");
	//2������ ~s�����ϸ@��������e~ �ı����滻
	sSql=StringUtils.replaceWithConfig(sSql, "~s", "e~", Sqlca);
	sSql =StringFunction.replace(sSql, "~YH~", "\"");
	response.setContentType("image/jpeg");
	// ������״ͼ����
	JFreeChart jf = ChartFactory.createPieChart("ռ��ͳ��", PieChart.getDataSet(sSql,Sqlca), true, true, true);
	PieChart.setStyle(jf);
	ChartUtilities.writeChartAsJPEG(response.getOutputStream(), jf, 400, 300);

%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
	<%
		//����Ϊ��
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//as_add("myiframe0");//������¼
		popComp("QResultInfo","/Common/Configurator/MetaDataManage/QResultInfo.jsp","tableName=<%=sTableName%>&keyColumn=<%=sKeyColumn%>","");
		reloadSelf();
	}
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

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sKeyIDs="<%=sKeyColumn%>".split(",");
		var keyID1 = getItemValue(0,getRow(),sKeyIDs[0].toUpperCase());
		if (typeof(keyID1)=="undefined" || keyID1.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
		OpenComp("TMetaDatabase","/Common/Configurator/MetaDataManage/DatabaseList.jsp","style="+styleValue,"right","")
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
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
