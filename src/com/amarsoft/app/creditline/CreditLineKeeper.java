/***********************************************************************
 * Module:  CreditLineKeeper.java
 * Author:  William
 * Modified: 2005.6.10 18:19:23
 * Purpose: Defines the Class CreditLineKeeper
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.are.ASException;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.web.config.ASConfigure;

public abstract class CreditLineKeeper implements ICreditLineKeeper {
	private CreditLine line;

	/** @param Sqlca 
	 * @throws Exception */
	public abstract Vector checkLimitations(Transaction Sqlca,String sObjectType,String sObjectNo) throws Exception;

	public final void setCreditLine(CreditLine cl) {
		this.line = cl;
	}

	/** @param Sqlca */
	public abstract double calcBalance(Transaction Sqlca) throws Exception;

	/**
	 * @param Sqlca
	 * @param BalanceID
	 * @throws Exception
	 */
	public abstract double calcBalance(Transaction Sqlca, String BalanceID)
			throws Exception;


	public abstract Vector checkLine(Transaction Sqlca,String sObjectType,String sObjectNo)
			throws Exception;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.amarsoft.app.creditline.ICreditLineKeeper#check(com.amarsoft.are.sql.Transaction,
	 *      java.lang.String, java.lang.String)
	 */
	public final Vector check(Transaction Sqlca,String Options, String ObjectType,String ObjectNo) throws Exception {
		if (this.getCreditLine().getCurCheckNo() == null) {
			throw new ASException("��ǰ�����δ���롰��顱״̬����ͨ�� enterCheckMode()������״̬��");
		}
		Vector errors = new Vector();

//		 ִ�ж���������������ж�
		try {
			Vector lineErrors = checkLine(Sqlca,ObjectType,ObjectNo);
			for(int i=0;i<lineErrors.size();i++){
				String error=(String)lineErrors.get(i);
				if(error!=null && error.length()>0) errors.add(error);
			}
		} catch (Exception ex) {
			throw new ASException("������������ж�ʱ����" + ex.getMessage());
		}

//		 ִ�и������������ж�
		try {
			Vector limitationErrors = checkLimitations(Sqlca,ObjectType,ObjectNo);
			for(int i=0;i<limitationErrors.size();i++){
				String error=(String)limitationErrors.get(i);
				if(error!=null && error.length()>0) errors.add(error);
			}
		} catch (Exception ex) {
			throw new ASException("������������ж�ʱ����" + ex.getMessage());
		}
		
		//��¼������־
		String sLogOption = StringFunction.getProfileString(Options,"LOG");
		if(sLogOption!=null && sLogOption.equalsIgnoreCase("Y"))
		{
			logError(Sqlca,errors);
		}else{
			Sqlca.executeSQL("delete from CL_CHECK_LOG " +
					"where LineID='"+this.getCreditLine().id()+"' " +
							"and CheckNo='"+this.getCreditLine().getCurCheckNo()+"'");
		}
		return errors;
	}

	public CreditLine getCreditLine() throws Exception {
		if (this.line == null)
			throw new ASException("Keeperû�л�õ����ʵ����");
		return this.line;
	}
	private void logError(Transaction Sqlca,Vector errors) throws Exception{
//		��¼�����־
		ASValuePool errorTypes = ASConfigure.getSysConfig("SYSCONF_CL_ERROR_TYPE",Sqlca);
		String sCurCheckLog = this.getCreditLine().getCurCheckNo();
		String sSql = null;
		int heighestErrorLevel = 0;
		for(int i=0;i<errors.size();i++){
			String sErrorString = (String)errors.get(i);
			String sErrorType = StringFunction.getProfileString(sErrorString,"ErrorType");
			String sMeasureColumn = StringFunction.getProfileString(sErrorString,"MeasureColumn");
			String sLimitationSetID = StringFunction.getProfileString(sErrorString,"LimitationSetID");
			String sLimitationID = StringFunction.getProfileString(sErrorString,"LimitationID");
			
			if(sErrorType==null || sErrorType.equals("")) throw new ASException("�쳣��������("+sErrorString+")��δ�ҵ����͹ؼ��֣�ErrorType��");
			if(!errorTypes.containsKey(sErrorType)){
				throw new ASException("δ������쳣�����ͣ�"+sErrorType+"�������쳣�㶨���(CL_ERROR_TYPE)");
			}
			String sSerialNo = DBFunction.getSerialNo("CL_ERROR_LIST","ErrorNo","",Sqlca);
			sSql = "insert into CL_ERROR_LIST" +
					"(LineID," +
					"CheckNo," +
					"ErrorNo," +
					"ErrorTypeID," +
					"MeasureColumn," +
					"LimitationSetID," +
					"LimitationID" +
					") values(" +
					"'"+this.getCreditLine().id()+"'," +
					"'"+sCurCheckLog+"'," +
					"'"+sSerialNo+"'," +
					"'"+sErrorType+"'," +
					"'"+sMeasureColumn+"'," +
					"'"+sLimitationSetID+"'," +
					"'"+sLimitationID+"'" +
					")";
			Sqlca.executeSQL(sSql);

			//ͨ���Ƚϣ������쳣����߼���
			int errorLevel = this.getErrorLevel(sErrorType,errorTypes);
			if(errorLevel>heighestErrorLevel) heighestErrorLevel = errorLevel;
			
		}
		//����CL_CHECK_LOG�쳣����߼���
		sSql = "update CL_CHECK_LOG set ErrorLevel='"+heighestErrorLevel+"' " +
				"where LineID='"+this.getCreditLine().id()+"' " +
						"and CheckNo='"+this.getCreditLine().getCurCheckNo()+"'";
		Sqlca.executeSQL(sSql);
	}
	
	private int getErrorLevel(String sErrorType,ASValuePool errorTypes) throws Exception {
		int errorLevel = 0;
		ErrorType errorType = (ErrorType)errorTypes.getAttribute(sErrorType);
		String sErrorLevel = (String)errorType.getAttribute("ErrorLevel");
		if(sErrorLevel==null) sErrorLevel="0";
		errorLevel = Integer.parseInt(sErrorLevel);
		
		return errorLevel;
	}
	

}