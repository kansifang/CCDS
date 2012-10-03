<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%!
public void genChapterNo(String sCriteria,Transaction Sqlca)
	throws Exception
{
	int i = 0;
	int iCurLevelLen = 0;
	int iParentLevelLen = 0;
	int iNumberLevel = 0;
	int iLevel[];
	ASResultSet rs,rs1,rs2;
	String sSql;
	String sCurLevelChapterNo="",sParentLevelChapterNo="";
	String sParentSortNo="";
	
	sSql = "select count(*) from OBJECT_LEVEL where ObjectType = 'Comment' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()) iNumberLevel = rs.getInt(1);
	rs.getStatement().close();
	
	iLevel = new int[iNumberLevel];
	
	//����ÿһ�㣬ѭ�������½ں�
	sSql = "select CodeLength from OBJECT_LEVEL where ObjectType = 'Comment' order by ObjectLevel";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		iParentLevelLen = iCurLevelLen;
		iCurLevelLen = rs.getInt("CodeLength");
		
		//��ȡ������½ں�
		sSql = "select SortNo,ChapterNo,'.' as Seperator from REG_COMMENT_ITEM  where Length(SortNo)="+iParentLevelLen+" and DoGenHelp='true' " +sCriteria+ " order by SortNo";
		
		//����ǵ�һ��
		if(i==0){
			sSql = "select '' as SortNo,'' as ChapterNo,'' as Seperator from ROLE_INFO where RoleID='800' ";
		}
		//System.out.println("parent chapter SQL:"+sSql);
		rs1=Sqlca.getASResultSet(sSql);
		while(rs1.next()){
			sParentSortNo = DataConvert.toString(rs1.getString("SortNo"));
			sParentLevelChapterNo = DataConvert.toString(rs1.getString("ChapterNo"));
			iLevel[i]=1;
			
			if(sParentSortNo==null) sParentSortNo="";
			
			sSql = "select CommentItemID,SortNo,ChapterNo from REG_COMMENT_ITEM  where Length(SortNo)="+iCurLevelLen+" and SortNo like '"+sParentSortNo+"%' and DoGenHelp='true' " +sCriteria+ " order by SortNo";
			rs2=Sqlca.getASResultSet(sSql);
			while(rs2.next()){
				sCurLevelChapterNo = sParentLevelChapterNo + DataConvert.toString(rs1.getString("Seperator")) + iLevel[i]++;
				sSql = "update REG_COMMENT_ITEM set ChapterNo = '"+sCurLevelChapterNo+"' where CommentItemID='"+rs2.getString("CommentItemID")+"'";
				Sqlca.executeSQL(sSql);
			}
			rs2.getStatement().close();
			
		}
		rs1.getStatement().close();
		i++;
	}
	rs.getStatement().close();
	

}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>�ޱ����ĵ�</title>
<script language="javascript">
function downloadAsWord(){
	alert("˵����\n\n 1 ѡ���ļ�-���Ϊ�����ļ�����ѡ��mht����\n\n 2 ʹ��word�򿪸��ļ���\n\n 3 ����������ļ���ʼ���ϣ�ѡ�񡰲���-����-������Ŀ¼-Ŀ¼���� \n\n 4 ����ʹ�ó�������ʹ��ҳ�롱ѡ��ȥ���� \n\n 5 ���Ϊdoc�ĵ���\n\n");
	OpenComp("GenerateDoc","/Common/help/GenerateDoc.jsp","","downloadAsWord","");
}
</script>
</head>

<body class="pagebackground" leftmargin="0" topmargin="0">
<%
	String sAction = DataConvert.toRealString(iPostChange,request.getParameter("Action"));
	String sGenCriteria = DataConvert.toRealString(iPostChange,request.getParameter("GenCriteria"));
	if(sGenCriteria==null) sGenCriteria="";
	if(sAction!=null && sAction.equals("GenerateChapterNo")){
		genChapterNo(sGenCriteria,Sqlca);
		out.println("Chapter number updated.");
	}
%>
    	<table>
	    	<tr>
	 		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","HyperLinkText","����","����","javascript:downloadAsWord()",sResourcesPath)%></td>
    		</tr>
    	</table>

</html>
<%@ include file="/IncludeEnd.jsp"%>