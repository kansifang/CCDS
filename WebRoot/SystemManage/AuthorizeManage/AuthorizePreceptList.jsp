<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: wwhe	2008-04-19
			Tester:
			Describe: ��Ȩ��������
			Input Param:
				Type:	Precept(��Ȩ��������)
						Condition(��Ȩ��������)
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
		String PG_TITLE = "��Ȩ��������"; // ��������ڱ��� <title> PG_TITLE </title>
		CurPage.setAttribute("ShowDetailArea","true");
		CurPage.setAttribute("DetailAreaHeight","125");
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
	
	//����������
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	String sType2 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type2"));
	//���ҳ�����
	
 	//����ֵת��Ϊ���ַ���
 	if(sType == null) sType = "";
 	if(sType2 == null) sType2 = "";
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
						{"AuthorizeClass","��Ȩ�������ȼ�"},
						{"AuthorizeName","��Ȩ��������"},
						{"BeginDate","��������"},
						{"EndDate","�ս�����"},
						{"InputOrgName","¼�����"},
						{"InputUserName","¼����Ա"},
						{"AuthorizeStatusName","��Ȩ״̬"},
						{"AuthorizeTypeName","��Ȩ����"}
		   				};		   		
		
		sSql =  " select SerialNo,AuthorizeClass,AuthorizeName,AuthorizeType,getItemName('AuthorizeType',AuthorizeType) as AuthorizeTypeName, "+
		" BeginDate,EndDate,AuthorizeStatus,getItemName('IsInUse',AuthorizeStatus) as AuthorizeStatusName,InputOrgID,InputUserID, "+
		" getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName "+
		" from AUTHORIZE_ROLE "+
		" where 1=1 "+
		" order by AuthorizeName,AuthorizeClass asc";
				
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		doTemp.UpdateTable = "AUTHORIZE_ROLE";
		doTemp.setKey("SerialNo",true);
		doTemp.setUpdateable("InputOrgName,InputUserName,AuthorizeStatusName,AuthorizeTypeName",false);
		//doTemp.setDDDWCode("AuthorizeType","AuthorizeType");
		doTemp.setReadOnly("",true);
		doTemp.setReadOnly("AuthorizeType",false);
		
		doTemp.setVisible("InputOrgID,InputUserID,AuthorizeStatus,AuthorizeType,AuthorizeTypeName",false);
		doTemp.setHTMLStyle("AuthorizeName"," style={width:380px} ");
		
		//���ӹ�����	
		doTemp.setColumnAttribute("SerialNo,AuthorizeName","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����ΪGrid���
		//dwTemp.ReadOnly = "1"; //����Ϊֻ��
		
		//��������¼�
		dwTemp.setEvent("BeforeDelete","!��Ȩ����.ɾ����Ȩ��������ҵ��Ʒ��(#SerialNo)+!��Ȩ����.ɾ����Ȩ������������(#SerialNo)+!��Ȩ����.ɾ����Ȩ����������Ȩ(#SerialNo)");
		
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
			{(sType.equals("Precept")?"true":"false"),"","Button","������Ȩ����","������Ȩ����","newRecord()",sResourcesPath},
			{(sType.equals("Precept")?"true":"false"),"","Button","�޸���Ȩ����","�޸���Ȩ����","editRecord()",sResourcesPath},
			{(sType.equals("Precept")?"true":"false"),"","Button","ɾ����Ȩ����","ɾ����Ȩ����","delRecord()",sResourcesPath},
			{(sType.equals("Condition")?"true":"false"),"","Button","�鿴��Ȩ����","�鿴��Ȩ����","editRecord()",sResourcesPath},
			//{"true","","PlainText","XXX","YYY","",sResourcesPath}
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
	/*~[Describe=������Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptInfo.jsp","right");
	}
	
	/*~[Describe=�޸���Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function editRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return false;
		}
		OpenPage("/SystemManage/AuthorizeManage/AuthorizePreceptInfo.jsp?Type=<%=sType%>&SerialNo="+sSerialNo,"right");
	}
	
	/*~[Describe=ɾ����Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function delRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
	/*~[Describe=ѡ��ĳ����Ȩ����,������ʾ��֮�������ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sType = "<%=sType%>";
		sType2 = "<%=sType2%>";

		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			if(sType=="Precept")
				OpenPage("/SystemManage/AuthorizeManage/AuthorizeTypeList.jsp?SerialNo="+sSerialNo,"DetailFrame","");
			if(sType=="Condition"){
				if(sType2=="Balance")
					OpenPage("/SystemManage/AuthorizeManage/AuthorizeBalanceList.jsp?SerialNo="+sSerialNo,"DetailFrame","");
				else
					OpenPage("/SystemManage/AuthorizeManage/AuthorizeControlList.jsp?SerialNo="+sSerialNo,"DetailFrame","");	
			}
		}
	}
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
	hideFilterArea();
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ����Ȩ����!","DetailFrame","");
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
