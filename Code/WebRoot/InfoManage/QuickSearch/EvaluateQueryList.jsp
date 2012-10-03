<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: �����������ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�����������Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectNo","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"EvaluateDate","��������"},
							{"EvaluateScore","������ֵ"},
							{"EvaluateResult","�������"},
							{"CognDate","�϶�����"},
							{"CognScore","�϶���ֵ"},
							{"CognResult","�϶����"},
						}; 	

	sSql =	" select SerialNo,ObjectType,ObjectNo,getCustomerName(ObjectNo) as CustomerName, " +
			" EvaluateDate,EvaluateScore,EvaluateResult,CognDate,CognScore,CognResult,UserID,OrgID " +
	       	" from EVALUATE_RECORD" +
			" where ObjectType = 'Customer' "+
			" and OrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo||ObjectType||ObjectNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EVALUATE_RECORD";
	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	doTemp.setVisible("UserID,OrgID",false);

	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType",false);

	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("EvaluateDate,CognDate,EvaluateResult,CognResult","style={width:70px} ");  
		
	//���ö��뷽ʽ
	doTemp.setAlign("EvaluateDate,CognDate,EvaluateResult,CognResult","2");
	doTemp.setAlign("EvaluateScore,CognScore","3");
	doTemp.setType("EvaluateScore,CognScore","Number");

	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");
	doTemp.setCheckFormat("TermMonth","5");
	
	//ָ��˫���¼�

	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,ObjectNo,EvaluateResult,CognResult","IsFilter","1");

	doTemp.generateFilters(Sqlca);
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/

	function viewAndEdit()
	{
		
		var sSerialNo	  = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo	  = getItemValue(0,getRow(),"ObjectNo");
		var sUserID       = getItemValue(0,getRow(),"UserID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ��������¼��");
		}else
		{
			var sEditable="true";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("EvaluateDetail","/Common/Evaluate/EvaluateDetail.jsp","Action=display&ObjectType=Customer&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&Editable="+sEditable,"_blank",OpenStyle);
		}

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
