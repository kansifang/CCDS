<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lpzhang 
		Tester:
		Describe: ͳ�ƴ�������
		Input Param:
			sFlowNo
			sPhaseNo
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
	//�����������ǩ�����ʱ���ӡ�������ܡ���ť���������ʾ���������Ӧ��������ʵ��������ͬ����������ͬ�������������顣
	String sMemberRole ="",sSuperPhaseNo="",sResult="",sMainOpinion="",sSql0="",sPhaseChoice="";// ������Ա��ɫ,�Ͻ׶κţ����
	int iYDNum=0,iSDNum=0,iOkNum=0,iNoNum=0;
	ASResultSet rs = null;
	if(sFlowNo.equals("EntCreditFlowTJ01"))
	{
		if(sPhaseNo.equals("0050"))
			sMemberRole ="424','224";
		if(sPhaseNo.equals("0170"))
			sMemberRole ="214";
		if(sPhaseNo.equals("0300"))
			sMemberRole ="014";
	}
	if(sFlowNo.equals("IndCreditFlowTJ01"))
	{
		if(sPhaseNo.equals("0050"))
			sMemberRole ="424','224";
		if(sPhaseNo.equals("0170"))
			sMemberRole ="214";
		if(sPhaseNo.equals("0300"))
			sMemberRole ="014";
	}
	//Ӧ������
	iYDNum = Sqlca.getDouble(" select count(*) from USER_INFO UI,USER_ROLE UR "+
			                 " where UI.UserID = UR.UserID and UI.BelongOrg='"+CurOrg.OrgID+"' and UI.UserID <> '"+CurUser.UserID+"'"+
			                 " and UR.Status = '1' and UI.Status = '1' and UR.RoleID in ('"+sMemberRole+"' )").intValue();
	//ʵ������
	sSuperPhaseNo = Sqlca.getString(" select PhaseNo from Flow_Task where PhaseNo < '"+sPhaseNo+"'  and  ObjectNo = '"+sObjectNo+"'and "+
			                        " ObjectType ='CreditApply' group by PhaseNo having count(PhaseNo)>1 order by PhaseNo desc fetch first 1 rows only ");
	 
	iSDNum = Sqlca.getDouble(" Select count(*) from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
			                 " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' ").intValue();
	iOkNum = Sqlca.getDouble(" select count(*) from Flow_Opinion where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
           					 " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) and PhaseChoice ='01'").intValue();
	iNoNum = Sqlca.getDouble(" select count(*) from Flow_Opinion where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
          				     " and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) and PhaseChoice ='02'").intValue();
	//---------����ίԱ���---------------
	sSql0 = " select PhaseChoice from Flow_Opinion FO where SerialNo in (Select SerialNo from Flow_Task where PhaseNo ='"+sSuperPhaseNo+"' "+
			" and ObjectType='CreditApply' and ObjectNo ='"+sObjectNo+"' AND (EndTime<>'' or EndTime is not null) ) "+
			" and  exists (select 'X' from User_Role UR where UR.UserID =  FO.InputUser and UR.RoleID in ('016','218'))";
	rs = Sqlca.getASResultSet(sSql0);
	if(rs.next())
	{ 
		sPhaseChoice = DataConvert.toString(rs.getString("PhaseChoice"));
		if(sPhaseChoice == null) sPhaseChoice = "";
	}
	rs.getStatement().close(); 
	
	
	if(iOkNum+iNoNum<iSDNum){
		sResult = "���ڳ�Աδ�ύҵ��";
	}else if(Double.parseDouble(String.valueOf(iOkNum))/Double.parseDouble(String.valueOf(iSDNum))<2.0/3.0){
		sResult = "��ͬ��";
	}else{
		sResult = "ͬ��";
	}
		
	if(sPhaseChoice.equals("")){
		sMainOpinion="������ίԱ���";
	}else if(sPhaseChoice.equals("02")){
		sMainOpinion="��ͬ��";
		sResult = "��ͬ��";
	}else if(sPhaseChoice.equals("01")){
		sMainOpinion="ͬ��";
	}
	
	String sHeaders[][] = {
							{"iYDNum","Ӧ������"},
							{"iSDNum","ʵ������"},
							{"iOkNum","ͬ��Ʊ��"},
							{"iNoNum","��ͬ��Ʊ��"},
							{"sMainOpinion","����ίԱ���"},
							{"sResult","������"},
												
						  };

	String sqlStr="";
	if("014,214".indexOf(sMemberRole)>-1)
	{
		sqlStr = "'"+sMainOpinion+"' as sMainOpinion,";
	}
	//ȡ���ʽ�������ͻ�����CustomerID�б�
	String sSql =  " select "+iYDNum+" as iYDNum,"+iSDNum+" as iSDNum,"+
				   " "+iOkNum+" as iOkNum,"+iNoNum+" as iNoNum,"+sqlStr+
				   " '"+sResult+ "' as sResult "+
				   " from  (values 1) as a ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);
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
			{"true","","Button","ȷ��","ȷ������","doReturn()",sResourcesPath},
	
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	function doReturn(){
		sResult = getItemValue(0,0,"sResult");
		top.returnValue = sResult;
		top.close();
	}

	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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
