<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<script language="javascript">
<%String sCurCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CurCompID"));
	String sTargetCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetCompID"));
	String sTargetOrderNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetOrderNo"));
	String sInjectionType = DataConvert.toRealString(iPostChange,CurPage.getParameter("InjectionType"));
	if(sTargetOrderNo==null || sTargetOrderNo.equals("")){
		throw new Exception("û�н��ܵ�TargetOrderNo:"+sTargetOrderNo);
	}   
	int iTargetLength = sTargetOrderNo.length();
	int iLengthA = 0;
	if(iTargetLength<6)
		iLengthA=2;
	else
		iLengthA=iTargetLength-4;
	int iLengthB = iTargetLength-iLengthA;
	
	String sOrderNoA = sTargetOrderNo.substring(0,iLengthA);
	String sOldOrderNo = Sqlca.getString("select OrderNo from REG_COMP_DEF where CompID='"+sCurCompID+"'");
	
	//String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	
	//�������ڵ�һ��ֱ�Ӳ���
	if(sCurCompID.equals(sTargetCompID)){%>
		alert("�벻Ҫѡ�������");
		top.returnValue="failed";
		<%}else if(sTargetOrderNo.indexOf(sOldOrderNo)==0){%>
		alert("�벻Ҫѡ���������������¼������");
		top.returnValue="failed";
		<%}else if(iTargetLength==2 && sInjectionType!=null && !sInjectionType.equals("below")){%>
		alert("�벻Ҫ�ڵ�һ����룬ѡ����ϸ���ѡ���ڡ�֮�¡����룡");
		top.returnValue="failed";
		<%}else if(sTargetOrderNo.indexOf("0")==0){%>
		alert("�벻Ҫ��0��ͷ���֮ǰ������֮�󡱻�֮�¡����롣");
		top.returnValue="failed";
		<%}else if(sInjectionType!=null && sInjectionType.equals("before")){
		//��TargetComp����֮������������SortNo��ǰ iTargetLength λ��10
		//���ȴ��ڵ������� 
		//modifyed by sxwang 2009.02.16 
		String sSql =  "";
		
		sSql="select OrderNo from REG_COMP_DEF "+
			" where length(OrderNo)>="+iTargetLength+" "+
			" and OrderNo>='"+sTargetOrderNo+"' "+
			" and OrderNo like '"+sOrderNoA+"%' "+
			//" and OrderNo not like '"+sOldOrderNo+"%'"//�ų���ǰ������¼����
			" Order by OrderNo desc"; 	
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//λ����������λ�Զ�ֵ0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
									" where OrderNo='"+sOldOrderNo1+"'";
				Sqlca.executeSQL(sUpdateSql);
			}
				
		}
		rs.getStatement().close();
		
		//��ȡ��ǰ�����OrderNo
		sOldOrderNo="";
		sSql = "Select OrderNo from REG_COMP_DEF  where CompID = '"+sCurCompID+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
        	//��ǰ�����OrderNo����ΪsTargetOrderNo
        	sSql="update REG_COMP_DEF set OrderNo='"+sTargetOrderNo+"' where CompID = '"+sCurCompID+"'";
        	Sqlca.executeSQL(sSql);
        	sNewMaxOrderNo=sTargetOrderNo;
			//���µ�ǰ����¼����
    		sSql="select OrderNo from REG_COMP_DEF "+
    			" where OrderNo like '"+sOldOrderNo+"%'and length(OrderNo)>"+sOldOrderNo.length()+
    			" order by OrderNo desc";
    		rs=Sqlca.getASResultSet(sSql);
    		while(rs.next()){
    			String sOldOrderNo1=rs.getString("OrderNo");
    			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
    			String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
    			" where OrderNo='"+sOldOrderNo1+"'";
    			Sqlca.executeSQL(sUpdateSql);
    		}
    		rs.getStatement().close();
        }%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮ǰ��");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}else if(sInjectionType!=null && sInjectionType.equals("after")){
		//��TargetComp����֮������������SortNo��ǰ iTargetLength λ��10
		//���ȴ��ڵ�������              
		//modifyed by sxwang 2009.02.16                                     
		String sSql = "";
		sSql="select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>="+iTargetLength+" "+
		" and OrderNo>'"+sTargetOrderNo+"' "+
		" and OrderNo not like '"+sTargetOrderNo+"%' "+ //�ų�Ŀ������Լ��¼����
		" and OrderNo like '"+sOrderNoA+"%' "+
		//"and OrderNo not like '"+sOldOrderNo+"%'";//�ų���ǰ������¼����
		" Order by OrderNo desc";
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//λ����������λ�Զ�ֵ0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
									" where OrderNo='"+sOldOrderNo1+"'";
				Sqlca.executeSQL(sUpdateSql);
			}
				
		}
		rs.getStatement().close();
	    
		//��ȡ��ǰ�����OrderNo
		sOldOrderNo="";
		sSql = "Select OrderNo from REG_COMP_DEF  where CompID = '"+sCurCompID+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
			//����ǰ�����OrderNo����ΪsTargetOrderNo+10
    		double dNewOrderNo=DataConvert.toDouble(sTargetOrderNo.substring(0,iTargetLength));
    		sNewMaxOrderNo=new DecimalFormat("##").format(dNewOrderNo+10);
    		while(sNewMaxOrderNo.length()<iTargetLength)sNewMaxOrderNo="0"+sNewMaxOrderNo;
    		sSql = "update REG_COMP_DEF set OrderNo = '"+sNewMaxOrderNo+"' where CompID = '"+sCurCompID+"'";
    		Sqlca.executeSQL(sSql);
    		//���µ�ǰ������¼����
    		sSql="select OrderNo from REG_COMP_DEF "+
    		" where OrderNo like '"+sOldOrderNo+"%'and length(OrderNo)>"+sOldOrderNo.length()+
    		" Order by OrderNo desc";
    		rs=Sqlca.getASResultSet(sSql);
    		while(rs.next()){
    			String sOldOrderNo1=rs.getString("OrderNo");
    			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
    			String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
    			" where OrderNo='"+sOldOrderNo1+"'";
    			Sqlca.executeSQL(sUpdateSql);
    		}
    		rs.getStatement().close();
        }%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮��");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}else if(sInjectionType!=null && sInjectionType.equals("below")){
		//��TargetComp����֮������������SortNo��10
		//modifyed by sxwang 2009.02.16 
		String sSql = "select max(OrderNo) from REG_COMP_DEF where OrderNo like '"+sTargetOrderNo+"%' and length(OrderNo)="+(sTargetOrderNo.length()+4);
		String sMaxOrderNo = Sqlca.getString(sSql);
		
		String sNewMaxOrderNo = "";
		if(sMaxOrderNo==null || sMaxOrderNo.equals(""))
			sNewMaxOrderNo = sTargetOrderNo+"0010";
		else{
			sNewMaxOrderNo = String.valueOf(Long.parseLong(sMaxOrderNo)+10);
			while(sNewMaxOrderNo.length()<iTargetLength+4)sNewMaxOrderNo="0"+sNewMaxOrderNo;
		}
		//����ǰ�����OrderNo����ΪsTargetOrderNo
		sSql = "update REG_COMP_DEF set OrderNo = '"+sNewMaxOrderNo+"' where CompID = '"+sCurCompID+"'";
		Sqlca.executeSQL(sSql);
		//���µ�ǰ������¼����
		sSql="select OrderNo from REG_COMP_DEF "+
		" where OrderNo like '"+sOldOrderNo+"%'and length(OrderNo)>"+sOldOrderNo.length()+
		" Order by OrderNo desc";
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
			String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
			" where OrderNo='"+sOldOrderNo1+"'";
			Sqlca.executeSQL(sUpdateSql);
		}
		rs.getStatement().close();%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮�£�");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}
	//���»���
	(com.lmt.frameapp.config.dal.ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_COMP)).loadConfig(SqlcaRepository);%>
</script>

<script language="javascript">
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
