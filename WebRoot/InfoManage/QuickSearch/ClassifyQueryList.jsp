<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui 2005-1-25
			Tester:
			Content: ���շ�����Ϣ���ٲ�ѯ
			Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ����շ�����Ϣ���ٲ�ѯ
		          
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
		String PG_TITLE = "���շ�����Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//--���sql���
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
	/*
	//�����ͷ�ļ�����ͬ��
	String sHeaders[][] = {
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"ObjectNo","��ͬ��ˮ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessType","ҵ������"},
							{"BusinessSum","���"},
							{"PutOutDate","��ͬ��ʼ��"},
							{"Maturity","��ͬ������"},
							{"Currency","����"},
							{"FinallyResult","�϶����"},
							{"FinallyResultName","�϶����"},
							{"balance","���"},
							{"ClassifyDate","��������"},
					}; 
					
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
		" BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
		" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum,BC.balance, " +
		" BC.PutOutDate,BC.Maturity,CR.FinallyResult,CR.ClassifyDate,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
	       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC " +
		" where CR.ObjectNo = BC.SerialNo "+
		" and CR.ObjectType = 'BusinessContract' "+
		" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	*/
	//�����ͷ�ļ�����ݣ�
	String sHeaders[][] = {
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"ObjectNo","�����ˮ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessType","ҵ������"},
							{"BusinessSum","���"},
							{"PutOutDate","��Ϣ��"},
							{"Maturity","������"},
							{"Currency","����"},
							{"FinallyResult","�϶����"},
							{"FinallyResultName","�϶����"},
							{"balance","���"},
							{"ClassifyDate","��������"},
					}; 
					
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BD.CustomerID,BD.CustomerName, " +
		" BD.BusinessType,getBusinessName(BD.BusinessType) as BusinessTypeName, " +
		" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.balance, " +
		" BD.PutOutDate,BD.Maturity,CR.FinallyResult,CR.ClassifyDate,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
	       		" from CLASSIFY_RECORD CR,BUSINESS_DUEBIll BD " +
		" where CR.ObjectNo = BD.SerialNo "+
		" and CR.ObjectType in ('BusinessDueBill','ClassifyApply') "+
		" and BD.OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CR.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	
	//���ùؼ���
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);

	//���ò��ɼ���
	doTemp.setVisible("ObjectType,SerialNo,CustomerID,BusinessType,FinallyResult",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("Currency","style={width:60px} ");  
		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,balance","3");
	doTemp.setType("BusinessSum,balance","Number");

	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,balance","2");
	doTemp.setDDDWCode("FinallyResult","ClassifyResult");	
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");
	doTemp.setFilter(Sqlca,"3","ObjectNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","balance","");
	doTemp.setFilter(Sqlca,"6","FinallyResult","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"7","ClassifyDate","");
	
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
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		sObjectType =getItemValue(0,getRow(),"ObjectType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			OpenComp("ClassifyQueryInfo","/InfoManage/QuickSearch/ClassifyQueryInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo, "_bank",OpenStyle);
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
