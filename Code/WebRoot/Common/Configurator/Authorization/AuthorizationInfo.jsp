<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: wlu 2009-2-13 
		Tester:
		Describe: �û�Ȩ����Ϣ
		Input Param:
			UserID:	   �û����
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���ҳ�����	
	String sSql;
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));	
	if(sSerialNo == null ) sSerialNo = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%       
    String[][] sHeaders = {
							{"SerialNo","���"},
							{"AuthorizationType","��Ȩ����"},
							{"UserName","�û���"},
							{"BusinessTypeName","ҵ��Ʒ��<br>(��ѡ�񵥱���Ȩ����ѡ��ҵ��Ʒ��)"},
							{"BusinessSumCurrency","��Ȩ����"},
							{"BusinessSum","��Ȩ���"},
							{"BusinessExposureCurrency","��Ȩ���ڱ���"},
							{"BusinessExposure","��Ȩ���ڽ��"},
							{"Remark","��ע"},
							{"InputUserName","�Ǽ���"},							
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}							
		                 };
	sSql =  " select SerialNo,AuthorizationType,UserID,getUserName(UserID) as UserName, "+
			" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSumCurrency, "+
			" BusinessSum,BusinessExposureCurrency,BusinessExposure,Remark, "+			
			" InputUserID,getUserName(InputUserID) as InputUserName,InputOrgID, "+
			" getOrgName(InputOrgID) as InputOrgName,InputDate,UpdateDate "+
		    " from USER_AUTHORIZATION "+
		    " where SerialNo = '"+sSerialNo+"'";
		    
    //����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "USER_AUTHORIZATION";
	//��������
	doTemp.setKey("SerialNo",true);
    //���ñ�����
 	doTemp.setRequired("UserName,AuthorizationType,BusinessSumCurrency,BusinessSum,BusinessExposureCurrency,BusinessExposure",true);
 	//�����Ʒ��Ų�Ϊ�գ��������޸�
 	if(!sSerialNo.equals(""))
 		doTemp.setReadOnly("AuthorizationType,UserName,BusinessTypeName",true);
 	//��������datawindows
	doTemp.setDDDWCode("BusinessSumCurrency,BusinessExposureCurrency","Currency");	    
	doTemp.setDDDWCode("AuthorizationType","AuthorizationType");
	//����Ĭ��ֵ
	doTemp.setDefaultValue("BusinessSumCurrency","01");
	doTemp.setDefaultValue("BusinessExposureCurrency","01");
	//�����еĿ��
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Remark",200);
 	doTemp.setHTMLStyle("InputOrgID"," style={width:160px} ");
 	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");
 	//��λһ����ʾ 	
 	doTemp.setType("BusinessSum,BusinessExposure","number");
	doTemp.setAlign("BusinessSum,BusinessExposure","3");
	//����ֻ����
	doTemp.setReadOnly("UserName,BusinessTypeName,InputUserName,InputUserID,InputOrgName,InputOrgID,UpdateDate,InputDate,SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("UserID,InputUserID,InputOrgID,BusinessType",false);	
	//���ò����޸���    	
	doTemp.setUpdateable("BusinessTypeName,UserName,InputUserName,InputOrgName",false);	
	if(sSerialNo == "")
	{
		doTemp.setUnit("BusinessTypeName"," <input type=button class=inputdate value=.. onclick=parent.selectBusinessType(\"ALL\")>");
		doTemp.setUnit("UserName"," <input type=button class=inputdate value=.. onclick=parent.selectUser(\"ALL\")>");
	}		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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
	String sButtons[][] = 
		{
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
		//OpenPage("/Common/Configurator/Authorization/AuthorizationList.jsp?SerialNo="+<%=sSerialNo%>,"_self","");
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>	
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�	
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");	
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");		
		setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");		
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{			
			as_add("myiframe0"); //������¼						
			bIsInsert = true;
		}		
    }
    
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "USER_AUTHORIZATION";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=����ҵ��Ʒ��ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");			
		}	
	}	
	
	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser(sType)
	{		
		if(sType == "ALL")
		{			
			setObjectValue("SelectAllUser","","@UserID@0@UserName@1",0,0,"");			
		}	
	}	
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//���¼�����Ȩ���͡��û���ҵ��Ʒ���Ƿ����
		sSerialNoOld=getItemValue(0,0,"SerialNo");//��ˮ��
		sUserID = getItemValue(0,0,"UserID");	//�û����
		sBusinessType = getItemValue(0,0,"BusinessType");//--ҵ��Ʒ��
		sAuthorizationType = getItemValue(0,0,"AuthorizationType");//--��Ȩ����
		//������Ȩ��ҵ��Ʒ��һ��Ҫ����
		if(sAuthorizationType=='01'){
			if(typeof(sBusinessType) == "undefined" || sBusinessType == ""){
				alert("������Ȩ�£�ҵ��Ʒ�ֲ���Ϊ�գ�");
				return false;
			}
		}
		
		if(typeof(sUserID) != "undefined" && sUserID != "" && typeof(sAuthorizationType) != "undefined" && sAuthorizationType != "")
		{
	        //������̱��
	        var sColName = "SerialNo";
			var sTableName = "USER_AUTHORIZATION";
			//�����Ȩ����Ϊ������Ȩ����Ҫ����Ƿ��Ѵ���Ҫ¼����û��������Ȩ����Ϊ������Ȩ����Ҫ����û���ҵ��Ʒ���Ƿ����
			if(sAuthorizationType == "01")
			{
				var sWhereClause = "String@UserID@"+sUserID+"@String@BusinessType@"+sBusinessType+"@String@AuthorizationType@"+sAuthorizationType;
			}else
			{
				var sWhereClause = "String@UserID@"+sUserID+"@String@AuthorizationType@"+sAuthorizationType;
			}
			//ִ���෽��ȡSerialNo�ж���Ч��
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
						//��ѯ��ˮ��
						if(my_array2[n] == "serialno")
							sSerialNo = sReturnInfo[n+1];					
					}
				}
				//ͨ����ֳ�����ˮ���жϼ����
				if(typeof(sSerialNo)!="undefined" && sSerialNo != "")
				{
					isExist=true;
					if(typeof(sSerialNoOld)!="undefined" && sSerialNoOld != ""&&sSerialNo==sSerialNoOld)
						isExist=false;
					if(isExist)
					{
						if(sAuthorizationType == "01")
							alert("�Բ����Ѵ��ڸ���Ȩ�����¸��û��Ը�ҵ��Ʒ�ֵ���Ȩ��");
						else
							alert("�Բ����Ѵ��ڸ���Ȩ�����¶Ը��û�����Ȩ��");
						return false;
					}
				}
			}			
		}
		return true;
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
