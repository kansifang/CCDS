<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/10/10
*	Tester:
*	Describe: ̨��ά����ծ�ʲ���Ϣ�б�
*	Input Param:
*	Output Param:  
*		DealType:��ͼ�ڵ��
*		
*	
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "̨��ά����ծ�ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%
	//�������	    
	String sSql = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"SerialNo","�ʲ����"},
							{"AssetTypeName","�ʲ����"},
							{"AssetName","�ʲ�����"},
							{"PayDate","ȡ��ʱ��"},
							{"PayTypeName","ȡ�÷�ʽ"},
							{"AssetStatusName","��ծ�ʲ���״"},
							{"CurrencyName","��ծ����"},
							{"AssetSum","��ծ���"},
							{"InAccontDate","��������"},
							{"DisposeDate","��������"},
							{"SaleSum","���۽��"},
							{"LeaseSum","������"},
							{"OtherTypeSum","�������ý��"},
							{"DisposeLossSum","������ʧ���"},
							{"AccountSum","������"},
							{"ManageUserName","������"},
							{"ManageOrgName","�������"},
							{"AccountFlag","���״̬"}
						}; 

 	sSql = "select A.SerialNo as SerialNo,A.ObjectNo as ObjectNo,A.ObjectType as ObjectType,"+
 	 		" A.AssetTypeName as AssetTypeName,A.AssetName as AssetName," +
 	 		" A.PayDate as PayDate,A.PayTypeName as PayTypeName,"+
 	 		" A.AssetStatusName as AssetStatusName,A.AssetSum as AssetSum,"+
 	 		" A.CurrencyName as CurrencyName,"+
 			" A.InAccontDate as InAccontDate, "+
 			" B.DisposeDate as DisposeDate,Nvl(B.SaleSum,0) as SaleSum,"+
 			" Nvl(B.LeaseSum,0) as LeaseSum,Nvl(B.OtherTypeSum,0) as OtherTypeSum,"+
 			" Nvl(B.DisposeLossSum,0) as DisposeLossSum,"+
 			" A.AccountSum as AccountSum,"+
 			" A.ManageUserID as ManageUserID,A.ManageUserName as ManageUserName," + 
 			" A.ManageOrgID as ManageOrgID,A.ManageOrgName as ManageOrgName,A.AccountFlag as AccountFlag " + 
 			" from ("+
	 			" select AI.SerialNo as SerialNo, AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
			   	" getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,AI.AssetName as AssetName," + 
			  	" AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
			  	" getItemName('AssetActualStatus',AI.AssetStatus) as AssetStatusName,"+
			    " AI.AssetSum as AssetSum,"+
			    " getItemName('Currency',BA.Currency) as CurrencyName,"+
			    " AI.InAccontDate as InAccontDate, "+
			    " AI.AccountSum as AccountSum,"+
			    " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
			    " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName,nvl(AI.AccountFlag,'000') as AccountFlag " + 
		   		" from ASSET_INFO AI,BADBIZ_APPLY BA "+
		  		" where AI.ObjectNo=BA.SerialNo  and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		  		" and BA.ManageUserID='"+CurUser.UserID+"' "+
		   		" and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("020010"))//�ѵ���������ʲ�
	{
		sSql+=" and AI.AssetFlag in('040','020') order by AccountFlag";
	}else if(sDealType.equals("020030"))//�Ѵ����ʲ�
	{
		sSql+=" and AI.AssetFlag in('040','020') and AI.AccountFlag is not null and  AI.AccountFlag!='' order by AccountFlag" ;
	}else
	{
		sSql+=" and 1=2";
	}
	//������
	sSql+=") A LEFT OUTER JOIN ASSET_DISPOSE B "+
		 " ON  A.serialno=B.ObjectNo ORDER BY A.AccountFlag ";
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);

	//���ù��ø�ʽ
	doTemp.setVisible("DisposeLossSum,OtherTypeSum,LeaseSum,SaleSum,DisposeDate,AccountFlag,InAccontDate,AssetSum,CurrencyNameAssetStatusName,ObjectNo,PayDate,PayTypeName,ObjectType,ManageUserID,ManageOrgID",false);
	
	if(sDealType.equals("020010"))//�ѵ���������ʲ�
	{
		doTemp.setVisible("InAccontDate,AssetSum,CurrencyNameAssetStatusName,PayDate,PayTypeName",true);
	}else if(sDealType.equals("020030"))//�Ѵ����ʲ�
	{
		doTemp.setVisible("DisposeLossSum,OtherTypeSum,LeaseSum,SaleSum,DisposeDate",true);
	}
	//�����п�
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance ","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance","2");
	doTemp.setCheckFormat("Number","5");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("SaleSum,LeaseSum,OtherTypeSum,DisposeLossSum,AssetSum,BusinessSum,InterestBalance,Number","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"false","","Button","����","����","new_Record()",sResourcesPath},
		{"true","","Button","��ծ����","��ծ����","viewTab()",sResourcesPath},
		{"false","","Button","��������Ǽ�","��������Ǽ�","account_Register()",sResourcesPath},
		{"false","","Button","���õǼ�","���õǼ�","dispose_Register()",sResourcesPath},
		{"false","","Button","�Ǽ����","�Ǽ����","deal_With()",sResourcesPath},
		{"false","","Button","�������","�������","do_Done()",sResourcesPath},
		};
	if(sDealType.equals("020010"))//�ѵ���������ʲ�
	{
		sButtons[getBtnIdxByName(sButtons,"����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��������Ǽ�")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�Ǽ����")][0]="true";
	}else if(sDealType.equals("020030"))//�Ѵ����ʲ�
	{
		sButtons[getBtnIdxByName(sButtons,"���õǼ�")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="true";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>


<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function new_Record()
	{
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sTableName = "BADBIZ_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		PopPage("/RecoveryManage/AccountManage/AddBadBizAssetAction.jsp?SerialNo="+sSerialNo,"","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			
        //���������������ˮ�ţ��������������
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=BadBizApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();		
	}
	
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//����������͡�������ˮ��
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		//reloadSelf();
	}
	
	/*~[Describe=�Ǽ����;InputParam=��;OutPutParam=��;]~*/   
	function deal_With()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//�ʲ����
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ծ�ʲ�������
		sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//����״̬
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			if(typeof(sAccountFlag) != "undefined" || sAccountFlag.length != 0)//�Ǽ����
			{
				alert("�ѽ��еǼ�,�����ظ����!");
				return;
			}
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","AccountSum,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("����е�������Ǽ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):������
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@AccountFlag@010,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//����ʧ��
					return;
				}
			}
		}
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/   
	function do_Done()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//���ʵ�ծ���
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ծ�ʲ����
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//����״̬
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			if(sAccountFlag == "020")//�Ǽ����
			{
				alert("�ѽ��д���,�����ظ����!");
				return;
			}
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","Count(SerialNo),ASSET_DISPOSE,String@ObjectNo@"+sSerialNo);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null" || sReturnInfo[1] == 0) 
			{	
				alert("����д��õǼǺ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):�������
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@AccountFlag@020,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}else
				{
					alert(getHtmlMessage('72'));//����ʧ��
					return;
				}
			}
		}
	}

	/*~[Describe=��������Ǽ�;InputParam=��;OutPutParam=��;]~*/
	function account_Register()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sEditRight = "01";
		//��������˵�������Ǽ��򲻿ɱ༭
		if(sAccountFlag > "000")
		{
			sEditRight="02";
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/RecoveryManage/AccountManage/APDAssetAccountInfo.jsp?EditRight="+sEditRight+"&SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_self",""); 
		}
	}
	
	/*~[Describe=���õǼ�;InputParam=��;OutPutParam=��;]~*/    
	function dispose_Register()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAccountFlag = getItemValue(0,getRow(),"AccountFlag");//����״̬
		var sEditRight = "01";
		//��������˵�������Ǽ��򲻿ɱ༭
		if(sAccountFlag == "020")
		{
			sEditRight="02";
		}
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("DisposeRegisterList","/RecoveryManage/AccountManage/DisposeRegisterList.jsp","ComponentName=�ʲ����õǼ��б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>&EditRight="+sEditRight,"","");
		}
		reloadSelf();
	}
	
	/*~[Describe=����Excel;InputParam=��;OutPutParam=��;]~*/
	function export_Excel()
	{
		amarExport("myiframe0");
	}
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>