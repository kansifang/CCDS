
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/29
		Tester:
		Content: ���Ŷ�Ȼ�����Ϣҳ��
		Input Param:
			LineID�����Ŷ�ȱ��			
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŷ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineID"));
	//����ֵת��Ϊ���ַ���
	if(sLineID == null) sLineID = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String[][] sHeaders = {											
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"LineSum1","��Ƚ��"},
					{"Currency","����"},	
					{"LineEffDate","��Ч��"},
					{"BeginDate","��ʼ��"},
					{"EndDate","������"},			
					{"PutOutDeadLine","���ʹ���������"},				
					{"MaturityDeadLine","�������ҵ����ٵ�������"},				
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�����"},
					{"UpdateTime","��������"}															
					};
	String sSql = 	" select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName, "+
					" Currency,LineSum1,LineEffDate,BeginDate,EndDate,PutOutDeadLine, "+
					" MaturityDeadLine,GetOrgName(InputOrg) as InputOrgName,InputOrg,InputUser, "+
					" GetUserName(InputUser) as InputUserName,InputTime,UpdateTime "+
					" from CL_INFO "+
					" Where LineID = '"+sLineID+"' ";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Currency","Currency");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//���ò��ɼ�����
	doTemp.setVisible("LineID,CLTypeID,CLTypeName,BCSerialNo,InputUser,InputOrg",false);
	//���ò��ɸ�������
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setType("LineSum1","Number");	
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{"true","","Button","���Ŷ������ҵ��","������Ŷ������ҵ��","lineSubList()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=���Ŷ������ҵ��;InputParam=��;OutPutParam=��;]~*/
	function lineSubList()
	{		
		sLineID = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","CreditAggreement="+sLineID,"","");
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
	OpenPage("/CreditManage/CreditLine/SubCreditLineAccountList.jsp?ParentLineID=<%=sLineID%>","DetailFrame","");
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
