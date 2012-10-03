<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ����ʲ��б�
		Input Param:
				SerialNo:�������
				BookType��̨������				      
		Output param:
				SerialNo������ʲ����
				AssetType������ʲ�����
				ObjectNo:�����Ż򰸼����
				ObjectType:��������
		History Log: zywei 2005/09/06 �ؼ����
		                  
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
		
	//������������������ˮ�š�̨�����ͣ�	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sBookType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BookType"));
	//����ֵת��Ϊ���ַ���
	if(sBookType == null) sBookType = "";
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectNo","�������"},
							{"LawCaseName","��������"},
							{"SerialNo","����ʲ����"},				
							{"AssetName","����ʲ�����"},
							{"AssetTypeName","����ʲ����"},
							{"LandownerNo","����ʲ�����"},
							{"Currency","����ʲ�����"},
							{"AssetSum","����ʲ��ܶ�"},
							{"PropertyOrg","����ʲ�������"},
							{"BeginDate","�������"}, 
							{"EndDate","��⵽����"},
							{"AssetOrgName","������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},				
							{"InputDate","�Ǽ�����"}
						}; 
	
	//���ʲ���Ϣ���в��������Ӧ�Ĳ���ʲ���Ϣ
	sSql = " select AI.ObjectNo,LI.LawCaseName,AI.SerialNo,AI.ObjectType,AI.AssetName, "+
		   " AI.AssetType,getItemName('LawsuitAssetsType',AI.AssetType) as AssetTypeName,"+
		   " AI.LandownerNo,getItemName('Currency',AI.Currency) as Currency,AI.AssetSum,AI.PropertyOrg,AI.BeginDate,AI.EndDate, "+
		   " AI.AssetOrgID,getOrgName(AI.AssetOrgID) as AssetOrgName,"+
		   " AI.InputUserID,getUserName(AI.InputUserID) as InputUserName,AI.InputOrgID, "+
		   " getOrgName(AI.InputOrgID) as InputOrgName,AI.InputDate " +
		   " from ASSET_INFO AI,LAWCASE_INFO LI " +
		   " where AI.ObjectNo='"+sSerialNo+"' "+	//������Ż������
		   " and AI.AssetAttribute='02' "+		//�ʲ�����Ϊ����ʲ�
		   " and LI.SerialNo = AI.ObjectNo "+
		   " and AI.ObjectType='LawcaseInfo' "+
		   " order by InputDate desc";	//��������
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";	
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);	 //���ùؼ���

	//���ù��ø�ʽ
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo,AssetAttribute,AssetType,InputUserID,InputOrgID,AssetOrgID",false);
	//���ý��Ϊ��λһ������
	doTemp.setType("AssetSum","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("AssetSum","2");
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
	doTemp.setAlign("AssetSum","3");
		
	//����ѡ��˫�����п�
	doTemp.setHTMLStyle("AssetName"," style={width:120px} ");
	doTemp.setHTMLStyle("AssetTypeName"," style={width:80px} ");	
	doTemp.setHTMLStyle("BeginDate,EndDate"," style={width:80px} ");	
	doTemp.setHTMLStyle("InputUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
			};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{			
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?BookType=<%=sBookType%>&ObjectNo=<%=sSerialNo%>&ObjectType=LawcaseInfo&SerialNo=","right","");  
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ü�¼��ˮ�š�������Ż�����š��������͡�����ʲ�����
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sObjectNo=getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		var sLawsuitAssetsType=getItemValue(0,getRow(),"AssetType");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawsuitAssetsInfo.jsp?PageSerialNo="+sSerialNo+"&BookType=<%=sBookType%>&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"","right","");

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
