<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --wangdw 2012-05-23
		Tester:
		Describe: --�ص�ͻ���Ϣ;
		Input Param:
			EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
           DATE	     CHANGER		CONTENT
           2005.7.25 fbkang         �°汾�ĸ�д		
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ص�ͻ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sTempletNo = "ImportantCustomerInfo";//ģ���

	//�������������ͻ����롢�����ͻ����롢������ϵ���༭Ȩ��
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ�����
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	String sSERIALNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.SelectCustomerByCertType()><font color=red>(�����ѡ)</font>");
	doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName()");	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	//���ò���͸����¼������������͸��¿ͻ���Ϣ��
	//dwTemp.setEvent("BeforeUpdate","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeFinancePlatFormList)");
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#CustomerName,#CertType,#CertID,,#InputUserId)");
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sSERIALNO);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ:
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","�����ص�ͻ���Ϣ","newRecord()",sResourcesPath},
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/SystemManage/SynthesisManage/ImportantCustomerInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert)
		{
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			afterUpdate();
			return;
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/ImportantCustomerList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
		/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
	   sCertType = "Ent01";
       sCertId = getItemValue(0,0,"CertID");//--��֯��������֤	//��ʼ����ˮ���ֶ�
       initSerialNo();
       //�жϸ���֯���������Ƿ���ϵͳ�д��ڣ����������ʹ��ԭ�ͻ��ţ������������ʹ�������ɵĿͻ���
       sReturn = RunMethod("CustomerManage","GetCustomerIdByCardId",sCertType+","+sCertId);
       if(sReturn != "Null" && typeof(sReturn) != "undefined")
       {
       		setItemValue(0,getRow(),"CustomerID",sReturn);
       }else{
       	var sTableName = "CUSTOMER_INFO";//����
		var sColumnName = "CustomerID";//�ֶ���
		var sPrefix = "";//ǰ׺
       	var sCustomerID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			setItemValue(0,getRow(),"CustomerID",sCustomerID);
		}
	}
	
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--���»����ˮ��
		OpenPage("/SystemManage/SynthesisManage/ImportantCustomerInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
		
	}
	
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function SelectCustomerByCertType()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		var sReturn = "";
		var sCustomerName = "";
		var sCertType = "";
		var sCertID = "";
		var sReturn = setObjectValue("SelectCustomerByCertType","","",0,0,"");
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined")
		{
			return;
		}else{
		sReturn= sReturn.split('@');
		sCustomerName = sReturn[0];
		sCertType = sReturn[1];
		sCertID = sReturn[2];
		sLoanCardNo = sReturn[3];
		setItemValue(0,0,"CustomerName",sCustomerName);
		setItemValue(0,0,"CertType",sCertType);
		setItemValue(0,0,"CertID",sCertID);
		setItemValue(0,0,"LoanCardNo",sLoanCardNo);
		setItemDisabled(0,0,"CustomerName",true);
		//setItemDisabled(0,0,"CertType",true);
		setItemDisabled(0,0,"CertID",true);
		setItemDisabled(0,0,"LoanCardNo",true);
		}
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--��õ�ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
		setItemValue(0,0,"CertType","Ent01");
		sCustomerID 	   = getItemValue(0,0,"CustomerID");	//--�ͻ����	
		sImportantFlag = getItemValue(0,0,"ImportantFlag");	//--�Ƿ��ص�ͻ�	
		RunMethod("PublicMethod","UpdateColValue","String@ImportantFlag@"+sImportantFlag+",ENT_INFO,String@CustomerID@"+sCustomerID);
	}
	/*~[Describe=ִ�и��²�����ִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function afterUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--��õ�ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
		setItemValue(0,0,"CertType","Ent01");
		sCustomerID 	   = getItemValue(0,0,"CustomerID");	//--�ͻ����	
		sImportantFlag = getItemValue(0,0,"ImportantFlag");	//--�Ƿ��ص�ͻ�	
		RunMethod("PublicMethod","UpdateColValue","String@ImportantFlag@"+sImportantFlag+",ENT_INFO,String@CustomerID@"+sCustomerID);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
	
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"CertType","Ent01");
			
		}
		
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_IMPORTANT";//����  
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
	   //���ÿͻ��Ƿ�¼�������ƽ̨��Ϣ	
	   sCertType = getItemValue(0,0,"CertType");	//--֤������	
	   sCertID = getItemValue(0,0,"CertID");		//--֤������
	   if(bIsInsert == true)
	   {
		   var isPlatformed=RunMethod("PublicMethod","GetColValue","CustomerID" + "," + "CUSTOMER_IMPORTANT" + "," + "String@CertType@"+sCertType+"@String@CertID@"+sCertID);
		   if(isPlatformed != "" && typeof(isPlatformed) != "undefined" && isPlatformed != "Null" )
		   {
		   		alert("�ÿͻ���¼����ص�ͻ���Ϣ��");
		   		return false;
		   }
	   }
	   //�����֯���������Ƿ�Ϸ�
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				return false;
			}		
		}	
	    return true;
		
	}
	//У����֯��������
	function ValidityORG()
	{
	
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
	
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//��֯������������
				return false;
			}else{
				return true;
			}		
		}	
	
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //��ÿͻ�����
	        var sColName = "CustomerID@CustomerName";
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
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"CustomerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
					}
				}			
			}
		}     
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>