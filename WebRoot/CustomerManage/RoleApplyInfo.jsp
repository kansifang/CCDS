<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --Ȩ������ҳ��
		Input Param:
            CustomerID���ͻ���
            UserID���û�����
            OrgID����������
            Check������־
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�Ȩ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//�������������ͻ���š��û�ID������ID������־
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    String sCheck = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Check"));
    //����ֵת��Ϊ���ַ���
    if(sCustomerID == null) sCustomerID = "";
    if(sUserID == null) sUserID = "";
    if(sOrgID == null) sOrgID = "";
    if(sCheck == null) sCheck = "";
    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {										
								{"CertID","֤������"},
								{"CustomerName","�ͻ�����"},
                                {"ApplyAttribute","�Ƿ�����ͻ�����Ȩ"},   
                                {"ApplyAttribute1","�Ƿ�������Ϣ�鿴Ȩ"},
                                {"ApplyAttribute2","�Ƿ�������Ϣά��Ȩ"},
                                {"ApplyAttribute3","�Ƿ�����ҵ�����Ȩ"},
								{"ApplyReason","��������"}
						  };

	String sSql =	" select CI.CustomerID as CustomerID,CB.UserID as UserID,CB.OrgID as OrgID, "+
					" CI.CertID as CertID,CI.CustomerName as CustomerName, "+
					" CB.ApplyAttribute as ApplyAttribute,CB.ApplyAttribute1 as ApplyAttribute1, "+
					" CB.ApplyAttribute2 as ApplyAttribute2,CB.ApplyAttribute3 as ApplyAttribute3, "+
					" CB.ApplyAttribute4 as ApplyAttribute4,CB.BelongAttribute as BelongAttribute, "+
					" CB.BelongAttribute1 as BelongAttribute1,CB.BelongAttribute2 as BelongAttribute2, "+
					" CB.BelongAttribute3 as BelongAttribute3,CB.BelongAttribute4 as BelongAttribute4,"+
					" CB.ApplyStatus as ApplyStatus,CB.ApplyReason as ApplyReason"+
					" from CUSTOMER_INFO CI,CUSTOMER_BELONG CB " +
					" where CI.CustomerID=CB.CustomerID and CB.CustomerID='"+sCustomerID+"' and UserID='"+sUserID+"' and OrgID='"+sOrgID+"'";

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);
	doTemp.setLimit("ApplyReason",200);
	//���ñ�����
	doTemp.setRequired("ApplyAttribute,ApplyAttribute1,ApplyAttribute2,ApplyAttribute3,ApplyAttribute4,ApplyReason",true);   //Ӧ������Ҫ�޸�
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,UserID,OrgID,BelongAttribute,ApplyStatus,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,ApplyAttribute4",false);
	//���ò��ɸ�����
	doTemp.setUpdateable("CertID,CustomerName",false);
	doTemp.setReadOnly("ApplyAttribute2",true);
    //�����¼�
    doTemp.setHTMLStyle("ApplyAttribute"," onchange=parent.checkApplyAttribute() ");
    
	//�����ֶθ�ʽ	
	doTemp.setEditStyle("ApplyReason","3");
	doTemp.setHTMLStyle("ApplyReason"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	doTemp.setLimit("ApplyReason",200);
    doTemp.setReadOnly("CertID,CustomerName",true);
    if(sCheck.equals("Y"))
    {
       doTemp.setReadOnly("ApplyReason",true); 
       doTemp.setRequired("",false);
    }
	//������������Դ
	doTemp.setDDDWCode("ApplyAttribute,ApplyAttribute1,ApplyAttribute2,ApplyAttribute3,ApplyAttribute4","YesNo");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","�ύ","�ύ����","Apply()",sResourcesPath},
			{"true","","Button","��׼","��׼����","Authorize()",sResourcesPath},
			{"true","","Button","���","�������","Overrule()",sResourcesPath}
		};
	if(sCheck.equals("Y"))
	{
	   sButtons[1][0]="false";
	}
	else
	{
	   sButtons[2][0]="false"; 
	   sButtons[3][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(!checkOtherRoles())
		    return;
		as_save("myiframe0",sPostEvents);
	}
    /*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/
    function Apply()
    {
        if(!checkOtherRoles())
		    return;
        var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
        if(sApplyReason=="")
        {
            alert("��Ϣ��ȫ���ύʧ�ܣ�(��������û��)");
            return;
        }
        var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
        sCustomerID=getItemValue(0,getRow(),"CustomerID");
        
        if(sApplyAttribute == "1" || sApplyAttribute1=="1" || sApplyAttribute2 == "1" || sApplyAttribute3 == "1")
        {    
            setItemValue(0,0,"ApplyStatus","1"); 
            sReturnString = PopPage("/CustomerManage/GetMessageAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
           	alert(sReturnString);
           	saveRecord(self.close());
        }
        else
        {
            alert("����Ҫ�ύһ��Ȩ�޵����룡");
        }
    }
    
    function Authorize()
    {
        if(!checkOtherRoles())
		    return;
        if(confirm("ȷ��ͨ����������"))
        {
            var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
            var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
            var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
            var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
            var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--��ô�����Ȩ�ޱ�־
            
            sReturn = PopPage("/CustomerManage/AuthorizeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&ApplyAttribute="+sApplyAttribute+"&ApplyAttribute1="+sApplyAttribute1+"&ApplyAttribute2="+sApplyAttribute2+"&ApplyAttribute3="+sApplyAttribute3+"&ApplyAttribute4="+sApplyAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
            sReturn = sReturn.split("@");
            sHave = sReturn[0];
            sOrgName = sReturn[1];
            sUserName = sReturn[2];
            sBelongUserID = sReturn[3];
            if(sHave == "_TRUE_")
            {
                if(confirm(sOrgName+" "+sUserName+" "+"�Ѿ�ӵ�иÿͻ�������Ȩ���Ƿ������׼���������Ȩת�ƣ�ԭ������Ȩ�����Զ�ɥʧһ�пͻ�Ȩ�����������������������룡"))
                {
                    PopPage("/CustomerManage/ChangeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
                    alert("��׼�ÿͻ�Ȩ�޳ɹ���");
                    setItemValue(0,0,"ApplyStatus","2");
		            setItemValue(0,0,"ApplyAttribute","");
		            setItemValue(0,0,"ApplyAttribute1","");
		            setItemValue(0,0,"ApplyAttribute2","");
		            setItemValue(0,0,"ApplyAttribute3","");
		            setItemValue(0,0,"ApplyAttribute4","");
		            setItemValue(0,0,"ApplyReason","");
		            saveRecord(self.close());   
                }
            }else
            {
                alert("��׼�ÿͻ�Ȩ�޳ɹ���");
                setItemValue(0,0,"ApplyStatus","2");
	            setItemValue(0,0,"ApplyAttribute","");
	            setItemValue(0,0,"ApplyAttribute1","");
	            setItemValue(0,0,"ApplyAttribute2","");
	            setItemValue(0,0,"ApplyAttribute3","");
	            setItemValue(0,0,"ApplyAttribute4","");
	            setItemValue(0,0,"ApplyReason","");
	            saveRecord(self.close());   
            }
            self.close();        
        }
    }
    
    function Overrule()
    {
        if(confirm("ȷ�������������"))
        {
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute","");
            setItemValue(0,0,"ApplyAttribute1","");
            setItemValue(0,0,"ApplyAttribute2","");
            setItemValue(0,0,"ApplyAttribute3","");
            setItemValue(0,0,"ApplyAttribute4","");
            setItemValue(0,0,"ApplyReason","");
            alert("�ѷ���ÿͻ�Ȩ�����룡");
            saveRecord(self.close());  
        }
    }
    
    function checkApplyAttribute()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        if(sApplyAttribute == "1")
        {
            setItemValue(0,0,"ApplyAttribute1","1");
            setItemValue(0,0,"ApplyAttribute2","1");
            setItemValue(0,0,"ApplyAttribute3","1");
            setItemValue(0,0,"ApplyAttribute4","1");
        }
        else
        {
        	setItemValue(0,0,"ApplyAttribute2","2");
        }
    }
    function checkOtherRoles()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--����Ƿ�������Ϣ�鿴Ȩ��־
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--����Ƿ�������Ϣά��Ȩ��־
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--����Ƿ�����ҵ�����Ȩ��־
        var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--δ��
        
        if(sApplyAttribute == "1")
        {
            if(sApplyAttribute == "2" || sApplyAttribute2 == "2" || sApplyAttribute3 == "2" || sApplyAttribute4 == "2")
            {
                alert("���Ѿ�ѡ��������Ȩ������Ȩ�����˸���Ȩ�����������ѡ��");
                return false;
            }
            
        }
        
        if(sApplyAttribute2 == "1" && sApplyAttribute1 == "2")
        {            
            alert("���Ѿ�ѡ������Ϣά��Ȩ����Ϣά��Ȩ��������Ϣ�鿴Ȩ����Ϣ�鿴Ȩ����ѡ��");
            return false;    
        }
        
        return true;
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

    function initRow()
    {
        var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--����Ƿ�ͻ�����Ȩ��־
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--����Ƿ����õȼ�����Ȩ��־
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--����Ƿ���Ϣ�鿴Ȩ��־
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--����Ƿ���Ϣά��Ȩ��־
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--����Ƿ�ҵ�����Ȩ��־
        
        var sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");//--����Ƿ��ύ�����־

		if(sApplyStatus != "1")
		{
	        if(sBelongAttribute == "1")
	        	setItemValue(0,0,"ApplyAttribute","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute","2");
			
		    if(sBelongAttribute1 == "1")
	        	setItemValue(0,0,"ApplyAttribute1","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute1","2");
			
			if(sBelongAttribute2 == "1")
	        	setItemValue(0,0,"ApplyAttribute2","1");
	    	else 
			 	setItemValue(0,0,"ApplyAttribute2","2");
		
	        if(sBelongAttribute3 == "1")
	        	setItemValue(0,0,"ApplyAttribute3","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute3","2");
		
	        if(sBelongAttribute4 == "1")
	        	setItemValue(0,0,"ApplyAttribute4","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute4","2"); 
		}	    
        
    }
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>

<script language=javascript>	
    //����ʾҳ�����޸�
	function isModified(objname)
	{
		return false;
	}
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
