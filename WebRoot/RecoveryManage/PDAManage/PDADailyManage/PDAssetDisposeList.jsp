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
	System.out.println("sDealType="+sDealType);
	//���ҳ�����
			
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�������
	String sHeaders[][] = {
							{"BadSerialNo","���ʵ�ծ������"},
							{"SerialNo","��ծ�ʲ����"},
							{"AssetCustomerName","�ֳ�������"},
							{"AssetContractNo","�ֳ������ͬ��ˮ��"},
							{"AssetTypeName","�ʲ�����"},
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
							{"AssetLocation","����(����)�ص�"},
							{"AssetStatus","��ծ�ʲ���״"},
							{"AssetArea","�������(Ķ)"},
							{"AssetArea1","�������(ƽ����)"},
							{"AssetAna","��������"},
							{"TransferFlag","�Ƿ����"},
							{"AssetOccurType","��������"},
							{"AssetAccountSum","��ծ�ʲ����˽��"},
							{"AssetAccountBalance","��ծ�ʲ��������"},
							{"MainManager","��Ӫ������������"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 

 	sSql = " select AI.SerialNo as SerialNo, BA.Serialno as BadSerialNo,AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
		   " AI.AssetType as AssetType,"+
		   " AI.AssetCustomerName as AssetCustomerName,AI.AssetContractNo as AssetContractNo,"+
		   " getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,"+
		   " AI.AssetName as AssetName," + 
		   " AI.AccountDescribe as AccountDescribe,AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
		   " BA.InAccontSum as InAccontSum,"+
		   " AI.AssetAmount as AssetAmount,AI.AssetSum as AssetSum,AI.AssetBalance as AssetBalance,"+
		   " BA.InterestBalance1 as InterestBalance1,BA.InterestBalance2 as InterestBalance2,"+
		   " getItemName('PDAKeepType',AI.KeepType) as KeepTypeName,"+
		   " AI.RightCardKeepPlace as RightCardKeepPlace,"+
		   " AI.PracticeKeepPlace as PracticeKeepPlace,AI.PracticeKeeper as PracticeKeeper,"+
		   " AI.RightCardKeeper as RightCardKeeper,"+
		   " AI.AssetLocation as AssetLocation,getItemName('AssetActualStatus',AI.AssetStatus) as AssetStatus,"+
		   " AI.AssetArea as AssetArea,AI.AssetArea as AssetArea1,"+
		   " getItemName('SoilProperty',AI.AssetAna) as AssetAna,getItemName('YesNo',AI.TransferFlag) as TransferFlag,"+
		   " getItemName('ExistNewType',AI.AssetOccurType) as AssetOccurType,AI.AssetAccountSum as AssetAccountSum,"+
		   " AI.AssetAccountBalance as AssetAccountBalance,"+
		   " AI.MainManager as MainManager,"+
		   " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
		   " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName,AI.AssetFlag as AssetFlag  " + 
		   " from ASSET_INFO AI,BADBIZ_APPLY BA "+
		   " where BA.SerialNo=AI.ObjectNo and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		   " and BA.ManageUserID='"+CurUser.UserID+"' "+
		   " and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
		   
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("050"))//δ���õ�ծ�ʲ�
	{
		sSql+=" and AI.AssetFlag ='020' ";
	}else if(sDealType.equals("060"))//�Ѵ��õ�ծ�ʲ�
	{
		sSql+=" and DisposeFlag='010' ";
	}else
	{
		sSql+=" and 1=2";
	}
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);
	
	//���ù��ø�ʽ
	doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,InAccontSum,AssetType,AssetFlag,AssetBalance,RightCardKeeper,RightCardKeepPlace,PracticeKeeper,PracticeKeepPlace,KeepTypeName,ManageUserName,ManageOrgName,ObjectNo,ObjectType,ManageUserID,ManageOrgID",false);
	
	if(sDealType.equals("020010010")){
		//doTemp.setHeader("ManageUserName","����������");
		doTemp.setVisible("AccountDescribe,ManageUserName,AssetAmount,AssetSum,InterestBalance1,InterestBalance2,KeepTypeName,RightCardKeepPlace",false);
		doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,",true);
	}else if(sDealType.equals("020010020"))
	{	
		//doTemp.setHeader("ManageUserName","����������");
		doTemp.setVisible("AccountDescribe,ManageUserName,AssetAmount,AssetSum,InterestBalance1,InterestBalance2,KeepTypeName,RightCardKeepPlace",false);
		doTemp.setVisible("AssetAccountBalance,AssetAccountSum,AssetOccurType,TransferFlag,AssetAna,AssetArea1,AssetArea,AssetStatus,AssetLocation,AssetCustomerName,AssetContractNo,",true);
	}
	//�����п�
	doTemp.setHTMLStyle("InputDate"," style={width:65px} ");
	doTemp.setHTMLStyle("OperateOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("OperateUserName"," style={width:60px} ");

	//���ý��Ϊ��λһ������
	doTemp.setType("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","2");
	doTemp.setCheckFormat("Number","5");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("AssetAccountBalance,AssetAccountSum,BusinessSum,InterestBalance,Number,InAccontSum,AssetArea1,AssetArea,InterestBalance1,InterestBalance2","3");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("SerialNo,BadSerialNo","IsFilter","1");
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
		{"flase","","Button","̨����Ϣά��","̨����Ϣά��","mend_Info()",sResourcesPath},
		{"flase","","Button","̨����Ϣ����","̨����Ϣ����","mend_Info()",sResourcesPath},
		{"flase","","Button","����̨��ά����Ϣ","����̨��ά����Ϣ","new_Vindicate()",sResourcesPath},
		{"flase","","Button","�����̵����","�����̵����","new_Liquidate()",sResourcesPath},
		{"flase","","Button","̨��ά����Ϣ����","̨��ά����Ϣ����","vindicate_List()",sResourcesPath},
		{"flase","","Button","�̵������Ϣ����","�̵������Ϣ����","liquidate_List()",sResourcesPath},
		{"flase","","Button","���ʵ�ծ��������","���ʵ�ծ��������","viewTab()",sResourcesPath},
		{"flase","","Button","�����������","�����������","viewOpinions()",sResourcesPath},
		{"flase","","Button","���յǼ�","���յǼ�","incept_Rgister()",sResourcesPath},
		{"flase","","Button","��������","��������","incept_Rgister()",sResourcesPath},
		{"flase","","Button","̨����Ϣ����","̨����Ϣ����","mend_Info()",sResourcesPath},
		{"flase","","Button","���ά��","���ά��","vindicate_Complete()",sResourcesPath},
		{"flase","","Button","����̵����","����̵����","liquidate_Complete()",sResourcesPath},
		{"flase","","Button","�������","�������","incept_Complete()",sResourcesPath},
		{"flase","","Button","�������","�������","mend_Complete()",sResourcesPath},
		{"false","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath},
		};

	
		if(sDealType.equals("050"))//��ծ�ʲ�δ����
		{	
			sButtons[getBtnIdxByName(sButtons,"���ʵ�ծ��������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"�����������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"��������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"�̵������Ϣ����")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"̨����Ϣ����")][0]="true";
		}else if(sDealType.equals("060"))//��ծ�ʲ��ѽ���
		{	
			sButtons[getBtnIdxByName(sButtons,"���ʵ�ծ��������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"�����������")][0]="true";
			sButtons[getBtnIdxByName(sButtons,"��������")][0]="true";
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
	/*~[Describe=̨����Ϣ����;InputParam=��;OutPutParam=��;]~*/
	function mend_Info()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sAssetType   = getItemValue(0,getRow(),"AssetType");
		sAssetFlag   = getItemValue(0,getRow(),"AssetFlag");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/	PDAAcceptMendInfo.jsp?SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&AssetFlag="+sAssetFlag, "_self","");
		}
	}
	
	/*~[Describe=����̨��ά����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function new_Vindicate()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/VindicateReportInfo.jsp?OpenFlag=1&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","_self","");
		}
	}
	
	/*~[Describe=�����̵����;InputParam=��;OutPutParam=��;]~*/
	function new_Liquidate()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/LiquidateReportInfo.jsp?OpenFlag=1&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","_self","");
		}
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
		reloadSelf();
	}
	
	/*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		//����������͡�������ˮ�š����̱�š��׶α��
		sObjectType = "BadBizApply";
		sObjectNo = getItemValue(0,getRow(),"BadSerialNo");
		sFlowNo = "BadBizApply";
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
		//������ʵ�ծ��
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
	
	/*~[Describe=���յǼ�;InputParam=��;OutPutParam=��;]~*/
	function incept_Rgister()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAssetInceptInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DealType=<%=sDealType%>","_self",""); 
		}
	}
	
	
	/*~[Describe=���ά��;InputParam=��;OutPutParam=��;]~*/   
	function vindicate_Complete()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//���ʵ�ծ���
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��ɼ��
			sReturnValue=RunMethod("BadBizManage","FinishNPAReport",sSerialNo+",010");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//�����ɹ�
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("�����̨��ά���ٵ��!");
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
			}
		}
	}
	
	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/   
	function liquidate_Complete()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//���ʵ�ծ���
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��ɼ��
			sReturnValue=RunMethod("BadBizManage","FinishNPAReport",sSerialNo+",020");
			if(sReturnValue=="True")
			{
				alert(getHtmlMessage('71'));//�����ɹ�
				self.location.reload();
			}else if(sReturnValue=="None")
			{
				alert("������̵�����ٵ��!");
			}else
			{
				alert(getHtmlMessage('72'));//����ʧ��
			}
		}
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/   
	function incept_Complete()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//���ʵ�ծ���
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ծ�ʲ����
		sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","KeepType,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("����н��յǼǺ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):�ѽ���
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@040,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					//��ѯ��ծ�ʲ��Ƿ�ȫ���������
					sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@010");
					sReturnInfo=sReturn.split("@")
					if(sReturnInfo[1] == "0")// 
					{	
						//���²����ʲ������(��ծ�ʲ�������):�������
						sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@030,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
					
					}
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}
			}
		}
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/   
	function mend_Complete()
	{
		//��ú�ͬ��ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//���ʵ�ծ���
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//��ծ�ʲ����
		sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","PayDate,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("�����̨����Ϣ���Ǻ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):�Ѳ���
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@020,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					alert(getHtmlMessage('71'));//�����ɹ�
					self.location.reload();
				}
			}
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