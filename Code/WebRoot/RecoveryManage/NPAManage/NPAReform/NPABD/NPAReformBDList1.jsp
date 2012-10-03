<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*   
		Author:   hxli 2005.8.11
		Tester:
		Content: ���鷽���б�
		Input Param:
				���в�����Ϊ�����������
				ComponentName	������ƣ������е����鷽���б�			          
		Output param:
				SerialNo   : �����������к�
				
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���鷽���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	String sComponentName = "";
	String PG_CONTENT_TITLE = "";
	
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//������ʾ����
	String sHeaders[][] = { 							
								{"SerialNo","���鷽����ˮ��"},
								{"ApplyType","�����������"},
								{"ApplyTypeName","�����������"},
								{"ProjectName","����������"},
								{"BusinessSum","�����鱾��"},
								{"PaymentDate","����������"},
								{"InputUserName","�Ǽ���"},
								{"InputOrgName","�Ǽǻ���"},
								{"InputDate","�Ǽ�����"}
							}; 
	
	//��������Ϣ��BUSINESS_APPLY��ѡ�����鷽���б�(������Ϊ��ǰ�û����������Ϊ��ǰ������ҵ��Ʒ��Ϊ6010)
	sSql =  " select SerialNo,ApplyType,"+
			" getItemName('ReformType',ApplyType) as ApplyTypeName,ProjectName," +	
			" BusinessSum,PaymentDate, " +	
			" getUserName(InputUserID) as InputUserName,getOrgName(InputOrgID) as InputOrgName,InputDate" +	
			" from BUSINESS_APPLY  " +
			" where  OperateUserID = '"+CurUser.UserID+"' " +
			" and  OperateOrgID = '"+CurOrg.OrgID+"' " +
			" and BusinessType = '6010' "+
			" order by SerialNo desc " ;
			
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_APPLY";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("ApplyType,FlowNo,PhaseNo",false);
	//����������
	doTemp.setDDDWCode("ApplyType","ReformType");
	//�����ֶ���ʾ���
	doTemp.setHTMLStyle("ApplyTypeName,ProjectName,BusinessSum,PaymentDate"," style={width:100px} ");
	doTemp.setHTMLStyle("PaymentDate,"," style={width:80px} ");
	doTemp.setHTMLStyle("ProjectName,"," style={width:120px} ");
	doTemp.setUpdateable("ApplyTypeName",false); 
	
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum","3");
	doTemp.setType("BusinessSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("ApplyType,ProjectName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ
	
	//ɾ�����鷽��������Ϣ
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(NPAReformApply,#SerialNo,DeleteBusiness)");
	
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
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
		sCompID = "NPAReformApply";
		sCompURL = "/RecoveryManage/RMApply/NPAReformCreationInfo.jsp";			
		sReturn = PopComp(sCompID,sCompURL,"","dialogWidth=30;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sReturn == "" || sReturn == "_CANCEL_" || typeof(sReturn) == "undefined") return;
		var sObjectNo = sReturn;  //������
		openObject("NPAReformApply",sObjectNo,"001");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,APPLY_RELATIVE,String@ObjectType@NPARefromApply@String@ObjectNo@"+sSerialNo);
			if (typeof(sReturn) != "undefined" && sReturn.length != 0)
			{
				alert("�����鷽���Ѿ�������ҵ�����˹�����ϵ������ɾ����");  
				return;
			}else
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//������ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		openObject("NPAReformApply",sSerialNo,"001");
		reloadSelf();
	}	
	
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
