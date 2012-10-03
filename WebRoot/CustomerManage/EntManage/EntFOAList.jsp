<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2004-11-30
		Tester:
		Describe: ��ҵӦ��Ӧ���ʿ���Ϣ
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			SerialNo:��ˮ��
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ҵӦ��Ӧ���ʿ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//���ҳ�����	
	
	//����������	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";			

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ				
	String sHeaders[][] = { 
                            {"CustomerID","�ͻ����"},
                            {"SerialNo","��ˮ��"},
                            {"UpToDate","�����������"},
                            {"FOAType","�ʿ�����"},
                            {"AccountYears","����"}, 
                            {"FOACurrency","����"}, 
                            {"FOASum","���"},   
                            {"OrgName","�Ǽǻ���"},
                            {"UserName","�Ǽ���"}
			              };   		   		
	
	sSql = 	"  select CustomerID,SerialNo,UpToDate,getItemName('FundsType',FOAType) as FOAType," +
			"  getItemName('FundsAge',AccountYears) as AccountYears,getItemName('Currency',FOACURRENCY) as FOACURRENCY,FOASUM," +
			"  InputOrgId,getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
			"  from ENT_FOA" +
			"  where CustomerID ='"+sCustomerID+"'";
    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ENT_FOA";
	doTemp.setKey("CustomerID,SerialNo",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,SerialNo,InputOrgId,InputUserId",false);	    
	//ͨ�������ⲿ�洢�����õ����ֶ�
	doTemp.setUpdateable("UserName,OrgName",false);   
	//������ʾ�ı���ĳ���
	//doTemp.setCheckFormat("UpToDate","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	//����С����ʾ״̬,
	doTemp.setAlign("FOASum","3");
	doTemp.setAlign("FOAType,AccountYears,FOACurrency","2");
	doTemp.setType("FOASum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("FOASum","2");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
		{"true","","Button","����","����Ӧ��Ӧ���˿���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴Ӧ��Ӧ���˿���Ϣ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��Ӧ��Ӧ���˿���Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?EditRight=02","_self","");
	}
	

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserId");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));	
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
    function viewAndEdit()
    {
        sUserID=getItemValue(0,getRow(),"InputUserId");//--�û�����
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
        {
        	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return;
        }else
        {       
        	OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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
