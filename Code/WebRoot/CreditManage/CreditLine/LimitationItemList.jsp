<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: �������б�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//���ҳ�����	
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	String sLimitationSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitationSetID"));
	//����ֵת��Ϊ���ַ���
	if(sSubLineID == null) sSubLineID = "";
	if(sLimitationSetID == null) sLimitationSetID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String[][] sHeaders = {				
				{"LimObjectName","���ƶ���"},
				{"LineSum1","�����޶�"},
				{"LineSum2","�����޶�"},
			};
	sSql = 	" select LimitationID,LimObjectName,LineSum1,LineSum2,UpdateTime "+
			" from CL_LIMITATION "+
			" where LineID = '"+sSubLineID+"' "+
			" and LimitationSetID = '"+sLimitationSetID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_LIMITATION";
	doTemp.setKey("LimitationID",true);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("LimitationID,UpdateTime",false);
	//���ø�ʽ
	doTemp.setType("LineSum1,LineSum2","Number");
	doTemp.setUnit("LineSum1,LineSum2","(Ԫ)");
	//����ֻ������
	doTemp.setReadOnly("LimObjectName",true);
	//������ʾ�ĸ�ʽ
	doTemp.setHTMLStyle("LimObjectName","style={width:380px}");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //������仰����datawindow
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","���","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{ 
		popComp("NewLimitationItem","/CreditManage/CreditLine/LimitationItemInfo.jsp","SubLineID=<%=sSubLineID%>&LimitationSetID=<%=sLimitationSetID%>","dialogwidth:480px;dialogheight:360px");
		reloadSelf();
	}
	
	/*~[Describe=�����¼;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		sCurDate = PopPage("/Common/ToolsB/GetDay.jsp","","");		
		setItemValue(0,0,"UpdateTime",sCurDate);
		as_save("myiframe0");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sLimitationID = getItemValue(0,getRow(),"LimitationID");		
		if (typeof(sLimitationID)=="undefined" || sLimitationID.length==0)
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
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
