<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: xhyong 2009/10/20
*	Tester:
*	Describe: ��ծ�ʲ���Ϣ��ʾ�б�
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
	String PG_TITLE = "��ծ�ʲ���Ϣ��ʾ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));
	if(sAlarmType == null) sAlarmType="";
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
	if(sAlarmType.equals("010140"))//̨����Ϣδά��
	{
		sSql+=" and BA.ManageFlag='030' "+
				" and (AI.VindicateDate is  null or AI.VindicateDate ='' or "+
				" days(replace(AI.VindicateDate,'/','-'))<=days(current date)-20)";
	}if(sAlarmType.equals("010150"))//�̵�δ���
	{
		sSql+=" and BA.ManageFlag='030' "+
				" and (AI.LiquidateDate is  null or AI.LiquidateDate ='' or "+
				" days(replace(AI.LiquidateDate,'/','-'))<=days(current date)-20)";
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
		{"true","","Button","��ծ����","��ծ����","viewTab()",sResourcesPath},
		};

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