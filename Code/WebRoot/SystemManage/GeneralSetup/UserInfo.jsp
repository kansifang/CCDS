<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: �������Ϣ����
		Input Param:
                    UserID��    �������
                    ItemNo��    ��Ŀ��ţ������ǲ����룩
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	//���������
	String sSortNo = "";
	//�����
	ASResultSet rs = null;
	String sSql = "";
	//����������	
	String sUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if(sUserID==null) sUserID="";
	//���ó�ʼ����000000als6
	MD5 md5 = new MD5();
	String sPassword = md5.getMD5ofStr("000000als6");
	
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//��û��������
	sSql = "select SortNo from ORG_INFO where  OrgID='"+CurOrg.OrgID+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sSortNo = rs.getString("SortNo");
	}
	rs.getStatement().close();
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	if(!CurUser.hasRole("000")&&!CurUser.hasRole("099"))
	{
		doTemp.setDDDWSql("BelongOrg","select orgid,orgName from org_info where SortNo like '"+sSortNo+"%'");
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);
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
		{((CurUser.hasRole("098") || CurUser.hasRole("299") || CurUser.hasRole("0M2") || CurUser.hasRole("0J2"))?"true":"false"),"","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","���ص��б����","doReturn('Y')",sResourcesPath}		
		};

	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    var sCurUserID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		if (!ValidityCheck()) return;
        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        sUserID = getItemValue(0,getRow(),"UserID");
        if(sUserID!="<%=sUserID%>"){
	        sReturnInfo = RunMethod("PublicMethod","GetColValue","Count(*),USER_INFO,String@UserID@"+sUserID);
	        sReturnInfo = sReturnInfo.split('@');
	        if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
			{
				if(sReturnInfo[1] >= 1)
				{
					alert("������ͬ��ŵ��û����ڣ�");
					return;
				}
				//����������û������ó�ʼ����000000als6
				if(bIsInsert)
				{
					setItemValue(0,0,"Password","<%=sPassword%>");
					as_save("myiframe0","pageReload();");
					return;
				}
			}
       }
       as_save("myiframe0","");
       bIsInsert=false��
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
        OpenPage("/SystemManage/GeneralSetup/UserList.jsp","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	var bIsInsert = false;
	
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sUserID   = getItemValue(0,getRow(),"UserID");//--�����ͻ�����
		OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp?UserID="+sUserID,"_self","");
	}
	
	/*~[Describe=��������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectOrg()
	{		
		sParaString = "OrgID,"+"<%=CurOrg.OrgID%>";
		setObjectValue("SelectBelongOrg",sParaString,"@BelongOrg@0@BelongOrgName@1",0,0,"");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CertType","Ind01");
			setItemValue(0,0,"Status","1");
            setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");
            setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
            setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");            
            setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"InputTime","<%=StringFunction.getNow()%>");
            setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
            setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
            setItemValue(0,0,"UpdateTime","<%=StringFunction.getNow()%>");
            bIsInsert = true;
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
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
		
		//2��У��סլ�绰
		sCompanyTel = getItemValue(0,getRow(),"CompanyTel");//��λ�绰	
		if(typeof(sCompanyTel) != "undefined" && sCompanyTel != "" )
		{
			if(!CheckPhoneCode(sCompanyTel))
			{
				alert(getBusinessMessage('203'));//��λ�绰����
				return false;
			}
		}
		
		//3��У���ֻ�����
		sMobileTel = getItemValue(0,getRow(),"MobileTel");//�ֻ�����
		if(typeof(sMobileTel) != "undefined" && sMobileTel != "" )
		{
			if(!CheckPhoneCode(sMobileTel))
			{
				alert(getBusinessMessage('204'));//�ֻ���������
				return false;
			}
		}
		
		//4��У���������
		sEmail = getItemValue(0,getRow(),"Email");//��������	
		if(typeof(sEmail) != "undefined" && sEmail != "" )
		{
			if(!CheckEMail(sEmail))
			{
				alert(getBusinessMessage('205'));//������������
				return false;
			}
		}		
		return true;	
	}

	function getBirthday(){
		sCertID = getItemValue(0,getRow(),"CertID");//֤�����
		if(typeof(sCertID) != "undefined" && sCertID != ""){
			sBirthday = sCertID.substring(6,10);
			sBirthday1 = sCertID.substring(10,12);
			sBirthday2 = sCertID.substring(12,14);
			setItemValue(0,0,"Birthday",sCertID.substring(6,10)+"/"+sCertID.substring(10,12)+"/"+sCertID.substring(12,14));
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

