<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-2
		Tester:
		Content: ����ʲ��б�
		Input Param:
				ObjectType����������
				ObjectNo��������
				CurItemID����Ŀ���
		Output param:
				
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	String sItemID = "";  
	String sWhereCondition = "";
	
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sCurItemID == null) sCurItemID = "";
	
	if(sCurItemID.equals("075010")) //δ�˳������ʲ�
		sItemID="020";
	else if(sCurItemID.equals("075020")) //���˳������ʲ�
		sItemID="030";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"LawCaseName","��������"},
							{"SerialNo","����ʲ����"},				
							{"AssetName","����ʲ�����"},
							{"AssetTypeName","����ʲ����"},
							{"LandownerNo","����ʲ�����"},
							{"AssetSum","����ʲ��ܶ�(Ԫ)"},
							{"PropertyOrg","����ʲ�������"},
							{"BeginDate","�������"}, 
							{"EndDate","��⵽����"}, 
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						}; 
	
	if(sItemID.equals("020"))
	{
		sWhereCondition = " and AI.AssetStatus = '01' order by InputDate desc ";  //δ�˳������ʲ�
	}
	
	if(sItemID.equals("030"))
	{
		sWhereCondition = " and AI.AssetStatus = '02' order by InputDate desc ";  //���˳������ʲ�
	}
	
	//���ʲ���Ϣ���в����ǰ�û��ܻ��Ĳ���ʲ���Ϣ		
	sSql =  " select LI.LawCaseName,AI.SerialNo,AI.ObjectType, "+
			" AI.AssetName,AI.AssetType,getItemName('LawsuitAssetsType',AI.AssetType) as AssetTypeName,"+
			" AI.LandownerNo,AI.AssetSum,AI.PropertyOrg,AI.BeginDate,AI.EndDate, "+
			" AI.InputUserID,getUserName(AI.InputUserID) as InputUserName,AI.InputOrgID,"+
			" getOrgName(AI.InputOrgID) as InputOrgName,AI.InputDate " +
			" from LAWCASE_RELATIVE LR,ASSET_INFO AI,LAWCASE_INFO LI " +
			" where LR.ObjectType = '"+sObjectType+"' "+
			" and LR.ObjectNo = '"+sObjectNo+"' "+
			" and AI.AssetAttribute = '02' "+		//�ʲ�����Ϊ����ʲ�
			" and AI.ObjectNo = LR.SerialNo "+	//������
			" and LI.SerialNo = AI.ObjectNo "+
			" and AI.ObjectType ='LawcaseInfo' " + sWhereCondition;
			
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���

	//���ù��ø�ʽ
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,AssetAttribute,AssetType,InputUserID,InputOrgID",false);
	//���ý��Ϊ��λһ������
	doTemp.setType("AssetSum","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("AssetSum","2");	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("AssetSum","3");
		
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("AssetName"," style={width:120px} ");
	doTemp.setHTMLStyle("AssetTypeName,BeginDate,EndDate,InputUserName,InputDate"," style={width:80px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	
	//����HTMLDataWindow
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
			{"true","","Button","����","�鿴����","viewAndEdit()",sResourcesPath},
			{"true","","Button","�˳����","�˳�����ʲ���Ϣ","quitRecord()",sResourcesPath}
			};
			
		if(sItemID.equals("030"))
		{
			sButtons[1][0] = "false";
		}
	
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ü�¼��ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sItemID=="030")
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
		else
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
	
	}
	
	/*~[Describe=�˳����;InputParam=��;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//��ü�¼��ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //�ò���ʲ����Ҫ�˳������
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //ˢ��ҳ��
			{
				alert(getBusinessMessage("775"));//�ò���ʲ��ѳɹ��˳���⣡
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //�ò���ʲ��˳����ʧ�ܣ�
				return;
			}
		}
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
		
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
