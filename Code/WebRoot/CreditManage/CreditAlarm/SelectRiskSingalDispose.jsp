<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong  2012/06/19
		Tester:
		Describe: Ԥ������ѡ���б�
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ������ѡ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "Ԥ������ѡ���б�";//--��ͷ
	String sCustomerType =""; //�ͻ����� 1Ϊ��˾�ͻ� 2Ϊͬҵ�ͻ� 3Ϊ���˿ͻ� 4Ϊ���ù�ͬ��
	String sActionFlag = "";//������ʶ02�����
	//����������	
	
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","Ԥ���ź���ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"SignalType","Ԥ������"},
							{"SignalLevel","Ԥ������"},	
							{"SignalStatus","Ԥ��״̬"},
							{"CustomerOpenBalance","���ڽ��"},									
							{"OperateUserName","�Ǽ���"},
							{"OperateOrgName","�Ǽǻ���"},
							}; 
						
		sSql =	" select RS.SerialNo as SerialNo,"+
				" GetCustomerName(RS.ObjectNo) as CustomerName,"+
				" getItemName('SignalType',RS.SignalType) as SignalType,"+
				" getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
				" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
				" RS.CustomerOpenBalance as CustomerOpenBalance,"+
				" getUserName(RS.InputUserID) as OperateUserName,"+
				" getOrgName(RS.InputOrgID) as OperateOrgName "+
			" from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			" where  FO.ObjectType =  'RiskSignalApply' "+
				" and  FO.ObjectNo = RS.SerialNo and FO.PhaseType='1040' "+
				" and FO.ApplyType='RiskSignalApply' and RS.SignalType='01' "+
				" and RS.SerialNo not in(select RS1.SerialNo from RISK_SIGNAL RS1,INSPECT_INFO II where II.ObjectNo=RS1.SerialNo  and II.ObjectType='RiskSignalDispose' and ( II.FinishDate ='' or II.FinishDate is null))"+
				" and not exists(select 1 from RISK_SIGNAL RS1 where RS1.RelativeSerialNo=RS.SerialNo and SignalType='02' and SignalStatus='30')"+
				" and RS.InputOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	//�ͻ��������Լ���Ԥ�� 080,280,2A5,2D3,2J4,480
	if(CurUser.hasRole("080")||CurUser.hasRole("280")||CurUser.hasRole("2A5")
		||CurUser.hasRole("2D3")||CurUser.hasRole("2J4")||CurUser.hasRole("480"))
	{
		sSql = sSql+" and RS.InputUserID='"+CurUser.UserID+"' ";
	}
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RISK_SIGNAL";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("OperateOrgName","style={width:250px} ");
	doTemp.setHTMLStyle("SignalType,SignalLevel,SignalStatus","style={width:60px} "); 	
	//���ö��뷽ʽ
	doTemp.setAlign("CustomerOpenBalance","3");
	doTemp.setType("CustomerOpenBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	

	//���ɲ�ѯ��
	//doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateUserName","");
	doTemp.setFilter(Sqlca,"4","OperateOrgName","");
	
	doTemp.parseFilterData(request,iPostChange);
	
	//if("2".equals(sActionFlag))
	//{
	//	if(!doTemp.haveReceivedFilterCriteria())  doTemp.WhereClause+=" and 1=2";
	//}
		
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
			{"true","","Button","ȷ��","ȷ��","doReturn()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	function doReturn(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			self.returnValue=sSerialNo;//���ز���
			self.close();
		}
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
