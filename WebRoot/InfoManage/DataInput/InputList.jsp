<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bma 2008-09-17
		Tester:
		Describe: �����б�;
		Input Param:
		DataInputType��020010δ������
					   020020�ѽ�����
					   030010�ѽ������ҵ��
					   030020�ѽ������ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag1"));
	if(sReinforceFlag==null) sReinforceFlag="";
	if(sFlag==null) sFlag="";
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
					{"SerialNo","��ݺ�"},
					{"RelativeSerialNo1","ԭҵ����"},
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"BusinessStatus","���״̬"},
					{"BusinessCurrency","����"},					
					{"BusinessType","�������"},
					{"ReturnType","���ʽ"},
					{"ClassifyResult","�弶����״̬"},									
					{"PutoutDate","��������"},
					{"Balance","������(Ԫ)"},
					{"NormalBalance","�������(Ԫ)"},
					{"OverdueBalance","�������(Ԫ)"},
					{"DullBalance","�������(Ԫ)"},
					{"BadBalance","�������(Ԫ)"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputDate","�Ǽ�����"}					
				  };
	String sHeaders1[][] = {
					{"SerialNo","��ݺ�"},
					{"Describe2","ҵ����"},
					{"RelativeSerialNo2","��ͬ���"},
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"BusinessType","ҵ��Ʒ��"},
					{"SubjectNo","��ƿ�Ŀ"},
					{"BusinessCurrency","����"},					
					{"Balance","���(Ԫ)"},
					{"NormalBalance","�������(Ԫ)"},
					{"OverdueBalance","�������(Ԫ)"},
					{"DullBalance","�������(Ԫ)"},
					{"BadBalance","�������(Ԫ)"},
					{"BusinessStatus","ҵ��״̬"},
					{"PutoutDate","ע������"},
					{"ClassifyResult","�弶����״̬"},	
					{"ReturnType","���ʽ"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputDate","�Ǽ�����"}	
				};
	
	if(sReinforceFlag.equals("020010"))  //δ������
	{
		 sSql = " select SerialNo,RelativeSerialNo1,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
		 		" getItemName('BusinessStatusType',BusinessStatus) as BusinessStatus,"+
		 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		 		" getBusinessName(BusinessType) as BusinessType,"+
		 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
		 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
		 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
		 		" from BUSINESS_DUEBILL where BusinessType like '1130%' and "+
		 		" (BusinessStatus = '01' or BusinessStatus = '' or BusinessStatus is null) "+
		 		" order by SerialNo desc";
	}else if(sReinforceFlag.equals("020020"))//�ѽ�����
	{
		sSql = " select SerialNo,RelativeSerialNo1,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
	 		" getItemName('BusinessStatusType',BusinessStatus) as BusinessStatus,"+
	 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
	 		" getBusinessName(BusinessType) as BusinessType,"+
	 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
	 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
	 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
	 		" from BUSINESS_DUEBILL where BusinessType like '1130%' and BusinessStatus = '82'"+
	 		" order by SerialNo desc";
	}else if(sReinforceFlag.equals("030010"))  //δ�������ҵ��
	{
		 sSql = " select SerialNo,Describe2,RelativeSerialNo2,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
		 		" getItemName('BusinessStatusType1',BusinessStatus) as BusinessStatus,"+
		 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
		 		" getBusinessName(BusinessType) as BusinessType,"+
		 		" SI.subjectno||subjectname as subjectno,"+
		 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
		 		" Balance,NormalBalance,OverdueBalance,DullBalance,"+
		 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
		 		" from BUSINESS_DUEBILL BD,SUBJECT_INFO SI where BD.SubjectNo = SI.SubjectNo and (BusinessType like '1080%' or BusinessType like '2060%' or BusinessType like '2050%') and"+
		 		" (BusinessStatus = '10' or BusinessStatus = '' or BusinessStatus is null)"+
		 		" order by Describe2 desc";
	}else if(sReinforceFlag.equals("030020"))//�ѽ������ҵ��
	{
		sSql = " select SerialNo,Describe2,RelativeSerialNo2,CustomerID,getCustomerName(CustomerID) as CustomerName,"+
	 		" getItemName('BusinessStatusType1',BusinessStatus) as BusinessStatus,"+
	 		" getItemName('Currency',BusinessCurrency) as BusinessCurrency,"+
	 		" getBusinessName(BusinessType) as BusinessType,"+
	 		" SI.subjectno||subjectname as subjectno,"+
	 		" getItemName('ReturnType',ReturnType) as ReturnType,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
	 		" PutoutDate,Balance,NormalBalance,OverdueBalance,DullBalance,"+
	 		" BadBalance,getOrgName(InputOrgID) as InputOrgName,getUserName(InputUserID) as InputUserName,InputDate "+
	 		" from BUSINESS_DUEBILL BD,SUBJECT_INFO SI where BD.SubjectNo = SI.SubjectNo and (BusinessType like '1080%' or BusinessType like '2060%' or BusinessType like '2050%') and BusinessStatus = '20'"+
	 		" order by Describe2 desc";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//��SQL������ɴ������
	if(sReinforceFlag.equals("020010")||sReinforceFlag.equals("020020"))  //���
	{
		doTemp.setHeader(sHeaders);
	}else	//����ҵ��
	{
		doTemp.setHeader(sHeaders1);
	}
	doTemp.UpdateTable = "BUSINESS_DUEBILL";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ò��ɼ���
	//doTemp.setVisible("CustomerID,CustomerType,OccurType,BusinessCurrency,VouchType",false);
	//doTemp.setVisible("BusinessType,FinishType",false);
	
	doTemp.setUpdateable("",false);
	doTemp.setAlign("Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");
	doTemp.setCheckFormat("BusinessSum,Balance,Interestbalance1,Interestbalance2","2");
	
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,InputDate"," style={width:80px} ");
	//doTemp.setHTMLStyle("CustomerTypeName,CertID,ManageUserIDName"," style={width:80px} ");
	//doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	//doTemp.setHTMLStyle("VouchTypeName"," style={width:170px} ");
	//doTemp.setHTMLStyle("BusinessTypeName"," style={width:100px} ");
		
	//���ɲ�ѯ��
	if(sReinforceFlag.equals("020010") ||sReinforceFlag.equals("020020"))
	{
		doTemp.setColumnAttribute("CustomerName,SerialNo,BusinessType","IsFilter","1");
	}else
	{
		doTemp.setColumnAttribute("CustomerName,SerialNo,BusinessType,Describe2,RelativeSerialNo2","IsFilter","1");
	}
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); //��������ҳ

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
				{"true","","Button","����","����","NewContract()",sResourcesPath},
				{"true","","Button","����","����","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","ɾ��","ɾ��","my_del()",sResourcesPath}
			};
	
	//�ѽ�����
	if(sReinforceFlag.equals("020020") ||sReinforceFlag.equals("030020")) 
	{
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
	}
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		//��jsp�еı���ֵת����js�еı���ֵ
		sReinforceFlag = "<%=sReinforceFlag%>";
		sSerialNo = "";
		
		if(sReinforceFlag == "020010")	//δ�������
		{
			//��������ҳ��
			sCompID = "NewContract";
			sCompURL = "/InfoManage/DataInput/NewContract.jsp";
			sReturn = popComp(sCompID,sCompURL,"SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sSerialNo=sReturn[0];
			
	        //���������ɵ���ˮ�ţ��������������
			sCompID = "NewInputInfo";
			sCompURL = "/InfoManage/DataInput/NewInputInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}else	//δ�������ҵ��
		{
			//��������ҳ��
			sCompID = "NewNational";
			sCompURL = "/InfoManage/DataInput/NewNational.jsp";
			sReturn = popComp(sCompID,sCompURL,"SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			sReturn = sReturn.split("@");
			sSerialNo=sReturn[0];
			
	        //���������ɵ���ˮ�ţ��������������
			sCompID = "NewNationalInfo";
			sCompURL = "/InfoManage/DataInput/NewNationalInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}		
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(sReinforceFlag == "030010" ||sReinforceFlag == "030020" ) //����ҵ��
		{
			 //���������ɵ���ˮ�ţ��������������
			sCompID = "NewNationalInfo";
			sCompURL = "/InfoManage/DataInput/NewNationalInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else	//����
		{
			 //���������ɵ���ˮ�ţ��������������
			sCompID = "NewInputInfo";
			sCompURL = "/InfoManage/DataInput/NewInputInfo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function my_del()
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
