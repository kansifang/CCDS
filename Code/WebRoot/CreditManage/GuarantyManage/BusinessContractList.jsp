<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-9
		Tester:
		Describe: ����Ѻ�ﵣ����ҵ���ͬ�б�;
		Input Param:
			GuarantyID: ����Ѻ����
		Output Param:
			
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ���ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//���ҳ�����

	//����������������Ѻ����
	String sGuarantyID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ���"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","��ͬ���"},
							{"OverdueBalance","����/�����"},
							{"FineBalance1","����Ϣ"},
							{"FineBalance2","��Ϣ��Ϣ"},
							{"BusinessRate","����(��)"},
							{"PdgRatio","����(��)"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"VouchTypeName","������ʽ"},	
							{"ManageUserName","�ܻ��ͻ�����"},
							{"ManageOrgName","�ܻ�����"}
						  };

	
	sSql =  " select BC.SerialNo,BC.CustomerName, "+
			" getBusinessName(BC.BusinessType) as BusinessTypeName, "+
			" getItemName('Currency',BC.BusinessCurrency) as Currency, "+
			" BC.BusinessSum,BC.Balance,BC.OverdueBalance,BC.FineBalance1, "+
			" BC.FineBalance2,BC.BusinessRate,BC.PdgRatio,BC.PutOutDate,BC.Maturity, "+
			" getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
			" getOrgName(BC.ManageOrgID) as ManageOrgName,"+
			" getUserName(BC.ManageUserID) as ManageUserName "+			
			" from GUARANTY_RELATIVE GR, BUSINESS_CONTRACT BC "+
			" where GR.ObjectType = 'BusinessContract' "+
			" and GR.ObjectNo = BC.SerialNo "+
			" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
			" and GR.GuarantyID = '"+sGuarantyID+"' ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo",false);
	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,Balance,OverdueBalance,FineBalance1,FineBalance2","3");
	doTemp.setCheckFormat("BusinessSum,Balance,OverdueBalance,FineBalance1,FineBalance2","2");
	doTemp.setHTMLStyle("CustomerName,VouchTypeName"," style={width:200px} ");

	//����datawindow
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
		{"true","","Button","����","�鿴��ͬ����","viewAndEdit()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenComp("CreditTab","/CreditManage/CreditApply/ObjectTab.jsp","ObjectType=AfterLoan&ObjectNo="+sSerialNo+"&ViewID=002","_blank",OpenStyle);
		}
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
