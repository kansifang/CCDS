<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   wlu 2009-02-13
			Tester:
			Content: ���������б�
			Input Param:
	                  
			Output param:             


		 */
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��Ȩ�����б�"; // ��������ڱ���
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
	
	//��ȡҳ�����
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {	
					{"SerialNo","���"},
					{"AuthorizationType","��Ȩ����"},
					{"AuthorizationTypeName","��Ȩ����"},
					{"UserID","�û���"},
					{"BusinessType","ҵ��Ʒ��"},
					{"BusinessSumCurrency","��Ȩ������"},
					{"BusinessSum","��Ȩ���"},
					{"BusinessExposureCurrency","��Ȩ���ڽ�����"},
					{"BusinessExposure","��Ȩ���ڽ��"}													
	                       }; 

	String sSql = " select SerialNo,AuthorizationType,getItemName('AuthorizationType',AuthorizationType) as AuthorizationTypeName, "+
		  " getUserName(UserID) as UserID, getBusinessName(BusinessType) as BusinessType,"+
		  " getItemName('Currency',BusinessSumCurrency) as BusinessSumCurrency, BusinessSum, "+
		  " getItemName('Currency',BusinessExposureCurrency) as BusinessExposureCurrency,BusinessExposure "+
		  " from USER_AUTHORIZATION "+
		  " where 1=1 order by SerialNo";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "USER_AUTHORIZATION";
	doTemp.setKey("SerialNo",true);	 //Ϊ�����ɾ��

	//���ò��ɼ���
	doTemp.setVisible("AuthorizationType",false);
	//���������б�
	doTemp.setDDDWCode("AuthorizationType","AuthorizationType");	
	//������ʾ��
	doTemp.setUpdateable("UserID,BusinessType",false);
	doTemp.setHTMLStyle("AuthorizationTypeName,BusinessSumCurrency,BusinessExposureCurrency"," style={width:80px} ");
	doTemp.setHTMLStyle("SerialNo,BusinessType,UserID,BusinessSum,BusinessExposure"," style={width:150px} ");
	doTemp.setType("BusinessSum,BusinessExposure","number");
	doTemp.setAlign("BusinessSum,BusinessExposure","3");
	doTemp.setAlign("AuthorizationTypeName,BusinessSumCurrency,BusinessExposureCurrency","2");

	//filter��������
    doTemp.setFilter(Sqlca,"1","UserID","");
 	doTemp.setFilter(Sqlca,"2","BusinessType","");
 	doTemp.setFilter(Sqlca,"3","AuthorizationType","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
		String sButtons[][] = 
		{
			{"true","","Button","����","������Ȩ","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴����/�޸�","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ������Ȩ","deleteRecord()",sResourcesPath},
			
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

		/*~[Describe=������Ȩ��¼;InputParam=��;OutPutParam=��;]~*/
		function newRecord(){
			sReturn = popComp("AuthorizationInfo","/Common/Configurator/Authorization/AuthorizationInfo.jsp","","");
			reloadSelf();
		}

		/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
		function viewAndEdit(){
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}

			sReturn = popComp("AuthorizationInfo","/Common/Configurator/Authorization/AuthorizationInfo.jsp","SerialNo="+sSerialNo,"");
			//�޸����ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				reloadSelf();
			}
		}
    
		/*~[Describe=�ӵ�ǰ�б���ɾ���ü�¼;InputParam=��;OutPutParam=��;]~*/
		function deleteRecord(){   
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
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
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	function mySelectRow(){     
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
