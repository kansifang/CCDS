<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: δ�ַ������ʲ���Ϣ�б�
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :��ȫ������ԱID
*   	SerialNo	:��ͬ��ˮ��
*		sShiftType	:�ƽ�����
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ�ַ������ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������	    
	String sSql = "";
	
	//����������
	
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},				
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"CustomerName","�ͻ�����"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","���"},
							{"ShiftBalance","�ƽ����"},
							{"Balance","��ǰ���"},
							{"CAVSum","�������"},
							{"Maturity","��������"},							
							{"ClassifyResultName","�弶����"},							
							{"ShiftTypeName","�ƽ�����"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"}
						}; 

 	sSql = " select SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,Balance, Cancelsum+CancelInterest as CAVSum,Maturity,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName" + 
		   " from BUSINESS_CONTRACT" ;
	//ȡ���˶Ի��������ƣ��б��п��Կ������еĲ����ʲ�����Ŀ��ɸ���ʵ��������ӻ�������
	//	   " Where  RecoveryOrgID = '"+CurOrg.OrgID+"'" +
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
 	if(sDBName.startsWith("INFORMIX"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ''" +
		   " and (RecoveryUserID is null or RecoveryUserID ='') ";
 	}
 	else if(sDBName.startsWith("ORACLE"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ' '" +
		   " and (RecoveryUserID is null or RecoveryUserID =' ') ";
	}
 	else if(sDBName.startsWith("DB2"))
 	{
		   sSql+=" Where  RecoveryOrgID <> ''" +
		   " and (RecoveryUserID is null or RecoveryUserID ='') ";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
    
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName,Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
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
		{"true","","Button","ָ��������","ָ����ͬ�ܻ��˻��߸����ˣ�תΪ�ѷַ�","my_Distribute()",sResourcesPath},
		{"true","","Button","���ƽ�","����ͬ�˻ظ�ԭ�ܻ���","my_ReverseHandover()",sResourcesPath}
		};

/*added by FSGong 2005-03-30
	���ݸ߿Ƴ�Ҫ������ָ�������˹���
	ԭָ�������˲��䣺����ǿͻ��ƽ�����ָ���ܻ��ˣ�ͬʱ�ƽ�������������ƽ�����ָ�������ˣ�ͬʱ�ƽ���
	����ָ�������ˣ�	  ����ǿͻ��ƽ�����ָ�������ˣ����ƽ�������������ƽ�����ָ�������ˣ�ͬʱ�ƽ���
*/
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
	/*~[Describe=ָ����ȫ��������;InputParam=��;OutPutParam=��;]~*/   
	function my_Distribute()
	{
		//��ú�ͬ��ˮ�š��ƽ�����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sShiftType = getItemValue(0,getRow(),"ShiftType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{
			//�����Ի�ѡ���
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				
				var sReturn = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserAction.jsp?"+
					 "RecoveryUserID="+sRecoveryUserID+"&RecoveryOrgID="+sRecoveryOrgID+"&SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"","","");
				if(sReturn == "true") //ˢ��ҳ��
				{
					if(sShiftType=="02")
					{
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"���ܻ���");
						self.location.reload();
					}
					else
					{
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"�����٣�");
						self.location.reload();
					}
				}
			}
		}
	}
		
	/*~[Describe=�����ƽ���¼;InputParam=��;OutPutParam=��;]~*/	
	function my_ReverseHandover()
	{ 
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{	
			if(confirm(getBusinessMessage('785')))//������뽫�˲����ʲ��˻ظ�ԭ�ܻ�����
    		{	
				var sReturn = PopPage("/RecoveryManage/Public/NPAShiftAction.jsp?SerialNo="+sSerialNo+"&Type=2","","");
				if(sReturn == "true") //ˢ��ҳ��
				{
					alert(getBusinessMessage('784')); //�ò����ʲ��ѳɹ��˻ظ�ԭ�ܻ��ˣ�
					self.location.reload();
				}
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>