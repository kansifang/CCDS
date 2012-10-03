<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/09/23
*	Tester:
*	Describe: ��ծ�ʲ���Ϣ�б�
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
	String PG_TITLE = "��ծ�ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"SerialNo","���ʵ�ծ������"},
							{"AssetTypeName","��ծ�ʲ����"},
							{"AssetName","��ծ�ʲ�����"},
							{"AccountDescribe","��ծ�ʲ����"},
							{"PayDate","ȡ��ʱ��"},
							{"PayTypeName","ȡ�÷�ʽ"},
							{"AssetAmount","��ծ�ʲ�����"},
							{"InAccontSum","��ծ�ʲ����˽��"},
							{"AssetSum","�ֳ������"},
							{"AssetBalance","��ֳ�������Ϣ"},
							{"InterestBalance1","�ֳ�������Ϣ"},
							{"InterestBalance2","�ֳ�������Ϣ"},
							{"KeepTypeName","��ծ�ʲ����ܷ�ʽ"},
							{"PracticeKeepPlace","��ծ�ʲ�ʵ�ﱣ�ܵص�"},
							{"PracticeKeeper","ʵ�ﱣ����"},
							{"RightCardKeepPlace","��ծ�ʲ�Ȩ֤���ܵص�"},
							{"RightCardKeeper","Ȩ֤������"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 

 	sSql =  " select AI.SerialNo as SerialNo, AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
			   " getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,AI.AssetName as AssetName," + 
			   " AI.AccountDescribe as AccountDescribe,AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
			   " BA.InAccontSum as InAccontSum,"+
			   " AI.AssetAmount as AssetAmount,AI.AssetSum as AssetSum,AI.AssetBalance as AssetBalance,"+
			   " BA.InterestBalance1 as InterestBalance1,BA.InterestBalance2 as InterestBalance2,"+
			   " getItemName('PDAKeepType',AI.KeepType) as KeepTypeName,"+
			   " AI.PracticeKeepPlace as PracticeKeepPlace,AI.PracticeKeeper as PracticeKeeper,"+
			   " AI.RightCardKeepPlace as RightCardKeepPlace,AI.RightCardKeeper as RightCardKeeper,"+
			   " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
			   " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName " + 
		   " from ASSET_INFO AI,BADBIZ_APPLY BA "+
		   " where BA.SerialNo=AI.ObjectNo and "+
		   " AI.ObjectType='BadBizApply' and BA.ApplyType='010' ";
	
		   
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("080010"))//̨����Ϣδά��
	{
		sSql+="  and AI.AssetFlag in('040','020')  "+
				" and (VindicateDate is  null or VindicateDate ='' or "+
				" days(replace(VindicateDate,'/','-'))<=days(current date)-30)";
	}else if(sDealType.equals("080020"))//̨����Ϣ��ά��
	{
		sSql+="  and AI.AssetFlag in('040','020')  "+
				" and VindicateDate is not null and VindicateDate!='' "+
				" and days(replace(VindicateDate,'/','-'))>days(current date)-30 ";
	}else if(sDealType.equals("090010"))//�̵�δ���
	{
		sSql+="  and AI.AssetFlag in('040','020') "+
				" and (LiquidateDate is  null or LiquidateDate ='' or "+
				" days(replace(LiquidateDate,'/','-'))<=days(current date)-30)";
	}else if(sDealType.equals("090020"))//�̵������
	{
		sSql+="  and AI.AssetFlag in('040','020')  "+
				" and LiquidateDate is not null and LiquidateDate!='' "+
				" and days(replace(LiquidateDate,'/','-'))>days(current date)-30 ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("ObjectNo,ObjectType,ManageUserID,ManageOrgID",false);
    
	//�����п�
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("BusinessSum,InterestBalance ","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BusinessSum,InterestBalance","2");
	doTemp.setCheckFormat("Number","5");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("BusinessSum,InterestBalance,Number","3");
	
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
		{"flase","","Button","̨��ά������","̨��ά��","vindicate_List()",sResourcesPath},
		{"flase","","Button","�̵��������","�̵����","liquidate_List()",sResourcesPath},
		{"true","","Button","��ծ����","��ծ����","viewTab()",sResourcesPath},
		{"flase","","Button","�����������","�����������","viewOpinions()",sResourcesPath},
		{"false","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		};

		if(sDealType.equals("080010"))//̨����Ϣδά��
		{
			sButtons[getBtnIdxByName(sButtons,"̨��ά������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
		}else if(sDealType.equals("080020"))//̨����Ϣ��ά��
		{
			sButtons[getBtnIdxByName(sButtons,"̨��ά������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
		}else if(sDealType.equals("090010"))//�̵�δ���
		{
			sButtons[getBtnIdxByName(sButtons,"�̵��������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
		}else if(sDealType.equals("090020"))//�̵������
		{
			sButtons[getBtnIdxByName(sButtons,"�̵��������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"����EXCEL")][0]="true";
		}
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>


<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
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
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		popComp("ViewBadBizOpinions","/Common/WorkFlow/ViewBadBizOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=̨��ά��;InputParam=��;OutPutParam=��;]~*/    
	function vindicate_List()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("VindicateReportList","/RecoveryManage/PDAManage/PDADailyManage/VindicateReportList.jsp","ComponentName=��ծ�ʲ��ճ���ر����б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
	}
	
	/*~[Describe=�̵����;InputParam=��;OutPutParam=��;]~*/    
	function liquidate_List()
	{
		//��û�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			popComp("LiquidateReportList","/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportList.jsp","ComponentName=��ծ�ʲ��ճ�����̵���鱨���б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
		}
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