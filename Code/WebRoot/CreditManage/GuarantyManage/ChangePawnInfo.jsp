<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-12-15
		Tester:
		Describe: ��Ѻ����Ϣ���;
		Input Param:
			SerialNo: �����ˮ��
			GuarantyID:��Ѻ����ˮ��
			ChangeType: �������
				010 ��ֵ���
				020 �������
				030 ����Ȩ֤���
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ѻ����Ϣ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	if (sGuarantyID == null) sGuarantyID = "";
	String sChangeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ChangeType"));
	if (sChangeType == null) sChangeType = "";
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if (sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//����ChangeType�Ĳ�ͬ���õ���ͬ�Ĺ�������
    String sTempletFilter = " (ColAttribute like '%"+sChangeType+"%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("PawnChangeInfo",sTempletFilter,Sqlca);
	
	   //����һЩ������
    if(sChangeType.equals("010"))
    {
    	doTemp.setRequired("NewEvalOrgName,NewEvalNetValue,NewConfirmValue",true);
    }
    else if(sChangeType.equals("020"))
    {
    	doTemp.setRequired("NewCertType,NewCertID,NewOwnerName",true);
    } 
	//����Ȩ����ѡ���
	doTemp.setUnit("NewCertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("NewCertType,NewCertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("NewOwnerName"," style={width:400px} ");
	doTemp.setUnit("NewEvalOrgName"," <input type=button value=.. onclick=parent.selectNewEvalOrgName()>");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")+!CustomerManage.AddCustomerInfo(#NewOwnerID,#NewOwnerName,#NewCertType,#NewCertID,#NewLoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")+!CustomerManage.AddCustomerInfo(#NewOwnerID,#NewOwnerName,#NewCertType,#NewCertID,#NewLoanCardNo,#InputUserID)");
	
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ChangePawnList.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������
		setObjectValue("SelectOwner","","@NewOwnerID@0@NewOwnerName@1@NewCertType@2@NewCertID@3@NewLoanCardNo@4",0,0,"");
	}
	function selectNewEvalOrgName()
	{
		
		setObjectValue("selectNewEvalOrgName1","","@NewEvalOrgName@0",0,0,"");
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"NewCertType");
		var sCertID   = getItemValue(0,getRow(),"NewCertID");
		
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
			//��ÿͻ���š��ͻ����ƺʹ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ�ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"NewOwnerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"NewOwnerName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"NewLoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"NewLoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"NewOwnerID","");
				setItemValue(0,getRow(),"NewOwnerName","");	
				setItemValue(0,getRow(),"NewLoanCardNo","");			
			} 
		}		
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//���֤������Ƿ���ϱ������
		sNewCertType = getItemValue(0,0,"NewCertType");//--֤������		
		sNewCertID = getItemValue(0,0,"NewCertID");//֤������
		
		if(typeof(sNewCertType) != "undefined" && sNewCertType != "" )
		{
			//�ж���֯��������Ϸ���
			if(sNewCertType =='Ent01')
			{
				if(typeof(sNewCertID) != "undefined" && sNewCertID != "" )
				{
					if(!CheckORG(sNewCertID))
					{
						alert(getBusinessMessage('102'));//��֯������������						
						return false;
					}
				}
			}
				
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sNewCertType =='Ind01' || sNewCertType =='Ind08')
			{
				if(typeof(sNewCertID) != "undefined" && sNewCertID != "" )
				{
					if (!CheckLisince(sNewCertID))
					{
						alert(getBusinessMessage('156'));//���֤��������				
						return false;
					}
				}
			}
		}
		
		//У����Ȩ���˴�����
		sNewLoanCardNo = getItemValue(0,getRow(),"NewLoanCardNo");//��Ȩ���˴�����	
		if(typeof(sNewLoanCardNo) != "undefined" && sNewLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sNewLoanCardNo))
			{
				alert(getBusinessMessage('237'));//��Ȩ���˴���������							
				return false;
			}
			
			//������Ȩ���˴�����Ψһ��
			sNewOwnerName = getItemValue(0,getRow(),"NewOwnerName");//��Ȩ��������	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sNewOwnerName+","+sNewLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('238'));//����Ȩ���˴������ѱ������ͻ�ռ�ã�							
				return false;
			}						
		}
		
		//���ԭȨ�������ƺ���Ȩ���������Ƿ���ͬ
		sOldOwnerName = getItemValue(0,getRow(),"OldOwnerName");//ԭȨ��������	
		sNewOwnerName = getItemValue(0,getRow(),"NewOwnerName");//��Ȩ��������	
		if(typeof(sOldOwnerName) != "undefined" && sOldOwnerName != "" 
		&& typeof(sNewOwnerName) != "undefined" && sNewOwnerName != "")
		{
			if(sOldOwnerName == sNewOwnerName)
			{
				alert(getBusinessMessage('245'));//��Ȩ�������ƺ�ԭȨ�������Ʋ�����ͬ��							
				return false;
			}
		}
		
		//����������Ȩ�����Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ��Ȩ���˵Ŀͻ����
		if(typeof(sNewCertType) != "undefined" && sNewCertType != "" 
		&& typeof(sNewCertID) != "undefined" && sNewCertID != "")
		{
			var sNewOwnerID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sNewCertType+"&CertID="+sNewCertID,"","");
			if (typeof(sNewOwnerID)=="undefined" || sNewOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"NewOwnerID",sNewOwnerID);
		}			
		
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"ChangeType","<%=sChangeType%>");
			setItemValue(0,0,"ChangeDate","<%=StringFunction.getToday()%>");
