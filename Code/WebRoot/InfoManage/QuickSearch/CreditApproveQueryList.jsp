<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  bqliu 2011-5-9
		Tester:
		Content: �������һ��
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
	String PG_TITLE = "�������һ����"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"PassApply1","��˾һ��(��׼)"},
							{"VetoApply1","��˾һ��(���)"},									
							{"PassApply2","����һ��(��׼)"},
							{"VetoApply2","����һ��(���)"},
							{"PassApply3","��˾�ͷ���(��׼)"},
							{"VetoApply3","��˾�ͷ���(���)"},
							{"PassApply4","���˵ͷ���(��׼)"},
							{"VetoApply4","���˵ͷ���(���)"},
							}; 					
	sSql =	"select OrgID,getorgName(OrgID) as OrgName,UserName,PhaseName,"+
			"sum(PassApply) as PassApply,Sum(VetoApply) as VetoApply,"+
			"Sum(PassApply1) as PassApply1,Sum(VetoApply1) as VetoApply1,"+
			"Sum(PassApply2) as PassApply2,Sum(VetoApply2) as VetoApply2,"+
			"Sum(PassApply3) as PassApply3,Sum(VetoApply3) as VetoApply3,"+
			"Sum(PassApply4) as PassApply4,Sum(VetoApply4) as VetoApply4 "+
			"from (select FT1.OrgName,FT1.OrgID,FT1.UserName,FT1.PhaseName,FT1.FlowNo,"+
			"case when FT2.PhaseNo='1000' then 1 else 0 end as PassApply,"+
			"case when FT2.PhaseNo='8000' then 1 else 0 end as VetoApply,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='EntCreditFlowTJ01'  then 1 else 0 end as PassApply1,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='EntCreditFlowTJ01'  then 1 else 0 end as VetoApply1,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='IndCreditFlowTJ01'  then 1 else 0 end as PassApply2,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='IndCreditFlowTJ01'  then 1 else 0 end as VetoApply2,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='EntCreditFlowTJ02'  then 1 else 0 end as PassApply3,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='EntCreditFlowTJ02'  then 1 else 0 end as VetoApply3,"+
			"case when FT2.PhaseNo='1000' and FT1.FlowNo='IndCreditFlowTJ02'  then 1 else 0 end as PassApply4,"+
			"case when FT2.PhaseNo='8000' and FT1.FlowNo='IndCreditFlowTJ02'  then 1 else 0 end as VetoApply4"+
			" from FLOW_TASK FT1,FLOW_TASK FT2"+
			" where FT1.SerialNo=FT2.RelativeSerialno and FT1.ObjectType='CreditApply' "+
			"and FT1.PhaseNo<>'0010'  and  FT2.PhaseNo in('8000','1000') )  as a where "+
			"FlowNo in('EntCreditFlowTJ01','EntCreditFlowTJ02','IndCreditFlowTJ01','IndCreditFlowTJ02') "+
			"group by OrgID,UserName,PhaseName ";
		
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
	doTemp.setCheckFormat("PassApply,VetoApply,PassApply1,VetoApply1,PassApply2,VetoApply2,PassApply3,VetoApply3,PassApply4,VetoApply4","5");	
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