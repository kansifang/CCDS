<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:  bgzhang 2008-04-07
			Tester:
			Content: �ж��й���
			Input Param:
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%> 
 

<%
  	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
  %>
	<%
		String PG_TITLE = "�ж��й�����ϸ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";//--���sql���
	//����������

	//���ҳ�����	,��ˮ��
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
	<%
		String sHeaders[][] = { 							
		{"ObjectType","��������"},										
		{"ObjectNo","������"},
		{"SerialNo","��ˮ��"},
		{"BillNo","Ʊ�ݱ��"}, 
		{"BillType","Ʊ������"},     
		{"Writer","��Ʊ������"},
		{"WriterID","��Ʊ���˺�"},
		{"BillSum","Ʊ����(Ԫ)"},	
		{"WriteDate","Ʊ��ǩ����"},
		{"Maturity","Ʊ�ݵ�����"},
		{"AccountNo","��Ʊ�˽����˺�"},
		{"GatheringName","�տ�������"},
		{"AboutBankID","�տ����˺�"},
		{"AboutBankName","�տ�������"},
		{"FinishDate","�⸶����"},
			}; 
		
		 sSql =	" select ObjectType,ObjectNo,SerialNo,BillNo,BillType,Writer,WriterID,BillSum, "+
			" WriteDate,Maturity,AccountNo,GatheringName,AboutBankID,AboutBankName,"+
			" FinishDate "+
			" from BILL_INFO " +
			" where ObjectType='"+sObjectType+"'  "+
			" and ObjectNo ='"+sObjectNo+"' order by SerialNo ";
	    //sql����datawindows
		ASDataObject doTemp = new ASDataObject(sSql);
		//ͷ����
		doTemp.setHeader(sHeaders);
		//�޸ı�
		doTemp.UpdateTable = "BILL_INFO";
	    //��������
		doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
		doTemp.setAlign("actualSum,actualint,Rate,BillSum,Term,EndorseTimes,AcceptDays","3");
		doTemp.setType("actualSum,actualint,Rate,BillSum","Number");
		doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
		doTemp.setCheckFormat("WriteDate,Maturity,FinishDate,SearchDate,ApproveDate,InputDate","3");
		doTemp.setVisible("ObjectType,ObjectNo",false); 
		doTemp.setDDDWCode("HolderID","BillResource");
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}	
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

	<script language=javascript>

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

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
</script>	
<%
		/*~END~*/
	%>


<%@ include file="/IncludeEnd.jsp"%>
