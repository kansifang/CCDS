<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --cchang  2004.12.2
		Tester:
		Content: --�ͻ��ſ�
		Input Param:
			  CustomerID:--�ͻ���
		Output param:
		History Log: 
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д
		   2005.9.10 zywei         �ؼ���� 
		   2005.12.15 jbai
		   2006.10.16 fhuang       �ؼ����
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sCustomerInfoTemplet = "";//--ģ������
    String sSql = "";//--���sql���
    String sCustomerType = "";//--��ſͻ�����   
    String sCustomerScale = "";//--��С�ͻ���ģ   
    String sItemAttribute = "" ;
    String sTempSaveFlag = "" ;//�ݴ��־
	String sCertType = "",sCertID = "",sAttribute3 = "";
	ASResultSet rs = null;//-- ��Ž����
	String sIsUseSmallTemplet = ""; //--�Ƿ�ʹ��С��ҵ����ģ��
	
	//����������,�ͻ�����
    String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ�ÿͻ�����
	sSql = "select CustomerType,CertType,CertID,CustomerScale from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType");
		sCertID = rs.getString("CertID");
		sCustomerScale = rs.getString("CustomerScale");
	}
	rs.getStatement().close();

	if(sCustomerType == null) sCustomerType = "";
	if(sCertType == null) sCertType = "";
	if(sCertID == null) sCertID = "";	
	
	//ȡ����ͼģ������
	sSql = " select ItemAttribute,Attribute3  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo = '"+sCustomerType+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
		sItemAttribute = DataConvert.toString(rs.getString("ItemAttribute"));		//�ͻ�������ͼ����
		sAttribute3 = DataConvert.toString(rs.getString("Attribute3"));		//��С��ҵ�ͻ�������ͼ����
	}
	rs.getStatement().close(); 
	
	if(sCustomerType.substring(0,2).equals("01")){
		sSql = "select TempSaveFlag from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		sTempSaveFlag = Sqlca.getString(sSql);
	}
	if(sCustomerType.substring(0,2).equals("03")){
		sSql = "select TempSaveFlag from IND_INFO where CustomerID = '"+sCustomerID+"' ";
		sTempSaveFlag = Sqlca.getString(sSql);
	}
	if(sTempSaveFlag == null) sTempSaveFlag = "";
	
	if(sCustomerScale!=null&&sCustomerScale.startsWith("02"))
	{
		//��˾�ͻ�������ʾģ��
		sCustomerInfoTemplet = sAttribute3;		//��С��˾�ͻ�������ʾģ��
	}else
	{
		//��˾�ͻ�������ʾģ��
		sCustomerInfoTemplet = sItemAttribute;		//��˾�ͻ�������ʾģ��
	}
	
	
	if(sCustomerInfoTemplet == null) sCustomerInfoTemplet = "";
		
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	//¼�빫˾�ͻ���Ϣʱ�жϣ��û����û��Ƿ���Ȩʹ��С��ҵ����ģ��
	if(sCustomerType.substring(0,2).equals("01"))
	{
		sIsUseSmallTemplet = Sqlca.getString(" select IsUseSmallTemplet from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ");
		if(sIsUseSmallTemplet == null) sIsUseSmallTemplet = "";
	}
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sCertType.equals("Ind01") || sCertType.equals("Ind08"))
	{
		doTemp.setReadOnly("Sex,Birthday",true);
	}	
	//���ù��ڵ���ѡ��ʽ
	doTemp.appendHTMLStyle("RegionName"," style=cursor:hand; onClick=\"javascript:parent.getRegionCode()\" ");	
	
	//����ע���ʱ���Χ
	doTemp.appendHTMLStyle("RegisterCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ע���ʱ�������ڵ���0��\" ");
	//����ְ��������Χ
	if(sCustomerType.substring(0,2).equals("04"))
	{
		doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>0 \" mymsg=\"����С���Ա�����������5��\" ");
	}else
	{
		doTemp.appendHTMLStyle("EmployeeNumber"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ְ������������ڵ���0��\" ");
	}
	//����ʵ���ʱ���Χ
	doTemp.appendHTMLStyle("PaiclUpCapital"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ʵ���ʱ�������ڵ���0��\" ");
	//���þ�Ӫ���������ƽ���ף���Χ
	doTemp.appendHTMLStyle("WorkFieldArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӫ���������ƽ���ף�������ڵ���0��\" ");
	//���ü�ͥ������(Ԫ)��Χ
	doTemp.appendHTMLStyle("FamilyMonthIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͥ������(Ԫ)������ڵ���0��\" ");
	//���ø���������(Ԫ)��Χ
	doTemp.appendHTMLStyle("YearIncome"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����������(Ԫ)������ڵ���0��\" ");
	
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ò���͸����¼������������͸���(���¿ͻ��Ĵ�����) 
	if(sCustomerType.substring(0,2).equals("01")) //��˾�ͻ�
	{
    	if(sCertType.equals("Ent01"))
    	{
    		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.UserID+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+",#CorpID,#LoanCardNo,"+CurUser.UserID+")");
  		}
  		else
  		{
  			dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
			dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#EnterpriseName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
  		}
  		
  }else if(sCustomerType.substring(0,2).equals("03"))//���˿ͻ�
  {
		dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#FullName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
		dwTemp.setEvent("AfterUpdate","!CustomerManage.AddCustomerInfo(#CustomerID,#FullName,"+sCertType+","+sCertID+",#LoanCardNo,"+CurUser.UserID+")");
  }
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(dwTemp.Name);
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
				{sTempSaveFlag.equals("2")?"false":"true","","Button","�ݴ�","��ʱ���������޸�����","saveRecordTemp()",sResourcesPath}
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
		getEnterpriseScale();
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(vI_all("myiframe0")){
			//¼��������Ч�Լ��
			if (!ValidityCheck()) return;
			beforeUpdate();
			setItemValue(0,getRow(),'TempSaveFlag',"2");//�ݴ��־��1���ǣ�2����
			as_save("myiframe0","");		
			if(sCustomerType=='02')
			{
				afterUpdate();	
			}					
		}
	}
	
	function alertMsg(){
		alert("�����¼��������Ϣ��");
	}
		
	function saveRecordTemp()
	{
		var sCustomerType = "<%=sCustomerType%>";
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"1");//�ݴ��־��1���ǣ�2����
		as_save("myiframe0");   //���ݴ�
		setNeedCheckRequired(0);//����ٽ����������û���	
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		//sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		// getEnterpriseScale();
	}
	//������ſͻ��ܻ�����Ϣ
	function afterUpdate(){
		var sUserID=getItemValue(0,getRow(),"UserID");
		var sOrgID= getItemValue(0,getRow(),"OrgID");
		var scustomerID =getItemValue(0,getRow(),"CustomerID");
		sReturn = RunMethod("CustomerManage","UpdateCustomerBelong",sOrgID+","+sUserID+","+scustomerID);
	}

	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		var sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		if(sCustomerType == '01') //��˾�ͻ�
		{			
			//1��У��Ӫҵִ�յ������Ƿ�С��Ӫҵִ����ʼ��			
			sLicensedate = getItemValue(0,getRow(),"Licensedate");//Ӫҵִ�յǼ���			
			sLicenseMaturity = getItemValue(0,getRow(),"LicenseMaturity");//Ӫҵִ�յ�����
			sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sLicensedate) != "undefined" && sLicensedate != "" && 
			typeof(sLicenseMaturity) != "undefined" && sLicenseMaturity != "")
			{
				if(sLicensedate >= sToday)
				{		    
					alert(getBusinessMessage('132'));//Ӫҵִ�յǼ��ձ������ڵ�ǰ���ڣ�
					return false;		    
				}
				if(sLicenseMaturity <= sLicensedate)
				{		    
					alert(getBusinessMessage('118'));//Ӫҵִ�յ����ձ�������Ӫҵִ�յǼ��գ�
					return false;		    
				}
			}
			//2��У�鵱���ڹ���(����)��Ϊ�л����񹲺͹�ʱ���ͻ�Ӣ�����Ʋ���Ϊ��			
			sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");//���ڹ���(����)
			sEnglishName = getItemValue(0,getRow(),"EnglishName");//�ͻ�Ӣ������
			if(sCountryTypeValue != 'CHN')
			{
				if (typeof(sEnglishName) == "undefined" || sEnglishName == "" )
				{
					alert(getBusinessMessage('119')); //���ڹ���(����)��Ϊ�л����񹲺͹�ʱ���ͻ�Ӣ��������Ϊ�գ�
					return false;	
				}
			}
			//3��У����������
			sOfficeZip = getItemValue(0,getRow(),"OfficeZIP");//��������
			if(typeof(sOfficeZip) != "undefined" && sOfficeZip != "" )
			{	
				if(!CheckPostalcode(sOfficeZip))
				{
					alert(getBusinessMessage('120'));//������������
					return false;
				}
			}
			//4��У����ϵ�绰
			sOfficeTel = getItemValue(0,getRow(),"OfficeTel");//��ϵ�绰	
			if(typeof(sOfficeTel) != "undefined" && sOfficeTel != "" )
			{
				if(!CheckPhoneCode(sOfficeTel))
				{
					alert(getBusinessMessage('121'));//��ϵ�绰����
					return false;
				}
			}
			//5��У�鴫��绰
			sOfficeFax = getItemValue(0,getRow(),"OfficeFax");//����绰	
			if(typeof(sOfficeFax) != "undefined" && sOfficeFax != "" )
			{
				if(!CheckPhoneCode(sOfficeFax))
				{
					alert(getBusinessMessage('124'));//����绰����
					return false;
				}
			}
			//6��У�������ϵ�绰
			sFinanceDeptTel = getItemValue(0,getRow(),"FinanceDeptTel");//������ϵ�绰	
			if(typeof(sFinanceDeptTel) != "undefined" && sFinanceDeptTel != "" )
			{
				if(!CheckPhoneCode(sFinanceDeptTel))
				{
					alert(getBusinessMessage('125'));//������ϵ�绰����
					return false;
				}
			}
			//7��У������ʼ���ַ
			sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//�����ʼ���ַ	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" )
			{
				if(!CheckEMail(sEmailAdd))
				{
					alert(getBusinessMessage('130'));//��˾E��Mail����
					return false;
				}
			}
			
			//8��У�������
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('101'));//����������							
					return false;
				}
				
				//���������Ψһ��
				sCustomerName = getItemValue(0,getRow(),"EnterpriseName");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					//alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					//return false;
				}						
			}
			
			//9:У�鵱�Ƿ��ſͻ�Ϊ��ʱ�����������ϼ���˾���ơ��ϼ���˾��֯����������ϼ���˾������
			sECGroupFlag = getItemValue(0,getRow(),"ECGroupFlag");//�Ƿ��ſͻ�
			if(sECGroupFlag == '1')//�Ƿ��ſͻ���1���ǣ�2����
			{
				sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//�ϼ���˾����
				sSuperLoanCardNo = getItemValue(0,getRow(),"SuperLoanCardNo");//�ϼ���˾������
				sSuperCertID = getItemValue(0,getRow(),"SuperCertID");//�ϼ���˾��֯��������
				if(typeof(sSuperCorpName) == "undefined" || sSuperCorpName == "" )
				{
					alert(getBusinessMessage('126'));
					return false;
				}
				if((typeof(sSuperLoanCardNo) == "undefined" || sSuperLoanCardNo == "") && 
				(typeof(sSuperCertID) == "undefined" || sSuperCertID == "") )
				{
					alert(getBusinessMessage('127'));
					return false;
				}
				//���¼�����ϼ���˾��֯�������룬����ҪУ���ϼ���˾��֯��������ĺϷ��ԣ�ͬʱ���ϼ���˾֤����������Ϊ��֯��������֤
				if(typeof(sSuperCertID) != "undefined" && sSuperCertID != "" )
				{
					if(!CheckORG(sSuperCertID))
					{
						alert(getBusinessMessage('128'));//�ϼ���˾��֯������������							
						return false;
					}
					setItemValue(0,getRow(),'SuperCertType',"Ent01");
				}
				//���¼�����ϼ���˾�����ţ�����ҪУ���ϼ���˾�����ŵĺϷ���
				if(typeof(sSuperLoanCardNo) != "undefined" && sSuperLoanCardNo != "" )
				{
					if(!CheckLoanCardID(sSuperLoanCardNo))
					{
						alert(getBusinessMessage('129'));//�ϼ���˾����������							
						return false;
					}
					
					//�����ϼ���˾������Ψһ��
					sSuperCorpName = getItemValue(0,getRow(),"SuperCorpName");//�ϼ���˾�ͻ�����	
					sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sSuperCorpName+","+sSuperLoanCardNo);
					if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
					{
						//alert(getBusinessMessage('228'));//���ϼ���˾�������ѱ������ͻ�ռ�ã�							
						//return false;
					}						
				}
			}	
			
			//add by xhyong 2009/07/31
			//10��У�鵱��ҵ��ģѡ��Ϊ"С����ҵ"ʱ����"�Ƿ������ھ�С��ҵ"����Ϊ��
			sScope = getItemValue(0,getRow(),"Scope");//��ҵ��ģ
			sSmallEntFlag = getItemValue(0,getRow(),"SmallEntFlag");//�Ƿ������ھ�С��ҵ
			if(sScope == '4')
			{
				if ((typeof(sSmallEntFlag) == "undefined" || sSmallEntFlag == "") && sCustomerType != '0107')
				{
					alert("����ҵ��ģѡ��ΪС����ҵʱ�����Ƿ����϶�΢С��ҵ����Ϊ��!"); //����ҵ��ģѡ��ΪС����ҵʱ�����Ƿ����϶�΢С��ҵ����Ϊ��!
					return false;	
				}
			}
			//11��"��ҵ��������"��Ӧ����"Ӫҵִ�յǼ���"���Ҳ������ڵ�ǰ����
			sSetupDate = getItemValue(0,getRow(),"SetupDate");//��ҵ��������
			sLicensedate = getItemValue(0,getRow(),"Licensedate");//Ӫҵִ�յǼ���
			sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sSetupDate) != "undefined" && sSetupDate != "" )
			{
				if(sSetupDate > sLicensedate)
				{
					alert("��ҵ�������ڲ�Ӧ����Ӫҵִ�յǼ���!");//"��ҵ�������ڲ�Ӧ����Ӫҵִ�յǼ���"
					return false;
				}
				if(sSetupDate > sToday)
				{
					alert("��ҵ�������ڲ������ڵ�ǰ����!");//"��ҵ�������ڲ������ڵ�ǰ����"
					return false;
				}
			}	
			//11�����п������˺ź����п������˺Ų�����ͬ
			sMybankAccount = getItemValue(0,getRow(),"MybankAccount");//���п������˺�
			sOtherBankAccount = getItemValue(0,getRow(),"OtherBankAccount");//���п������˺�
			if(typeof(sMybankAccount) != "undefined" && sMybankAccount != "" &&typeof(sOtherBankAccount) != "undefined" && sOtherBankAccount != ""  )
			{
				if(sMybankAccount == sOtherBankAccount)
				{
					alert("���п������˺ź����п������˺Ų�����ͬ!");//���п������˺ź����п������˺Ų�����ͬ
					return false;
				}
			}	
			//add end 		
		}
		
		if(sCustomerType == '02') //���ſͻ�
		{
			//1��У�����ܿͻ�������ϵ�绰
			sRelativeType = getItemValue(0,getRow(),"RelativeType");//���ܿͻ�������ϵ�绰
			if(typeof(sRelativeType) != "undefined" && sRelativeType != "" )
			{
				if(!CheckPhoneCode(sRelativeType))
				{
					alert(getBusinessMessage('223'));//���ܿͻ�������ϵ�绰����
					return false;
				}
			}
			//2��У�鵱��������Ϊ������ʱ,�����ܲ����ڵر���
			sGroupType = getItemValue(0,getRow(),"GroupType");//��������
			sRegionCodeName = getItemValue(0,getRow(),"RegionCodeName");//��������
			if(sGroupType == "010")
			{
				if (typeof(sRegionCodeName) == "undefined" || sRegionCodeName == "" )
				{
					alert("����������Ϊ������ʱ�������ܲ����ڵز���Ϊ��!"); //����������Ϊ������ʱ�������ܲ����ڵز���Ϊ��!
					return false;	
				}
			}
		}
		if(sCustomerType == '03') //���˿ͻ�
		{
			//1:У��֤������Ϊ���֤����ʱ���֤ʱ�����������Ƿ�֤ͬ������е�����һ��
			sCertType = getItemValue(0,getRow(),"CertType");//֤������
			sCertID = getItemValue(0,getRow(),"CertID");//֤�����
			sBirthday = getItemValue(0,getRow(),"Birthday");//��������
			if(typeof(sBirthday) != "undefined" && sBirthday != "" )
			{			
				if(sCertType == 'Ind01' || sCertType == 'Ind08')
				{
					//�����֤�е������Զ�������������,�����֤�е��Ա𸳸��Ա�
					if(sCertID.length == 15)
					{
						sSex = sCertID.substring(14);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,12);
						sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sCertID.length == 18)
					{
						sSex = sCertID.substring(16,17);
						sSex = parseInt(sSex);
						sCertID = sCertID.substring(6,14);
						sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
						if(sSex%2==0)//����żŮ
							setItemValue(0,getRow(),"Sex","2");
						else
							setItemValue(0,getRow(),"Sex","1");
					}
					if(sBirthday != sCertID)
					{
						alert(getBusinessMessage('200'));//�������ں����֤�еĳ������ڲ�һ�£�	
						return false;
					}
				}
				
				if(sBirthday < '1900/01/01')
				{
					alert(getBusinessMessage('201'));//�������ڱ�������1900/01/01��	
					return false;
				}
			}
			
			//2��У���ס��ַ�ʱ�
			sFamilyZIP = getItemValue(0,getRow(),"FamilyZIP");//��ס��ַ�ʱ�
			if(typeof(sFamilyZIP) != "undefined" && sFamilyZIP != "" )
			{	
				if(!CheckPostalcode(sFamilyZIP))
				{
					alert(getBusinessMessage('202'));//��ס��ַ�ʱ�����
					return false;
				}
			}
			
			//3��У��סլ�绰
			sFamilyTel = getItemValue(0,getRow(),"FamilyTel");//סլ�绰	
			if(typeof(sFamilyTel) != "undefined" && sFamilyTel != "" )
			{
				if(!CheckPhoneCode(sFamilyTel))
				{
					alert(getBusinessMessage('203'));//סլ�绰����
					return false;
				}
			}
			
			//4��У���ֻ�����
			sMobileTelephone = getItemValue(0,getRow(),"MobileTelephone");//�ֻ�����
			if(typeof(sMobileTelephone) != "undefined" && sMobileTelephone != "" )
			{
				if(!CheckPhoneCode(sMobileTelephone) || sMobileTelephone.length !=11)
				{
					alert(getBusinessMessage('204'));//�ֻ���������
					return false;
				}
				
			}
			
			//5��У���������
			sEmailAdd = getItemValue(0,getRow(),"EmailAdd");//��������	
			if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" )
			{
				if(!CheckEMail(sEmailAdd))
				{
					alert(getBusinessMessage('205'));//������������
					return false;
				}
			}
			
			//6��У��ͨѶ��ַ�ʱ�
			sCommZip = getItemValue(0,getRow(),"CommZip");//ͨѶ��ַ�ʱ�
			if(typeof(sCommZip) != "undefined" && sCommZip != "" )
			{	
				if(!CheckPostalcode(sCommZip))
				{
					alert(getBusinessMessage('206'));//ͨѶ��ַ�ʱ�����
					return false;
				}
			}
			
			//7��У�鵥λ��ַ�ʱ�
			sWorkZip = getItemValue(0,getRow(),"WorkZip");//��λ��ַ�ʱ�
			if(typeof(sWorkZip) != "undefined" && sWorkZip != "" )
			{	
				if(!CheckPostalcode(sWorkZip))
				{
					alert(getBusinessMessage('207'));//��λ��ַ�ʱ�����
					return false;
				}
			}
			
			//8��У�鵥λ�绰
			sWorkTel = getItemValue(0,getRow(),"WorkTel");//��λ�绰	
			if(typeof(sWorkTel) != "undefined" && sWorkTel != "" )
			{
				if(!CheckPhoneCode(sWorkTel))
				{
					alert(getBusinessMessage('208'));//��λ�绰����
					return false;
				}
			}
			
			//9��У�鱾��λ������ʼ��
			sWorkBeginDate = getItemValue(0,getRow(),"WorkBeginDate");//����λ������ʼ��
			sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sWorkBeginDate) != "undefined" && sWorkBeginDate != "" )
			{
				if(sWorkBeginDate >= sToday)
				{
					alert(getBusinessMessage('209'));//����λ������ʼ�ձ������ڵ�ǰ���ڣ�
					return false;
				}
				
				if(sWorkBeginDate <= sBirthday)
				{
					alert(getBusinessMessage('210'));//����λ������ʼ�ձ������ڳ������ڣ�
					return false;
				}
			}	
			
			//add by xhyong 2009/07/31
			//10��У�� ����������ѡ��Ϊ"ũ��"����Ϊ������
			sIndRPRType = getItemValue(0,getRow(),"IndRPRType");//��������
			sHousemasterFlag = getItemValue(0,getRow(),"HousemasterFlag");//�Ƿ���
			if(sIndRPRType == '010')
			{
				if (typeof(sHousemasterFlag) == "undefined" || sHousemasterFlag == "" )
				{
					alert("����������ѡ��Ϊũ��ʱ,�Ƿ�������Ϊ��!"); //����������ѡ��Ϊũ��ʱ,�Ƿ�������Ϊ��!
					return false;	
				}
			}
			
			//add end 
			//11��У�������
			sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//������	
			sCertID = getItemValue(0,getRow(),"CertID");//������
			if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
			{
				if(!CheckLoanCardID(sLoanCardNo))
				{
					alert(getBusinessMessage('101'));//����������							
					return false;
				}
				
				//���������Ψһ��
				sReturn=RunMethod("CustomerManage","CheckLoanCardNoByCertID",sCertType+","+sCertID+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('227'));//�ô������ѱ������ͻ�ռ�ã�							
					return false;
				}						
			}				
		}
		
		if(sCustomerType == '04')//ũ������С��
		{
			//11��"����С��Э��ǩ��ʱ��"�������ڵ�ǰ����
			sSetupDate = getItemValue(0,getRow(),"SetupDate");//����С��Э��ǩ��ʱ��
			sToday = "<%=StringFunction.getToday()%>";//��ǰ����
			if(typeof(sSetupDate) != "undefined" && sSetupDate != "" )
			{
				if(sSetupDate > sToday)
				{
					alert("����С��Э��ǩ��ʱ�䲻�����ڵ�ǰ����!");//"����С��Э��ǩ��ʱ�䲻�����ڵ�ǰ����!"
					return false;
				}	
			}
		}
		// ���鹫˾�ͻ�����ģ��
		if(sCustomerType.substring(0,2) == '01')//��˾�ͻ�
		{
			sCreditBelong = getItemValue(0,getRow(),"CreditBelong");// �ÿͻ���Ӧ����ģ��
			if ("<%=sIsUseSmallTemplet%>" != "1" && sCreditBelong.indexOf("3") == 0)
		   	{
		   	    alert("������ѡ�����õȼ�����ģ�����ơ�");
		   	    return false;
		   	}		   	
		}		
		return true;		
	}

    /*~[Describe=������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrgType()
	{
		sParaString = "CodeNo"+",OrgType";		
		setObjectValue("SelectCode",sParaString,"@OrgType@0@OrgTypeName@1",0,0,"");
	}
	
	/*~[Describe=��������/����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCountryCode()
	{		
		sParaString = "CodeNo"+",CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != ""  && sCountryCodeInfo != "_NONE_" 
		&& sCountryCodeInfo != "_CLEAR_" && sCountryCodeInfo != "_CANCEL_")
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			sCountryCodeValue = sCountryCodeInfo[0];//-- ���ڹ���(����)����
			if(sCountryCodeValue != 'CHN') //�����ڹ���(����)��Ϊ�л����񹲺͹�ʱ�������ʡ�ݡ�ֱϽ�С�������������
			{
				setItemValue(0,getRow(),"RegionCode","");
				setItemValue(0,getRow(),"RegionCodeName","");
				setItemRequired(0,0,"RegionCodeName",false);//���÷Ǳ���
			}else{
				setItemRequired(0,0,"RegionCodeName",true);//���ñ���
			}
		}
	}
	
	/*~[Describe=�������õȼ�����ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditTempletType()
	{	
		if("<%=sCustomerType%>".substring(0,2)=='03')
		{
			sParaString = "CodeNo"+",IndCreditTempletType";
			setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
		}else{	
			sParaString = "CodeNo"+",CreditTempletType";
			if ("<%=sIsUseSmallTemplet%>" == "1")
			{
			    setObjectValue("SelectCode",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
			}else{
			    setObjectValue("SelectTemplet",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
			}
		}
	}
	
	/*~[Describe=������Ӧ���ֿ�ģ��ģ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAnalyseType(sModelType)
	{		
		sParaString = "ModelType"+","+sModelType;			
		setObjectValue("selectAnalyseType",sParaString,"@CreditBelong@0@CreditBelongName@1",0,0,"");
	}
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getRegionCode(flag)
	{
		//�жϹ�����û��ѡ�й�
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent")
		{
			if("<%=sCustomerType.substring(0,2)%>" == "01")//��˾�ͻ�Ҫ����ѡ���ڹ��һ��������ѡ�����ʡ��
			{
				//�жϹ����Ƿ��Ѿ�ѡ��
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )
				{
					if(sCountryTypeValue == "CHN")
					{
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
					}else
					{
						alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
						return;
					}
				}else
				{
					alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
					return;
				}
			}else
			{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@RegionCode@0@RegionCodeName@1",0,0,"");
			}
		}else 	//������ҵ�ͻ�����������͸��˵ļ���
		{
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@NativePlace@0@NativePlaceName@1",0,0,"");
		}
	}	
	
	//add by xhyong ũ�����ڵ� 
	//modified  by zrli 20090914
	/*~[Describe=����ʡ�ݡ�ֱϽ�С�������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getVillageCode(flag)
	{
		var sVillageCode = getItemValue(0,getRow(),"VillageCode");
		//��������м������������ʾ
		sVillageInfo = PopComp("VillageVFrame","/Common/ToolsA/VillageVFrame.jsp","Village="+sVillageCode,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		if(sVillageInfo == "NO")
		{
			setItemValue(0,getRow(),"VillageCode","");
			setItemValue(0,getRow(),"VillageName","");
		}else if(typeof(sVillageInfo) != "undefined" && sVillageInfo != "")
		{
			sVillageInfo = sVillageInfo.split('@');
			sVillageCode = sVillageInfo[0];//-- ��������
			sVillageName = sVillageInfo[1];//--���������
			setItemValue(0,getRow(),"VillageCode",sVillageCode);
			setItemValue(0,getRow(),"VillageName",sVillageName);					
		}
	}	
	
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{

		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
		//���ݡ�������ҵͶ�򡯶�̬���á���ҵ��ģ������ҵ���࡯
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
        if(sIndustryType.indexOf("A") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","040"); // ũ������ҵ
        }
        else if(sIndustryType.indexOf("B") == 0 || sIndustryType.indexOf("C") == 0 || sIndustryType.indexOf("D") == 0 ) 
        {
          	setItemValue(0,getRow(),"IndustryName","005"); // ��ҵ
        }
        else if(sIndustryType.indexOf("E") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","010"); // ����ҵ
        }
        else if(sIndustryType.indexOf("F51") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","015"); // ����ҵ
        }
        else if(sIndustryType.indexOf("F52") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","020"); // ����ҵ
        }
        else if(sIndustryType.indexOf("G54") == 0 || sIndustryType.indexOf("G55") == 0 || sIndustryType.indexOf("G56") == 0 || sIndustryType.indexOf("G57") == 0 || sIndustryType.indexOf("G58") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","025"); // ��ͨ����ҵ
        }
        else if(sIndustryType.indexOf("G59") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","045"); // �ִ�ҵ
        }
        else if(sIndustryType.indexOf("G60") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","030"); // ����ҵ
        }
        else if(sIndustryType.indexOf("H61") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","110"); // ס��ҵ
        }        
        else if(sIndustryType.indexOf("H62") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","100"); // ����ҵ
        }
        else if(sIndustryType.indexOf("I63") == 0 || sIndustryType.indexOf("I64") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","070"); // ��Ϣ����ҵ
        }
        else if(sIndustryType.indexOf("I65") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","075"); // �������Ϣ��������ҵ
        }
        else if(sIndustryType.indexOf("K7010") == 0 || sIndustryType.indexOf("K7040") == 0 || sIndustryType.indexOf("K7090") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","050"); // ���ز�������Ӫ
        }
        else if(sIndustryType.indexOf("K7020") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","105"); // ��ҵ����
        }
        else if(sIndustryType.indexOf("L") == 0) 
        {
          	setItemValue(0,getRow(),"IndustryName","080"); // ���޺��������ҵ
        }else
        {
            setItemValue(0,getRow(),"IndustryName","095"); // ����δ������ҵ
        }             		        		
	}
		
	/*~[Describe=����������ҵ���ͽ���ҵѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	//add by xhyong 2009/08/12 
	function getFinanceIndustryType()
	{
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue=J&IndustryType=&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
		setItemValue(0,getRow(),"IndustryName","095"); // ����δ������ҵ
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{			
		sCustomerType = "04";//���ù�ͬ��ѡ���ƿ���
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID"+","+"<%=CurUser.UserID%>"+","+"CustomerType"+","+sCustomerType;
		setObjectValue("SelectCustomer1",sParaString,"@SuperCertID@0@SuperCorpName@1",0,0,"");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getOrg()
	{		
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getUser()
	{		
		var sOrg = getItemValue(0,getRow(),"OrgID");
		sParaString = "BelongOrg,"+sOrg;	
		if (sOrg.length != 0 )
		{		
			setObjectValue("SelectUserBelongOrg",sParaString,"@UserID@0@UserName@1",0,0,"");
		}else
		{
			alert(getBusinessMessage('132'));//����ѡ��ܻ�������
		}
	}
						
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		var sListingCorpOrNot = getItemValue(0,getRow(),"ListingCorpOrNot");//�������
		var sIndustryName = getItemValue(0,getRow(),"IndustryName");//��ҵ��ģ������ҵ����
		//�����ֶ�Ĭ��ֵ
		if (sCountryCode=="")
		{
			setItemValue(0,getRow(),"CountryCode","CHN");
			setItemValue(0,getRow(),"CountryCodeName","�л����񹲺͹�");
		}
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","011");			
			setItemValue(0,getRow(),"CreditBelongName","��ҵ���������ҵ��λ���õȼ�������");
		}
		if (sListingCorpOrNot=="") 
		{
			//Ĭ��Ϊδ����
			setItemValue(0,getRow(),"ListingCorpOrNot","050");
		}
		if (sIndustryName==""&&"<%=sCustomerType%>"=="0107") 
		{
			//ͬҵ�ͻ�����Ϊ������ҵ
			setItemValue(0,getRow(),"IndustryName","055");
		}
		sCustomerType = "<%=sCustomerType.substring(0,2)%>";
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
		ssCustomerType = "<%=sCustomerType%>";
		if(ssCustomerType == '0101' || ssCustomerType == '0102' || ssCustomerType == '0107')
		{
			sRCCurrency = getItemValue(0,0,"RCCurrency");
			sPCCurrency = getItemValue(0,0,"PCCurrency");
			if(typeof(sRCCurrency)=="undefined" || sRCCurrency.length==0)
			{
		    	setItemValue(0,getRow(),"RCCurrency","01");	
		    }
		    if(typeof(sPCCurrency)=="undefined" || sPCCurrency.length==0)
			{
		    	setItemValue(0,getRow(),"PCCurrency","01");	
		    }
		}
		if(sCustomerType == '01')//��˾�ͻ�
		{
			setItemValue(0,getRow(),"LoanFlag","1");
		}
		if(sCustomerType == '03') //���˿ͻ�
		{	
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				//�����֤�е������Զ�������������
				if(sCertID.length == 15)
				{
					sSex = sCertID.substring(14);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,12);
					sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
				if(sCertID.length == 18)
				{
					sSex = sCertID.substring(16,17);
					sSex = parseInt(sSex);
					sCertID = sCertID.substring(6,14);
					sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
					setItemValue(0,getRow(),"Birthday",sCertID);
					if(sSex%2==0)//����żŮ
						setItemValue(0,getRow(),"Sex","2");
					else
						setItemValue(0,getRow(),"Sex","1");
				}
			}
		}
    }
    
	/*~[Describe=�Զ������»�����������;InputParam=��;OutPutParam=��;]~*/
	function getIndRate()
	{	
		var dFamilyMonthIncome = getItemValue(0,getRow(),"FamilyMonthIncome");//��ͥ������
		var dMonthReturnSum = getItemValue(0,getRow(),"MonthReturnSum");//�»����
		if (typeof(dFamilyMonthIncome) != "undefined" && dFamilyMonthIncome != "" )
		{
			IndRate = (dMonthReturnSum/dFamilyMonthIncome)*100;
			IndRate = Math.round(parseFloat(IndRate)*100)/100;
		}
		if(dFamilyMonthIncome==0 || dMonthReturnSum ==0 || IndRate<0) IndRate = "0";
		setItemValue(0,getRow(),"IndRate",IndRate);
	}
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
     	return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }
	
	//���� ��ҵ���͡�Ա�����������۶�ʲ��ܶ�ȷ����С��ҵ��ģ
	function EntScope() 
	{
		/*
		����˵����
		�μ��ĵ���ͳ���ϴ���С����ҵ���ְ취�����У�������ͳ�ƾ����˾
		����������ָ���������ҵ���͡�Ա�����������۶�ʲ��ܶ�
		*/
		var sIndustryName = getItemValue(0,getRow(),"IndustryName");//��С��ҵ��ҵ
		var sLastYearSale = getItemValue(0,getRow(),"SellSum");//�����۶�
		var sCapitalAmount = getItemValue(0,getRow(),"TotalAssets");//�ʲ��ܶ�
		var sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");//Ա������
		if(typeof(sIndustryName)=="undefined" || sIndustryName.length==0)
			sIndustryName=" ";
		if(typeof(sLastYearSale)=="undefined" || sLastYearSale.length==0)
			sLastYearSale=0;
		if(typeof(sCapitalAmount)=="undefined" || sCapitalAmount.length==0)
			sCapitalAmount=0;
		if(typeof(sEmployeeNumber)=="undefined" || sEmployeeNumber.length==0)
			sEmployeeNumber=0;
		if(sIndustryName=="005")
		{
		//��ҵ����ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=30000&&sCapitalAmount>=40000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<300||sLastYearSale<3000||sCapitalAmount<4000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
			
		}	
		else if(sIndustryName=="010")
		{
		//����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000&&sCapitalAmount>=40000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<600||sLastYearSale<3000||sCapitalAmount<4000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="015")
		{
		//����ҵ��ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=30000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","3");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="020")
		{
		//����ҵ��ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="025")
		{
		//��ͨ����ҵ��ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=30000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<500||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="030")
		{
		//����ҵ��ҵ
			if(sEmployeeNumber>=1000&&sLastYearSale>=30000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<400||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		
		}
		else if(sIndustryName=="035")
		{
		//ס�޺Ͳ���ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<400||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="040")
		{
		//ũ��������ҵ
			if(sEmployeeNumber>=3000&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<500||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="045")
		{
		//�ִ���ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="050")
		{
		//���ز���ҵ
			if(sEmployeeNumber>=200&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="055")
		{
		//������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=50000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<5000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="060")
		{
		//���ʿ����ˮ������������ҵ
			if(sEmployeeNumber>=2000&&sLastYearSale>=20000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<600||sLastYearSale<2000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="065")
		{
		//���塢������ҵ
			if(sEmployeeNumber>=600&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<200||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="070")
		{
		//��Ϣ������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=30000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="075")
		{
		//��������������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=30000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<3000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}

		}
		else if(sIndustryName=="080")
		{
		//������ҵ
			if(sEmployeeNumber>=300&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="085")
		{
		//���񼰿Ƽ�������ҵ
			if(sEmployeeNumber>=400&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else if(sIndustryName=="090")
		{
		//���������ҵ
			if(sEmployeeNumber>=800&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<200||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}
		else
		{
		//������ҵ
			if(sEmployeeNumber>=500&&sLastYearSale>=15000)
			{
				//����
				setItemValue(0,getRow(),"Scope","2");
			}else if(sEmployeeNumber<100||sLastYearSale<1000)
			{
				//С��
				setItemValue(0,getRow(),"Scope","4");
			}else
			{
				//����
				setItemValue(0,getRow(),"Scope","3");
			}
		}		
	}
	//���Ҹÿͻ��ĵ���Э��	
	function VouchAgreement()
	{
		sParaString = "";
		sReturn = selectObjectValue("SelectVouchCustomer",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn1 = sReturn.split("@");
		setItemValue(0,0,"VouchCorpName",sReturn1[0]);
	}
	//�ж���ҵ��ģ
	function getEnterpriseScale(){
	     sCustomerID = getItemValue(0,getRow(),"CustomerID");
		 sEmployeeNumber = getItemValue(0,getRow(),"EmployeeNumber");
		 sSellSum = getItemValue(0,getRow(),"SellSum");
		 sTotalAssets = getItemValue(0,getRow(),"TotalAssets");
		 sIndustryName = getItemValue(0,getRow(),"IndustryName");

         sReturn = RunMethod("CustomerManage","EnterpriseScale",sEmployeeNumber+","+sSellSum+","+sTotalAssets+","+sIndustryName+","+sCustomerID);
         if(sReturn == '2' || sReturn == '3'|| sReturn == '4' || sReturn == '5'){
              setItemValue(0,0,"Scope",sReturn);
         }else if(sReturn == 'NODATA'){
              alert("����ҵ����δ�趨��ҵ������ģ!");
              setItemValue(0,0,"Scope","9");
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
