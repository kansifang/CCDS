<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/15
*	Tester:
*	Describe: ��ծ�ʲ���Ϣ�б�
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
	String PG_TITLE = "��ծ�ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//�������
	String sHeaders[][] = {
							{"SerialNo","��ծ�ʲ����"},	
							{"CurrencyName","����"},
							{"OperateTypeName","��ծ�ʲ�ȡ�÷�ʽ"},
							{"BorrowerName","���������"},
							{"Number","�ֳ��������"},
							{"BusinessSum","�ֳ������"},
							{"InAccontSum","��ծ�ʲ����˽��"},
							{"InterestBalance","�ֳ���Ϣ���"},
							{"InterestBalance1","�ֳ����������Ϣ"},
							{"InterestBalance2","�ֳ����������Ϣ"},
							{"AssetName","��ծ�ʲ�����"},
							{"ManageUserName","ָ����ծ�ʲ�������"},
							{"ManageOrgName","ָ����ծ�ʲ�ָ������"},
							{"OperateUserName","ԭ�ܻ���"},	
							{"OperateUserID","ԭ�ܻ���"},	
							{"OperateOrgName","ԭ�ܻ�����"},
							{"InputDate","�Ǽ�ʱ��"}
						}; 

 	sSql = " select SerialNo,getItemName('Currency',Currency) as CurrencyName," + 	
		   " OperateType,getItemName('PDAGainType',OperateType) as OperateTypeName," + 
		   " BorrowerName,"+
		   " Number,BusinessSum,InterestBalance1,InterestBalance2,InterestBalance,InAccontSum,AssetName," + 
		   " ManageUserID,getUserName(ManageUserID) as ManageUserName," + 
		   " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,"+
		   " OperateUserID,getUserName(OperateUserID) as OperateUserName," + 
		   " OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,InputDate" + 
		   " from BADBIZ_APPLY "+
		   " where ApplyType='010' ";//�����϶�����ͨ���ĺ�ͬ
	
		   
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("030010"))//��ծ�ʲ�δ�ַ�
	{
		sSql+=" and ManageFlag='010' and (ManageUserID is null or ManageUserID ='')  ";
	}else if(sDealType.equals("030020"))//��ծ�ʲ��ѷַ�
	{
		sSql+=" and ManageFlag in('020','030') and ManageUserID is not null and ManageUserID !='' ";
	}else if(sDealType.equals("030020010"))//��ծ�ʲ��ѷַ��ѽ���
	{
		sSql+=" and ManageFlag='030' and ManageUserID is not null and ManageUserID !='' ";
	}else if(sDealType.equals("030020020"))//��ծ�ʲ��ѷַ�δ����
	{
		sSql+=" and ManageFlag='020' and ManageUserID is not null and ManageUserID !=''  ";
	}else if(sDealType.equals("050"))//��ծ�ʲ������˱��
	{
		sSql+=" and ManageFlag in ('020','030') and ManageUserID is not null and ManageUserID !=''  ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ManageUserID,ManageOrgID,ManageOrgName,ManageUserName,InterestBalance,InputDate,OperateTypeName,OperateType,OperateUserID,OperateOrgID",false);
	doTemp.setKeyFilter("SerialNo");		//add by hxd in 2005/02/20 for �ӿ��ٶ�
	
	if(!sDealType.equals("030010"))//��ծ�ʲ�δ�ַ�
	{
		doTemp.setVisible("ManageOrgName,ManageUserName",true);
	}
	//�����п�
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");
	doTemp.setHTMLStyle("BorrowerName"," style={width:300px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,InterestBalance,InAccontSum,InterestBalance1,InterestBalance2, ","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,InterestBalance,InAccontSum,InterestBalance1,InterestBalance2,","2");
	doTemp.setCheckFormat("Number","5");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,InterestBalance,Number,InAccontSum,InterestBalance1,InterestBalance2,","3");
	
	//����header
	 if(sDealType.equals("030020010"))//��ծ�ʲ��ѷַ��ѽ���
	{
		doTemp.setHeader("ManageUserName","��ծ�ʲ�������");
		doTemp.setHeader("ManageOrgName","��ծ�ʲ��������");
	}else if(sDealType.equals("030020020"))//��ծ�ʲ��ѷַ�δ����
	{
		doTemp.setHeader("ManageUserName","��ծ�ʲ�������");
		doTemp.setHeader("ManageOrgName","��ծ�ʲ��������");
	}else if(sDealType.equals("050"))//��ծ�ʲ������˱��
	{
		doTemp.setHeader("ManageUserName","�ֵ�ծ�ʲ�������");
		doTemp.setHeader("ManageOrgName","�ֵ�ծ�ʲ��������");
	}
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
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
		{"true","","Button","��ծ����","��ծ����","viewTab()",sResourcesPath},
		{"true","","Button","�����������","�����������","viewOpinions()",sResourcesPath},
		{"false","","Button","ָ��������","ָ����ծ�ʲ��ܻ��ˣ�תΪ�ѷַ�","my_Distribute()",sResourcesPath},
		{"false","","Button","���������","������ͬ��ȫ�������˸���","change_User()",sResourcesPath},
		{"false","","Button","�鿴�����˱����¼","������ͬ��ȫ�������˸��ļ�¼","my_ChangeUserRec()",sResourcesPath},
		};
	
	if(sDealType.equals("030010"))//��ծ�ʲ�δ�ַ�
	{
		sButtons[getBtnIdxByName(sButtons,"ָ��������")][0]="true";
	}else if(sDealType.equals("050"))
	{
		sButtons[getBtnIdxByName(sButtons,"���������")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�鿴�����˱����¼")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>


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
				var sBadBizProjectFlag = sRecovery[3];
				
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageUserID@"+sRecoveryUserID+"@String@ManageOrgID@"+sRecoveryOrgID+"@String@ManageFlag@020,BADBIZ_APPLY,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
						alert("�õ�ծ�ʲ��ɹ��ַ�����"+sRecoveryUserName+"���ܻ���");
						self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//����������͡�������ˮ��
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			sOldOrgID = getItemValue(0,getRow(),"ManageOrgID");
			sOldUserID = getItemValue(0,getRow(),"ManageUserID");
			sOldOrgName	= getItemValue(0,getRow(),"ManageOrgName");
			sOldUserName = getItemValue(0,getRow(),"ManageUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BadBizAsset&ObjectNo="+sSerialNo,"right",OpenStyle);
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
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectType=BadBizAsset&ObjectNo="+sSerialNo,"right",OpenStyle);			
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