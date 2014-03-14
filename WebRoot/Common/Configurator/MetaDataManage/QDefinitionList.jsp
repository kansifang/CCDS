<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: ��ҵծȯ������Ϣ_List
			Input Param:
		                CustomerID���ͻ����
		                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
			Output param:
			                CustomerID����ǰ�ͻ�����Ŀͻ���
			              	Issuedate:��������
			              	BondType:ծȯ����
			                CustomerRight:Ȩ�޴���
			                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
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
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	String PG_TITLE = "��ѯ��ʷ@WindowTitle"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql;
	
	//���ҳ�����	
	//01@tablename@keycolumn ��  02@columns@tablename@whereclause
	String sDocNo=DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("docNo")));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sTempletNo = "QDefinition";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.setEditStyle("FileName,Column,TableName,KeyColumn,Remark", "1");
	doTemp.setHTMLStyle("FileName,Column,TableName,KeyColumn,Remark", "");
	//��ѯ
 	//doTemp.setColumnAttribute(sKeyColumn,"IsFilter","1");
	doTemp.generateFilters(Sqlca);
	
	doTemp.parseFilterData(request,iPostChange);
	ASDataObjectFilter adof=(ASDataObjectFilter)doTemp.Filters.get(2);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
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
		}else{//û��ƥ��
			sb.append("''");
		}
		sb.append(")");
		dwTemp.DataObject.WhereClause="where DocNo='"+sDocNo+"' and AttachmentNo in"+sb.toString();
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(""+sDocNo+",All");
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
			{"false","","Button","ά��","ά�����ݿ�","handleDatabase()",sResourcesPath}
			//{"true","","Button","����","���������޸�,�������б�ҳ��","save()",sResourcesPath},
			};
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
		popComp("QDefinitionInfo","/Common/Configurator/MetaDataManage/QDefinitionInfo.jsp","docNo=<%=sDocNo%>","");
		reloadSelf();
	}
	function save(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");;
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
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
		//RunMethod("���÷���","GetColValue","Flow_Task,PhaseOpinion");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
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
