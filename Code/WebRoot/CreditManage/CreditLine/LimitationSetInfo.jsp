<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: ������������Ϣ
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","1");
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sLimitationSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationSetID"));
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String[][] sHeaders = {
					{"TypeName","��������"},
					{"ControlType","���Ʒ�ʽ"},					
					};
	String sSql = " select CLS.LineID,CLS.LimitationSetID,CLT.TypeName,CLT.ControlType,CLT.CrossUsageEnabled"+
				  " from CL_LIMITATION_SET CLS,CL_LIMITATION_TYPE CLT "+
				  " Where CLS.LimitationType = CLT.TypeID "+
				  " and CLS.LineID='"+sSubLineID+"' "+
				  " and CLS.LimitationSetID = '"+sLimitationSetID+"'";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("LineID,ASDataObject,LimitationSetID,TypeName,ControlType,CrossUsageEnabled",false);
	doTemp.setDDDWCode("ControlType","ControlType");
	doTemp.setDDDWCode("CrossUsageEnabled","CrossUsageEnabled");
	doTemp.setReadOnly("TypeName",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		//{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	function deleteRecord()
	{		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			var sReturn = RunMethod("CreditLine","DeleteLimitaionSet","<%=sSubLineID%>,<%=sLimitationSetID%>");
			parent.reloadSelf();
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');		
	OpenPage("/CreditManage/CreditLine/LimitationItemList.jsp?SubLineID=<%=sSubLineID%>&LimitationSetID=<%=sLimitationSetID%>","DetailFrame","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
