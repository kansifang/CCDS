<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Dialog00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zxu 2005-03-11
		Tester:
		Content: ���Ϸ��Բ�ע��Ȩ�޵�
		Input Param:
                  
		Output param:
		                
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������

	
	//����������	
	String sSightSetID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightSetID"));
	String sSightID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SightID"));
	String sOper = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Oper"));
	if(sSightSetID==null) sSightSetID="";
	if(sSightID==null) sSightID="";
	if(sOper==null) sOper="Y";
%>
<%/*~END~*/%>

<%
	if( sOper.equals("N") ) {
		if( sSightSetID.length() != 0 && sSightID.length() != 0 )
			Sqlca.executeSQL("update DS_Sight set EffStatus = '0' where SightSetId = '"+sSightSetID+"' and SightId = '"+sSightID+"' ");

		%>
		<script language="javascript">
		self.returnValue="succeeded";
		self.close();
		</script>
		<%
	}else{
%>
<html>
<head>
<title>�����Ұ������ע��Ȩ�޵�</title> 
<script language="javascript">
function doReturn(){
	self.close();
}
</script>
</head>
<body class="InfoPage" leftmargin="0" topmargin="0" >
<table border="0" width="60%" height="20%" cellspacing="0" cellpadding="0">
	<tr height=1 >
	    <td id="InfoTitle" class="InfoTitle">
	    </td>
	</tr>
	<tr>
		<td>
		<!--��Ϣ��ʾ��-->
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=���Ϸ��Լ�ע��Ȩ��;]~*/%>
<%	
	boolean flag = true;
	String sSightWhereClause = null;
        try{
		int i = 0;
		sSightWhereClause = Sqlca.getString("select SightWhereClause from DS_SIGHT where SightSetId = '"+sSightSetID+"' and SightId = '" + sSightID + "'");
		if(sSightWhereClause==null) sSightWhereClause="";
	        //����Ұ�������ȡȨ����Ϣ
	        String sMacroParams = Sqlca.getString("select MacroParams from DS_SIGHT_SET where SightSetId = '"+sSightSetID+"'");
	        if( sMacroParams == null ){
	            out.println("����Ұ��["+sSightSetID+"]�û���δ���壬�붨���ȣ�");
	        }
	        sMacroParams = sMacroParams.trim();
		sSightWhereClause = sSightWhereClause.trim();
	
	        //���ú��滻���õ�Attribute
	        int iAttrSize = StringFunction.getSeparateSum(sMacroParams,",");
	        String[][] ssAttribute = new String[iAttrSize][2];
	        for( i = 0; i < iAttrSize; i++ ){
	            ssAttribute[i][0] = "#{"+StringFunction.getSeparate(sMacroParams,",",i+1)+"}";
		    ssAttribute[i][1] = "0";
	        }
	        int iPosBegin=0,iPosEnd=0;
	        String sAttributeID="";
		String sAttrValue=null;
		String sReTemp = sSightWhereClause;
        
	        while((iPosBegin=sReTemp.indexOf("#{",iPosBegin))>=0){
	            iPosEnd = sReTemp.indexOf("}",iPosBegin);
	            sAttributeID = sReTemp.substring(iPosBegin,iPosEnd+"}".length());
		    sAttrValue = StringFunction.getAttribute(ssAttribute,sAttributeID,0,1);
	            sReTemp = sReTemp.substring(0,iPosBegin) + sAttrValue + sReTemp.substring(iPosEnd+"}".length());
		    if( sAttrValue == null )
		    {
			out.println("ȱ�ٺ궨�������" + sAttributeID );
			flag = false;
			%>
			<script language="javascript">
			self.returnValue="failed";
			</script>
			<%
	            }
		}
        }catch(Exception ex){
		out.println("�����Ӿ��﷨����:"+sSightWhereClause + ",��Ϣ��"+ex.getMessage());
		flag = false;
		%>
		<script language="javascript">
		self.returnValue="failed";
		</script>
		<%
        }
	if( flag ) {
		//���ͨ����ע��Ȩ�޵㣬��������Ұ���е�Ȩ���ֶ�
		String sRightId = "��Ұ-" + sSightSetID + "-" + sSightID;
	
		try{
			Sqlca.conn.setAutoCommit(false);
			int rowCount=0;
			String sTmpRightID = Sqlca.getString("select RightId from Right_Info where RightID = '"+sRightId+"'");
			if( sTmpRightID == null ) {
				rowCount = Sqlca.executeSQL("insert into Right_Info (RightID,RightName,RightStatus,InputTime,InputUser,InputOrg) values('"+sRightId + "','" + sRightId + "','1','"+ StringFunction.getToday() +"','"+CurUser.UserID+"','"+CurOrg.OrgID+"')");
			}
			rowCount += Sqlca.executeSQL("update DS_Sight set RightId = '"+sRightId+"', EffStatus = '1' where SightSetId = '"+sSightSetID+"' and SightId = '"+sSightID+"' ");

			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(true);
			out.println("�﷨���ͨ����ע��Ȩ�޳ɹ���");
			%>
			<script language="javascript">
			self.returnValue="succeeded";
			</script>
			<%
	        }catch(Exception exx){
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(true);
			out.println("ע��Ȩ�޵�:"+sRightId + "ʱ���ݿ��������" + exx.getMessage());
			%>
			<script language="javascript">
			self.returnValue="failed";
			</script>
			<%
	        }
	}
	
%>

		</td>
		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript:doReturn()",sResourcesPath)%></td>
	</tr>
</table>
</body>
</html>
<%
	} // END for if( sOper.equals("N") )
%>

<%/*~END~*/%>
		
<%@ include file="/IncludeEnd.jsp"%>
