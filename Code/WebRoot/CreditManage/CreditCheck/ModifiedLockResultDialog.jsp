<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  2010-5-27 �޸�����������
		Tester:
		Content: 
		Input Param:
			
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";
	
	//����������	���������͡�ģ�ͺš�����
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	
	//����ֵת��Ϊ���ַ���	
	if(sObjectNo == null) sObjectNo = "";
	if(sCustomerType == null) sCustomerType = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	
	String[][] sHeaders = {
					{"SerialNo","��ͬ��ˮ��"},
					{"LockClassifyResult","����������"},	
			      };
	sSql = 	" select SerialNo,LockClassifyResult "+	
			" from Business_Contract "+
			" where SerialNo ='"+sObjectNo+"' ";	
	//,getItemName('ClassifyResult',LockClassifyResult) as LockClassifyResultName
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ð���ͬ����ı���

	doTemp.setHeader(sHeaders);
		
	doTemp.UpdateTable = "Business_Contract";
	doTemp.setKey("SerialNo",true);	
	//���ñ�����
	//doTemp.setRequired("LockClassifyResult",true);
	if(sCustomerType.startsWith("03")){
		doTemp.setDDDWSql("LockClassifyResult","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno in('01','02','03','04','05') and isinuse ='1' ");
	}else{
		doTemp.setDDDWSql("LockClassifyResult","select itemNo,itemName from Code_Library where CodeNo ='ClassifyResult' and  itemno not in('01','02','03','04','05') and isinuse ='1' ");
	}
	//����ֻ������
	doTemp.setReadOnly("SerialNo",true);
	//����Ĭ��ֵ
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

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
		{"true","","Button","ȷ��","�޸��ʲ����շ���","doSubmit()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���ʲ����շ���","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�����ʲ����շ���;InputParam=��;OutPutParam=��;]~*/	
	function doSubmit()
	{
		 as_save("myiframe0","");
		 top.close();
    }
    
	/*~[Describe=ȡ�������ʲ����շ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
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
	my_load(2,0,'myiframe0');
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>