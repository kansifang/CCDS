<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-23
		Tester:
		Describe: ���������б�;
		Input Param:

		Output Param:
				
		HistoryLog:zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//����������
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"AgencyName","������������"},
							{"AgencyLicense","Ӫҵִ�ձ��"},
							{"AgencyTel","��ϵ�绰"},				
							{"AgencyAdd","��ַ"},
							{"PrincipalName","����������"},
							{"UserName","�Ǽ���"},
							{"OrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}								
						  };

	String sSql =	" select SerialNo,AgencyName,AgencyLicense,AgencyTel,AgencyAdd, "+
				    " PrincipalName,InputUserID,getUserName(InputUserID) as UserName, "+
				    " InputOrgID,getOrgName(InputOrgID) as OrgName,InputDate "+
				    " from AGENCY_INFO "+			
				    " where AgencyType='02' "+
				    " order by InputDate desc ";

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENCY_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID",false);	

	doTemp.setHTMLStyle("UserName,OrgName,InputDate,AgencyTel"," style={width:80px} ");
	doTemp.setHTMLStyle("AgencyName,AgencyLicense,AgencyAdd,PrincipalName","style={width=120px} ");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AgencyName,AgencyLicense","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

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
				{"true","","Button","����","������������","newRecord()",sResourcesPath},
				{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
				{"true","","Button","����������","�鿴����������","my_agent()",sResourcesPath},
				{"true","","Button","�Ѵ�������","�鿴�Ѵ�������","my_lawcase()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ����������","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/RecoveryManage/Public/AgencyInfo.jsp?SerialNo="+sSerialNo, "_self","");
	}

	/*~[Describe=������������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_agent()
	{
		//��ô���������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/RecoveryManage/Public/AgentList.jsp?BelongNo="+sSerialNo+"&Flag=Y&rand="+randomNumber(),"_self","");           	
	}
	
	/*~[Describe=�Ѵ���������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		//��÷�Ժ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/RecoveryManage/Public/SupplyLawCase.jsp?QuaryName=OrgNo&QuaryValue="+sSerialNo+"&Back=1&rand="+randomNumber(),"_self","");           			
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