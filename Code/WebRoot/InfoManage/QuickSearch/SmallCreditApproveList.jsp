<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  bqliu 2011-5-9
		Tester:
		Content: ΢С���������һ����
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "΢С���������һ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";//--��ͷ
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"OrgName","��������"},
							{"UserName","��λ"},
							{"PhaseName","����������"},
							{"PassApply","��׼�ܱ���"},
							{"VetoApply","����ܱ���"},	
							{"PassApply1","΢С����������(��׼)"},
							{"VetoApply1","΢С����������(���)"}
							}; 					
	sSql =	"select OrgID,getOrgName(OrgID) as OrgName,UserName,PhaseName,"+
			"sum(PassApply) as PassApply,Sum(VetoApply) as VetoApply,"+
			"Sum(PassApply1) as PassApply1,Sum(VetoApply1) as VetoApply1 "+
			"from (select FT1.OrgName,FT1.OrgID,FT1.UserName,FT1.PhaseName,FT1.FlowNo,"+
			"case when FT2.PhaseNo='1000' then 1 else 0 end as PassApply,"+
			"case when FT2.PhaseNo='8000' then 1 else 0 end as VetoApply,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='CreditFlow02'  then 1 else 0 end as PassApply1,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='CreditFlow02'  then 1 else 0 end as VetoApply1 "+
		    "from FLOW_TASK FT1,FLOW_TASK FT2"+
			" where FT1.SerialNo=FT2.RelativeSerialno and FT1.ObjectType='CreditApply' "+
			"and FT1.PhaseNo<>'0010'  and  FT2.PhaseNo in('8000','1000') and FT1.FlowNo='CreditFlow02' )  as a"+ 
			" group by OrgID,UserName,PhaseName";
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//doTemp.setKey("SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("OrgName,UserName","style={width:250px} ");  
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("PassApply,VetoApply,PassApply1,VetoApply1","5");	
	//doTemp.setType("PassApply,VetoApply,PassApply1,VetoApply1,PassApply2,VetoApply2,PassApply3,VetoApply3,PassApply4,VetoApply4","Number");
	doTemp.setVisible("OrgID",false);
	//���ɲ�ѯ��
	/*
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    */
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