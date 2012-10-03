<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  hlzhang 2011-10-28
		Tester:
		Content: �޸�ҵ���ͬ����������
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ���ͬ��Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�޸�ҵ���ͬ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String sType="";
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},	
							{"BusinessType","ҵ��Ʒ��"},	
							{"BusinessTypeName","ҵ��Ʒ��"},		
							{"BusinessSum","��Ԫ��"},								
							{"ManageUserName","�Ǽ���"},
							{"ManageOrgName","�Ǽǻ���"},
							}; 
	
	sSql =	" select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSum, "+
			" getUserName(InputUserID) as ManageUserName,getOrgName(InputOrgID) as ManageOrgName "+
			" from BUSINESS_CONTRACT "+
			//" where exists (select 'X' from DATA_MODIFY DM,FLOW_OBJECT FO where DM.SerialNo=FO.ObjectNo and FO.ObjectType='DataModApply' and FO.PhaseNo='1000' and DM.RelativeNo=BUSINESS_CONTRACT.SerialNo) "+
			" where 1=1 ";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "Business_Contract";
	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth","Number");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where IsinUse='1' and ContractDetailNo is not null  order by SortNo");
	doTemp.setVisible("BusinessType",false);
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

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
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","�鿴��ͬ��ʷ��¼","��ʷ��ͬ�޸ļ�¼��Ϣ","HistoryContract()",sResourcesPath},
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","ɾ���˺�ͬ","ɾ����ͬ��Ϣ","deleteContract()",sResourcesPath}
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
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenComp("ContractManageInfo","/SystemManage/SynthesisManage/ContractManageInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"_blank");
	}
	
	
	/*~[Describe=ʹ��OpenComp��ʷ��ͬ�޸ļ�¼��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function HistoryContract()
	{
		sObjectType = "BusinessContract";
		sBCSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{							
			if(confirm("������ȷ������ť��ѡ��һ����ͬ��Ϣ���ߵ����ȡ������ť�ֹ�������Ӻ�ͬ��ˮ�ţ�")){
				return;
			}else{
				sReturn = PopPage("/SystemManage/SynthesisManage/SelectBusinessContract.jsp?","","dialogWidth=20;dialogHeight=7;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if(sReturn != "_CANCEL_"){
					sBCSerialNo = sReturn;
				}else{
					return;
				}
			}	
		}
		OpenComp("HistoryContractList","/SystemManage/SynthesisManage/HistoryContractList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sBCSerialNo,"_blank");	
	}
	
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteContract()
	{
		//��ú�ͬ���͡���ͬ��ˮ��
		sObjectNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
			
			//��ý�ݱ��
        	var sColName = "SerialNo";
			var sTableName = "BUSINESS_DUEBILL";
			var sWhereClause = "String@RelativeSerialNo2@"+sObjectNo;
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("�Բ��𣬸ú�ͬ�����Ľ����Ϣ["+sReturn+"]��δ����ָ����ͬ������ɾ���˺�ͬ��");
				return;
			}
			
			if(confirm("��ȷ���Ѿ�����ú�ͬ�����Ľ����Ϣ����ָ����ͬ����"))
			{
				//ҵ������ʱ����ǰ��ͬ��¼���뵽BC_B���ݱ���
				sBCBSerialNo = initSerialNo();
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",BusinessContract");
				if(sReturn == 1){
					as_del("myiframe0");
					as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				}else{
					alert("ɾ������ʧ�ܣ�");
					return;
				}
			}
		}
	}
	
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT_BAK";//����
		var sColumnName = "BCSerialNo";//�ֶ���
		var sPrefix = "BCB";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sBCBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//����ˮ�ŷ���
		return sBCBSerialNo;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
