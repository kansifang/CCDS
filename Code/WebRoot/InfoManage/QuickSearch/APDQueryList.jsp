<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: zwhu 2009/10/13
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
							{"SerialNo","���ʵ�ծ������"},
							{"AssetTypeName","��ծ�ʲ����"},
							{"AssetName","��ծ�ʲ�����"},
							{"AccountDescribe","��ծ�ʲ����"},
							{"PayDate","ȡ��ʱ��"},
							{"PayTypeName","ȡ�÷�ʽ"},
							{"AssetAmount","��ծ�ʲ�����"},
							//{"","��ծ�ʲ����˽��"},
							{"AssetSum","�ֳ������"},
							{"AssetBalance","��ֳ�������Ϣ"},
							//{"","�ֳ�������Ϣ"},
							//{"","�ֳ�������Ϣ"},
							{"ManageUserName","�ܻ���"},
							{"ManageOrgName","�ܻ�����"}
						}; 

 	sSql = " select AI.SerialNo as SerialNo, AI.ObjectNo as ObjectNo,AI.ObjectType as ObjectType ," + 	
		   " getItemName('PDAAssetType',AI.AssetType) as AssetTypeName,AI.AssetName as AssetName," + 
		   " AI.AccountDescribe as AccountDescribe,AI.PayDate as PayDate,getItemName('PDAGainType',AI.PayType) as PayTypeName,"+
		   " AI.AssetAmount as AssetAmount,AI.AssetSum as AssetSum,AI.AssetBalance as AssetBalance,"+
		   " BA.ManageUserID as ManageUserID,getUserName(BA.ManageUserID) as ManageUserName," + 
		   " BA.ManageOrgID as ManageOrgID,getOrgName(BA.ManageOrgID) as ManageOrgName " + 
		   " from ASSET_INFO AI,BADBIZ_APPLY BA "+
		   " where BA.SerialNo=AI.ObjectNo and AI.ObjectType='BadBizApply' and BA.ApplyType='010' "+
		   " and BA.ManageUserID='"+CurUser.UserID+"' "+
		   " and BA.ManageOrgID='"+CurOrg.OrgID+"'";
	
	//������ͼȡ��ͬ�����	   
	if(sDealType.equals("020010"))//�ѵ���������ʲ�
	{
		sSql+=" and AI.AssetFlag in('040','020')  ";
	}else if(sDealType.equals("020020"))//�������ʲ�
	{
		sSql+=" and AI.AssetFlag='050'  ";
	}else if(sDealType.equals("020030"))//�Ѵ����ʲ�
	{
		sSql+=" and AI.AssetFlag='060'  ";
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
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"false","","Button","����","����","new_Record()",sResourcesPath},
		{"true","","Button","��ծ����","��ծ����","viewTab()",sResourcesPath},
		{"false","","Button","��������Ǽ�","��������Ǽ�","account_Register()",sResourcesPath},
		{"false","","Button","���õǼ�","���õǼ�","dispose_Register()",sResourcesPath},
		{"false","","Button","�� ��","������","deal_With()",sResourcesPath},
		{"false","","Button","�������","�������","do_Done()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","export_Excel()",sResourcesPath}	
		};
	if(sDealType.equals("020010"))//�ѵ���������ʲ�
	{
		sButtons[getBtnIdxByName(sButtons,"����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��������Ǽ�")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�� ��")][0]="true";
	}else if(sDealType.equals("020020"))//�������ʲ�
	{
		sButtons[getBtnIdxByName(sButtons,"����")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"��������Ǽ�")][0]="true";
		sButtons[getBtnIdxByName(sButtons,"�������")][0]="true";
	}else if(sDealType.equals("020030"))//�Ѵ����ʲ�
	{
		sButtons[getBtnIdxByName(sButtons,"���õǼ�")][0]="true";
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
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/   
	function deal_With()
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
			sReturn=RunMethod("PublicMethod","GetColValue","AccountSum,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("����е�������Ǽ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):������
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@050,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					//��ѯ��ծ�ʲ��Ƿ�ȫ������
					//sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@040");
					//sReturnInfo=sReturn.split("@")
					//if(sReturnInfo[1] == "0")// 
					//{	
					//	//���²����ʲ������(��ծ�ʲ�������):������
					//	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@040,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);	
					//}
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
		sObjectType = getItemValue(0,getRow(),"ObjectType");//��������
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{	
			//��֤������Ϣ�Ƿ���д
			sReturn=RunMethod("PublicMethod","GetColValue","AccountSum,ASSET_INFO,String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType);
			sReturnInfo=sReturn.split("@")
			if(sReturnInfo[1] == ""  || sReturnInfo[1] == "null") 
			{	
				alert("����е�������Ǽ��ٵ��!");
				return;
			}else
			{
				//��ծ�ʲ���Ϣ):�������
				sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ASSETFLAG@060,ASSET_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{	
					////��ѯ��ծ�ʲ��Ƿ�ȫ������
					//sReturn=RunMethod("PublicMethod","GetColValue","count(*),ASSET_INFO,String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType+"@String@ASSETFLAG@050");
					//sReturnInfo=sReturn.split("@")
					//if(sReturnInfo[1] == "0")// 
					//{	
					//	//���²����ʲ������(��ծ�ʲ�������):�������
					//	sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ManageFlag@050,BADBIZ_APPLY,String@SerialNo@"+sObjectNo);
					//}
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/AccountManage/APDAssetAccountInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_self",""); 
		}
	}
	
	/*~[Describe=���õǼ�;InputParam=��;OutPutParam=��;]~*/    
	function dispose_Register()
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
			popComp("DisposeRegisterList","/RecoveryManage/AccountManage/DisposeRegisterList.jsp","ComponentName=�ʲ����õǼ��б�&ObjectNo="+sSerialNo+"&DealType=<%=sDealType%>","","");
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