<%
		ASResultSet rs=Sqlca.getASResultSet("select * from GUARANTY_INFO where GuarantyID='"+sGuarantyID+"'");
		if(rs.next())
		{ 
			String sEvalOrgID = DataConvert.toString(rs.getString("EvalOrgID"));
			String sEvalOrgName = DataConvert.toString(rs.getString("EvalOrgName"));
			String sEvalNetValue = DataConvert.toMoney(DataConvert.toString(rs.getString("EvalNetValue")));
			String sConfirmValue = DataConvert.toMoney(DataConvert.toString(rs.getString("ConfirmValue")));
			String sOwnerID = DataConvert.toString(rs.getString("OwnerID"));
			String sOwnerName = DataConvert.toString(rs.getString("OwnerName"));
			String sCertType = DataConvert.toString(rs.getString("CertType"));
			String sCertID = DataConvert.toString(rs.getString("CertID"));
			String sLoanCardNo = DataConvert.toString(rs.getString("LoanCardNo"));
			//����ֵת��Ϊ���ַ���
			if(sEvalOrgID == null) sEvalOrgID = "";
			if(sEvalOrgName == null) sEvalOrgName = "";
			if(sEvalNetValue == null) sEvalNetValue = "";
			if(sConfirmValue == null) sConfirmValue = "";
			if(sOwnerID == null) sOwnerID = "";
			if(sOwnerName == null) sOwnerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
			if(sLoanCardNo == null) sLoanCardNo = "";
%>
			setItemValue(0,0,"OldEvalOrgID","<%=sEvalOrgID%>");
			setItemValue(0,0,"OldEvalOrgName","<%=sEvalOrgName%>");
			setItemValue(0,0,"OldEvalNetValue","<%=sEvalNetValue%>");
			setItemValue(0,0,"OldConfirmValue","<%=sConfirmValue%>");
			setItemValue(0,0,"OldOwnerID","<%=sOwnerID%>");
			setItemValue(0,0,"OldOwnerName","<%=sOwnerName%>");
			setItemValue(0,0,"OldCertType","<%=sCertType%>");
			setItemValue(0,0,"OldCertID","<%=sCertID%>");
			setItemValue(0,0,"OldLoanCardNo","<%=sLoanCardNo%>");
<%
		}
		rs.getStatement().close(); 
%>
			bIsInsert = true;
		}
		
    }

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CHANGE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

