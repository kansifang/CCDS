<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: thong 2005-09-14
		Tester:	
		Content: ҵ����ʾ��Ԥ������
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ����ʾ��Ԥ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ��SQL����ASDataObject����doTemp
	
	String[][] sHeaders = {
							{"ScenarioID","�������"},
							{"ScenarioName","��������"},
							{"ObjectType","Ԥ����������"},
							{"ScenarioDescribe","����˵��"}
						  };

	sSql = "select ScenarioID,ScenarioName,ObjectType,ScenarioDescribe "+
		   "from ALARM_SCENARIO where 1=1 order by ScenarioID";
		   
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "ALARM_SCENARIO";
	doTemp.setKey("ScenarioID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setHTMLStyle("ScenarioDescribe","Style={width=450px};");

	//��ѯ
 	doTemp.setColumnAttribute("ScenarioID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","Ԥ�������б�","�鿴/�޸�Ԥ�������б�","viewAndEditLib()",sResourcesPath},
		{"true","","Button","Ԥ����������","�鿴/�޸�Ԥ��Ԥ�������","viewAndEditArg()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","�ύ������ȹ���","�ύ������ȹ���","submitAlsert()",sResourcesPath}
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
		sReturn=popComp("OperationAlertInfo","/CreditManage/CreditAlarm/OperationAlertInfo.jsp","","");
	    reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		
		if (typeof(sScenarioID)=="undefined" || sScenarioID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	                return ;
	    }
	    sReturn=popComp("OperationAlertInfo","/CreditManage/CreditAlarm/OperationAlertInfo.jsp","ScenarioID="+sScenarioID,"");
	    reloadSelf();
	}
    /*~[Describe=�鿴���޸�Ԥ�������б�;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditLib()
	{
        	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
        	popComp("AlarmLibList","/Common/Configurator/AlarmManage/AlarmLibList.jsp","ScenarioID="+sScenarioID,"");
	}

    /*~[Describe=�鿴���޸�Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditArg()
	{
        	sScenarioID = getItemValue(0,getRow(),"ScenarioID");
        	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            		return ;
		}
        	popComp("AlarmArgsList","/Common/Configurator/AlarmManage/AlarmArgsList.jsp","ScenarioID="+sScenarioID,"");
	}	
	function submitAlsert()
	{
			var sReturn3;
            var sSerialNo = "1111";
            var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
             
            sReturn3 = popComp("SubmitAlarm","/PublicInfo/SubmitAlarm.jsp","OneStepRun=yes&ScenarioNo="+sScenarioID+"&ObjectType=ApplySerialNo&ObjectNo="+sSerialNo,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no","");
             
            if (typeof(sReturn3)== 'undefined' || sReturn3.length == 0) 
            {
                alert("�����Ǹ���ֵĴ���");
                
            } else if (sReturn3 >= 0) //�ɹ� 
            {
                if( sReturn3 == 0 )
                 { 
                    alert("�Ѿ��ɹ��ύ��Ԥ������͵����ưɣ� ����" );    
                	 
                 }
                 else
                 {
                    alert("���뿴������Ҫ�ύ���Ԥ�������� ���� \n��ȥ��\"Ԥ���������\"ȥ���ɡ�" );    
                	                  
                 }
            } 
           
            return;    
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
