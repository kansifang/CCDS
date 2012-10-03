<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: �����ʲ���ͬ��ʾ�б�
*	Input Param:
*	Output Param:  
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���ͬ��ʾ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//�������	    
	String sSql = "";
	//���������
	//����������
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));
	if(sAlarmType == null) sAlarmType="";
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"CustomerName","�ͻ�����"},
							{"SerialNo","��ͬ���"},				
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���"},
							{"Balance","���"},
							{"PutOutDate","��ʼ��"},
							{"Maturity","������"}
						}; 
 	sSql = " select CustomerID,CustomerName,SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " getItemName('VouchType',VouchType) as VouchTypeName," + 
		   " getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,Balance,PutOutDate,Maturity "+
		   " from BUSINESS_CONTRACT "+
		   " where substr(ClassifyResult,1,2)>'02'"+
		   " and RecoveryUserID='"+CurUser.UserID+"'"+
		   " and RecoveryOrgID='"+CurOrg.OrgID+"'";
		   
	//������ͼȡ��ͬ�����	 
	/*
		BadLoanCaliber ��������ھ���ʶ:
					010:���治������
					020:Ʊ���û���������
					030:�ɽ��û���������
					040:�Ѻ�����������
		BadBizProjectFlag ����������Ŀ��ʶ:
					010:һ����Ŀ
					020:�ص���Ŀ
		EMonitorDate ���һ���ص���Ŀ���ʱ��
		CMonitorDate ���һ��һ����Ŀ���ʱ��
						
	*/
	if(sAlarmType.equals("010050"))//30�첻��������ʾ
	{
		sSql+=" and days(replace(Maturity,'/','-'))<30+days(current date) and days(replace(Maturity,'/','-'))>days(current date)";
	}else if(sAlarmType.equals("010090"))//60�����治�������ص�����ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  and BadLoanCaliber='010' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-60)";
	}else if(sAlarmType.equals("010100"))//60��ɽ��û����������ص�����ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='020' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-60)";
	}else if(sAlarmType.equals("010110"))//150��Ʊ���û����������ص�����ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='030' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<days(current date)-150)";
	}else if(sAlarmType.equals("010120"))//�Ѻ������������ص�����ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') and BadLoanCaliber='040' "+
				" and (CMonitorDate is  null or CMonitorDate ='' or "+
				" days(replace(CMonitorDate,'/','-'))<=days(current date)-180 )";
	}else if(sAlarmType.equals("010060"))//90������ʱЧ����������ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='')  "+
				" and LawEffectDate is not null and LawEffectDate!='' "+
				" and days(replace(LawEffectDate,'/','-'))<days(current date)+90"+
				" and days(replace(LawEffectDate,'/','-'))>days(current date)";
	}else if(sAlarmType.equals("010070"))//90�쵣��ʱЧ����������ʾ
	{
		sSql+=" and (FinishDate is  null or FinishDate ='') "+
		" and VouchEffectDate is not null and VouchEffectDate!='' "+
		" and days(replace(VouchEffectDate,'/','-'))<days(current date)+90"+
		" and days(replace(VouchEffectDate,'/','-'))>days(current date)";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("RecoveryUserID,RecoveryOrgID,CustomerID,BusinessType,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		
    
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("PutOutDate,Maturity"," style={width:65px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,Balance","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		};
	//���ݲ�ͬ��ͼ��ʾ��ť
	
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	
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

<%@include file="/IncludeEnd.jsp"%>