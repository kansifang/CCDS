<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xhyong 2012/05/28
		Tester:
		Content: ��˾��ͻ���������̨��
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�
					Flag:
						030:δ��������ҵ��
						040:�ѽ�������ҵ��
						050:�㱾���Ϣ����ҵ��
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˾��ͻ���������̨��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String sFlag = "";//��ʶ
	String PG_CONTENT_TITLE = "";//--��ͷ
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����
	sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));	//���ҳ�����
	if(sFlag==null) sFlag = "";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 
							{"OperateOrgName","���˻���"},
							{"SerialNo","��ݱ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"CorpID","�ͻ�֤������"},
							{"RegisterAdd","�ͻ�ע���ַ"},
							{"IndustryTypeName","�ͻ�������ҵ"},
							{"OrgNature","�ͻ���������"},
							{"ScopeName","��ҵ��ģ"},
							{"CreditLevel","�ͻ����õȼ�"},
							{"ECGroupFlagName","�Ƿ��ſͻ�"},
							{"DirectionName","������ҵͶ��"},
							{"AgriLoanClassifyName","��ũ�������"},
							{"AgriLoanFlag","�Ƿ���ũ"},
							{"AgriLoanFlagName","�Ƿ���ũ"},
							{"OccurType","��������"},
							{"OccurTypeName","��������"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessType","ҵ��Ʒ��"},
							{"ActualBusinessRate","ִ�����ʣ��룩"},
							{"RateFloatTypeName","���ʸ�����ʽ"},
							{"RateFloat","���ʸ���ֵ"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"VouchType","��Ҫ������ʽ"},
							{"BCBusinessSum","��ͬ���"},
							{"BCPutOutDate","��ͬ��ʼ����"},
							{"BCMaturity","��ͬ��������"},
							{"BusinessSum","��ݽ��"},
							{"Balance","������"},
							{"PutOutdate","�����ʼ����"},
							{"Maturity","��ݵ�������"},
							{"SubjectNo","��ƿ�Ŀ"},
							{"OverDueDays","��������"},
							{"Interestbalance1","����ǷϢ"},
							{"Interestbalance2","����ǷϢ"},
							{"ClassifyResult","��ǰ���շ����������棩"},
							{"ClassifyResultName","��ǰ���շ����������棩"},
							{"BaseClassifyResult","��ǰ���շ�������ʵ�ʣ�"},
							{"BaseClassifyResultName","��ǰ���շ�������ʵ�ʣ�"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"},
							{"MFOrgName","���˵�λ"}
							}; 					
	sSql =	"select "+
				"BD.SerialNo,"+
				"BC.CustomerID,BC.CustomerName,EI.CorpID,EI.RegisterAdd, "+
				"getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,"+
				"getItemName('CustomerType',EI.OrgNature) as OrgNature,"+
				"getItemName('Scope',EI.Scope) as ScopeName,"+
				"EI.CreditLevel,"+
				"getItemName('YesNo',EI.ECGroupFlag) as ECGroupFlagName,"+
				"getItemName('IndustryType',BC.Direction) as DirectionName,"+
				"getItemName('AgriLoanClassify1',BC.AgriLoanClassify) as AgriLoanClassifyName,"+
				"BC.AgriLoanFlag,getItemName('YesNo',BC.AgriLoanFlag) as AgriLoanFlagName,"+
				"BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				"BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
				"BD.ActualBusinessRate,"+
				"getItemName('RateFloatType',BC.RateFloatType) as RateFloatTypeName,"+
				"BC.RateFloat,"+
				"BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
				"BC.BusinessSum as BCBusinessSum,"+
				"BC.PutOutdate as BCPutoutDate,BC.Maturity as BCMaturity,"+
				"BD.BusinessSum,BD.Balance,"+
				"BD.PutOutdate,BD.Maturity,"+
				"BD.SubjectNo,BD.OverDueDays,"+
				"BD.Interestbalance1,BD.Interestbalance2,"+
				"BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				"BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				"getUserName(BC.ManageUserID) as ManageUserName,"+
				"getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				"getOrgName(BD.MFOrgID) as MFOrgName, "+
				"getOrgName(BD.MFOrgID) as OperateOrgName "+
			" from ENT_INFO EI ,BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC"+
			" where EI.CustomerID=BC.CustomerID and BC.SerialNo=BD.RelativeSerialNo2 "+
				" and BC.BusinessType like '1%'"+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	if("030".equals(sFlag))//δ����
	{
		sSql = sSql+" and  BD.Balance>0 and (BD.FinishDate is null or BD.FinishDate ='') ";
	}else if("040".equals(sFlag))//�ѽ���
	{
		sSql = sSql+" and BD.FinishDate is not null and BD.FinishDate !=''";
	}else if("050".equals(sFlag))//�㱾���Ϣ
	{
		sSql = sSql+" and  nvl(BD.Balance,0)=0 and (BD.FinishDate is null or BD.FinishDate ='')";
	}
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//doTemp.setKey("SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ManageOrgName,MFOrgName,OperateOrgName","style={width:250px} ");  
	doTemp.setHTMLStyle("BCMaturity,ClassifyResultName,BaseClassifyResultName","style={width:50px} ");
	//���ö��뷽ʽ
	doTemp.setAlign("OverDueDays,ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","3");
	doTemp.setVisible("AgriLoanFlag,AgriLoanClassifyName,OccurType,VouchType,BaseClassifyResult,ClassifyResult,BusinessType",false);
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	doTemp.setCheckFormat("OverDueDays","5");
	doTemp.setType("ActualBusinessRate,RateFloat,BCBusinessSum,BusinessSum,Balance,Interestbalance1,Interestbalance2","Number");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	doTemp.setDDDWCode("AgriLoanFlag","YesNo");
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","CorpID","");
	doTemp.setFilter(Sqlca,"4","OccurType","");
	doTemp.setFilter(Sqlca,"5","BusinessType","");
	doTemp.setFilter(Sqlca,"6","DirectionName","");
	doTemp.setFilter(Sqlca,"7","ScopeName","");
	doTemp.setFilter(Sqlca,"8","AgriLoanFlag","");
	doTemp.setFilter(Sqlca,"9","BusinessSum","");
	doTemp.setFilter(Sqlca,"10","Balance","");
	doTemp.setFilter(Sqlca,"11","PutOutdate","");
	doTemp.setFilter(Sqlca,"12","Maturity","");
	doTemp.setFilter(Sqlca,"13","ClassifyResult","");
	doTemp.setFilter(Sqlca,"14","BaseClassifyResult","");
	doTemp.setFilter(Sqlca,"15","VouchType","");
	doTemp.setFilter(Sqlca,"16","ManageUserName","");
	doTemp.setFilter(Sqlca,"17","ManageOrgName","");
	doTemp.setFilter(Sqlca,"18","MFOrgName","");
	doTemp.setFilter(Sqlca,"19","OperateOrgName","");
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
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
 	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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