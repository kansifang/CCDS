<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ��ͬת���б����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬת��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%		
	//�������
	String sSql;	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sHeaders[][] = {
			                    {"BCFlag","�Ƿ�ת��"},
			                    {"SerialNo","��ͬ��ˮ��"},
						        {"CustomerName","�ͻ�����"},
						        {"ManageOrgName","��ͬ��������"},
						        {"ManageUserName","�ܻ��ͻ�����"},
						        {"BusinessTypeName","ҵ��Ʒ��"},
						        {"OccurTypeName","��������"},
						        {"CurrencyName","����"},
						        {"BusinessSum","���"}						        
			               };
		
	sSql = " select '' as BCFlag,SerialNo,CustomerName,getOrgName(ManageOrgID) as ManageOrgName,ManageOrgID, "+
		   " getUserName(ManageUserID) as ManageUserName,ManageUserID,getBusinessName(BusinessType) as BusinessTypeName, "+
           " getItemName('OccurType',OccurType) as OccurTypeName,getItemName('Currency',BusinessCurrency) "+
		   " as CurrencyName,BusinessSum from BUSINESS_CONTRACT where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//�����ֱ��֧�й���Ա
	if(CurUser.hasRole("0M2"))
	{
		sSql += " AND ManageOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	//����ҵ������ϵͳ����Ա
	if(CurUser.hasRole("0J2"))
	{
		sSql += " AND exists(select 1 from user_role where UserID=BUSINESS_CONTRACT.ManageUserID and roleid in('080'))  ";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setType("BusinessSum","Number");
    doTemp.setAlign("BusinessSum","3");
	doTemp.setAlign("BCFlag","2");
	//�����ֶβ��ɼ�
	doTemp.setVisible("ManageOrgID,ManageUserID",false);
	//�����ֶ���ʾ���
	doTemp.setHTMLStyle("BusinessTypeName,CustomerName,ManageOrgName"," style={width:200px} ");	
	doTemp.setHTMLStyle("OccurTypeName,CurrencyName,ManageUserName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BCFlag","style={width:60px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");

	//���ֶ��Ƿ�ɸ���
	doTemp.setUpdateable("BusinessTypeName,OccurTypeName,CurrencyName",false);
	
	//���ɲ�ѯ����	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
		
	doTemp.parseFilterData(request,iPostChange);
	doTemp.haveReceivedFilterCriteria();
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));		
	
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����ΪGrid���
	dwTemp.Style="1";
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","ת��","ת�ƺ�ͬ��Ϣ","transferContract()",sResourcesPath}	,
		{"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","(˫�����ѡ��/ȡ�� �Ƿ�ת��)","style={color:red}",sResourcesPath},
		{"true","","Button","ȫѡ","ȫѡ","SelectedAll()",sResourcesPath},
		{"true","","Button","��ѡ","��ѡ","SelectedBack()",sResourcesPath},
		{"true","","Button","�ָ�","ȡ��ȫѡ","SelectedCancel()",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ת�ƺ�ͬ;InputParam=��;OutPutParam=��;]~*/	
	function transferContract()
    {    	
    	if(!selectRecord()) return;
    	if (confirm(getBusinessMessage("936")))//ȷ��ת�Ƹú�ͬ��
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//��ȡ��ǰ����
			sSortNo = "<%=CurOrg.SortNo%>";
			sParaStr = "SortNo,"+sSortNo;
			sUserInfo = setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
		    if(sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage("937"));//��ѡ��ת�ƺ�Ŀͻ�����
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//��ȡ������Ϣ����,����ͬʱѡ�������¼���ӵģ��˴�ѡ��ֻ����һ��	
				sChangeObject = PopPage("/SystemManage/SynthesisManage/ContractShiftDialog.jsp","","dialogWidth=24;dialogHeight=16;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 													
				if(sChangeObject != "_CANCEL_" && typeof(sChangeObject) != "undefined")
				{
					//���ж��Ƿ�������һ����ͬ��ѡ���������ˡ����е��ҳ���
					var b = getRowCount(0);				
					for(var i = 0 ; i < b ; i++)
					{
						var a = getItemValue(0,i,"BCFlag");
						if(a == "��")
						{
							sSerialNo = getItemValue(0,i,"SerialNo");	
							sFromOrgID = getItemValue(0,i,"ManageOrgID");
							sFromOrgName = getItemValue(0,i,"ManageOrgName");
							sFromUserID = getItemValue(0,i,"ManageUserID");
							sFromUserName = getItemValue(0,i,"ManageUserName");	
							if(sFromUserID == sToUserID)
							{
								alert(getBusinessMessage("938"));//�������ͬת����ͬһ�ͻ��������У�������ѡ��ת�ƺ�Ŀͻ�����
								return;
							}	
						
							//����ҳ�����
							sReturn = PopPage("/SystemManage/SynthesisManage/ContractShiftAction.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"&ChangeObject="+sChangeObject,"","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
							if(sReturn == "TRUE")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("939"));//��ͬת�Ƴɹ���
							else if(sReturn == "FALSE")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("940"));//��ͬת��ʧ�ܣ�
							else if(sReturn == "NOT")
								alert("��ͬ��ˮ��("+sSerialNo+"),"+getBusinessMessage("941"));//���ܿͻ�����Ըú�ͬ�Ŀͻ�û��ҵ�����Ȩ������ת�ƣ�
							else if(sReturn == "UNFINISHRISKSIGNAL")
								alert("��ͬ��ˮ��("+sSerialNo+")�Ľ���˻�������;��Ԥ���źŷ����������,����ת�ƣ�");
						}
					}
				}				
				reloadSelf();				
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=�һ�ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function onDBClickStatus()
	{
		sBCFlag = getItemValue(0,getRow(),"BCFlag") ;
		if (typeof(sBCFlag) == "undefined" || sBCFlag == "")
			setItemValue(0,getRow(),"BCFlag","��");
		else
			setItemValue(0,getRow(),"BCFlag","");

	}
	
	/*~[Describe=ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function selectRecord()
	{
		var b = getRowCount(0);
		var iCount = 0;				
		for(var i = 0 ; i < b ; i++)
		{
			var a = getItemValue(0,i,"BCFlag");
			if(a == "��")
				iCount = iCount + 1;
		}
		
		if(iCount == 0)
		{
			alert(getHtmlMessage('24'));//������ѡ��һ����Ϣ��
			return false;
		}
		
		return true;
	}
	/*~[Describe=ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"BCFlag","��");
			}
		}
	}
	
	
	/*~[Describe=��ѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != "��"){
				setItemValue(0,iMSR,"BCFlag","��");
			}else{
				setItemValue(0,iMSR,"BCFlag","");
			}
		}
	}
	
	/*~[Describe=ȡ��ȫѡObjectViewer��;InputParam=��;OutPutParam=��;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"BCFlag");
			if(a != ""){
				setItemValue(0,iMSR,"BCFlag","");
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
