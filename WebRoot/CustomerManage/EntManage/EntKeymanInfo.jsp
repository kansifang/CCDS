<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --�ؼ�����Ϣ;
		Input Param:
			CustomerID: --��ǰ�ͻ����
			RelativeID: --�����ͻ����
			Relationship: --������ϵ
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
	String PG_TITLE = "�ؼ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sTempletNo = "EntKeymanInfo";//ģ���

	//�������������ͻ����롢�����ͻ����롢������ϵ���༭Ȩ��
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	
	//���ҳ�����
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	//����ֵת��Ϊ���ַ���
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(!(sRelativeID == null || sRelativeID.equals("")))
	{
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}

	//����������
	doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'RelationShip' and ItemNo like '01%' and length(ItemNo)>2 order by SortNo ");
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo not like 'Ent%' order by SortNo ");
    	
	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=\"...\" onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font>");
		doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip",true);
	}
	
	//���������ҵ��ҵ���޷�Χ
	doTemp.appendHTMLStyle("EngageTerm"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ҵ��ҵ���ޱ�����ڵ���0��\" ");
		
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
  	
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);
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
		{"true","","Button","����","�����߹���Ϣ","newRecord()",sResourcesPath},
		{(sEditRight.equals("02")?"true":"false"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","�߹���Ϣ����","�鿴�߹���Ϣ����","viewKeymanInfo()",sResourcesPath},
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
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		if(bIsInsert)
		{
			//����ǰ���й�����ϵ���
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

	/*~[Describe=���ظ߹���Ϣ����ҳ��;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function viewKeymanInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("�Բ�����ѡ��һλ�߹ܣ�");
			return;
		}
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sRelativeID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
                        
        if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2")
        {    		
    		openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
    		//reloadSelf();
		}else
		{
		    alert("�Բ�����û�в鿴�ÿͻ���Ȩ�޻򲻴��ڸ߹���Ϣ���飡");//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntKeymanList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--������ϵ
		OpenPage("/CustomerManage/EntManage/EntKeymanInfo.jsp?RelationShip="+sRelationShip+"&RelativeID="+sRelativeID+"&EditRight=<%=sEditRight%>", "_self","");
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
			
			//�����֤�ĳ��������Զ��������������ֶ�
			if (!GetBirthday()) return;  
		}     
	}
	
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������
		sParaString = "OrgID"+","+"<%=CurUser.OrgID%>";		
		sReturn = setObjectValue("SelectManager",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
		//�����֤�ĳ��������Զ��������������ֶ�,xing
		if (!GetBirthday()) return;
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			setFieldDisabled("CustomerName");
			setFieldDisabled("CertType");
			setFieldDisabled("CertID");
		}
	}
	
	//�����򲻿���
	function setFieldDisabled(sField)
	{
	  setItemDisabled(0,0,sField,true);
      //getASObject(0,0,sField).style.background ="#efefef";
      //setItemValue(0,0,sField,"");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--��õ�ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
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
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
				
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
								
					//�����֤�е������Զ�������������,���Ա�����(add by fhuang 06.11.28)
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
			//��֤�ͻ�ֻ��һ�����˴���
			var sCustomerID = "<%=sCustomerID%>";
			var sRelationShip = getItemValue(0,getRow(),"RelationShip");
			var sRelativeID = getItemValue(0,getRow(),"RelativeID");
			if(sRelationShip == "0100"){
				sCustomerName = RunMethod("BusinessManage","getFictitiousPerson",sCustomerID+","+sRelativeID);
				if(sCustomerName !="Null" && sCustomerName !="NULL" && typeof(sCustomerName) != "undefined" && sCustomerName.length!=0 )
				{
					alert("�ÿͻ��Ѿ�¼�뷨�˴�����Ϣ������");
					return false;
				}	
			}	
		}
		
		sBirthday = getItemValue(0,getRow(),"Birthday");//��������			
		sHoldDate = getItemValue(0,getRow(),"HoldDate");//���θ�ְ��ʱ��
		//У��������ڡ����θ�ְ��ʱ���Ƿ���ڵ�ǰ����
		sToday = "<%=StringFunction.getToday()%>";
		if(typeof(sBirthday) != "undefined" && sBirthday != "" )
		{
			if(sBirthday >= sToday)
			{		    
				alert(getBusinessMessage('134'));//�������ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		if(typeof(sHoldDate) != "undefined" && sHoldDate != "" )
		{
			if(sHoldDate >= sToday)
			{		    
				alert(getBusinessMessage('135'));//���θ�ְ��ʱ��������ڵ�ǰ���ڣ�
				return false;		    
			}
		}		
		//У����������Ƿ���ڵ��θ�ְ��ʱ��
		if(typeof(sBirthday) != "undefined" && sBirthday != "" && 
		typeof(sHoldDate) != "undefined" && sHoldDate != "")
		{		
			if(sHoldDate <= sBirthday)
			{		    
				alert(getBusinessMessage('136'));//���θ�ְ��ʱ��������ڳ������ڣ�
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
				
		return true;
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{
		/*~
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����		
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������			
		sRelationship = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationship) != "undefined" && sRelationship != "")
		{
			var sMessage = PopPage("/CustomerManage/EntManage/RelativeCheckAction.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationship+"&CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sMessage)=="undefined" || sMessage.length==0) 
			{
				return false;
			}
			setItemValue(0,getRow(),"RelativeID",sMessage);
		}
		~*/
		//����Ƿ�¼���ظ�¼����Ϣ
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����
		sRelationShip   = getItemValue(0,0,"RelationShip");//--������ϵ
		sRelativeID   = getItemValue(0,0,"RelativeID");//--�����ͻ�����
		sCertType  = getItemValue(0,0,"CertType");//--֤������
		sCertID  = getItemValue(0,0,"CertID");//--֤������
		if(typeof(sRelativeID) == "undefined" || sRelativeID.length == "")
		{
			var sRelativeID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=CUSTOMER_INFO&ColumnName=CustomerID","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			setItemValue(0,getRow(),"RelativeID",sRelativeID);
		}
		sPara = "1,Customer_Relative,String@CustomerID@"+sCustomerID+
					"@String@CertType@"+sCertType+"@String@CertID@"+sCertID+"@String@RelationShip@"+sRelationShip;
		sReturn=RunMethod("PublicMethod","GetColValue",sPara);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert("�ø߹��Ѿ�¼��,��ѡ�������߹�!");//�ø߹��Ѿ�¼��,��ѡ�������߹�!				
			return false;
		}
		return true;
	}
	
	/*~[Describe=�������֤�Ż�ȡ��������;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function GetBirthday()
	{		
		sCertType = getItemValue(0,0,"CertType");//--֤������	
		sCertID = getItemValue(0,0,"CertID");//--֤������
	
			
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		if(sCertType =='Ind01' || sCertType =='Ind08')
		{
			if (!CheckLisince(sCertID))
			{
				alert(getBusinessMessage('156'));//�������֤��������				
				return false;
			}
			
			//�����֤�е������Զ�������������,���Ա�����(add by fhuang 06.11.28)
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
		return true;			
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