<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=ע����;]~*/%>
<%
/* 
  author:  --fbkang 2005-7-25 
  Tester:
  Content:  У���Ƿ����ɾ������Ŀ
  Input Param:
			--ObjectType  ����������
			--ObjectNo    : ������
            --ProjectNo   ����Ŀ���
  Output param:
 
  History Log:     

               
 */
 %>
<%/*~END~*/%>

<%     
	
    //�������
    ASResultSet rs = null;
    int iCount = 0;
    String sSql = "";
    String sreturnvalue = "";
    //���ҳ�����,��Ŀ��š������š�
	String sProjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
   	if(sProjectNo == null) sProjectNo = "";
   	if(sObjectNo == null) sObjectNo = "";
   	//����������
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    if(sObjectType == null) sObjectType = "";
    sSql= " select count(ProjectNo) from PROJECT_RELATIVE "+
    	  " where ProjectNo='"+sProjectNo+"' and " +
	      " (ObjectType ='CreditApply' "+
	      " or ObjectType ='AfterLoan') ";
	
	rs = Sqlca.getResultSet(sSql);
	if(rs.next())
		iCount = rs.getInt(1);
	    
	rs.getStatement().close();
	//����ǿͻ���Ϣ����
	if (sObjectType.equals("Customer"))
	{
		//������ҵ���������ɾ��
		if (iCount>0)
		  sreturnvalue="NO";
		//���û��ҵ�����������ȫɾ��
		else
		  sreturnvalue="YES";
	}else //�����ҵ����룬ֻ��ɾ������Ŀ�Ĺ�������  
	    sreturnvalue="YES";   
	      
 %>

<script language=javascript>
	sreturnvalue="<%=sreturnvalue%>";
	self.returnValue=sreturnvalue;	
	self.close();
		
</script>


<%@ include file="/IncludeEnd.jsp"%>