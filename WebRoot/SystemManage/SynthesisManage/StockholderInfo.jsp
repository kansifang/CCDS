<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: �ɶ���������ҳ��
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 
		-- fbkang on 2005/08/14 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ɶ����������ϸҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSerialNo="";//--��ˮ����
	String sSql="";//--���sql���
	//����������

	//���ҳ�����	,��ˮ��
    sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {               
			                    {"CertID","֤����"},
			                    {"CertType","֤������"},
			                    {"CustomerName","�ɶ�����"},
						        {"Attribute3","ӵ�б��йɷ�ռ��"},
						        {"Sum1","ʵ���ʱ�"},
								{"Sum2","ӵ�б��йɷ���"},
						        {"BeginDate","��Ϊ�ɶ�����"},
						        {"EndDate","��ʼ����"},
						        {"Remark","��ע"},
						        {"OrgName","�Ǽǻ���"},
						        {"UserName","�Ǽ���"},
						        {"InputDate","�Ǽ�����"},
						        {"UpdateDate","��������"}
						   };   	
	 sSql = " select SerialNo,SectionType,CertType,CertID,CustomerID,CustomerName,Sum1,Sum2,BeginDate,EndDate,Attribute3, "+
		    " Remark,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName,"+
		    " InputDate,UpdateDate "+
		    " from CUSTOMER_SPECIAL "+
		    " where SerialNo = '"+sSerialNo+"' ";
    //sql����datawindows
	ASDataObject doTemp = new ASDataObject(sSql);
	//ͷ����
	doTemp.setHeader(sHeaders);
	//�޸ı�
	doTemp.UpdateTable = "CUSTOMER_SPECIAL";
    //��������
	doTemp.setKey("SerialNo",true);
	//���ò����޸ĵ���
	doTemp.setUpdateable("UserName,OrgName,Resouce",false);
    //���ò��ɼ���
	doTemp.setVisible("SerialNo,SectionType,InputOrgID,InputUserID,CustomerID",false);
	//���ñ�����
	doTemp.setRequired("Attribute3,BeginDate,CertID,CertType,CustomerName",true);
	//����ֻ����
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true); 
	//�������ڵĸ�ʽ
	doTemp.setCheckFormat("BeginDate,InputDate,UpdateDate,EndDate","3");
	//���ÿ��
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark"," style={height:100px;width:400px} ");
	doTemp.setHTMLStyle("Attribute3"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	//��������
    //֤������
    doTemp.setDDDWCode("CertType","CertType");
    //����numberֵ����
    doTemp.setType("Sum1,Sum2","Number");
    //����Attribute3��С��������ʾ��λ    
    doTemp.setCheckFormat("Attribute3","16");
   	//���ö��뷽ʽ���Ҷ��� 
	doTemp.setAlign("Attribute3","3");
	doTemp.setUnit("Attribute3","%");
	doTemp.setUnit("Sum1","Ԫ");
	//�����ֶ����볤��
	doTemp.setLimit("CustomerName",40);
	doTemp.setLimit("Remark",100);
	//�����������ֶ�У�����
	doTemp.appendHTMLStyle("Attribute3"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"ӵ�б��йɷ�ռ�ȵķ�ΧΪ[0,100]\" ");
	doTemp.appendHTMLStyle("Sum1"," myvalid=\"parseFloat(myobj.value,10)>0 \" mymsg=\"ʵ���ʱ��������0��\" ");
	doTemp.appendHTMLStyle("Sum2"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000000000 \" mymsg=\"ӵ�б��йɷ����ķ�ΧΪ[0,1000000000]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setEvent("BeforeUpdate","!CustomerManage.InsertHistoryInfoLog(#SerialNo,"+CurUser.UserID+",ChangeStockholderList)");
	doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
	doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddCustomerInfo(#CustomerID,#CustomerName,#CertType,#CertID,,#InputUserID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{((CurUser.hasRole("097"))?"false":"true"),"","Button","����","���������޸�","saveRecord()",sResourcesPath},
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

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if (!ValidityCheck()) return;
		if(bIsInsert)
		{
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function ValidityCheck()
	{
		sAttribute3 = getItemValue(0,getRow(),"Attribute3");
		if(sAttribute3 < 0 || sAttribute3 > 100){
			alert("ӵ�б��йɷ�ռ�ȵķ�ΧΪ[0,100]");
			return false;
		}
		
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
		
		//У��Ȩ���˴�����
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//Ȩ���˴�����	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('235'));//Ȩ���˴���������							
				return false;
			}
			
			//����Ȩ���˴�����Ψһ��
			sOwnerName = getItemValue(0,getRow(),"OwnerName");//Ȩ��������	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sOwnerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('236'));//��Ȩ���˴������ѱ������ͻ�ռ�ã�							
				return false;
			}						
		}
		
		//��������Ȩ�����Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡȨ���˵Ŀͻ����
		if(typeof(sCertType) != "undefined" && sCertType != "" 
		&& typeof(sCertID) != "undefined" && sCertID != "")
		{
			var sCustomerID = PopPage("/PublicInfo/CheckCustomerAction.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) {
				return false;
			}
			setItemValue(0,0,"CustomerID",sCustomerID);
		} 
		return true;
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/SystemManage/SynthesisManage/StockholderList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

		/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--���»����ˮ��
		OpenPage("/SystemManage/SynthesisManage/StockholderInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
       initSerialNo();//��ʼ����ˮ���ֶ�
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");//--��õ�ǰ����
		setItemValue(0,0,"UpdateDate",sDay);
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤������		
		setObjectValue("SelectOwner","","@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");	    
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
        
        //��ÿͻ�����
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		if(typeof(sCertType) == "undefined" || sCertType == "") 
		{
			alert("������֤�����ͣ�");
			return;
		}
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
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;

			sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate",sDay);
			setItemValue(0,0,"UpdateDate",sDay);
			setItemValue(0,0,"SectionType","50");//--�ɶ�
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CUSTOMER_SPECIAL";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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
