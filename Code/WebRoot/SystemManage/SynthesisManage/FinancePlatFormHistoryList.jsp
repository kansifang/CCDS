<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:xhyong
		Tester:
		Describe: ����ƽ̨��ʷ��¼
		Input Param:
	              --sComponentName:�������
		Output Param:
		
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ƽ̨��ʷ��¼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo == null||"undefined".equals(sSerialNo)) sSerialNo = "";
	//�������
	String sSql="";//--���sql���
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sHeaders[][] = { 			                   
		        {"CustomerName","�ͻ�����"},						      
		        {"UserName","�Ǽ���"},
		        {"OrgName","�Ǽǻ���"},
		        {"CustomerID","�ͻ����"},
		        {"PlatformType","ƽ̨����"},
		        {"DealClassify","���÷���"},
		        {"UpdateOrgName","���»���"},
	            {"UpdateUser","������"},
	            {"UpdateDate","����ʱ��"}  
	   };   				   		
	
	if(sSerialNo=="" )
	{
		sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,getItemName('FinancePlatformType',PlatformType) as PlatformType,getItemName('DealClassify',DealClassify) as DealClassify, "+
		" getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName,getOrgName(UPDATEORG) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		" from CUSTOMER_FINANCEPLATFORMLOG where 1=1 order by UpdateDate ";
	}else
	{
		sSql = " select SerialNo,CustomerName,nvl(CustomerID,'') as CustomerID,getItemName('FinancePlatformType',PlatformType) as PlatformType,getItemName('DealClassify',DealClassify) as DealClassify, "+
		" getOrgName(InputOrgID) as OrgName,getUserName(InputUserID) as UserName,getOrgName(UPDATEORG) as UpdateOrgName,getUserName(UpdateUser) as UpdateUser,UpdateDate "+
		" from CUSTOMER_FINANCEPLATFORMLOG where SerialNo='"+sSerialNo+"' order by UpdateDate ";
	}						 
  	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "CUSTOMER_FINANCEPLATFORMlog";
	doTemp.setKey("SerialNo",true);		
	//�����ֶεĲ��ɼ�
	doTemp.setVisible("SerialNo",false);
	//���ɲ�ѯ����
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
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
//---------------------���尴ť�¼�------------------------------------
	
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
