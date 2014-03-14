<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: ������ͬ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ�������ͬ���ٲ�ѯ
		          
			Output param:
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "������ͬ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
					{"CustomerID","���ܿͻ����"},
					{"CustomerName","���ܵ����ͻ�����"},
					{"ContractType","��������"},
					{"ContractTypeName","��������"},
					{"GuarantyType","������ʽ"},
					{"GuarantyTypeName","������ʽ"},
					{"GuarantorName","�ṩ����������"},
					{"GuarantyCurrencyName","��������"},
					{"GuarantyValue","�����ܽ��"},
					{"SerialNo","������ͬ��ˮ��"},
					{"InputOrgID","�Ǽǻ���"},
					{"InputOrgIDName","�Ǽǻ���"}
					}; 
	
	sSql =	" select InputOrgID,getOrgName(InputOrgID) as InputOrgIDName, "+
	" SerialNo,ContractNo,CustomerID,getCustomerName(CustomerID) as CustomerName, " +
	" ContractType,getItemName('ContractType',ContractType) as ContractTypeName, "+
	" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName, "+
	" getCustomerName(GuarantorID) as GuarantorName,"+
	" getItemName('Currency',GuarantyCurrency) as GuarantyCurrencyName,GuarantyValue " +
	       	" from GUARANTY_CONTRACT " +
	" where ContractStatus ='020' "+
	" and InputOrgID in  (select BelongOrgID from ORG_BELONG where OrgID='"+CurOrg.OrgID+"') ";
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("ContractNo,BusinessType,ContractType,GuarantyType,InputOrgID",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:250px} ");  		
	//���ö��뷽ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setType("GuarantyValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("GuarantyValue","2");	
	//����������
	doTemp.setDDDWCode("ContractType","ContractType");
	doTemp.setDDDWCode("GuarantyType","GuarantyType");
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","ContractType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","GuarantorName","");
	doTemp.setFilter(Sqlca,"4","GuarantyValue","");
	doTemp.setFilter(Sqlca,"5","SerialNo","");
	doTemp.setFilter(Sqlca,"6","InputOrgIDName","");
	doTemp.parseFilterData(request,iPostChange);	
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
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

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("GuarantyContract",sSerialNo,"002");
		}
	}	

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
