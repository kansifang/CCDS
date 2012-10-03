<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-6
		Tester:
		Describe: ����Ѻ�ﵣ���ĵ�����ͬ�б�;
		Input Param:
				
		Output Param:
				
		HistoryLog:
										
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	
	//����������������Ѻ����
	String sGuarantyID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	
	//���ҳ�����

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ͬ���"},
							{"GuarantyTypeName","������ʽ"},
							{"GuarantyStatusName","����״̬"},				           
							{"GuarantorName","����������"},
							{"GuarantyValue","�������"},				            
							{"GuarantyCurrency","����"},
							{"ContractStatusName","��ͬ״̬"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	sSql =  " select distinct GC.SerialNo,GC.CustomerID,GC.GuarantyType,GC.ContractStatus, "+	
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+	
			" getItemName('ContractStatus',GC.ContractStatus) as GuarantyStatusName, "+	
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+			
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName "+
			" from GUARANTY_RELATIVE GR,GUARANTY_CONTRACT GC "+
			" where GR.ObjectType = 'BusinessContract' "+
			" and GR.ContractNo = GC.SerialNo "+
			" and GR.GuarantyID = '"+sGuarantyID+"' "+			
			" and GC.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,ContractStatus,InputUserID,InputOrgID",false);
	
	//���ø�ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
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
		{"true","","Button","����","�鿴������ͬ��Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����ͻ�����","�鿴������ͬ��صĵ����ͻ�����","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","���ҵ������","�鿴������ͬ��ص�ҵ���ͬ��Ϣ�б�","viewBusinessInfo()",sResourcesPath}
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//��������
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//������ͬ���
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/GuarantyManage/GuarantyContractInfo.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType,"_self");
		}
	}
	
	/*~[Describe=�鿴�����ͻ���������;InputParam=��;OutPutParam=��;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (sCustomerID.length == 0)
				alert("�����ͻ�����ϸ��Ϣ��");
			else
				openObject("Customer",sCustomerID,"002");
		}
	}

	/*~[Describe=�鿴������ͬ����ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--��ˮ����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenComp("AssureBusinessList","/CreditManage/CreditAssure/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>