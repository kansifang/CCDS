<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: �ͻ��ſ�
		Input Param:
			                sCustomerID:�ͻ���
			                sCustomerInfoTemplet:�ͻ��ſ���ʾģ��
		Output param:
		History Log: 
		    jytian 2004.12.23  ����ʱ����"�Ƿ�����Ŀ"��"�Ƿ���·��ز�����"����ʾ
		    cwzhan 2005-1-19    ���ͻ����ڹ���(����)�����й�ʱ����Ҫ������ʡ�ݡ�ֱϽ�С�������
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
	//ģ������
	String sCustomerInfoTemplet="";
	
	//����������

	//���ҳ�����	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));

	String sSql;
	ASResultSet rs = null;
	
	//ȡ����ͼģ������
	sCustomerInfoTemplet = "";
	sSql="select ItemAttribute  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo in (select CustomerType from CUSTOMER_INFO where CustomerID ='"+sCustomerID+"' )";
    rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   	sCustomerInfoTemplet=DataConvert.toString(rs.getString("ItemAttribute"));
	}
	rs.getStatement().close(); 
	
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("�ͻ���Ϣ�����ڻ�ͻ�����δ���ã�"); 
	

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = sCustomerInfoTemplet;
	
  
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	//������ҵ����һѡ��ʽ
	doTemp.appendHTMLStyle("IndustryType"," style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getIndustryType()\" ");
	//���ù��ڵ���ѡ��ʽ
	doTemp.appendHTMLStyle("RegionName"," style=cursor:hand; onClick=\"javascript:parent.getRegionCode()\" ");	
	//�ж���������
	doTemp.appendHTMLStyle("OfficeZIP"," onchange=parent.checkOfficeZIP() ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
	    //@author:  cwzhan 
        //@date:    2005-1-19
        //@GoTo:    ����ǰ�жϸÿͻ����ڹ���(����)Ϊ�й�ʱ�Ƿ������롰ʡ�ݡ�ֱϽ�С�����������Ϣ
        //~end add 2005-1-19
        //�ж�Ӫҵִ�պϷ���
		/*
        var sLicenseNo = getItemValue(0,getRow(),"LicenseNo");
		if(sLicenseNo !=' ' && sLicenseNo != '')
		{
			//Ӫҵִ�մ���Ӧ����13λ��
			if (sLicenseNo.length != 13)
			{
				alert(getBusinessMessage('155'));
				return;
			}
		}
			
		//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
		var sFictitiousPersonID = getItemValue(0,getRow(),"FictitiousPersonID");
		if(sFictitiousPersonID !='')
		{
			if (sFictitiousPersonID.length != 15 && sFictitiousPersonID.length != 18)
			{
				alert(getBusinessMessage('156'));
				return;
			}
		}
		*/

		if(vI_all("myiframe0"))
		{
			beforeUpdate();
			setItemValue(0,getRow(),'TempSaveFlag',"");
			as_save("myiframe0",sPostEvents);
		}
	}
		
	function saveRecordTemp()
	{
		//0����ʾ��һ��dw
		setNoCheckRequired(0);  //���������б���������
		setItemValue(0,getRow(),'TempSaveFlag',"��");
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
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate",sDay);
	}

        /*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCode(sCodeNo,sIDColumn,sNameColum)
	{
		
		setObjectInfo("Code","CodeNo="+sCodeNo+"@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
		/*
		* setObjectInfo()����˵����---------------------------
		* ���ܣ� ����ָ�������Ӧ�Ĳ�ѯѡ��Ի��򣬲������صĶ������õ�ָ��DW����
		* ����ֵ�� ���硰ObjectID@ObjectName���ķ��ش��������ж�Σ����硰UserID@UserName@OrgID@OrgName��
		* sObjectType�� ��������
		* sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
		* iArgDW:  �ڼ���DW��Ĭ��Ϊ0
		* iArgRow:  �ڼ��У�Ĭ��Ϊ0
		* ��������� common.js -----------------------------
		*/
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		if(sCountryTypeValue!="142")
		{
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionCodeName","");
		}
		
	}
	function selectVillage(sIDColumn,sNameColum)
	{
		setObjectInfo("Village","VillageType='0'@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
	
	}
	
	//ѡ����ڵ��������˼��ᣩ
	function getRegionCode(flag)
	{
		//�жϹ�����û��ѡ�й�
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		//alert(sCountryTypeValue);
		var sRegionInfo;
		if (flag=="ent")
		{
		//�жϹ����Ƿ��Ѿ�ѡ��
		if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )

		{
			if(sCountryTypeValue=="142")
			{
			
			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        		//���ε���RegionSelect.jsp����ҪĿ���Ƿִ���ʾ���д��룬����ҳ����ʾʱ��
			if(sRegionInfo!="NO" && sRegionInfo != "" && typeof(sRegionInfo) != "undefined")
			{
	        		sRegionInfo1=sRegionInfo.split("@");
	        		sRegionCode = sRegionInfo1[0];
	        		sRegionName = sRegionInfo1[1];
	        		if(sRegionCode !='71' && sRegionCode !='81' && sRegionCode !='82')
	        			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?RegionCode="+sRegionCode+"&RegionName="+sRegionName+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
	    		}
			if(sRegionInfo == "NO")
			{
				
					setItemValue(0,getRow(),"RegionCode","");
					setItemValue(0,getRow(),"RegionCodeName","");
			
			}
			else if(typeof(sRegionInfo) != "undefined" && sRegionInfo != "")
			{
				sRegionInfo = sRegionInfo.split('@');
				sRegionValue = sRegionInfo[0];
				sRegionName = sRegionInfo[1];
			
					setItemValue(0,getRow(),"RegionCode",sRegionValue);
					setItemValue(0,getRow(),"RegionCodeName",sRegionName);
			
			}
			}
			else
			{
				alert(getBusinessMessage('122'));//��ѡ���Ҳ����й�������ѡ�����
			}
		}
		else
		{
			alert(getBusinessMessage('123'));//��δѡ����ң��޷�ѡ�����
		}
		
		
		}
		else 	//������ҵ�ͻ�����������͸��˵ļ���
		{

			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        		//���ε���RegionSelect.jsp����ҪĿ���Ƿִ���ʾ���д��룬����ҳ����ʾʱ��
			if(sRegionInfo!="NO" && sRegionInfo != "" && typeof(sRegionInfo) != "undefined")
			{
	        		sRegionInfo1=sRegionInfo.split("@");
	        		sRegionCode = sRegionInfo1[0];
	        		sRegionName = sRegionInfo1[1];
	        		if(sRegionCode !='71' && sRegionCode !='81' && sRegionCode !='82')
	        			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?RegionCode="+sRegionCode+"&RegionName="+sRegionName+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
	    		}
			if(sRegionInfo == "NO")
			{
				
					setItemValue(0,getRow(),"NativePlace","");
					setItemValue(0,getRow(),"NativePlaceName","");
				
			}
			else if(typeof(sRegionInfo) != "undefined" && sRegionInfo != "")
			{
				sRegionInfo = sRegionInfo.split('@');
				sRegionValue = sRegionInfo[0];
				sRegionName = sRegionInfo[1];
				
				
				setItemValue(0,getRow(),"NativePlace",sRegionValue);
				setItemValue(0,getRow(),"NativePlaceName",sRegionName);
				
			}
		}
	}	
	
    	//ѡ�������ҵ����
	function getIndustryType()
	{

		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}
		else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];
			sIndustryTypeName = sIndustryTypeInfo[1];

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}
			else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];
				sIndustryTypeName = sIndustryTypeInfo[1];
				setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
				setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);
				
			}

		}

	}
	//Ч�������������Ƿ�����ַ��������ַ�ȥ�� Add by ndeng 2005.01.27
	function checkOfficeZIP()
	{
		var sOfficeZIP = getItemValue(0,getRow(),"OfficeZIP");
		var siOfficeZIP = "";	//����������
		var bhavechar = false;	//�����ֶ��Ƿ�����ַ�
		for(var i=0;i<=sOfficeZIP.length-1;i++)
		{
			s_tmp = sOfficeZIP.substring(i,i+1);
			if (s_tmp<="9" && s_tmp>="0")
			{
				siOfficeZIP=siOfficeZIP+s_tmp;		//��������		
			}
			else
			{
				bhavechar=true; 			//�в������ֵ��ַ�
			}
		}		
		if(bhavechar)
		{
			alert("��������ӦΪ���֣�");
			setItemValue(0,getRow(),"OfficeZIP",siOfficeZIP); //����������ֱ����������
		}
	}
	function View()
	{	
		var sCustomerID="<%=sCustomerID%>";
		openObject("Customer",sCustomerID,"001");	
	}
	
	/*~[����ʱ����"�Ƿ�����Ŀ"��"�Ƿ���·��ز�����"����ʾ;]~*/		
	function alertInput()
	{	
		var sProjectFlag = getItemValue(0,getRow(),"ProjectFlag");
		var sRealtyFlag = getItemValue(0,getRow(),"RealtyFlag");
		if (sProjectFlag=='010')
		{
			alert(getBusinessMessage('187')); //�ÿͻ�Ŀǰ����Ŀ�����Ժ��ڡ�������Ŀ�������¼����Ӧ����Ŀ��Ϣ��
		}
		if (sRealtyFlag=='010')
		{
			alert(getBusinessMessage('188'));  //�ÿͻ����·��ز����������Ժ��ڡ����ز������������¼����Ӧ�ķ��ز�������Ϣ��
		}	
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		if (sCountryCode=="") //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			setItemValue(0,getRow(),"CountryCode","142");
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
    }
	
    //����String.replace���������ַ����������ߵĿո��滻�ɿ��ַ���
    function Trim (sTmp)
    {
    return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
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



<%@ include file="IncludeEnd.jsp"%>
