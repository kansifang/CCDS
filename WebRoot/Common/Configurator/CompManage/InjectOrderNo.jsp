<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<script language="javascript">
<%String sCurCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CurCompID"));
	String sTargetCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetCompID"));
	String sTargetOrderNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetOrderNo"));
	String sInjectionType = DataConvert.toRealString(iPostChange,CurPage.getParameter("InjectionType"));
	if(sTargetOrderNo==null || sTargetOrderNo.equals("")){
		throw new Exception("没有接受到TargetOrderNo:"+sTargetOrderNo);
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
	
	//不允许在第一层直接插入
	if(sCurCompID.equals(sTargetCompID)){%>
		alert("请不要选择本组件！");
		top.returnValue="failed";
		<%}else if(sTargetOrderNo.indexOf(sOldOrderNo)==0){%>
		alert("请不要选择本组件及本组件的下级组件！");
		top.returnValue="failed";
		<%}else if(iTargetLength==2 && sInjectionType!=null && !sInjectionType.equals("below")){%>
		alert("请不要在第一层插入，选择明细项，或选择在“之下”插入！");
		top.returnValue="failed";
		<%}else if(sTargetOrderNo.indexOf("0")==0){%>
		alert("请不要在0开头的项“之前”、“之后”或“之下”插入。");
		top.returnValue="failed";
		<%}else if(sInjectionType!=null && sInjectionType.equals("before")){
		//将TargetComp及其之后的所有组件的SortNo的前 iTargetLength 位加10
		//长度大于等于它的 
		//modifyed by sxwang 2009.02.16 
		String sSql =  "";
		
		sSql="select OrderNo from REG_COMP_DEF "+
			" where length(OrderNo)>="+iTargetLength+" "+
			" and OrderNo>='"+sTargetOrderNo+"' "+
			" and OrderNo like '"+sOrderNoA+"%' "+
			//" and OrderNo not like '"+sOldOrderNo+"%'"//排除当前组件及下级组件
			" Order by OrderNo desc"; 	
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//位数不够，首位自动值0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
									" where OrderNo='"+sOldOrderNo1+"'";
				Sqlca.executeSQL(sUpdateSql);
			}
				
		}
		rs.getStatement().close();
		
		//获取当前组件的OrderNo
		sOldOrderNo="";
		sSql = "Select OrderNo from REG_COMP_DEF  where CompID = '"+sCurCompID+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
        	//当前组件的OrderNo更新为sTargetOrderNo
        	sSql="update REG_COMP_DEF set OrderNo='"+sTargetOrderNo+"' where CompID = '"+sCurCompID+"'";
        	Sqlca.executeSQL(sSql);
        	sNewMaxOrderNo=sTargetOrderNo;
			//更新当前组件下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之前！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}else if(sInjectionType!=null && sInjectionType.equals("after")){
		//将TargetComp及其之后的所有组件的SortNo的前 iTargetLength 位加10
		//长度大于等于它的              
		//modifyed by sxwang 2009.02.16                                     
		String sSql = "";
		sSql="select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>="+iTargetLength+" "+
		" and OrderNo>'"+sTargetOrderNo+"' "+
		" and OrderNo not like '"+sTargetOrderNo+"%' "+ //排除目标组件以及下级组件
		" and OrderNo like '"+sOrderNoA+"%' "+
		//"and OrderNo not like '"+sOldOrderNo+"%'";//排除当前组件及下级组件
		" Order by OrderNo desc";
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//位数不够，首位自动值0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"'"+
									" where OrderNo='"+sOldOrderNo1+"'";
				Sqlca.executeSQL(sUpdateSql);
			}
				
		}
		rs.getStatement().close();
	    
		//获取当前组件的OrderNo
		sOldOrderNo="";
		sSql = "Select OrderNo from REG_COMP_DEF  where CompID = '"+sCurCompID+"'";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
			//将当前组件的OrderNo更新为sTargetOrderNo+10
    		double dNewOrderNo=DataConvert.toDouble(sTargetOrderNo.substring(0,iTargetLength));
    		sNewMaxOrderNo=new DecimalFormat("##").format(dNewOrderNo+10);
    		while(sNewMaxOrderNo.length()<iTargetLength)sNewMaxOrderNo="0"+sNewMaxOrderNo;
    		sSql = "update REG_COMP_DEF set OrderNo = '"+sNewMaxOrderNo+"' where CompID = '"+sCurCompID+"'";
    		Sqlca.executeSQL(sSql);
    		//更新当前组件的下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之后！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}else if(sInjectionType!=null && sInjectionType.equals("below")){
		//将TargetComp及其之后的所有组件的SortNo加10
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
		//将当前组件的OrderNo更新为sTargetOrderNo
		sSql = "update REG_COMP_DEF set OrderNo = '"+sNewMaxOrderNo+"' where CompID = '"+sCurCompID+"'";
		Sqlca.executeSQL(sSql);
		//更新当前组件的下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之下！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%}
	//更新缓存
	(com.lmt.frameapp.config.dal.ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_COMP)).loadConfig(SqlcaRepository);%>
</script>

<script language="javascript">
	self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>
