<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: ������ͬ��ʷ��¼�б�
		Input Param:
				ObjectType���������ͣ���
				ObjectNo: �����ţ���ͬ��ˮ�ţ�
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ��ʷ��¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"GCBSerialNo","������ͬ�޸���ˮ��"},
							{"SerialNo","������ͬ���"},
							{"GuarantyTypeName","������ʽ"},							
							{"GuarantorName","����������"},
							{"GuarantyValue","�������"},				            
							{"GuarantyCurrency","����"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"ModifyUserName","�޸���"},
							{"ModifyOrgName","�޸Ļ���"}
						  };

	sSql =  " select GC.GCBSerialNo,GC.SerialNo,GC.CustomerID,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName,Channel, "+
			" ModifyUserID,getUserName(ModifyUserID) as ModifyUserName, "+
			" ModifyOrgID,getOrgName(ModifyOrgID) as ModifyOrgName "+
			" from GUARANTY_CONTRACT_BAK GC "+
			" where SerialNo = '"+sObjectNo+"' "+
			" Order by GCBSerialNo Desc ";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT_BAK";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID,Channel,ModifyUserID,ModifyOrgID",false);
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
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
		sObjectNo = getItemValue(0,getRow(),"GCBSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//OpenComp("HistoryGuarantyContractInfo","/SystemManage/SynthesisManage/HistoryGuarantyContractInfo.jsp","GuarantyType="+sGuarantyType+"&SerialNo="+sObjectNo,"_blank");
		OpenPage("/SystemManage/SynthesisManage/HistoryGuarantyContractInfo.jsp?GuarantyType="+sGuarantyType+"&SerialNo="+sObjectNo, "_self","");
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