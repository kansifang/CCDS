<%@ page contentType="text/html;charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

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
	}else{//ͨ�����ݿ��ѯ����ѯ�����ִ�в�ѯ
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
	}
	//���� ~s�����ϸ@��������e~ �ı����滻
	while(sSql.indexOf("~s")!=-1){
		int ss=sSql.indexOf("~s");
		int se=sSql.indexOf("e~");
		String toReplaceS="";
		if(se+2>sSql.length()){
			toReplaceS=sSql.substring(ss,sSql.length());
		}else{
			toReplaceS=sSql.substring(ss, se+2);
		}
		String configContent=sSql.substring(ss+2, se);
		String[] configContentA=configContent.split("@");
		String ssSql="select ItemDescribe from Code_Library CL "+
				"where Attribute1='"+configContentA[1].trim()+"' and IsInUse='1' "+
				"and exists(select 1 from Code_Catalog CC where CC.CodeNo=CL.CodeNo and CC.CodeName='"+configContentA[0].trim()+"')";
		String sReplaceS=Sqlca.getString(ssSql);
		sSql =StringFunction.replace(sSql, toReplaceS, sReplaceS);
		//sSql=sSql.replaceAll(toReplaceS, sReplaceS);
	};
	sSql =StringFunction.replace(sSql, "~YH~", "\"");
	ASDataObject doTemp = new ASDataObject(sSql);
	//����sql�����һ���ֶ��ж��  as ������Ч��ñ����������� ���Լ� sql�����������ֿ�ͷʱ����������˫��������������Ҳ�����γɱ���ʱ˫���ŷ�������ȥ��
	for (int i=0;i<doTemp.Columns.size();i++){
		String sHeader=doTemp.getColumnAttribute(i, "Header");
		if(sHeader.lastIndexOf(" as ")!=-1){
			sHeader=sHeader.substring(sHeader.lastIndexOf(" as ")+3);
		}
		doTemp.setColumnAttribute(i, "Header", sHeader.replace("\"", ""));
	}
	doTemp.UpdateTable=sTableName;
	doTemp.setKey(sKeyColumn,true);
	//doTemp.setHeader(sHeaders);
	//doTemp.setHTMLStyle("DatabaseID"," style={width:160px} ");
	//doTemp.setCheckFormat(sNumberColumn,"3");
	//doTemp.setType(sStringColumn,"1");
	//��ѯ
 	doTemp.setColumnAttribute(sFilterColumn,"IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
	<%@include file="/Resources/CodeParts/List05.jsp"%>
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
	hideFilterArea();
</script>	
<%
		/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp"%>
