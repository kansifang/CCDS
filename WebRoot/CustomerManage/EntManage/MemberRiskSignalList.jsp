<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: ��������(������С��)��Ա���Ŷ����Ϣ�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
			NoteType������ �������ţ�Aggregate
            		       ����С�飺AssureGroup
            		       ���ù�ͬ��:CreditGroup
		Output Param:
          	ObjectType: �������͡�
        	ObjectNo: �����š�
        	BackType: ���ط�ʽ����(Blank)


		HistoryLog:
		��������С��
		2004-12-14
		jytian
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ų�Ա���Ŷ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//���ҳ�����	
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//����ֵת��Ϊ���ַ���	
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	
	String sHeaders[][] = { 
		                   {"SerialNo","Ԥ����ˮ��"},	
	                       {"CustomerName","�ͻ�����"},					      
	                       {"SignalType","Ԥ������"},
		                   {"SignalLevel","Ԥ������"},			
	                       {"SignalStatus","Ԥ��״̬"},
	                       {"CustomerOpenBalance","���ڽ��"},
	                       {"OperateUserName","�Ǽ���"},
	                       {"OperateOrgName","�Ǽǻ���"}
			      		  };   				   		

	sSql =  "select SerialNo,getCustomerName(ObjectNo) as CustomerName,getItemName('SignalType',SignalType) as SignalType,getItemName('SignalLevel',SignalLevel) as SignalLevel,"+
	        " getItemName('SignalStatus',SignalStatus) as SignalStatus,"+
	        " CustomerOpenBalance,getUserName(InputUserID) as OperateUserName,"+
	        " getOrgName(InputOrgID) as OperateOrgName "+
	        " from RISK_SIGNAL where ObjectNo in (select RelativeID from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' and RelationShip like '04%'  and length(RelationShip)>2)";

   	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ��� 
	//doTemp.setVisible("SerialNo",false);
	doTemp.setAlign("BusinessTypeName,VouchTypeName,Currency","2");	
	//���ø�ʽ
	doTemp.setHTMLStyle("BusinessTypeName,CreditTypeName,VouchTypeName,Currency"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName,OperateOrgName"," style={width:200px} ");		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
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
		{"true","","Button","Ԥ������","Ԥ������","viewAndEdit()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    	
	/*~[Describe=Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		
		reloadSelf();
		//   OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?ObjectNo="+sSerialNo,"_self","");
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
