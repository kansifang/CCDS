
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2005/08/28
		Tester:
		Content: ��Ȩ���б�ҳ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	String sPolicyID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PolicyID"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	//����ֵת��Ϊ���ַ���
	if(sPolicyID == null) sPolicyID = "";
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {														
							{"PolicyName","��Ȩ����"},
							{"FlowName","����"},
							{"PhaseName","�׶�"},							
							{"OrgName","����"},
							{"ProductName","��Ʒ"},
							{"GuarantyTypeName","������ʽ"},							
							{"CustBalanceCeiling","�������������Ȩ���ޣ�Ԫ��"},
							{"CustExposureCeilin","��������������Ȩ���ޣ�Ԫ��"},
							{"BizBalanceCeiling","�������ʽ�����ޣ�Ԫ��"},
							{"BizExposureCeiling","�������ʳ�����Ȩ���ޣ�Ԫ��"},
							{"InterestRateFloor","�����������ޣ�����"},
							{"EffDate","��������"},
							{"EffStatus","��Ч״̬"}
						  };
						  
	sSql =  " select AuthID,PolicyID,SortNo,getPolicyName(PolicyID) as PolicyName, "+
			" getFlowName(FlowNo) as FlowName,getPhaseName(FlowNo,PhaseNo) as PhaseName, "+
			" GetOrgName(OrgID) as OrgName,getBusinessName(ProductID) as ProductName, "+
			" getItemName('VouchType',GuarantyType) as GuarantyTypeName,CustBalanceCeiling, "+
			" CustExposureCeilin,BizBalanceCeiling,BizExposureCeiling,InterestRateFloor, "+
			" EffDate,getItemName('YesNo',EffStatus) as EffStatus "+
			" from AA_AUTHPOINT "+
			" Where PolicyID = '"+sPolicyID+"' "+
			" and FlowNo='"+sFlowNo+"' "+
			" and PhaseNo='"+sPhaseNo+"' "+
			" order by SortNo";	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "AA_AUTHPOINT";
	doTemp.setKey("AuthID,PolicyID",true);
	doTemp.setHeader(sHeaders);
	//���ò��ɼ�	
	doTemp.setVisible("AuthID,PolicyID,SortNo",false);
	//���������������ʽ
	doTemp.setAlign("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","3");
	doTemp.setType("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin,InterestRateFloor","Number");
	doTemp.setCheckFormat("BizBalanceCeiling,BizExposureCeiling,CustBalanceCeiling,CustExposureCeilin","2");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style = "1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		PopComp("NewAuthPoint","/Common/Configurator/AAManage/AuthPointSettingInfo.jsp","PolicyID=<%=sPolicyID%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>","","");	
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		//��Ȩ��ID   
	    sAuthID = getItemValue(0,getRow(),"AuthID");			
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			sReturn=RunMethod("PublicMethod","GetColValue","ExceptionID,AA_EXCEPTION,String@AuthID@"+sAuthID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("��ѡ��Ȩ���ѱ�ĳЩ�����������ã�����ɾ����");
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��Ȩ��ID  
		sAuthID = getItemValue(0,getRow(),"AuthID");
		if (typeof(sAuthID) == "undefined" || sAuthID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		PopComp("AuthPointEdit","/Common/Configurator/AAManage/AuthPointSettingInfo.jsp","PolicyID=<%=sPolicyID%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&AuthID="+sAuthID,"","");
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
	hideFilterArea();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
