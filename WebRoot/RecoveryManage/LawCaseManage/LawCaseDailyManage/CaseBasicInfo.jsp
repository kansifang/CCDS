<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ����������Ϣ
		Input Param:
			        SerialNo:������ˮ��
			        LawCaseType����������			        
		Output param:
		               
		History Log: zywei 2005/09/06 �ؼ����
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//������������������ˮ�š��������ͣ�
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sLawCaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("LawCaseType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null ) sSerialNo = "";
	if(sLawCaseType == null ) sLawCaseType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	if (sLawCaseType.equals("01"))
		sTempletNo="LawCaseInfo1";	//һ�㰸��
	else if (sLawCaseType.equals("02"))
		sTempletNo="LawCaseInfo2";	//����/�ٲ�ִ�а���
	else if (sLawCaseType.equals("05"))
		sTempletNo="LawCaseInfo5";	//�Ʋ�����
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�Զ����������ܱ��
	doTemp.appendHTMLStyle("Principal,InDebtInterest,OutDebtInterest,OtherCost"," onChange=\"javascript:parent.getAimSum()\" ");
	
	//ѡ���ֻ�������Ա
	doTemp.setUnit("ManageUserName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.OrgID+"\",\"ManageUserID\",\"ManageUserName\",\"ManageOrgID\",\"ManageOrgName\")>");
	doTemp.setUnit("OperateUserName"," <input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectUser(\""+CurOrg.OrgID+"\",\"OperateUserID\",\"OperateUserName\",\"OperateOrgID\",\"OperateOrgName\")>");
	
	//ѡ��Ժ
	doTemp.setUnit("CourtStatus"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getAgencyName()\">");
	doTemp.appendHTMLStyle("CourtStatus","  style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getAgencyName()\" ");
	
	
	//���ñ��ʷ�Χ
	doTemp.appendHTMLStyle("EnforcedCost"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�Ʋ��峥�ʵķ�ΧΪ[0,100]\" ");
	
	//���ݲ�ͬ�İ������͹������е����ϵ�λ
	doTemp.setDDDWSql("LawsuitStatus","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'LawsuitStatus' and ItemAttribute = '"+sLawCaseType+"' ");
	
	//���ƽ��ķ�Χ�������ʽ
	doTemp.appendHTMLStyle("AimSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ϊ������\" ");
	doTemp.appendHTMLStyle("Principal"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���У�������Ϊ������\" ");
	doTemp.appendHTMLStyle("InDebtInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ϣ����Ϊ������\" ");
	doTemp.appendHTMLStyle("OutDebtInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ϣ����Ϊ������\" ");
	doTemp.appendHTMLStyle("OtherCost"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������Ϊ������\" ");
	doTemp.appendHTMLStyle("LegalCost"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ծȨ�걨����Ϊ������\" ");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ѡ��������������;InputParam=��;OutPutParam=��;]~*/
	function getAgencyName()
	{		
		sParaString = "AgencyType"+",01";
		setObjectValue("SelectAgency",sParaString,"@CourtStatus@1",0,0,"");			
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	</script>
	
	<script language=javascript>	
	
	//������������У����𣬱�����Ϣ��������Ϣ��������������ܱ��	
	function getAimSum()
 	{ 
       sPrincipal = getItemValue(0,getRow(),"Principal");
       sInDebtInterest = getItemValue(0,getRow(),"InDebtInterest");
       sOutDebtInterest = getItemValue(0,getRow(),"OutDebtInterest");
       sOtherCost = getItemValue(0,getRow(),"OtherCost");
       sCurrency = getItemValue(0,getRow(),"Currency");
 
       if(typeof(sPrincipal)=="undefined" || sPrincipal.length==0) sPrincipal=0; 
       if(typeof(sInDebtInterest)=="undefined" || sInDebtInterest.length==0) sInDebtInterest=0;
       if(typeof(sOutDebtInterest)=="undefined" || sOutDebtInterest.length==0) sOutDebtInterest=0; 
       if(typeof(sOtherCost)=="undefined" || sOtherCost.length==0) sOtherCost=0; 

		//��ȡ����sCurrency������ҵĻ���
		var sReturn = PopPage("/RecoveryManage/PDAManage/PDADailyManage/PDAGetRMBExchangeRateDialog.jsp?ReclaimCurrency="+sCurrency,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		sReturn = sReturn.split("@");
		sRatio=sReturn[0];
		sOtherCost=sOtherCost*sRatio;  //ת��Ϊ���
		  
       //�����ܱ��=���У�����+������Ϣ+������Ϣ+����
       sAimSum = sPrincipal+sInDebtInterest+sOutDebtInterest+sOtherCost;
	   setItemValue(0,getRow(),"AimSum",sAimSum);       
    }
     	
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sParam,sUserID,sUserName,sOrgID,sOrgName)
	{		
		sParaString = "BelongOrg"+","+sParam;
		setObjectValue("SelectUserBelongOrg",sParaString,"@"+sUserID+"@0@"+sUserName+"@1@"+sOrgID+"@2@"+sOrgName+"@3",0,0,"");
	}
	
	/*--------��������ܳ���---------	 add by zwhu  */
	function getCoverRatio()
	{
		dBankruptSum = getItemValue(0,getRow(),"BankruptSum");
		dCoverSum = getItemValue(0,getRow(),"CoverSum");
		dCoverRatio = roundOff(parseFloat(dCoverSum)/parseFloat(dBankruptSum)*100,2);
		if(dCoverRatio>0)
		{
			setItemValue(0,getRow(),"CoverRatio",dCoverRatio);
		}
	}
	/*~[Describe=�����Զ���С��λ����������,����objectΪ�������ֵ,����decimalΪ����С��λ��;InputParam=��������������λ��;OutPutParam=��������������;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;	
	}
	
	function selectCustomer()
	{
		setObjectValue("SelectCustomer","","@LawCaseOrg@0",0,0,"");
	}
	</script>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
