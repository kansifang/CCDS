<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<html>
<head>
<title>Ȩ����Ϣ�б�</title>
</head>

<%
	String sObjectType  = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	String sFinishedFlag = DataConvert.toRealString(iPostChange,CurComp.getParameter("FinishedFlag"));
	String sSql="";
	
	String sHeaders[][] = { {"ObjectType","��������"},{"ObjectNo","���"},{"OrgName","����"},{"RoleID","��ɫ"},{"UserName","�û�"},{"RightType","Ȩ������"},
		{"ViewName","�ɷ�����ͼ"},{"InputUser","¼����"},{"InputOrg","¼�����"},
		{"InputTime","¼��ʱ��"},{"UpdateUser","������"},{"UpdateTime","����ʱ��"}
		};
	

	sSql = "select ObjectType,ObjectNo,OrgID,GetOrgName(OrgID) as OrgName,UserID,GetUserName(UserID) as UserName,GetViewName(ObjectType,ViewID) as ViewName,ViewID,GetItemName('RightType',RightType) as RightType,getUserName(InputUser) as InputUser,getOrgName(InputOrg) as InputOrg,InputTime,getUserName(UpdateUser) as UpdateUser,UpdateTime from OBJECT_USER where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="OBJECT_USER";
	doTemp.setKey("ObjectType,ObjectNo,OrgID,UserID,ViewID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("ObjectType,ObjectNo,OrgID,UserID,ViewID",false);
	doTemp.setRequired("ObjectType,ObjectNo,OrgID,UserID,ViewID",true);
	
	doTemp.setColumnAttribute("ObjectType,ObjectNo,OrgID,UserID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			{"true","","Button","����","����һ����¼","my_add()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","my_mod()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","my_del()",sResourcesPath}
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


<script language=javascript> 

	function my_add()
	{
		sReturn = PopPage("/Common/ObjectRight/ObjectRightDialog.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		sss = sReturn.split("@");
		sRightViewID=sss[0];
		sOrgOrInd=sss[1];
		if(sOrgOrInd==''|| sOrgOrInd.length<=0)
			return;
		OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?RightViewID="+sRightViewID+"&OrgOrInd="+sOrgOrInd+"&AddorChg=1&rand="+randomNumber(),"_self","");
		<!--AddorChg �����ж������������޸� Creat by whyu-->
	}
	function my_mod()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
		sUserID = getItemValue(0,getRow(),"UserID");
		sRightViewID = getItemValue(0,getRow(),"ViewID");
		sArgString = "&OrgID="+sOrgID+"&UserID="+sUserID+"&RightViewID="+sRightViewID;
		
		if(typeof(sOrgID)=="undefined" || sOrgID.length==0)
		{
			alert("��ѡ��һ����¼");
			return;
		}
		if(sUserID=="000000")
			OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>"+sArgString+"&OrgOrInd=2&AddorChg=2&rand="+randomNumber(),"_self","");
		else
			OpenPage("/Common/ObjectRight/ObjectRightInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewID%>"+sArgString+"&OrgOrInd=1&AddorChg=2&rand="+randomNumber(),"_self","");
		
	}
	function my_save()
	{
		as_save('myiframe0');
	}

	
	
	
	function my_del(myiframename)
	{
		
		if(confirm("�������ɾ�������뼰�������Ϣ��")) 
		{
			as_del(myiframename);
			as_save(myiframename);  //�������ɾ������Ҫ���ô����
		}

	}
	
</script>	 
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>

<%@ include file="/IncludeEnd.jsp"%>
