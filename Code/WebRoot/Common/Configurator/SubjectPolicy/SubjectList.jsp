<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   wlu 2009-2-17
		Tester:
		Content: ���Ŀ�Ŀ����
		Input Param:
                  
		Output param:
		

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŀ�Ŀ����"; // ��������ڱ���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//��ȡ�������
	
	//��ȡҳ�����
    
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String sHeaders[][] = {	{"SubjectNo","��Ŀ���"},
							{"SubjectName","��Ŀ����"},
							{"Attribute3","�Ƿ���Ч"},
							{"Attribute2","��ҵ��Ʒ�ַ���"},
							{"GeneralBusinessType","��ҵ��Ʒ�ַ���"},
	                       }; 

	String sSql = " select SubjectNo, SubjectName, getItemName('IsInUse',Attribute3) as Attribute3,"+
				  " Attribute2,getItemName('GeneralBusinessType',Attribute2) as GeneralBusinessType "+
				  " from SUBJECT_INFO Where 1=1 Order by SubjectNo";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "SUBJECT_INFO";
	doTemp.setKey("SubjectNo",true);	 //Ϊ�����ɾ��
	doTemp.setAlign("Attribute3,GeneralBusinessType","2");
	//������ʾ��ʽ
	doTemp.setHTMLStyle("SubjectNo,Attribute2,Attribute3"," style={width:80px} ");
	doTemp.setHTMLStyle("SubjectName"," style={width:200px} ");
	doTemp.setVisible("Attribute2",false);
	//���������б�
	doTemp.setDDDWCode("Attribute2","GeneralBusinessType");

	//filter��������
    //���˲�ѯ
 	doTemp.setFilter(Sqlca,"1","SubjectNo","");
 	doTemp.setFilter(Sqlca,"2","SubjectName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
 	doTemp.setFilter(Sqlca,"3","Attribute2","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����ҳ����ʾ������
	dwTemp.setPageSize(20);
	
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
	String sButtons[][] = 
	{
		{"true","","Button","����","����","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����/�޸�","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		
	};
        
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

		/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
		function newRecord(){
			sReturn = popComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","","");
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) {
				reloadSelf();
			}
		}

		/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
		function viewAndEdit(){
			sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
			if (typeof(sSubjectNo)=="undefined" || sSubjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}

			sReturn = popComp("SubjectInfo","/Common/Configurator/SubjectPolicy/SubjectInfo.jsp","SubjectNo="+sSubjectNo,"");
			//�޸����ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				reloadSelf();
			}
		}
    
		/*~[Describe=�ӵ�ǰ�б���ɾ���ü�¼;InputParam=��;OutPutParam=��;]~*/
		function deleteRecord(){   
			sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
			if (typeof(sSubjectNo)=="undefined" || sSubjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			if(confirm(getHtmlMessage("2")))//�������ɾ������Ϣ��
			{
				as_del("myiframe0");
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			}
		}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	function mySelectRow(){     
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
