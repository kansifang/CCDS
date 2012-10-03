<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ��ż����ͥ��Ҫ��Ա;
		Input Param:
			--CustomerID: ��ǰ�ͻ����
			--RelativeID: �����ͻ����
			--Relationship: ������ϵ
			--EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ż����ͥ��Ҫ��Ա"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//�������������ͻ�����
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ������������ͻ���š�������ϵ
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {
							{"CertType","֤������"},
							{"CertID","֤������"},
							{"CustomerName","����"},							
							{"RelationShip","��ÿͻ���ϵ"},
							{"Telephone","��ϵ�绰"},	
							{"Describe","������λ"},
							{"WorkAdd","��λ��ַ"},
							{"WorkZip","��λ�ʱ�"},
							{"WorkTel","��λ�绰"},
							{"Occupation","��Աְҵ"},
							{"HealthStatus","����״��"},
							{"Birthday","��������"},
							{"EffStatus","�Ƿ���Ч"},						
							{"Remark","��ע"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"InputDate","��������"},
							{"UpdateDate","��������"}
						 };
	String sSql =   " select CustomerID,RelativeID,CertType,CertID,"+
					" CustomerName,RelationShip,Telephone,Describe,"+
					" WorkAdd,WorkZip,WorkTel,"+
					" Occupation,HealthStatus,Birthday,EffStatus," +
					" Remark,InputUserId,getUserName(InputUserId) as UserName," +
					" InputOrgId,getOrgName(InputOrgId) as OrgName," +
					" InputDate,UpdateDate " +
					" from CUSTOMER_RELATIVE" +
					" where CustomerID='"+sCustomerID+"'" +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip='"+sRelationShip+"' " ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("RelationShip,CustomerName,CertType,CertID,Occupation,HealthStatus,Birthday,EffStatus",true);
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setLimit("Remark",200);
	//�����ֶθ�ʽ
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("Describe"," style={width:250px}; ");
	doTemp.setHTMLStyle("CustomerName"," style={width:80px} ");
	doTemp.setHTMLStyle("WorkAdd"," style={width:400px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("CustomerName,OrgName,UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//����������
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '03%' and length(ItemNo)>2 and IsInUse = '1' ");
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like 'Ind%' and IsInUse = '1' ");
	doTemp.setDDDWCode("EffStatus","EffStatus");
	doTemp.setDDDWCode("Occupation","Occupation");
	doTemp.setDDDWCode("HealthStatus","HealthStatus");

	//����Ϊ3
	doTemp.setCheckFormat("Birthday","3");
	//����Ĭ��ֵ

	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	//doTemp.setHTMLStyle("CertID"," onchange=parent.getBirthday() ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	//���ò���͸����¼������������͸���
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,,#InputUserId)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/IndManage/IndFamilyList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/IndManage/IndFamilyInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getBirthday()
	{
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		if(sCertType=="Ind01")
		{
			//�����֤�е������Զ�������������
			if(sCertID.length == 15)
			{
				sSex = sCertID.substring(14);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,12);
				sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
				setItemValue(0,getRow(),"Birthday",sCertID);
			}
			if(sCertID.length == 18)
			{
				sSex = sCertID.substring(16,17);
				sSex = parseInt(sSex);
				sCertID = sCertID.substring(6,14);
				sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
				setItemValue(0,getRow(),"Birthday",sCertID);	
			}
		}
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		sParaStr = "OrgID"+","+"<%=CurOrg.OrgID%>";		
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������		
		//setObjectValue("SelectManager",sParaStr,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		//modify by xhyong 2009/08/03
		setObjectValue("SelectFamily",sParaStr,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4@Occupation@5@HealthStatus@6@Birthday@7@Telephone@8@Describe@9",0,0,"");
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
		//�����֤�е������Զ�������������
		if(sCertID.length == 15)
		{
			sSex = sCertID.substring(14);
			sSex = parseInt(sSex);
			sCertID = sCertID.substring(6,12);
			sCertID = "19"+sCertID.substring(0,2)+"/"+sCertID.substring(2,4)+"/"+sCertID.substring(4,6);
			setItemValue(0,getRow(),"Birthday",sCertID);
		}
		if(sCertID.length == 18)
		{
			sSex = sCertID.substring(16,17);
			sSex = parseInt(sSex);
			sCertID = sCertID.substring(6,14);
			sCertID = sCertID.substring(0,4)+"/"+sCertID.substring(4,6)+"/"+sCertID.substring(6,8);
			setItemValue(0,getRow(),"Birthday",sCertID);	
		}
	}

	//modify by xhyong 2009/08/03
/**	
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
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");								
			} 
		}				     
	}
**/
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
		    //��ÿͻ�����
		    var sColName = "CustomerID@FullName@Occupation@HealthStatus@Birthday";
			var sTableName = "IND_INFO";
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
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "fullname")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
						//���ó�Աְҵ
						if(my_array2[n] == "occupation")
							setItemValue(0,getRow(),"Occupation",sReturnInfo[n+1]);
						//���ý���״��
						if(my_array2[n] == "healthstatus")
							setItemValue(0,getRow(),"HealthStatus",sReturnInfo[n+1]);
						//���ó�������
						if(my_array2[n] == "birthday")
							setItemValue(0,getRow(),"Birthday",sReturnInfo[n+1]);
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");
				setItemValue(0,getRow(),"Occupation","");
				setItemValue(0,getRow(),"HealthStatus","");	
				setItemValue(0,getRow(),"Birthday","");									
			} 
			getBirthday();
		}				     
	}
	//add end
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		//���Ѿ�������ż��ϵ������ʾ
		var sCertType = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID = getItemValue(0,getRow(),"CertID");//--֤������
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");//��ͻ��Ĺ�ϵ
		sReturnValue=RunMethod("CustomerManage","AlertCustomerRelationShip","0301,"+sCertType+","+sCertID);
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" )
		{
			alert(sReturnValue);
		}
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		getBirthday();
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		//�����֯������������֤�����Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//֤������		
		sCertID = getItemValue(0,0,"CertID");//֤�����	
				
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
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
		
		//���¼��Ŀͻ��Ƿ�Ϊ�䱾��
		sCustomerID   = getItemValue(0,0,"CustomerID");	//�ͻ����
		sRelativeID   = getItemValue(0,0,"RelativeID");//--�����ͻ�����
		if (typeof(sRelativeID) != "undefined" && sRelativeID != '')
		{
			if(sCustomerID == sRelativeID)	
			{
				alert(getBusinessMessage('141'));//¼��Ŀͻ�����Ϊ�䱾��
				return false;
			}
		}
		
		//У����ϵ�绰
		sTelephone = getItemValue(0,getRow(),"Telephone");//��ϵ�绰	
		if(typeof(sTelephone) != "undefined" && sTelephone != "" )
		{
			if(!CheckPhoneCode(sTelephone))
			{
				alert(getBusinessMessage('121'));//��ϵ�绰����
				return false;
			}
		}
		
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");	//�ͻ����			
		sCertType = getItemValue(0,0,"CertType");//֤������	
		sCertID = getItemValue(0,0,"CertID");//֤�����	
		sRelationShip = getItemValue(0,0,"RelationShip");//������ϵ
		if (typeof(sRelationShip) != "undefined" && sRelationShip != "")
		{
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)=="undefined" || sMessage.length==0) {
				return false;
			}
			setItemValue(0,0,"RelativeID",sMessage);
		}
		return true;
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>