<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2009/09/08
		Tester:
		Describe: ��������������Ϣ�б�
		Input Param:
			ObjectType: ��������
			ObjectNo��������
		Output Param:
			SerialNo��ҵ����ˮ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectType == null ) sObjectType = "";
	if(sObjectNo == null ) sObjectNo = "";
	String sSql1 = "select ApplyType ,ContractSerialNo from BADBIZ_APPLY where serialno='"+sObjectNo+"' " ;
	ASResultSet rs2 = Sqlca.getASResultSet(sSql1);
	String sApplyType = "";
	String sContractSerialNo = "";
	if(rs2.next()){
		sApplyType = rs2.getString(1);
		sContractSerialNo = rs2.getString(2);
	}
	rs2.getStatement().close();
	if(sApplyType == null) sApplyType = "";
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	String sHeaders[][] = 	{
				{"SerialNo","��ˮ��"},	
				{"ObjectNo","���ʵ�ծ������"},
				{"ContractSerialNo","��ͬ����ˮ��"},	
				{"ContractSerialNo1","��ծ�����ͬ��ˮ��"},
				{"CustomerName","�ͻ�����"},
				{"BusinessType","ҵ��Ʒ��"},
				{"OccurType","��������"},
				{"BusinessCurrency","����"},
				{"VouchType","������ʽ"},
				{"BusinessSum","��ͬ���"},
				{"Balance","��ǰ���"},
				{"ClassifyResult","���շ���"},
				{"InterestBalance1","����ǷϢ"},
				{"InterestBalance2","����ǷϢ"},
				{"OriginalPutOutDate","�״η�����"},
				{"Maturity","�������"},
				{"FinishDate","��ͬ�ս�����"},
//				{"Balance","��Ƿ�����(Ԫ)"},
//				{"Interest","��Ƿ������Ϣ(Ԫ)"},
				{"OrgName","�Ǽǻ���"},
				{"UserName","�Ǽ���"},
				{"BadBizProjectFlagName","��Ŀ����"},
				{"RecoveryOrgName","�������"},
				{"RecoveryUserName","����������"},
				{"AssetSum","��ֳ������"},
				{"AssetInterestBalance1","��ֳ�����ǷϢ"},
				{"AssetInterestBalance2","��ֳ�����ǷϢ"},
			      	};
	String sSql = "";
	if("030".equals(sApplyType)){
		 sSql =	" select SerialNo as ContractSerialNo,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
						" getBusinessName(BusinessType) as BusinessType , getItemName('OccurType',OccurType) as OccurType,"+
						" getItemName('Currency',BusinessCurrency) as BusinessCurrency ,getItemName('VouchType',VouchType) as VouchType," +
						" BusinessSum,Balance,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult ,InterestBalance1,"+
						" InterestBalance2,OriginalPutOutDate,Maturity,FinishDate "+
						" from BUSINESS_CONTRACT " +
						" where SerialNo = '"+sContractSerialNo+"'";
	}else{
		 sSql =	" select AB.SerialNo,AB.ObjectNo as ObjectNo,AB.ContractSerialNo as ContractSerialNo1,AB.CustomerID,"+
						" getBusinessName(BC.BusinessType) as BusinessType , getItemName('OccurType',BC.OccurType) as OccurType,"+
						" getCustomerName(AB.CustomerID) as CustomerName,"+
						" getItemName('Currency',BC.BusinessCurrency) as BusinessCurrency ,getItemName('VouchType',BC.VouchType) as VouchType," +
						" BC.BusinessSum,AB.Balance,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult ,BC.InterestBalance1,"+
						" BC.InterestBalance2,BC.OriginalPutOutDate,BC.Maturity,BC.FinishDate ,"+
						" AB.InputOrgID,getOrgName(AB.InputOrgID) as OrgName,AB.InputUserID,getUserName(AB.InputUserID) as UserName, " +
						" getItemName('BadBizProjectFlag',BC.BadBizProjectFlag) as BadBizProjectFlagName,"+
						" getOrgName(BC.RecoveryOrgID) as RecoveryOrgName,"+
						" getUserName(BC.RecoveryUserID) as RecoveryUserName,"+
						" AB.AssetSum,AB.InterestBalance1 as AssetInterestBalance1,AB.InterestBalance2 as AssetInterestBalance2 "+
						" from ASSET_BIZ AB,BUSINESS_CONTRACT BC " +
						" where AB.ContractSerialNo = BC.SerialNo and "+
						" AB.ObjectNo='"+sObjectNo+"' and AB.ObjectType='"+sObjectType+"' " ;

	}
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_BIZ";
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);
	doTemp.setVisible("ObjectType,CustomerID,InputOrgID,InputUserID,SerialNo",false);
	if("030".equals(sApplyType))
	{
		doTemp.setVisible("BusinessCurrency,VouchType,OriginalPutOutDate,Maturity,FinishDate,OrgName,UserName",false);
	}else{
		doTemp.setVisible("BadBizProjectFlagName,RecoveryOrgName,RecoveryUserName,AssetSum,AssetInterestBalance1,AssetInterestBalance2",false);
	}
	doTemp.setUpdateable("UserName,OrgName",false);

	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	
	//����С����ʾ״̬,
	doTemp.setAlign("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","3");
	doTemp.setType("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,Balance,InterestBalance1,InterestBalance2,AssetSum,AssetInterestBalance1,AssetInterestBalance2","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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

	String sButtons[][] = 
		{
		{"true","","Button","����","������������������Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��������������Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����������������Ϣ","deleteRecord()",sResourcesPath},
		};
		
	if("030".equals(sApplyType)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/AssetBizInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		if("<%=sApplyType%>" == "030"){		
			sObjectType = "BusinessContract";
			sObjectNo = getItemValue(0,getRow(),"ContractSerialNo");
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
		else{
			sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else
			{
				OpenPage("/RecoveryManage/NPAManage/NPAApplyManage/AssetBizInfo.jsp?SerialNo="+sSerialNo, "_self","");
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

<%@include file="/IncludeEnd.jsp"%>
