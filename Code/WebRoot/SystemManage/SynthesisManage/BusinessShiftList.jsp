<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ������ҵ��ת��Ȩ�б����
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ҵ��ת��Ȩ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%		
	//�������
	String sSql;
	ASResultSet rs = null;
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sHeaders[][] = {
								{"Status","�Ƿ�ת��Ȩ"},
								{"SerialNo","������ˮ��"},
								{"ObjectTypeName","��������"},
								{"ObjectNo","������"},
								{"OrgName","��������"},
								{"UserName","�û�����"},		
								{"FlowName","����"},								
								{"PhaseName","��ǰ�׶�"},
								{"BeginTime","��ʼ����"}	
				            };
		
	 sSql = " Select '  ' as Status ,getObjectName(ObjectType) as ObjectTypeName,ObjectType,SerialNo, "+
	 		" ObjectNo,OrgID,OrgName,UserID,UserName,FlowNo,FlowName,PhaseNo,PhaseName,BeginTime "+
			" from FLOW_TASK where  OrgID In (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')"+
		    " and (EndTime is null or EndTime = '') and PhaseNo not in('0010','3000','1000','8000') ";  

	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	
	doTemp.setAlign("Status","2");
	//�����ֶβ��ɼ�
	doTemp.setVisible("ObjectType,OrgID,UserID,FlowNo,PhaseNo",false);
	//�����ֶ���ʾ���	
	doTemp.setHTMLStyle("Status","style={width:80px}  ondblclick=\"javascript:parent.onDBClickStatus()\"");
		
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����ΪGrid���
	dwTemp.Style="1";
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","�鿴ҵ������","�鿴ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ת��Ȩ","������ҵ��ת��Ȩ��Ϣ","transferTask()",sResourcesPath}	,
		   {"true","","PlainText","(˫�����ѡ��/ȡ�� �Ƿ�ת��Ȩ)","(˫�����ѡ���ȡ�� �Ƿ�ת��Ȩ)","style={color:red}",sResourcesPath}			
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//����Ƿ������ѡ�еļ�¼
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		//��ȡ�������ͺͶ�����
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		OpenObject(sObjectType,sObjectNo,"002");		
	}
	
	/*~[Describe=������ҵ��ת��Ȩ;InputParam=��;OutPutParam=��;]~*/	
	function transferTask()
    {    	
    	//����Ƿ������ѡ�еļ�¼
    	var j = 0;
		var a = getRowCount(0);
		for(var i = 0 ; i < a ; i++)
		{				
			var sStatus = getItemValue(0,i,"Status");
			if(sStatus == "��")
				j=j+1;
		}
		if(j <= 0)
		{
			alert(getBusinessMessage('918'));//��ѡ�������ҵ��
			return;
		}
    	if (confirm(getBusinessMessage('920')))//ȷ��ת�Ƹô�����ҵ����
    	{				
			var sSerialNo = "";			
			var sFromOrgID = "";
			var sFromOrgName = "";
			var sFromUserID = "";
			var sFromUserName = "";
			var sToUserID = "";
			var sToUserName = "";
			//��ȡ��ǰ����
			var sOrgID = "<%=CurOrg.OrgID%>";
			var sParaString = "BelongOrg"+","+sOrgID
			sUserInfo = setObjectValue("SelectUserBelongOrg",sParaString,"",0);	
		    if (sUserInfo == "" || sUserInfo == "_CANCEL_" || sUserInfo == "_NONE_" || sUserInfo == "_CLEAR_" || typeof(sUserInfo) == "undefined") 
		    {
			    alert(getBusinessMessage('921'));//��ѡ��ת��Ȩ����û���
			    return;
		    }else
		    {
			    sUserInfo = sUserInfo.split('@');
			    sToUserID = sUserInfo[0];
			    sToUserName = sUserInfo[1];			    
		   
				//���ж��Ƿ�������һ����ͬ��ѡ���������ˡ����е��ҳ���
				var b = getRowCount(0);				
				for(var i = 0 ; i < b ; i++)
				{
	
					var a = getItemValue(0,i,"Status");
					if(a == "��")
					{
						sSerialNo = getItemValue(0,i,"SerialNo");	
						sFromOrgID = getItemValue(0,i,"OrgID");
						sFromOrgName = getItemValue(0,i,"OrgName");
						sFromUserID = getItemValue(0,i,"UserID");
						sFromUserName = getItemValue(0,i,"UserName");	
						if(sFromUserID == sToUserID)
						{
							alert(getBusinessMessage('922'));//�����������ҵ��ת��Ȩ��ͬһ�û�����У�������ѡ��ת��Ȩ����û���
							return;
						}										
						//����ҳ�����
						sReturn = PopPage("/SystemManage/SynthesisManage/BusinessShiftAction.jsp?SerialNo="+sSerialNo+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&FromUserID="+sFromUserID+"&FromUserName="+sFromUserName+"&ToUserID="+sToUserID+"&ToUserName="+sToUserName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
						if(sReturn == "TRUE")
							alert("������ˮ��("+sSerialNo+"),"+"ҵ��ת��Ȩ�ɹ���");
						else if(sReturn == "FALSE")
							alert("������ˮ��("+sSerialNo+"),"+"ҵ��ת��Ȩʧ�ܣ�");						
					}
				}				
				reloadSelf();
				
			}
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	/*~[Describe=�һ�ѡ���¼;InputParam=��;OutPutParam=��;]~*/
	function onDBClickStatus()
	{
		sStatus = getItemValue(0,getRow(),"Status") ;
		if (typeof(sStatus) == "undefined" || sStatus == "")
			setItemValue(0,getRow(),"Status","��");
		else
			setItemValue(0,getRow(),"Status","");

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
