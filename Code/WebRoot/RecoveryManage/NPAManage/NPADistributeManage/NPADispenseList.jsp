<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/02
*	Tester:
*	Describe: �����ʲ���Ϣ�б�
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :��ȫ������ԱID
*   	SerialNo	:��ͬ��ˮ��
*		sShiftType	:�ƽ�����
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//���������SQL���,��ѯ�����,����ֱ�������ر�־
	String sSql1 = "";
	ASResultSet rs1 = null;
	String sOrgFlag = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ȡ����ֱ�������ر�־
	sSql1 = " select NVL(OrgFlag,'') "+
			" from ORG_INFO "+
			" where OrgID = '"+CurOrg.OrgID+"' ";
	sOrgFlag = Sqlca.getString(sSql1);	
	//�������
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},				
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},
							{"CustomerName","�ͻ�����"},
							{"BusinessCurrencyName","����"},
							{"BusinessSum","��ͬ���"},
							{"ShiftBalance","�ƽ����"},
							{"Balance","��ǰ���"},
							{"CAVSum","�������"},
							{"Maturity","��������"},							
							{"ClassifyResultName","���շ���"},
							{"BadBizProjectFlagName","�ַ�����"},
							{"ShiftTypeName","�ƽ�����"},
							{"RecoveryUserName","�����ʲ�������"},
							{"RecoveryOrgName","�����ʲ��������"},
							{"ManageUserName","ԭ�ܻ���"},
							{"ManageOrgName","ԭ�ܻ�����"},
							{"RecoveryDate","��������"},
						}; 

 	sSql = " select SerialNo," + 	
		   " BusinessType,getBusinessName(BusinessType) as BusinessTypeName," + 
		   " getItemName('OccurType',OccurType) as OccurTypeName," + 
		   " CustomerName,getItemName('Currency',BusinessCurrency) as BusinessCurrencyName," + 
		   " BusinessSum,ShiftBalance,Balance, Cancelsum+CancelInterest as CAVSum,"+
		   " ClassifyResult,getItemName('ClassifyResult',ClassifyResult) as ClassifyResultName," + 
		   " BadBizProjectFlag,getItemName('BadBizProjectFlag',BadBizProjectFlag) as BadBizProjectFlagName," + 
		   " ShiftType,getItemName('ShiftType',ShiftType) as ShiftTypeName," + 
		   " RecoveryUserID,getUserName(RecoveryUserID) as RecoveryUserName,"+
		   " RecoveryOrgID,getOrgName(RecoveryOrgID) as RecoveryOrgName,"+
		   " getUserName(ManageUserID) as ManageUserName," + 
		   " getOrgName(ManageOrgID) as ManageOrgName,Maturity,RecoveryDate " + 
		   " from BUSINESS_CONTRACT "+
		   " where BadAssetLcFlag='020' ";//�����϶�����ͨ���ĺ�ͬ
	//���ݻ���ֱ�������ر�־ȡ��ͬ�Ľ����
	if(sOrgFlag.equals("020"))//��������/����
	{
		sSql+=" and GETORGFLAG(ManageOrgID) = '020' ";
	}else if(sOrgFlag.equals("030"))//����ֱ��֧��
	{
		sSql+=" and GETORGFLAG(ManageOrgID) = '030' ";
	}
		   
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("010010"))//�����ʲ�ת��δ�ַ�
	{
		sSql+=" and substr(ClassifyResult,1,2)>'02' and (RecoveryUserID is null or RecoveryUserID ='') ";
	}else if(sDealType.equals("010020"))//�����ʲ�ת���ѷַ�
	{
		sSql+=" and RecoveryUserID is not null and RecoveryUserID <>'' ";// and ManageFlag = '010'";
	}else if(sDealType.equals("020010"))//�����ʲ�ת��δ�ַ�
	{
		sSql+=" and substr(ClassifyResult,1,2)='01' and RecoveryUserID is not null and RecoveryUserID <>'' ";
	}else if(sDealType.equals("020020"))//�����ʲ�ת���ѷַ�
	{
		sSql+=" and (RecoveryUserID is null or RecoveryUserID ='') and  ManageFlag = '090' ";
	}else if(sDealType.equals("040"))//�����ʲ������˱��
	{
		sSql+=" and RecoveryUserID is not null and RecoveryUserID <>'' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("BadBizProjectFlag,BadBizProjectFlagName,RecoveryUserID,RecoveryOrgID,CAVSum,RecoveryUserName,RecoveryOrgName,ShiftBalance,ShiftType,BusinessType,FinishType,FinishDate,ClassifyResult,ShiftType,ShiftTypeName",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
    if(!sDealType.equals("010010"))
    {
    	doTemp.setVisible("RecoveryUserName,RecoveryOrgName,BadBizProjectFlagName",true);
    }
	//�����п�
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:120px} ");
	doTemp.setHTMLStyle("Flag5"," style={width:80px} ");
	doTemp.setHTMLStyle("OccurTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessCurrencyName"," style={width:40px} ");
	doTemp.setHTMLStyle("BusinessSum"," style={width:95px} ");
	doTemp.setHTMLStyle("ShiftBalance,Balance"," style={width:95px} ");
	doTemp.setHTMLStyle("ClassifyResultName,BadBizProjectFlagName"," style={width:55px} ");
	doTemp.setHTMLStyle("ShiftTypeName"," style={width:56px} ");
	doTemp.setHTMLStyle("Maturity"," style={width:65px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("ManageUserName,RecoveryUserName"," style={width:100px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,ShiftBalance,Balance,ActualPutOutSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,Balance,ActualPutOutSum,CAVSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,CAVSum,Balance,ActualPutOutSum","3");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,BusinessCurrencyName","2");
	//����header
	 if(sDealType.equals("020020"))//�����ʲ�ת���ѷַ�
	{
		 doTemp.setHeader("ClassifyResultName","ת������շ���");
		 doTemp.setHeader("ManageUserName","ת����ܻ���");
		 doTemp.setHeader("ManageOrgName","ת����ܻ�����");

	}else if(sDealType.equals("040"))//�����ʲ������˱��
	{
		doTemp.setHeader("RecoveryUserName","�ֲ����ʲ�������");
		doTemp.setHeader("RecoveryOrgName","�ֲ����ʲ��������");
	}

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
		{"false","","Button","�����϶�����","�����϶�","dutyCogn_Info()",sResourcesPath},
		{"false","","Button","�����϶�����","�����϶�","classify_Info()",sResourcesPath},
		{"false","","Button","���������","������ͬ��ȫ�������˸���","change_User()",sResourcesPath},
		{"false","","Button","�鿴�����˱����¼","������ͬ��ȫ�������˸��ļ�¼","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","ָ��������","ָ����ͬ�ܻ��˻��߸����ˣ�תΪ�ѷַ�","my_Distribute()",sResourcesPath},
		{"false","","Button","ת��","����ͬ�˻ظ�ԭ�ܻ���","my_ReverseHandover()",sResourcesPath},
		{"false","","TestFiled","��ʾ��Ϣ","��ʾ��Ϣ","<font style='color:red;'>���500���������У�100-500��Ԫ���أ�100��Ԫ���»���</font>",sResourcesPath}
		};
	
	if(sDealType.equals("010010"))//�����ʲ�ת��δ�ַ�
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"ָ��������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��ʾ��Ϣ")][0]="true";
	}else if(sDealType.equals("010020"))//�����ʲ�ת���ѷַ�
	{
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
	}else if(sDealType.equals("020010"))//�����ʲ�ת��δ�ַ�
	{	
		sButtons[getBtnIdxByName(sButtons,"ת��")][0]="true";
	}else if(sDealType.equals("040"))//�����ʲ������˱��
	{	
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�����϶�����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"���������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�鿴�����˱����¼")][0]="true";
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
	/*~[Describe=ָ����ȫ��������;InputParam=��;OutPutParam=��;]~*/   
	function my_Distribute()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			retrun;
		}
		else
		{
			//�����Ի�ѡ���
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp?ShowFlag=010","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0)
			{
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@"+sRecoveryUserID+"@String@RecoveryOrgID@"+sRecoveryOrgID+"@String@BadBizProjectFlag@"+sBadBizProjectFlag+"@String@ManageFlag@010@String@RecoveryDate@<%=StringFunction.getToday()%>,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("�ò����ʲ��ɹ��ַ�����"+sRecoveryUserName+"���ܻ���");
						self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=�����϶�����;InputParam=��;OutPutParam=��;]~*/
	function dutyCogn_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "NPAssetDutyList";
			sCompURL = "/CreditManage/CreditPutOut/NPADutyList.jsp";
			sParamString = "EditRight=2&ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=���շ�������;InputParam=��;OutPutParam=��;]~*/
	function classify_Info()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			sCompID = "ClassifyHistoryList";
			sCompURL = "/CreditManage/CreditPutOut/ClassifyHistoryList.jsp";
			sParamString = "ObjectType=BusinessContract&ObjectNo="+sSerialNo;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=ת��;InputParam=��;OutPutParam=��;]~*/	
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
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@RecoveryUserID@None@String@RecoveryOrgID@None@String@ManageFlag@090,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")//ˢ��ҳ��
				{
					alert(getBusinessMessage('784')); //�ò����ʲ��ѳɹ��˻ظ�ԭ�ܻ��ˣ�
					self.location.reload();
				}
			}
		}
	}

	/*~[Describe=���ı�ȫ��������;InputParam=��;OutPutParam=��;]~*/
	function change_User()
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