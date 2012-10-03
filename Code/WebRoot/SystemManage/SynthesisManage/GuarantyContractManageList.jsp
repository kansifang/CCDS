<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: ������ͬ�޸��б�
		Input Param:
				ObjectType���������ͣ�BusinessContract��
				ObjectNo: �����ţ���ͬ��ˮ�ţ�
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ�޸��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","������ͬ���"},
							{"GuarantyTypeName","������ʽ"},							
							{"GuarantorName","����������"},
							{"GuarantyValue","�������"},				            
							{"GuarantyCurrency","����"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	sSql =  " select GC.SerialNo,GC.CustomerID,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName,Channel "+
			" from GUARANTY_CONTRACT GC "+
			//" where exists (select 'X' from DATA_MODIFY DM,FLOW_OBJECT FO,CONTRACT_RELATIVE CR where CR.SerialNo=DM.RelativeNo and CR.ObjectNo=GC.SerialNo and CR.ObjectType='GuarantyContract' and  DM.SerialNo=FO.ObjectNo and FO.ObjectType='DataModApply' and FO.PhaseNo='1000') "+
			" where 1=1 ";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID,Channel",false);
	doTemp.setUpdateable("",false);doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//���ø�ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","GuarantorName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(16);  //��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		OpenComp("GuarantyContractManageInfo","/SystemManage/SynthesisManage/GuarantyContractManageInfo.jsp","GuarantyType="+sGuarantyType+"&SerialNo="+sObjectNo,"_blank");
	}
	
	
	/*~[Describe=ʹ��OpenComp��ʷ��ͬ�޸ļ�¼��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function HistoryContract()
	{
		GuarantyType = getItemValue(0,getRow(),"GuarantyType");
		sBCSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{							
			if(confirm("������ȷ������ť��ѡ��һ����ͬ��Ϣ���ߵ����ȡ������ť�ֹ����뵣����ͬ��ˮ�ţ�")){
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
		OpenComp("HistoryGuarantyContractList","/SystemManage/SynthesisManage/HistoryGuarantyContractList.jsp","ObjectType="+GuarantyType+"&ObjectNo="+sBCSerialNo,"_blank");	
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
						
			if(confirm("��ȷ��ɾ�����ʵ�����ͬ��"))
			{
				//ҵ������ʱ����ǰ��ͬ��¼���뵽BC_B���ݱ���
				sBCBSerialNo = initSerialNo();
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",GuarantyContract");
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
		var sTableName = "GUARANTY_CONTRACT_BAK";//����
		var sColumnName = "GCBSerialNo";//�ֶ���
		var sPrefix = "GCB";//ǰ׺
       
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