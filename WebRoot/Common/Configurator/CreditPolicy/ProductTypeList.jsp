<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   --fbkang
			Tester:
			Content: --��Ʒ�����б�
			Input Param:
	                  
			Output param:
			       DoNo:--ģ�����
			       EditRight: --�༭Ȩ��
			                
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
		String PG_TITLE = "�Ŵ���Ʒ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql="";//--���sql���
	String sSortNo=""; //--������
	//���ҳ�����
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String[][] sHeaders = {
						{"TypeNo","��Ʒ���"},
						{"TypeName","��Ʒ����"},
						{"IsInUse","�Ƿ���Ч"},
						{"GerneralBusinessType","��ҵ��Ʒ�ַ���"},
						{"Attribute2","��ҵ��Ʒ�ַ���"},
						{"ApplyDetailNo","������ʾģ��"},	
						{"ApproveDetailNo","�������������ʾģ��"},	
						{"ContractDetailNo","��ͬ��ʾģ��"},
						{"DisplayTemplet","������ʾģ��"},	
						{"Attribute9","��������"},														
						{"InputUserName","�Ǽ���"},
						{"InputOrgName","�Ǽǻ���"},
						{"InputTime","�Ǽ�ʱ��"},
						{"UpdateUserName","������"},
						{"UpdateTime","����ʱ��"}
		             };
	sSql =  " select TypeNo,TypeName,getItemName('IsInUse',IsInUse) as IsInUse,"+
	" Attribute2,getItemName('GeneralBusinessType',Attribute2) as GerneralBusinessType,"+
	" ApplyDetailNo,ApproveDetailNo,ContractDetailNo,DisplayTemplet,Attribute9, "+
	" getUserName(InputUser) as InputUserName, "+
	" getOrgName(InputOrg) as InputOrgName,InputTime, "+
	" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
	" from BUSINESS_TYPE "+
	" where 1=1 "+
	" order by SortNo ";
	
	//����ASDataObject����doTemp		
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "BUSINESS_TYPE";
	//��������
	doTemp.setKey("TypeNo",true);
	//���ò�������
	doTemp.setVisible("Attribute2",false);
	//���������б�
	doTemp.setDDDWCode("Attribute2","GeneralBusinessType");	
	//�����п��
	doTemp.setHTMLStyle("TypeNo,IsInUse"," style={width:80px} ");
 	doTemp.setHTMLStyle("TypeName,InputOrg"," style={width:160px} ");
 	doTemp.setHTMLStyle("ApplyDetailNo,ApproveDetailNo,ContractDetailNo,DisplayTemplet,Attribute9"," style={width:150px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setAlign("IsInUse,GerneralBusinessType","2");
	//���˲�ѯ
 	doTemp.setFilter(Sqlca,"1","TypeNo","");
 	doTemp.setFilter(Sqlca,"2","TypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
 	doTemp.setFilter(Sqlca,"3","Attribute2","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(20);
  	

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
		String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","������ʾģ������","�鿴/�༭������ʾģ������","DataObjectview1()",sResourcesPath},
		{"true","","Button","�������������ʾģ������","�鿴/�༭�������������ʾģ������","DataObjectview2()",sResourcesPath},
		{"true","","Button","��ͬ��ʾģ������","�鿴/�༭��ͬ��ʾģ������","DataObjectview3()",sResourcesPath},
		{"true","","Button","������ʾģ������","�鿴/�༭����ģ������","DataObjectview4()",sResourcesPath},
		{"true","","Button","������������","�鿴/�༭������������","DataObjectview5()",sResourcesPath}					
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
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
                }
            }
        }
        
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","TypeNo="+sTypeNo,"");
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
				    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
				}
			}
	    }
	}
	
	/*~[Describe=�鿴������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview1()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApplyDetailNo");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû������������ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight+" ","");
	}
	
	/*~[Describe=�鿴�������������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview2()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApproveDetailNo");//--ģ��ű��
		sEditRight="01";//
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�������������������ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight+" ","");
	}
	
	/*~[Describe=�鿴��ͬ��ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview3()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ContractDetailNo");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�����ú�ͬ��ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight+" ","");
	}
   
	/*~[Describe=�鿴������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview4()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"DisplayTemplet");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�����ó�����ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight+" ","");
	}
	
   /*~[Describe=�鿴������������;InputParam=��;OutPutParam=��;]~add by wlu 2009-02-19*/
	function DataObjectview5()
	{
        sFlowNo = getItemValue(0,getRow(),"Attribute9");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0)
        {
			alert("��ѡ��Ĳ�Ʒû�������������̣�������ѡ��");//��ѡ��Ĳ�Ʒû�������������̣�������ѡ��
            return ;
		}
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo,"");
    }
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
        if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
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
