<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong  2012/02/21
		Tester:
		Describe: Ԥ�������б�
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "Ԥ�������б�";//--��ͷ
	String sCustomerType =""; //�ͻ����� 1Ϊ��˾�ͻ� 2Ϊͬҵ�ͻ� 3Ϊ���˿ͻ� 4Ϊ���ù�ͬ��
	String sActionFlag = "";//������ʶ02�����
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����
	sActionFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ActionFlag"));	//���ҳ�����
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
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
							{"FinishDate","��������"}
							}; 
						
		sSql =	" select RS.SerialNo as SerialNo,II.SerialNo as IISerialNo,"+
				" GetCustomerName(RS.ObjectNo) as CustomerName,"+
				" getItemName('SignalType',RS.SignalType) as SignalType,"+
				" getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
				" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
				" RS.CustomerOpenBalance as CustomerOpenBalance,"+
				" getUserName(RS.InputUserID) as OperateUserName,"+
				" getOrgName(RS.InputOrgID) as OperateOrgName,II.FinishDate "+
			" from FLOW_OBJECT FO,RISK_SIGNAL RS,INSPECT_INFO II "+
			" where  FO.ObjectType =  'RiskSignalApply' "+
				" and  FO.ObjectNo = RS.SerialNo "+
				" and II.ObjectType='RiskSignalDispose' "+
				" and II.ObjectNo=RS.SerialNo "+
				" and FO.PhaseType='1040' "+
				" and FO.ApplyType='RiskSignalApply' and RS.SignalType='01' "+
				//" and not exists(select 1 from RISK_SIGNAL RS1 where RS1.RelativeSerialNo=RS.SerialNo and SignalType='02' and SignalStatus='30')"+
				" and RS.InputOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
	if(CurUser.hasRole("08A")||CurUser.hasRole("0J0")) sSql +="and RS.InputUserID in (select userid from user_role where roleid='080')";
	if(CurUser.hasRole("2A1")) sSql +="and RS.InputUserID in (select userid from user_role where roleid='2A5')";
	if(CurUser.hasRole("2D1")) sSql +="and RS.InputUserID in (select userid from user_role where roleid='2D3')";
	if("2".equals(sActionFlag))
	{
		sSql = sSql+" and II.FinishDate is not null and II.FinishDate<>'' ";
	}else{
		sSql = sSql+" and ( II.FinishDate ='' or II.FinishDate is null) ";
	}
	//�ͻ��������Լ���Ԥ�� 080,280,2A5,2D3,2J4,480
	if(CurUser.hasRole("080")||CurUser.hasRole("280")||CurUser.hasRole("2A5")
		||CurUser.hasRole("2D3")||CurUser.hasRole("2J4")||CurUser.hasRole("480"))
	{
		sSql = sSql+" and RS.InputUserID='"+CurUser.UserID+"' ";
	}
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "INSPECT_INFO";	
	//���ùؼ���
	doTemp.setKey("IISerialNo",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("OperateOrgName","style={width:250px} ");
	doTemp.setHTMLStyle("SignalType,SignalLevel,SignalStatus","style={width:60px} "); 	
	//���ö��뷽ʽ
	doTemp.setAlign("CustomerOpenBalance","3");
	doTemp.setType("CustomerOpenBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	doTemp.setVisible("IISerialNo",false);
	

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
		{"2".equals(sActionFlag)?"false":"true","","Button","�������ñ���","�������ñ���","newReport()",sResourcesPath},
		{"true","","Button","�鿴Ԥ�����ñ���","�鿴Ԥ�����ñ���","viewDisposeReport()",sResourcesPath},
		{"true","","Button","Ԥ������","�鿴Ԥ������","viewAndEdit()",sResourcesPath},
		{"2".equals(sActionFlag)?"false":"true","","Button","ɾ��","�鿴Ԥ������","deleteRecord()",sResourcesPath},
		{"2".equals(sActionFlag)?"false":"true","","Button","��ɴ���","��ɴ���","doneDispose()",sResourcesPath},
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��дԤ�����ñ���;InputParam=��;OutPutParam=��;]~*/
	function newReport()
	{
		var sObjectNo = popComp("SelectRiskSingalDispose","/CreditManage/CreditAlarm/SelectRiskSingalDispose.jsp","","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sObjectType = "RiskSignalDispose";
		if(sObjectNo == "" || sObjectNo == "_CANCEL_" || sObjectNo == "_NONE_" || sObjectNo == "_CLEAR_" || typeof(sObjectNo) == "undefined")
			return;
		else{
			
			sSerialNo = PopPage("/CreditManage/CreditCheck/AddInspectAction.jsp?ObjectNo="+sObjectNo+"&InspectType=RiskSignalDispose","","");
			sCompID = "PurposeInspectTab";
			sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);	
		}
		reloadSelf();				
	}
	
	 /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			
		}	
		
	}
	
	/*~[Describe=�鿴Ԥ�����ñ���;InputParam=��;OutPutParam=��;]~*/
	function viewDisposeReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = "RiskSignalDispose";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sIISerialNo =  getItemValue(0,getRow(),"IISerialNo");
	    
	    if (typeof(sIISerialNo)!="undefined" && sIISerialNo.length!=0 && sIISerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sIISerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=<%="2".equals(sActionFlag)?"true":"false"%>";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}	
	}
    
    /*~[Describe=��ɴ���;InputParam=��;OutPutParam=��;]~*/
	function doneDispose()
	{
		sIISerialNo = getItemValue(0,getRow(),"IISerialNo");		
		if (typeof(sIISerialNo)=="undefined" || sIISerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm("ȷ����ɴ�����?")) //
		{
			//�ύ����
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,INSPECT_INFO,String@SerialNo@"+sIISerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert("����ʧ��!");
				return;
			}else
			{
				reloadSelf();
				alert("�����ɹ�!");
			}				
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
