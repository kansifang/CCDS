package com.amarsoft.datainit.impawn;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.ars.jxl.core.Cell;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ExcelImport;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class ImpawnExcelImport extends ExcelImport{
	private String[] sTables=new String[]{"Impawn_Total_Import"};
	/**
	 * ����xls �����ݲ������ݱ���
	 * @throws Exception 
	 */
	public ImpawnExcelImport(Transaction Sqlca, String[] files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new ImpawnExcelResultSet(Sqlca,CurUser));
	}
	public boolean checkHead() throws Exception{
		int iCount=0;
		boolean isPass=true;
		Cell[]headrow =this.ERS.getSheet().getRow(0);
		// �ϴ��ļ��ĸ�ʽ�Ƿ����
		for (int iColumns = 0; iColumns < headrow.length; ++iColumns) {
			String temp = headrow[iColumns].getContents().trim();
			if (temp.equals("�Ŀ�ƾ֤���")){
				iCount++;
				if(!headrow[++iColumns].getContents().trim().equals("�Ŀ��ǩ��")
						|| !headrow[++iColumns].getContents().trim().equals("�������")
						|| !headrow[++iColumns].getContents().trim().equals("�Ŀ�ƾ֤���")
						|| !headrow[++iColumns].getContents().trim().equals("�Ŀ�ƾ֤����")
						|| !headrow[++iColumns].getContents().trim().equals("���������")
						|| !headrow[++iColumns].getContents().trim().equals("����������")
						|| !headrow[++iColumns].getContents().trim().equals("������")
						|| !headrow[++iColumns].getContents().trim().equals("����Ա")
						|| !headrow[++iColumns].getContents().trim().equals("Ȩ֤���")
						|| !headrow[++iColumns].getContents().trim().equals("Ȩ֤����")
						|| !headrow[++iColumns].getContents().trim().equals("Ȩ֤����")
						|| !headrow[++iColumns].getContents().trim().equals("����ѺȨ����ʼ����")
						|| !headrow[++iColumns].getContents().trim().equals("����ѺȨ����������")
						|| !headrow[++iColumns].getContents().trim().equals("Ȩ����ֵ��Ȩ֤�б�ע��Ҫ��д��")
						|| !headrow[++iColumns].getContents().trim().equals("Ȩ����ֵ����") 
						|| !headrow[++iColumns].getContents().trim().equals("��֤����")){
					isPass=false;
				}
			}
		}
		if(iCount==0){
			isPass=false;
		}
		return isPass;
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		int currentrow=this.ERS.getCurrentRow()+1;
		//����Ѻ���Ų���Ϊ��
		String sImpawnID1=DataConvert.toString(this.ERS.getStringWH("��Ѻ����"));
		String sImpawnID2=DataConvert.toString(this.ERS.getStringWH("��Ѻ����"));
		if(sImpawnID1.length()==0&&sImpawnID2.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǵ�Ѻ���Ż���Ѻ���Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//�Ŀ�ƾ֤�Ų���Ϊ��
		String sPackageNo=DataConvert.toString(this.ERS.getStringWH("�Ŀ�ƾ֤���"));
		if(sPackageNo.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǣ��Ŀ�ƾ֤��Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//�Ŀ�ƾ֤�Ų���Ϊ��
		String sRightDoc=DataConvert.toString(this.ERS.getStringWH("Ȩ֤����"));
		String sRightDocNo=DataConvert.toString(this.ERS.getStringWH("Ȩ֤���"));
		if(sRightDoc.length()==0||sRightDocNo.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǣ��Ŀ�ƾ֤��Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//������Ѻ�����ͱ���ͱ�����ͬ
		String sImpawnType1=DataConvert.toString(this.ERS.getStringWH("��Ѻ������"));
		String sImpawnType2=DataConvert.toString(this.ERS.getStringWH("��Ѻ������"));
		String sSheetName=this.ERS.getSheet().getName();
		if(!sImpawnType1.equals(this.ERS.getSheet().getName())&&!sImpawnType2.equals(this.ERS.getSheet().getName())){
			throw new Exception("��ȷ�ϱ���"+sSheetName+"������������е�"+currentrow+"��-"+this.ERS.getRowSize()+"�С���Ѻ�����͡�����Ѻ�����͡��Ƿ�һ��?���������������ѡ����Щ�е���Ҽ�����ɾ����");
		}
		return isPass;
	}
	/**
	 * ƴ��SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importObj() throws Exception {
		// ѺƷ��������
		HashMap<String, String> mm0 = null;
		for(String sTable:sTables){
			PreparedStatement ps=this.ERS.getPs().get(sTable);
			//����excel���ݵ����ݿ���ʱ����
			String sImpawnID =DataConvert.toString(this.ERS.getStringWH("��Ѻ����"));
			sImpawnID=sImpawnID.length()==0?DataConvert.toString(this.ERS.getStringWH("��Ѻ����")):sImpawnID;
			String sMFCustomerID = "";
			String sApplySerialNo = "";
			String sLineManID = "";
			String sImpawnStatus = "";
			ASResultSet rs = Sqlca.getASResultSet("select GI.GuarantyStatus," +
								" getMFCustomerID(BCC.CustomerID) as MFCustomerID,"
								+ " BCC.CustomerID,"
								+ " getCustomerName(BCC.CustomerID),"
								+ " BCC.SerialNo,"
								+ " BCC.ApplySerialNo,"
								+ " BCC.LineManID"
								+ " from Guaranty_Info GI,Guaranty_Relative GR,Business_ContractCLInfo BCC"
								+ " where GI.GuarantyID='"+sImpawnID+"'"
								+ " and GI.GuarantyID=GR.GuarantyID"
								+ " and GR.ObjectType in('BusinessContract','CBBusContract')"
								+ " and GR.ObjectNo=BCC.RelativeSerialNo"
								+ " and BCC.SerialNo=BCC.CreditAggreeMent");
			if (rs.next()) {
				sMFCustomerID = DataConvert.toString(rs.getString("MFCustomerID"));
				sApplySerialNo = DataConvert.toString(rs.getString("ApplySerialNo"));
				sLineManID = DataConvert.toString(rs.getString("LineManID"));
				sImpawnStatus = DataConvert.toString(rs.getString("GuarantyStatus"));
			}
			rs.getStatement().close();
			// �ܵ���ʱ��
			String sSeriaNo = DBFunction.getSerialNo("Impawn_Total_Import", "SerialNo", Sqlca);//�����������������к�
			mm0 =new HashMap<String, String>();
			mm0.put("SerialNo", sSeriaNo);
			mm0.put("ObjectType", "ImpawnInApply");
			mm0.put("MFCustomerID", sMFCustomerID);
			mm0.put("ApplySerialNo", sApplySerialNo);
			mm0.put("RightDocStatus", "0103");//�����
			mm0.put("LineManID", sLineManID);
			mm0.put("ImpawnStatus", sImpawnStatus);//ԭGuaranty_Info�е�״̬
			mm0.put("PackageStatus", "0103");//�����
			mm0.put("ImpawnClass", "30");//��ͨ��
			mm0.put("IsHold", "1");//�����
			mm0.put("InputDataType", "copy");
			mm0.put("HoldType", "1010");
			ps =CopyInfoUtil.copyInfo("insert",this.ERS,"select * from "+sTable,"",null,null, mm0, Sqlca, ps);
			ps.addBatch();
			this.ERS.getPs().put(sTable,ps);
			this.iCount++;
		}
	}
}