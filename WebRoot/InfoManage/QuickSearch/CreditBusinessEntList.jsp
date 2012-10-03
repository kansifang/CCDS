<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xhyong 2011/09/19	
		Tester:
		Content: ��˾��ͻ�����̨��
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
	String PG_TITLE = "��˾��ͻ�����̨��"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"SerialNo","��ݱ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"CorpID","�ͻ�֤������"},
							{"OccurTypeName","��������"},
							{"OccurType","��������"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"BusinessType","ҵ��Ʒ��"},
							{"IndustryTypeName","�ͻ�������ҵ"},
							{"DirectionName","������ҵͶ��"},
							{"AgriLoanClassifyName","��ũ�������"},
							{"BusinessSum","��ݽ��"},
							{"Balance","������"},
							{"BusinessRate","ִ�����ʣ��룩"},
							{"NormalBalance","�������"},
							{"OverDueBalance","�������"},
							{"DullBalance","�������"},
							{"BadBalance","�������"},
							{"PutOutdate","�����ʼ����"},
							{"Maturity","����ս�����"},
							{"InterestBalance1","����ǷϢ"},
							{"InterestBalance2","����ǷϢ"},
							{"ClassifyResult","��ǰ���շ����������棩"},
							{"ClassifyResultName","��ǰ���շ����������棩"},
							{"BaseClassifyResult","��ǰ���շ�������ʵ�ʣ�"},
							{"BaseClassifyResultName","��ǰ���շ�������ʵ�ʣ�"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"VouchType","��Ҫ������ʽ"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"},
							{"MFOrgName","���˵�λ"},
							{"OperateOrgName","���˻���"},
							{"ScopeName","��ҵ��ģ"},
							{"CreditLevel","�ͻ����õȼ�"}
							}; 					
	sSql =	"select BD.SerialNo,"+
				"BC.CustomerID,BC.CustomerName ,EI.CorpID,EI.CreditLevel,"+
				"getItemName('IndustryType',EI.IndustryType) as IndustryTypeName,"+
				"BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				"BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName,"+
				"getItemName('IndustryType',BC.Direction) as DirectionName,"+
				"getItemName('Scope',EI.Scope) as ScopeName,"+
				"getItemName('AgriLoanClassify1',BC.AgriLoanClassify) as AgriLoanClassifyName,"+
				"BD.BusinessSum,BD.Balance,BC.BusinessRate,"+
				"BD.NormalBalance,BD.OverDueBalance,BD.DullBalance,BD.BadBalance,"+
				"BD.PutOutdate,BD.Maturity,BD.InterestBalance1,BD.InterestBalance2,"+
				"BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				"BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				"BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName,"+
				"getUserName(BC.ManageUserID) as ManageUserName,"+
				"getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				"getOrgName(BD.MFOrgID) as MFOrgName,"+
				"getOrgName(BD.MFOrgID) as OperateOrgName "+
			" from ENT_INFO EI ,BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC"+
			" where EI.CustomerID=BC.CustomerID and BC.SerialNo=BD.RelativeSerialNo2 "+
			"and (nvl(BD.BALANCE,0)+nvl(BD.INTERESTBALANCE1,0)+nvl(BD.INTERESTBALANCE2,0))>0"+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//doTemp.setKey("SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("ManageOrgName,MFOrgName,OperateOrgName","style={width:250px} ");  
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,Balance,BusinessRate,NormalBalance,OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","3");
	doTemp.setVisible("OccurType,VouchType,BaseClassifyResult,ClassifyResult,BusinessType",false);
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("OverDueBalance,DullBalance,BadBalance,InterestBalance1,InterestBalance2","2");
	doTemp.setType("BusinessSum,Balance","Number");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","CorpID","");
	doTemp.setFilter(Sqlca,"4","OccurType","");
	doTemp.setFilter(Sqlca,"5","BusinessType","");
	doTemp.setFilter(Sqlca,"6","DirectionName","");
	doTemp.setFilter(Sqlca,"7","ScopeName","");
	doTemp.setFilter(Sqlca,"8","AgriLoanClassifyName","");
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