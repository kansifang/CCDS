<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: ���������α��������Ϣ
		Change Param:
				ObjectNo: �����Ż��ծ�ʲ����
				ObjectType����������
				
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������α��������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sObjectNo;	//������
	String sObjectType;	//��������
	
	
	//���ҳ�����
	        	
    	//�����ţ�������Ż��ʲ���ţ�,��������
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	
	String sHeaders[][] = { 		
    					{"SerialNo","���α����¼��ˮ��"},
    					{"OldUserName","ԭ������"},
    					{"OldOrgName","ԭ�������"},  					
						{"NewUserName","�ֹ�����"},
						{"NewOrgName","�ֹ������"}, 					
						{"ChangeReason","���α��ԭ��"},
						{"ChangeDate","���α������"},
						{"Remark","��ע"},
						{"ChangeUserName","�����"},
						{"ChangeOrgName","�������"},
						{"ChangeTime","�������"}
						
					}; 

	sSql = 	" select SerialNo,ObjectNo,ObjectType, "+
			" OldUserID,getUserName(OldUserID) as OldUserName, "+
			" OldOrgID,getOrgName(OldOrgID) as OldOrgName, "+			
			" NewUserID,getUserName(NewUserID) as NewUserName, "+
			" NewOrgID,getOrgName(NewOrgID) as NewOrgName, "+
			" ChangeUserID,getUserName(ChangeUserID) as ChangeUserName, "+
			" ChangeOrgID,getOrgName(ChangeOrgID) as ChangeOrgName,ChangeTime "+
			" from MANAGE_CHANGE "+
			" where ObjectNo='"+sObjectNo+"'  "+	//�����ţ�������Ż��ծ�ʲ���ţ�
			" and ObjectType='"+sObjectType+"' "+
			" order by ChangeTime desc";	//�������ͣ�����ΪLawCase_info����ծ�ʲ�ΪAsset_Info��
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "MANAGE_CHANGE";	
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //���ùؼ���
	
	//���ò��ɸ���
	doTemp.setUpdateable("ChangeUserName,ChangeOrgName,NewOrgName,NewUserName",false);	

	//��������
	doTemp.setCheckFormat("ChangDate,ChangeDate","3");

	//���ù��ø�ʽ
	doTemp.setVisible("OldUserID,OldOrgID,NewUserID,NewOrgID",false);
	doTemp.setVisible("ChangeUserID,ChangeOrgID",false);
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	
	//����ֻ��
	doTemp.setReadOnly("SerialNo,OldUserName,OldOrgName,ChangeUserName,ChangeOrgName,NewUserName,NewOrgName,ChangeTime",true);
	
	//����ѡ���п�
	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	
	
	//���ñ༭��ʽ����ı���
	doTemp.setEditStyle("ChangeReason","3");
	doTemp.setEditStyle("Remark","3");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","�鿴����","�鿴�����ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	//�鿴�����������ʷ����	
	function viewAndEdit()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo"); //��¼��ˮ��
		sObjectNo=getItemValue(0,getRow(),"ObjectNo"); //������
		sObjectType=getItemValue(0,getRow(),"ObjectType"); //��������
		
	       if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));//��ѡ��һ����Ϣ��
			return false;
		}
		else
		{
			
			OpenPage("/RecoveryManage/LawCaseManage/ManagerChangeInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&Flag=Y","right",OpenStyle);

		}
		 
	}	
	
	
	/*~[Describe=�����б�ҳ��;ChangeParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","_self","");
		
	}
    
	</script>
	
	

<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

