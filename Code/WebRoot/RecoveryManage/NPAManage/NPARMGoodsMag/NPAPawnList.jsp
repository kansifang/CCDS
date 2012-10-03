<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006-1-24
		Tester:
		Content: �����ʲ��ĵ�Ѻ����Ϣ�б�
		Input Param:
			ObjectType����������
			ObjectNo��������	
		Output param:
				
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ѻ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql="";
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	//��ȡҳ�����
			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 	
				{"GuarantyID","��Ѻ����"},
				{"GuarantyName","��Ѻ������"},
				{"GuarantyType","��Ѻ������"},
				{"GuarantyTypeName","��Ѻ������"},							
				{"OwnerID","Ȩ���˱��"}, 
				{"OwnerName","Ȩ��������"}, 
				{"OwnerTypeName","Ȩ��������"}, 
				{"GuarantyRightID","Ȩ֤��"},				
				{"InputUserName","�Ǽ���"},
				{"InputOrgName","�Ǽǻ���"},
				{"InputDate","�Ǽ�����"}
			}; 
			
	//�ӵ�������Ϣ���в����ǰ�û��ܻ��Ĳ����ʲ���Ӧ�ĵ�Ѻ����Ϣ
	sSql = 	" select GI.GuarantyID,GI.GuarantyType,GI.GuarantyName,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName, "+
			" GI.OwnerID,GI.OwnerName,GI.OwnerType,getItemName('CustomerType',GI.OwnerType) as OwnerTypeName,GI.GuarantyRightID,"+
			" GI.InputUserID,getUserName(GI.InputUserID) as InputUserName,GI.InputOrgID,getOrgName(GI.InputOrgID) as InputOrgName,GI.InputDate " +
			" from GUARANTY_INFO GI,BUSINESS_CONTRACT BC,GUARANTY_RELATIVE GR  "+ 
			" where GR.ObjectNo = BC.SerialNo "+
			" and GR.ObjectType = '"+sObjectType+"' "+		
			" and GR.ObjectNo = '"+sObjectNo+"' "+						
			" and GI.GuarantyID =  GR.GuarantyID "+			
			" and GI.GuarantyType like '010%' " ;
	//����Sql���ɴ������	
	ASDataObject doTemp = new ASDataObject(sSql);
	//���õ�Ѻ����Ϣ��ͷ
	doTemp.setHeader(sHeaders);	
	doTemp.UpdateTable = "GUARANTY_INFO";	
	doTemp.setKey("GuarantyID",true);	 //���ùؼ���

	//���ù��ø�ʽ
	doTemp.setVisible("GuarantyName,OwnerID,GuarantyID,OwnerType,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setCheckFormat("CostSum","2");	
	//���ö��뷽ʽ
	doTemp.setAlign("CostSum","3");		
	//������ʾ�ı���ĳ���
	doTemp.setHTMLStyle("OwnerName"," style={width:200px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("GuarantyID,OwnerName","IsFilter","1");
	
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
					{"true","","Button","����","�鿴����Ѻ����Ϣ����","viewAndEdit()",sResourcesPath},
					{"true","","Button","��ֵ���","����Ѻ���ֵ���","valueChange()",sResourcesPath},
					{"true","","Button","������Ϣ���","����Ѻ��������Ϣ���","otherChange()",sResourcesPath},
					{"true","","Button","�ʲ������Ϣ","�ʲ������Ϣ","assetWard()",sResourcesPath}
				};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�ʲ������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function assetWard()
	{
		//��������
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectType = "GuarantyInfo";
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else 
		{
			OpenComp("AssetWardList","/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","ObjectNo="+sGuarantyID+"&ObjectType="+sObjectType,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//�������š�������ͬ��
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{		
			OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAPawnInfo.jsp?GuarantyID="+sGuarantyID+"&PawnType="+sGuarantyType,"_self");
		}
	}

	

	/*~[Describe=����Ѻ���ֵ���;InputParam=��;OutPutParam=��;]~*/
	function valueChange()
	{
		//�������š�������ͬ��
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=010&GuarantyID="+sGuarantyID,"_blank",OpenStyle);
			reloadSelf();
		}
																
															
	}

	/*~[Describe=����Ѻ��������Ϣ���;InputParam=��;OutPutParam=��;]~*/
	function otherChange()
	{
		//�������š�������ͬ��
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=020&GuarantyID="+sGuarantyID,"_blank",OpenStyle);
			reloadSelf();
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
	showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
