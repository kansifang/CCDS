<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   cwzhan 2004-12-28
			Tester:
			Content: �û������б�
			Input Param:
	                  
			Output param:
			                
			History Log: 
	            
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	
	//��ȡ�������
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sOrgID == null) sOrgID = "";
	String sSortNo="";
	sSortNo=Sqlca.getString("select SortNo from Org_Info where OrgID='"+sOrgID+"'");
	if(sSortNo==null)sSortNo="";
	//��ȡҳ�����
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "UserList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //filter��������
    doTemp.setColumnAttribute("BelongOrgName,UserName,UserID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(20);

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql);
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
	<%
		//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��
		String sButtons[][] = 
	        {
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","����","�ڵ�ǰ������������Ա","my_add()",sResourcesPath},			
		{"false","","Button","����","������Ա����ǰ����","my_import()",sResourcesPath},
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","ͣ��","�ӵ�ǰ������ɾ������Ա","my_del()",sResourcesPath}, 
	            {"true","","Button","����","�鿴�û�����","viewAndEdit()",sResourcesPath},
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","�û���ɫ","�鿴�����޸���Ա��ɫ","viewAndEditRole()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","�������½�ɫ","�������½�ɫ","my_Addrole()",sResourcesPath},
		//{((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","���û����½�ɫ","���û����½�ɫ","MuchAddrole()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","�û�Ȩ��","�鿴�����޸���ԱȨ��","viewAndEditRight()",sResourcesPath},
	           // {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","ת��","ת����Ա����������","UserChange()",sResourcesPath},                       
	            {((CurUser.hasRole("099") || CurUser.hasRole("299"))?"true":"false"),"","Button","��ʼ����","��ʼ�����û�����","ClearPassword()",sResourcesPath}            
	            
	        };
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	/*~[Describe=�ڵ�ǰ������������Ա;InputParam=��;OutPutParam=��;]~*/
	function my_add()
    {   
		OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp","_self","");
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/SystemManage/GeneralSetup/UserInfo.jsp?UserID="+sUserID,"_self","");
		}
	}

	/*~[Describe=�鿴�����޸���Ա��ɫ;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditRole()
    {
        sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else
        {
        	sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��鿴�û���ɫ��");
        	else
            	sReturn=popComp("UserRoleList","/SystemManage/GeneralSetup/UserRoleList.jsp","UserID="+sUserID,"");
        }    
    }
    
    /*~[Describe=�������½�ɫ;InputParam=��;OutPutParam=��;]~*/    
    function my_Addrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}
    	else
    	{
        	sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷��������½�ɫ��");
        	else
        		PopPage("/SystemManage/GeneralSetup/AddUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=22;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
    	}
	}
	
	/*~[Describe=���û����½�ɫ;InputParam=��;OutPutParam=��;]~*/
	function MuchAddrole()
	{
	    sUserID=getItemValue(0,getRow(),"UserID");
 		if(typeof(sUserID)=="undefined" ||sUserID.length==0)
    	{ 
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
    	}
    	else
    	{
    		sStatus=getItemValue(0,getRow(),"Status");
        	if(sStatus!="1")
        		alert(sUserID+"�������û����޷����û����½�ɫ��");
        	else
        		PopPage("/SystemManage/GeneralSetup/AddMuchUserRole.jsp?UserID="+sUserID,"","dialogWidth=36;dialogHeight=37;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");       	
		}
	}
    
    /*~[Describe=�鿴�����޸���ԱȨ��;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditRight()
    {
        sUserID=getItemValue(0,getRow(),"UserID");
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else
        {            
            popComp("RightView","/SystemManage/GeneralSetup/RightView.jsp","ObjectNo=USER@"+sUserID,"","");
        }    
    }

	/*~[Describe=ת����Ա����������;InputParam=��;OutPutParam=��;]~*/
	function UserChange()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        sFromOrgID = getItemValue(0,getRow(),"BelongOrg");
        sFromOrgName = getItemValue(0,getRow(),"BelongOrgName");
        
        var sReturnValue ="";
        if(typeof(sUserID)=="undefined" ||sUserID.length==0)
        { 
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        }else
        {	
            //��ȡ��ǰ�û�
			sOrgID = "<%=CurOrg.OrgID%>";			
			sParaStr = "OrgID,"+sOrgID;
			sOrgInfo = setObjectValue("SelectBelongOrg",sParaStr,"",0,0);	
		    if(sOrgInfo == "" || sOrgInfo == "_CANCEL_" || sOrgInfo == "_NONE_" || sOrgInfo == "_CLEAR_" || typeof(sOrgInfo) == "undefined") 
		    {
			    if( typeof(sOrgInfo) != "undefined"&&sOrgInfo != "_CLEAR_")alert(getBusinessMessage('953'));//��ѡ��ת�ƺ�Ļ�����
			    return;
		    }else
		    {
			    sOrgInfo = sOrgInfo.split('@');
			    sToOrgID = sOrgInfo[0];
			    sToOrgName = sOrgInfo[1];
			    
			    if(sFromOrgID == sToOrgID)	
				{
					alert(getBusinessMessage('954'));//��������Աת����ͬһ�����н��У�������ѡ��ת�ƺ������
					return;
				}
				//����ҳ�����
				sReturn = PopPage("/SystemManage/SynthesisManage/UserShiftAction.jsp?UserID="+sUserID+"&FromOrgID="+sFromOrgID+"&FromOrgName="+sFromOrgName+"&ToOrgID="+sToOrgID+"&ToOrgName="+sToOrgName+"","","dialogWidth=21;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 
				if(sReturn == "TRUE")	            
	            {
	                alert(getBusinessMessage("914"));//��Աת�Ƴɹ���
	                reloadSelf();           	
	            }else if(sReturn == "FALSE")
	            {
	                alert(getBusinessMessage("915"));//��Աת��ʧ�ܣ�
	            }
			}   
		}
	}
	

	/*~[Describe=������Ա����ǰ����;InputParam=��;OutPutParam=��;]~*/
	function my_import()
	{       	
       	sParaString = "BelongOrg"+","+"<%=sOrgID%>";		
		sUserInfo = setObjectValue("SelectImportUser",sParaString,"",0,0,"");
		if(typeof(sUserInfo) != "undefined" && sUserInfo != "" && sUserInfo != "_NONE_" 
		&& sUserInfo != "_CANCEL_" && sUserInfo != "_CLEAR_") 
		{
       		sInfo = sUserInfo.split("@");
	        sUserID = sInfo[0];
	        sUserName = sInfo[1];
	        if(typeof(sUserID) != "undefined" && sUserID != "")
	        {
	        	if(confirm(getBusinessMessage("912")))//��ȷ������ѡ��Ա���뵽����������
	        	{
	        		PopPage("/SystemManage/GeneralSetup/AddUserAction.jsp?UserID="+sUserID+"&OrgID=<%=sOrgID%>","","");
	        		alert(getBusinessMessage("913"));//��Ա����ɹ���
	        		reloadSelf();
	        	}
	        }			
       	}
	}
	

	/*~[Describe=�ӵ�ǰ������ɾ������Ա;InputParam=��;OutPutParam=��;]~*/
	function my_del()
    {   
		sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sUserID) == "undefined" || sUserID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("�������ͣ�ø��û���"))//�������ɾ������Ϣ��
		{
            sReturn = RunMethod("Configurator","DeleteUser",sUserID);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
			    alert("��Ϣͣ�óɹ���");//��Ϣɾ���ɹ���
			    reloadSelf(); 
			}
		}
	}
	
	/*~[Describe=��ʼ���û�����Ϊ1;InputParam=��;OutPutParam=��;]~*/
	function ClearPassword()
	{
        sUserID = getItemValue(0,getRow(),"UserID");
        if (typeof(sUserID)=="undefined" || sUserID.length==0)
		{
		    alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage("916"))) //��ȷ��Ҫ��ʼ�����û���������
		{
		    PopPage("/SystemManage/GeneralSetup/ClearPasswordAction.jsp?UserID="+sUserID,"","dialogWidth:320px;dialogHeight:270px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
		    alert(getBusinessMessage("917"));//�û������ʼ���ɹ���
		    reloadSelf();
		}
	}
   
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
