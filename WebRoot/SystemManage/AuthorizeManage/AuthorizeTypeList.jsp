<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2006-09-04
			Tester:
			Describe: ҵ��Ʒ��ȷ��
			Input Param:
			Output Param:
			HistoryLog: 
				 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ҵ��Ʒ��ȷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";
	
	//���ҳ�������������ʽ��������Ϣ���
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
 	//����ֵת��Ϊ���ַ���
 	if(sSerialNo == null) sSerialNo = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = 	{ 
						{"SerialNo","��Ȩ�������"},
						{"ObjectType","��������"},
						{"ObjectNo","������"},
						{"BusinessName","ҵ��Ʒ��"}
		   				};		   		
		
		sSql =  " select SerialNo,ObjectType,ObjectNo,getBusinessName(ObjectNo) as BusinessName "+
		" from AUTHORIZE_Object "+
		" where SerialNo = '"+sSerialNo+"' "+
		" and ObjectType = 'BusinessType' ";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_OBJECT";
		doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
		doTemp.setUpdateable("BusinessName",false);
		
		doTemp.setVisible("ObjectNo,ObjectType",false);
		doTemp.setHTMLStyle("BusinessName"," style={width:200px} ");
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		dwTemp.ReadOnly = "1"; //����Ϊֻ��
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
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
			{"true","","Button","����ҵ��Ʒ��","����ҵ��Ʒ��","newRecord()",sResourcesPath},
			{"true","","Button","�޸�/�鿴ҵ��Ʒ��","�޸�/�鿴ҵ��Ʒ��","editRecord()",sResourcesPath},
			{"true","","Button","ɾ��ҵ��Ʒ��","ɾ��ҵ��Ʒ��","delRecord()",sResourcesPath}
			};
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	/*~[Describe=����ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeTypeInfo.jsp?SerialNo=<%=sSerialNo%>","DetailFrame","right");
	}
	
	/*~[Describe=�޸�/�鿴ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/SystemManage/AuthorizeManage/AuthorizeTypeInfo.jsp?ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo,"DetailFrame","right");
	}
	
	/*~[Describe=ɾ��ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function delRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
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
