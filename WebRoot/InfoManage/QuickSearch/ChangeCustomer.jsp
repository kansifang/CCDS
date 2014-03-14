<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp" %>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/
%>
<%
	/*
         Author: 2010-05-11	wwhe
         Tester:
         Describe: �ͻ��ص�����
         Input Param:
         Output param:
         History Log:

      */
%>
<%
	/*~END~*/
%>

<%
	String sCustomerID = DataConvert.toRealString(iPostChange, (String) CurComp.getParameter("CustomerID"));
    if (sCustomerID == null) sCustomerID = "";
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
<%
	String PG_TITLE = "�ͻ��ص�����"; // ��������ڱ��� <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//���������SQL���
    String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/
%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
    String[][] sHeaders = {
		            {"CustomerID", "�ͻ����"},
		            {"EnterpriseName", "�ͻ�����"},
		            {"RealtyFlag", "�ͻ��ص���������"},
		            {"IndustryType1", "����ͻ�����"},
		            {"ProjectFlag", "����������"},
		            {"IndustryType", "������ҵ����"},
		            {"IndustryTypeName", "������ҵ����"},
		            {"IndustryType2", "������ҵ����"},
		            {"Flag3", "���ڿͻ�����"},
		            {"EconomyType","��Ӫ����"}
    };
    sSql = 	" select CustomerID,EnterpriseName,RealtyFlag,IndustryType1,ProjectFlag, "+
    		" IndustryType,getItemName('IndustryType',IndustryType) as IndustryTypeName,IndustryType2,Flag3,EconomyType "+
            " from ENT_INFO "+
            " where CustomerID= '" + sCustomerID + "' ";

    //ͨ��SQL����ASDataObject����doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //���ñ���
    doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "ENT_INFO";
    doTemp.setKey("CustomerID", true);
    doTemp.setUpdateable("IndustryTypeName", false);
    //������������
    doTemp.setDDDWCode("RealtyFlag","RealtyFlag");
    doTemp.setDDDWCode("IndustryType1","IndustryType1");
    doTemp.setDDDWCode("ProjectFlag","ProjectFlag");
    doTemp.setDDDWCode("IndustryType2","BankIndustryType");
    doTemp.setDDDWCode("Flag3","CustomerType2");
    doTemp.setDDDWCode("EconomyType","EconomyType");
    doTemp.appendHTMLStyle("IndustryTypeName"," onClick=\"javascript:parent.getIndustryType()\" ");
    doTemp.setVisible("IndustryType",false);
    doTemp.setReadOnly("IndustryTypeName,CustomerID,EnterpriseName",true);
    
    if(!CurUser.hasRole("000")){
    	doTemp.setVisible("IndustryType1,ProjectFlag,IndustryTypeName,IndustryType2,Flag3",false);
    }

    ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
    dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
    dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

    //����HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow("");
    for (int i = 0; i < vTemp.size(); i++) out.print((String) vTemp.get(i));
    session.setAttribute(dwTemp.Name, dwTemp);
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/
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
    String sButtons[][] = {
            {"true", "", "Button", "����", "����ʹ�ö����Ϣ", "saveRecord()", sResourcesPath}
    };
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/
%>
<%@ include file="/Resources/CodeParts/Info05.jsp" %>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/
%>
<script language=javascript>
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
    function doCancel() {
        top.returnValue = "_CANCEL_";
        top.close();
    }
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/
%>

<script language=javascript>

    /*~[Describe=��������Ľ��;InputParam=��;OutPutParam=��;]~*/
    function saveRecord(sPostEvents)
    {
    	as_save("myiframe0", sPostEvents);
    	close();
    }

	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}

    /*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
    function initRow()
    {
    	
    }

</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>
    AsOne.AsInit();
    init();
    my_load(2, 0, 'myiframe0');
    initRow();
    //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%
	/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp" %>