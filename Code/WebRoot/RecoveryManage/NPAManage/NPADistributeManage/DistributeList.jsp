<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: hxli 2005-8-4
*	Tester:
*	Describe:�ѷַ������ʲ���Ϣ�б�
*	Input Param:
*
*	Output Param:     
*		sShiftType���ƽ�����
*		sOldOrgID��ԭ�������ID
*		sOldUserID��ԭ������ID
*		sOldOrgName��ԭ�������
*		sOldUserName��ԭ������
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ѷַ������ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCurItemID ;    
	String sWhereClause=""; //Where����
	String sSql="";

	//����������
	sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo"));
	if(sCurItemID == null) sCurItemID = "";
	System.out.println(sCurItemID);
 	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�����ͷ�ļ�
	//�ͻ��ƽ���ͷ
	String sHeaders[][] = {
						{"RecoveryUserName","�ܻ���"},
						{"RecoveryOrgName","�ܻ�����������"},						
						{"SerialNo","��ͬ��ˮ��"},						
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"OccurTypeName","��������"},
						{"CustomerName","�ͻ�����"},
						{"BusinessCurrencyName","����"},
						{"BusinessSum","���"},
						{"ShiftBalance","�ƽ����"},
						{"Balance","��ǰ���"},
						{"Maturity","��������"},
						{"ClassifyResult","�弶����"},
						{"ShiftTypeName","�ƽ�����"},
						{"ManageUserName","ԭ�ܻ���"},
						{"ManageOrgName","ԭ�ܻ�����"}
					}; 
	
	//�����ƽ���ͷ
	String sHeaders1[][] = {						
						{"RecoveryUserName","��һ������"},
						{"RecoveryOrgName","��һ�����˻���"},
						{"SerialNo","��ͬ��ˮ��"},					
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"OccurTypeName","��������"},
						{"CustomerName","�ͻ�����"},
						{"BusinessCurrencyName","����"},
						{"BusinessSum","���"},
						{"ShiftBalance","�ƽ����"},
						{"Balance","��ǰ���"},
						{"Maturity","��������"},
						{"ClassifyResultName","�弶����"},
						{"ShiftTypeName","�ƽ�����"},						
						{"ManageUserName","ԭ�ܻ���"},
						{"ManageOrgName","ԭ�ܻ�����"}
					}; 

	//�Ӻ�ͬ����ѡ�������ʲ��ܻ�����Ϊ��¼�û����ڻ������¼������Ĳ����ʲ�
 	if(sCurItemID.equals("010"))	//�ͻ��ƽ�
	{	
		sSql =	 " select BC.SerialNo,getUserName(BC.RecoveryUserID) as RecoveryUserName," + 	
				 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," +					
				 " BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
				 " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
				 " BC.CustomerName,getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
				 " BC.BusinessSum,BC.ShiftBalance,BC.Balance,BC.Maturity,BC.ClassifyResult,BC.ShiftType," +  
				 " getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
				 " getUserName(BC.ManageUserID) as ManageUserName," + 
				 " getOrgName(BC.ManageOrgID) as ManageOrgName," + 
				 " BC.RecoveryUserID,BC.RecoveryOrgID,BC.ManageUserID,BC.ManageOrgID " + 
				 " from BUSINESS_CONTRACT BC " +
				 " Where exists (select OI.OrgID from ORG_INFO OI "+
				 " where OI.OrgID = BC.RecoveryOrgID "+
				 " and OI.SortNo like '"+CurOrg.SortNo+"%') "+
				 " and BC.ShiftType='02' and BC.RecoveryUserID ='"+CurUser.UserID+"' order by BC.SerialNo desc ";		
	}else if(sCurItemID.equals("020"))	//�����ƽ�
	{
		sSql =	 	 " select BC.SerialNo, "+					 
					 " getUserName(BC.RecoveryUserID) as RecoveryUserName," + 
					 " getOrgName(BC.RecoveryOrgID) as RecoveryOrgName," + 
					 " BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName," + 
					 " getItemName('OccurType',BC.OccurType) as OccurTypeName," + 
					 " BC.CustomerName," + 
					 " getItemName('Currency',BC.BusinessCurrency) as BusinessCurrencyName," + 
					 " BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName," +   
					 " BC.ShiftType,getItemName('ShiftType',BC.ShiftType) as ShiftTypeName," + 
					 " getUserName(BC.ManageUserID) as ManageUserName," + 
					 " getOrgName(BC.ManageOrgID) as ManageOrgName" + 
					 " from BUSINESS_CONTRACT BC " +
					 " Where exists (select OI.OrgID from ORG_INFO OI "+
					 " where OI.OrgID = BC.RecoveryOrgID "+
					 " and OI.SortNo like '"+CurOrg.SortNo+"%') "+
					 " and BC.ShiftType='01' order by BC.SerialNo desc ";
	}
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	if(sCurItemID.equals("010"))	//�ͻ��ƽ�
		doTemp.setHeader(sHeaders);
	
	if(sCurItemID.equals("020"))	//�����ƽ�
		doTemp.setHeader(sHeaders1);

	//doTemp.setKey("RecoveryUserID",true);	 //���ùؼ���
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,FinishType,BusinessType,ShiftType,FinishDate,ManageUserID,ManageOrgID",false);
	doTemp.setVisible("RecoveryOrgID,RecoveryUserID,ClassifyResult",false);
    	
	//����ѡ��˫�����п�	
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("RecoveryUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName,TraceUserName"," style={width:150px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("Balance,ShiftBalance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResult"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum","2");
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,Balance,ActualPutOutSum","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("RecoveryUserName,CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
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
		{"true","","Button","��ͬ����","�鿴�Ŵ���ͬ��������Ϣ���������Ϣ����֤����Ϣ�ȵ�","viewAndEdit()",sResourcesPath},
		{"true","","Button","���������","������ͬ��ȫ�������˸���","my_ChangeUser()",sResourcesPath},
		{"false","","Button","����ƽ�����","��ͬ��������ת��","my_ShiftManage()",sResourcesPath},
		{"true","","Button","�鿴�����˱����¼","������ͬ��ȫ�������˸��ļ�¼","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","�鿴�ƽ����ͱ����¼","�鿴�ƽ����ͱ����¼","my_ChangeType()",sResourcesPath}
		};
	
	if(sCurItemID.equals("020"))	//�����ƽ�
	{
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
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
   	
   	/*~[Describe=���ı�ȫ��������;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeUser()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoveryOrgID");
			sOldUserID = getItemValue(0,getRow(),"RecoveryUserID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoveryOrgName");
			sOldUserName = getItemValue(0,getRow(),"RecoveryUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo,"right",OpenStyle);
		}
	}

	/*~[Describe=����ƽ�����;InputParam=��;OutPutParam=��;]~*/
	function my_ShiftManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			//�����Ի�ѡ���
			sOldShiftType = getItemValue(0,getRow(),"ShiftType");
			sShiftType = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftChoice.jsp","","dialogWidth=19;dialogHeight=07;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sShiftType)!="undefined" && sShiftType.length!=0)
			{
				if(sShiftType == sOldShiftType)
				{
					alert(getBusinessMessage("761"));	//��δ�ı��ƽ��������ͣ�����ȡ����
					return;
				}else if(confirm(getBusinessMessage("762")))   //�Ƿ�����滻�ƽ���������?
				{
					sReturn = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftAction.jsp?ShiftType="+sShiftType+"&SerialNo="+sSerialNo+"&OldShiftType="+sOldShiftType+"","","");
					if(sReturn == "true")//ˢ��ҳ��
					{
						alert(getBusinessMessage("763"));//�ƽ����ͱ���ɹ���
						reloadSelf();
					}
				}
			}
		}	
	}

    /*~[Describe=�鿴���������α����¼;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeUserRec()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo,"right",OpenStyle);			
		}
	}

	/*~[Describe=�鿴�ƽ��������α����¼;InputParam=��;OutPutParam=��;]~*/
	function my_ChangeType()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo+"&Flag=ShiftType","right",OpenStyle);			
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