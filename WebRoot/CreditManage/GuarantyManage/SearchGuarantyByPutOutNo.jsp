<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: wangdw 2012-08-01
		Tester:
		Describe: ���ݳ�����ˮ�Ų�ѯ�ñ�ҵ�������е���Ѻ��;
		Input Param:
			CustomerID����ǰ������ˮ��
		Output Param:
			ObjectType: �������͡�
			ObjectNo: �����š�
			BackType: ���ط�ʽ����(Blank)

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ñ�ҵ���µ���Ѻ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"GUARANTYID","����Ѻ����"},
							{"GUARANTYSTATUS","����Ѻ��״̬"},
							{"SENDFLAG","���ͱ�־"},
							{"GuarantyType","����Ѻ������"},
						  };

	//ȡ���ʽ�������ͻ�����CustomerID�б�
	//select RelativeID from CUSTOMER_RELATIVE where CustomerID='"+sCustomerID+"' and (RelationShip like '52%' or RelationShip like '02%')
	String sSql =  " select GUARANTYID,GuarantyType,GUARANTYSTATUS,SENDFLAG from GUARANTY_INFO where GUARANTYID in (select GUARANTYID "+
			"from GUARANTY_RELATIVE where objectno=(select CONTRACTSERIALNO  from BUSINESS_PUTOUT where serialno='"+sObjectNo+"') )";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("GUARANTYSTATUS","GuarantyStatus");
	doTemp.setDDDWCode("GuarantyType","GuarantyList");
	doTemp.setDDDWCode("SENDFLAG","GISendFlag");
	//���ò��ɼ���
	//doTemp.setVisible("CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID",false);
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("BusinessSum,Balance","3");
	//doTemp.setCheckFormat("BusinessSum,Balance","2");
	//doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency,VouchTypeName","2");
	//����html��ʽ
	//doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	//doTemp.setHTMLStyle("ArtificialNo"," style={width:180px} ");
	//doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
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
		{"true","","Button","����","�鿴δ��������ҵ������","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ȡ����Ѻ��״̬","��ȡ����Ѻ��״̬","getGuarantyState()",sResourcesPath},
		{"true","","Button","��ӡ�����ƾ֤","��ӡ����Ѻ������ƾ֤","printLoadGuaranty()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
//�Ӻ��Ļ�ȡ����Ѻ��״̬
	function getGuarantyState()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sTradeType = "777120";	
        sObjectNo = sGuarantyID;
        sObjectType = "GuarantyInfoQuery";
        sGuarantyStatus = "";
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn = RunMethod("BusinessManage","SendMF",sObjectNo+","+sObjectType+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000"){
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			return;
		}else{
				alert("��ѯ�ɹ�["+sReturn[1]+"]");
				//sReturn[1]��1 �ڿ⣬2 ����
				if(sReturn[1]=="1")
				{
					sGuarantyStatus = "02";//���
				}else if(sReturn[1]=="2"){
					sGuarantyStatus = "04";//����
				}
				RunMethod("PublicMethod","UpdateColValue","String@GuarantyStatus@sGuarantyStatus,GUARANTY_INFO,String@GUARANTYID@"+sGuarantyID);
		}
		reloadSelf();
	}	
//����Ѻ������
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sPawnType = getItemValue(0,getRow(),"GuarantyType");
		sGuarantyStatus = getItemValue(0,getRow(),"GUARANTYSTATUS");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus="+sGuarantyStatus+"&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType,"_self");
		}
	}
	
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	}	
	/*~[Describe=��ӡ����Ѻ������ƾ֤;InputParam=��;OutPutParam=��;]~*/
	function printLoadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GUARANTYID");
		sGUARANTYSTATUS = getItemValue(0,getRow(),"GUARANTYSTATUS");
		sSENDFLAG = getItemValue(0,getRow(),"SENDFLAG");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			//�������Ѻ��״̬Ϊ"���"�ҷ��ͱ�־λ"��ⷢ��"
			if(sGUARANTYSTATUS == "02" && sSENDFLAG == "01")
				{
					PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet1.jsp","GuarantyID="+sGuarantyID+"&Churuku=���","dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
				}
			else
				{
					alert("����Ѻ��δ��⣬���ܴ�ӡƾ֤");					
				}
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
