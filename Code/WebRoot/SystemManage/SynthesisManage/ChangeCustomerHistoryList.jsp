<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: �ͻ���Ϣ�����¼
		Input Param:
	              --sComponentName:�������
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʷ������¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerID == null) sCustomerID = "";
	//�������
	String sSql="";//--���sql���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 
		                    	{"CustomerID","�ͻ�����"},
								{"CustomerName","�ͻ�����"},
								{"CustomerTypeName","�ͻ�����"},
		                    	{"CertTypeName","֤������"},
		                    	{"CertID","֤������"},
		                    	{"LoanCardNo","������"},
                          		{"UpdateUser","������"},
                         		{"UpdateOrgName","���������ڻ���"},  
                          		{"UpdateDate","��������"}    		        
						  	};   		   		
	
sSql = " select CustomerID,CustomerName,getItemName('CustomerType',CustomerType) as CustomerTypeName,getItemName('CertType',CertType) as CertTypeName,CertID,LoanCardNo,UpdateUser,getOrgName(UpdateOrg) as UpdateOrgName,UpdateDate "+
	              " from CUSTOMER_CHANGELOG where CustomerID = '"+sCustomerID+"' order by UpdateDate";
             
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	
	//���ÿɼ���
	if(sCustomerType.equals("03")) //����
	{
		
		doTemp.setVisible("LoanCardNo,NewLoanCardNo",false);
	}
	//���ӹ�����
	doTemp.setColumnAttribute(" ","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
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
			{"false","","Button","����","�鿴��׼�������","viewAndEdit()",sResourcesPath},
			{"false","","Button","��ʷ��¼��ѯ","�鿴��׼�������","viewHistory()",sResourcesPath},
			{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
//---------------------���尴ť�¼�------------------------------------
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ChangeCustomerList.jsp","_self","");
	}
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
