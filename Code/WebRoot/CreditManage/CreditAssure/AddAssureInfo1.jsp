<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ���ͬ�����ĵ�����ͬ���飨һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
			ObjectNo�������ţ���ͬ��ˮ�ţ�
			SerialNo��������ͬ���			
			GuarantyType��������ʽ
		Output Param:

		HistoryLog:pliu 2011-11-07
			 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//���ҳ�������������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//��ͬ��ˮ��
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	//out.print(sObjectNo);
	//���ҳ�������������ʽ��������ͬ���
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//������Ϣ���
	//����ֵת��Ϊ���ַ���
	if(sGuarantyType == null) sGuarantyType = "";
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sSql = " select CustomerID from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"' ";
	String sCustomerID = Sqlca.getString(sSql);
    //���ݵ�������ȡ����ʾģ���
    sSql = " select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo='"+sGuarantyType+"'";
	String sTempletNo = Sqlca.getString(sSql);
	//���ù�������
	String sTempletFilter = " (ColAttribute like '%BC%' ) ";
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//����Ȩ����ѡ���
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:400px} ");
	if(sGuarantyType.equals("010040")){
		doTemp.appendHTMLStyle("GuarantyInfo"," onkeyup=\"value=value.replace(/[^0-9]/g,&quot;&quot;) \" onbeforepaste=\"clipboardData.setData(&quot;text&quot;,clipboardData.getData(&quot;text&quot;).replace(/[^0-9]/g,&quot;&quot;))\" myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤������ķ�ΧΪ[0,100]\" ");
	}
	//���������������Ϊֻ��
	if(!"".equals(sSerialNo))
	{
		doTemp.setReadOnly("CertType,CertID,GuarantorName",true);
	}else{
		if("050".equals(sGuarantyType)||"060".equals(sGuarantyType))//��Ѻ����Ѻ
		{
			doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>");
		}else{
			doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()>");
		}
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent	
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGCChannel(#SerialNo)+!BusinessManage.InsertRelative("+sObjectNo+",GuarantyContract,#SerialNo,CONTRACT_RELATIVE)+!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#GuarantorID,#GuarantorName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
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
		OpenPage("/CreditManage/CreditAssure/AddAssureList1.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{		
		setItemValue(0,0,"ContractStatus","020");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼

			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","020");//��ǩ������ͬ
			setItemValue(0,0,"BusinessCurrency","01");//����
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		
		
		//����ˮ�������Ӧ�ֶ�
		//setItemValue(0,getRow(),"SerialNo",sSerialNo);
		var sTableName = "GUARANTY_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "ZJGC";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType()
	{
		sParaString = "CodeNo"+",AssureType";		
		setObjectValue("SelectCode",sParaString,"@CheckGuarantyMan2@0@CheckGuarantyMan2Name@1",0,0,"");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������
		var sReturn = "";
		if(sGuarantyType == '010020' || sGuarantyType == '010030')
		{
			setObjectValue("SelectInvest","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
		}else
		{
		    if(sGuarantyType == '010010' || sGuarantyType == '010040')
		    {
			sReturn=setObjectValue("SelectOwner3","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
			}else 
			{
			sReturn=setObjectValue("SelectOwner","","@GuarantorID@0@GuarantorName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");
			}
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				setFieldDisabled("GuarantorName");
				setFieldDisabled("CertType");
				setFieldDisabled("CertID");
			}			
		}
	}
	
	
	//�����򲻿���
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
      //getASObject(0,0,sField).style.background ="#efefef";
      //setItemValue(0,0,sField,"");
	}
	
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������		
		//�����������Ϊ��Ѻ����Ѻ����֤����Լ���ձ�֤��������֤����֤��ʱ�����¼���֤����źϷ��Խ�����֤
		if(sGuarantyType == '050' || sGuarantyType == '060' || sGuarantyType.substring(0,3) == '010')
		{
			//���֤������Ƿ���ϱ������
			sCertType = getItemValue(0,0,"CertType");//--֤������		
			sCertID = getItemValue(0,0,"CertID");//֤������
			
			if(typeof(sCertType) != "undefined" && sCertType != "" )
			{
				//�ж���֯��������Ϸ���
				if(sCertType =='Ent01')
				{
					if(typeof(sCertID) != "undefined" && sCertID != "" )
					{
						if(!CheckORG(sCertID))
						{
							alert(getBusinessMessage('102'));//��֯������������						
							return false;
						}
					}
				}
					
				//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
				if(sCertType =='Ind01' || sCertType =='Ind08')
				{
					if(typeof(sCertID) != "undefined" && sCertID != "" )
					{
						if (!CheckLisince(sCertID))
						{
							alert(getBusinessMessage('156'));//���֤��������				
							return false;
						}
					}
				}
			}
			
			//У�鵣���˴�����
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('414'));//�����˵Ĵ���������							
					return false;
				}
				
				//���鵣���˴�����Ψһ��
				sGuarantorName = getItemValue(0,getRow(),"GuarantorName");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sGuarantorName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('419'));//�õ����˵Ĵ������ѱ������ͻ�ռ�ã�							
					return false;
				}						
			}
			
			//�������ĵ������Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ�����˵Ŀͻ����
			if(typeof(sCertType) != "undefined" && sCertType != "" 
			&& typeof(sCertID) != "undefined" && sCertID != "")
			{
				var sGuarantorID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
				if (typeof(sGuarantorID)=="undefined" || sGuarantorID.length==0) {
					return false;
				}
				setItemValue(0,0,"GuarantorID",sGuarantorID);
			}			
		}
		
		//�����������Ϊ��֤����Լ���ձ�֤��������֤ʱ����Ե����˽��кϷ��Խ�����֤����֤�˷�ҵ�������ˣ�jlwu@
		if(sGuarantyType == '010010' || sGuarantyType == '010020' || sGuarantyType == '010030')
		{
			sCustomerID = "<%=sCustomerID%>";//ȡ��ҵ�������˵Ŀͻ�id
			sGuarantorID = getItemValue(0,getRow(),"GuarantorID");//��֤�˵Ŀͻ�id
			
			if(sCustomerID==sGuarantorID)
			{
				alert(getBusinessMessage('502'));//�ñ�֤�˲���Ϊ�Լ������ҵ����б�֤��
				return false;
			}	
		}
		
		//����������ڵ��߼�
		ssTempletNo	= "<%=sTempletNo%>";
		sCommonDate = getItemValue(0,getRow(),"CommonDate");
		sSignDate = getItemValue(0,getRow(),"SignDate");
		sBeginDate = getItemValue(0,getRow(),"BeginDate");			
		sEndDate = getItemValue(0,getRow(),"EndDate");
		
		if(ssTempletNo=="Guaranty011" || ssTempletNo=="Guaranty050" || ssTempletNo=="Guaranty060" || ssTempletNo=="Guaranty070" )
		{
			//�����������ڵ��߼�
			if (typeof(sSignDate)!="undefined" && sSignDate.length > 0)
			{
				if (typeof(sBeginDate)!="undefined" && sBeginDate.length > 0)
				{	
					if (typeof(sEndDate)!="undefined" && sEndDate.length > 0)
					{
						if(!(( sSignDate <= sBeginDate ) && (sBeginDate <= sEndDate)))
						{		    
							alert("��ͬǩ����Ӧ��С�ڵ��ں�ͬ��Ч�գ����Һ�ͬ��Ч��Ӧ��С�ڵ��ں�ͬ������!");
							return false;		    
						}
					}
				}
			}
		}
		
		
		return true;
	}

	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
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
							setItemValue(0,getRow(),"GuarantorID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"GuarantorName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"GuarantorID","");
				setItemValue(0,getRow(),"GuarantorName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 
		}		
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
