<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29 
		Tester:
		Describe: �ͻ�����Ȩά����ϵͳû�м�¼������־���������д������뱣��ʱ������ӣ�
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
			     ndeng 2004-11-30
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ�����Ȩά����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	//����ֵת��Ϊ���ַ���
	if(sCustomerID == null) sCustomerID = "";
	if(sOrgID == null) sOrgID = "";	
	if(sUserID == null) sUserID = "";
		
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {     
	                            {"CustomerID","��֯��������"},
	                            {"CustomerName","�ͻ�����"},
	                            {"OrgName","��������"},
	                            {"UserName","�ͻ�����"},
	                            {"BelongAttribute","�ͻ�����Ȩ"},                               
                                {"BelongAttribute1","��Ϣ�鿴Ȩ"},
                                {"BelongAttribute2","��Ϣά��Ȩ"},
                                {"BelongAttribute3","ҵ�����Ȩ"},
	                            {"InputOrgName","�Ǽǻ���"},
	                            {"InputUserName","�Ǽ���"},
	                            {"InputDate","�Ǽ�����"},
	                            {"UpdateDate","��������"},
	                            {"Remark","��ע"}
							};    	  		   		
	
	
	String sSql = " select CustomerID,getCustomerName(CustomerID) as CustomerName,"+
				  " OrgID,getOrgName(OrgID) as OrgName," +
	              " UserID,getUserName(UserID) as UserName,"+
	              " BelongAttribute,"+
                  " BelongAttribute1,"+
                  " BelongAttribute2,"+
                  " BelongAttribute3,"+
                  " BelongAttribute4,"+
	              " Remark," +
				  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputUserID,getUserName(InputUserID) as InputUserName,InputDate,UpdateDate " +
	              " from CUSTOMER_BELONG " +
	              " where CustomerID = '"+sCustomerID+"' " +
	              " and OrgID = '"+sOrgID+"' " +
	              " and UserID = '"+sUserID+"' " ;
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);	 //Ϊ�����ɾ��
	doTemp.setRequired("CustomerName,OrgName,UserName,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4",true);
	
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,BelongAttribute4,InputOrgID,InputUserID,OrgID,UserID",false);
	
	//ͨ�������ⲿ�洢�����õ����ֶ�
	doTemp.setUpdateable("CustomerName,UserName,OrgName,InputOrgName,InputUserName",false);
	doTemp.setHTMLStyle("UserName,OrgName,InputUserName,InputDate,UpdateDate"," style={width:80px} ");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("OrgName,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4"," style={width:300px} ");
	doTemp.setReadOnly("OrgName,UserName,CustomerName,InputOrgName,InputUserName,InputDate,UpdateDate,BelongAttribute2",true);
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	doTemp.setDDDWCode("BelongAttribute","HaveNot");
	doTemp.setDDDWCode("BelongAttribute1","HaveNot");
	doTemp.setDDDWCode("BelongAttribute2","HaveNot");
	doTemp.setDDDWCode("BelongAttribute3","HaveNot");	
	doTemp.appendHTMLStyle("BelongAttribute","onchange=parent.checkApplyAttribute()");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}		
		};
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
	function saveRecord()
	{		
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//--��ÿͻ����
		var sUserID = getItemValue(0,getRow(),"UserID");//--����û����
		var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--��ÿͻ�����Ȩ��־
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--�����Ϣ�鿴Ȩ��־
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--�����Ϣά��Ȩ��־
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--���ҵ�����Ȩ��־
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--��ô�����Ȩ�ޱ�־
        sReturn = PopPage("/CustomerManage/AuthorizeRoleAction.jsp?CustomerID="+sCustomerID+"&UserID="+sUserID+"&ApplyAttribute="+sBelongAttribute+"&ApplyAttribute1="+sBelongAttribute1+"&ApplyAttribute2="+sBelongAttribute2+"&ApplyAttribute3="+sBelongAttribute3+"&ApplyAttribute4="+sBelongAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
        sReturn = sReturn.split("@");
        sHave = sReturn[0];
        sOrgName = sReturn[1];
        sUserName = sReturn[2];
        sBelongUserID = sReturn[3];
        if(sHave == "_TRUE_")
        {
            if(confirm(sOrgName+" "+sUserName+" "+"�Ѿ�ӵ�иÿͻ�������Ȩ���Ƿ�������������Ȩת�ƣ�ԭ������Ȩ�����Զ�ɥʧһ�пͻ�Ȩ�����������������������룡"))
            {
                PopPage("/CustomerManage/ChangeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
                alert(getBusinessMessage('224'));//�ͻ�Ȩ�ޱ���ɹ���
            }            
        }
        else
        {
            alert(getBusinessMessage('224'));//�ͻ�Ȩ�ޱ���ɹ���
        }
        bCheckBeforeUnload=false;
	}
		
	function checkApplyAttribute()
    {
        var sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");//--����Ƿ�����ͻ�����Ȩ��־
        if(sBelongAttribute == "1")
        {
            setItemValue(0,0,"BelongAttribute1","1");
            setItemValue(0,0,"BelongAttribute2","1");
            setItemValue(0,0,"BelongAttribute3","1");
            setItemValue(0,0,"BelongAttribute4","1");
        }
        else
        {
        	setItemValue(0,0,"BelongAttribute2","2");
        }
    }	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
		
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