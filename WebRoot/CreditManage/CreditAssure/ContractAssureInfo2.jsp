<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ���ͬ������ĵ�����ͬ���飨һ����֤��ͬ��Ӧһ����֤�ˣ�;
		Input Param:
			ObjectType���������ͣ�BusinessContract��
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
	String sSql = "";	
	int iCount = 0;
	ASResultSet rs = null;
	
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	//���ҳ�������������ʽ��������ͬ���
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sGuarantyType == null) sGuarantyType = "";
	if(sSerialNo == null) sSerialNo = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	//������߶����ͬ�Ƿ��ѱ������
	sSql = 	" select count(SerialNo) from CONTRACT_RELATIVE "+
			" where SerialNo <> '"+sObjectNo+"' "+
			" and ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sSerialNo+"'";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
		iCount = rs.getInt(1);
	rs.getStatement().close();
	
	//��������߶����ͬ�������ҵ���ͬ�Ƿ��Ѿ����ʻ���ɷŴ�
	if(iCount <= 0)
	{
		String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
		if(sDBName.startsWith("INFORMIX"))
    	{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> '')) ";
		}else if(sDBName.startsWith("ORACLE"))
		{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> ' ')) ";
		}else if(sDBName.startsWith("DB2"))
    	{
			sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT "+
					" where SerialNo = '"+sObjectNo+"' "+
					" and ((SerialNo in (select ContractSerialNo "+
					" from BUSINESS_PUTOUT "+
					" where ContractSerialNo = '"+sObjectNo+"')) "+
					" or (PigeonholeDate is not null "+
					" and PigeonholeDate <> '')) ";
		}
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
	}
	
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
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(iCount <= 0||"ReinforceContract".equals(sObjectType)) dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
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
		{(iCount <= 0||"ReinforceContract".equals(sObjectType)?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}	
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditAssure/ContractAssureList2.jsp","_self","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{		
		setItemValue(0,0,"ContractStatus","020");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		return true;
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
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
