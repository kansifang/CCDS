<%
/* Copyright 2001-2006 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author:  hldu 2012.09.28
 * Tester:
 *
 * Content: ���пͻ��������������л�  		
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,com.amarsoft.biz.bizlet.Bizlet" %>


<%
    //��ȡ������
    String sInitFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
    if(sInitFlag == null) sInitFlag = "";
    String sFlag="";
    System.out.println(sInitFlag);
   	//������ʼ	
    boolean bOld = Sqlca.conn.getAutoCommit();
    Sqlca.conn.setAutoCommit(false);
    try{
    	if("1".equals(sInitFlag)){
    		//��������������ģ��,ͣ�þ���������ģ��
    		Sqlca.executeSQL(" update code_library set IsInuse = Case "+
    				         " when (itemno like '11%' or itemno like '31%' or itemno like '51%' or itemno like '21%') then '1' "+
                             " when (itemno like '50%' or itemno like '10%' or itemno like '30%' or itemno like '20%') then '2' "+
                             " else IsInuse end where codeno in ('IndCreditTempletType','CreditTempletType') ");
    		//����evaluate_catalog�����ֿ�ģ������
    		Sqlca.executeSQL(" update evaluate_catalog set ModelType = case "+ 
    				         " when ModelNo like '11%' then '010' "+ 
    				         " when ModelNo like '31%' then '010' "+
    				         " when ModelNo like '51%' then '015' "+
    				         " when ModelNo like '21%' then '017' "+
    				         " else ModelType end where ModelNo like '_1_' ");
    		//added by bllou 2012-10-25 �л��󣬿ͻ���������ģ�����˵�����ģ������ �� 910,915,917��Ϊ010,015,017
    		Sqlca.executeSQL(" update Code_Library set ItemDescribe = replace(ItemDescribe,'9','0')"+
    						" where (codeno in ('EnterpriseView','EntFinanceView') and itemno = '070025') "+
    						"or (codeno = 'IndView' and itemno = '055030') ");
    		//Sqlca.executeSQL(" update  code_library set IsInuse = '1' where  (codeno = 'EnterpriseView' and itemno ='070025') or  (codeno = 'IndView' and itemno ='055030') or (codeno = 'EntFinanceView' and itemno ='070025') ");
    		//���remark�¼�¼
    		Sqlca.executeSQL(" update code_library set remark = '' where codeno in ('IndCreditTempletType','CreditTempletType') "+
    				         " and (itemno like '51%' or itemno like '21%' or itemno like '31%' or itemno like '11%' or itemno in ('1','2','3'))");
    		//������Ϣģ��--IndividualInfo�����õȼ�����ģ�����ơ����Ӻ�׺���Ǹ���ģ���ѡ EnterpriseInfo01-����..,EnterpriseInfo03-��ҵ��λ..ģ��ȥ����׺ģ��ϵͳ��ֵ
    		Sqlca.executeSQL(" update dataobject_library  set colunit = case "+
                             " when dono = 'IndividualInfo' then '<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCreditTempletType()>' "+
                             " when dono = 'EnterpriseInfo01' then '' "+
                             " when dono = 'EnterpriseInfo03' then '' "+
                             " else colunit end where dono in ('IndividualInfo','EnterpriseInfo01','EnterpriseInfo03') and colname = 'CreditBelongName' ");
		}else if("2".equals(sInitFlag)){
			Sqlca.executeSQL(" ");
		}	
		//�����ύ
        Sqlca.conn.commit();
        Sqlca.conn.setAutoCommit(bOld);
        sFlag="00";
	}catch(Exception e)
	{
		sFlag="99";
		//����ع�
        Sqlca.conn.rollback();
        Sqlca.conn.setAutoCommit(bOld);
		throw new Exception("�����ʼ����"+e.getMessage());
	}
%>

<script language=javascript>
	self.returnValue = "<%=sFlag%>";
    self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>