<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zrli 2008-08-27
		Tester:
		Content: ��ʾ�������ӿ����ɵ���ʾ����
		Input Param:			
			Days��	   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ӿ����ɵ���ʾ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
		
	//����������		
	String sAlarmType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AlarmType"));	
	//����ֵת��Ϊ���ַ���	
	if(sAlarmType == null) sAlarmType = "";	
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//�б��ͷ
	String sHeaders[][] = {
							{"ObjectNo","������"},
							{"ObjectType","��������"},
							{"SerialNo","��ʾ��ˮ��"},													
							{"AlarmType","��ʾ����"},
							{"Status","״̬"},
							{"Channel","����"},
							{"Attribute2","���Զ�"},
							{"Attribute3","������"},
							{"Remark","��ע"},
							{"InputUserID","�Ǽ���"},												
							{"InputOrgID","�Ǽǻ���"},
							{"InputTime","�Ǽ�ʱ��"},
							{"UpdateUserID","������"},
							{"UpdateTime","����ʱ��"}
						};
	sSql = 	" select ObjectNo,ObjectType, "+
			" SerialNo, "+
			" AlarmType,Status, "+
			" Channel,Attribute2,Attribute3, "+
			" Remark,getUserName(InputUserID) as InputUserID,InputOrgID,InputTime,UpdateUserID,UpdateTime"+
			" from Alarm_Generate " + 
			" where AlarmType='"+sAlarmType+"' and Status = '010' "+
			" and InputOrgID = '"+CurOrg.OrgID+"' ";
	//����½�30%����Ԥ��
	String sHeaders1[][] = {
							{"ObjectNo","�ͻ����"},
							{"ObjectType","��������"},
							{"SerialNo","��ʾ��ˮ��"},													
							{"AlarmType","��ʾ����"},
							{"Status","״̬"},
							{"Channel","����"},
							{"Attribute2","���Զ�"},
							{"Attribute3","������"},
							{"Remark","��ע"},
							{"InputUserID","�Ǽ���"},												
							{"InputOrgID","��ʾ�Ǽǻ���"},
							{"InputTime","��ʾ�Ǽ�ʱ��"},
							{"UpdateUserID","������"},
							{"UpdateTime","����ʱ��"}
						};
	String sSql1 = 	" select ObjectNo,ObjectType, "+
			" SerialNo, "+
			" AlarmType,Status, "+
			" Channel,Attribute2,Attribute3, "+
			" Remark,getUserName(InputUserID) as InputUserID,InputOrgID,InputTime,UpdateUserID,UpdateTime"+
			" from Alarm_Generate " + 
			" where AlarmType='"+sAlarmType+"' and Status = '010' "+
			" and InputOrgID = '"+CurOrg.OrgID+"' ";
		
									
     //��Ѻ��
	if(sAlarmType.equals("170")){
		sSql=sSql1;
		sHeaders=sHeaders1;
	//�浥
	}else  if(sAlarmType.equals("020")){
		sSql=sSql1;
		sHeaders=sHeaders1;  
	//Ӫҵִ��
	}
					
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "Alarm_Generate";
	doTemp.setKey("SerialNo",true);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
	
	//���ø�ʽ
	doTemp.setVisible("ObjectType,SerialNo,AlarmType,Status,Attribute2,Attribute3,Remark,InputOrgID,UpdateUserID,UpdateTime",false);
	
	//���ù�����
	doTemp.setColumnAttribute("ObjectNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
			{"true","","Button","���ҵ������","���ҵ������","viewDetail()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ʾ","deleteRecord()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------	
	/*~[Describe=���ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewDetail()
	{
		sAlarmType="<%=sAlarmType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");	
		sAttribute2 = getItemValue(0,getRow(),"Attribute2");
		sAttribute3 = getItemValue(0,getRow(),"Attribute3");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//����ǵ�Ѻ����Ϣ
		if(sAlarmType=='010'){
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=02&GuarantyID="+sObjectNo+"&PawnType="+sAttribute2,"_self");
		}else if(sAlarmType=='020'){
			OpenPage("/CreditManage/GuarantyManage/ImpawnInfo.jsp?GuarantyStatus=02&GuarantyID="+sObjectNo+"&ImpawnType="+sAttribute2,"_self");
		}else if(sAlarmType=='030'){
			openObject("Customer",sObjectNo,"002");
		}else if(sAlarmType=='040'){
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sObjectNo,"_self","");
		}else if(sAlarmType=='050'){			
			openObject("LawCase",sObjectNo,"002");
		}else if(sAlarmType=='060'){			
			openObject("LawCase",sObjectNo,"002");
		}else if(sAlarmType=='070'||sAlarmType=='080'){			
			openObject("BusinessContract",sObjectNo,"002");
		}
		
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{	
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
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
