package com.amarsoft.datainit.impawn;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.ExcelResultSet;

public class ImpawnExcelResultSet extends ExcelResultSet {
	private ASUser CurUser=null;
	public ImpawnExcelResultSet(Transaction sqlca,ASUser CurUser) throws Exception {
		super(sqlca);
		this.CurUser=CurUser;
	}
	public void initResultSetMeta(String initWho) throws Exception {
			this.columns.clear();
			this.addColumn(new String[]{"ImpawnID"},new String[]{"��Ѻ����","��Ѻ����"});
			this.addColumn("GCSerialNo", "������ͬ���");
			
			this.addColumn("BCSerialNo", "��ͬ���");
			this.addColumn("CustomerID", "�ͻ���");
			this.addColumn("CustomerName", "�ͻ�����");
			this.addColumn(new String[]{"ImpawnType"},new String[]{"��Ѻ������","��Ѻ������"});
			this.addColumn("ImpawnStatus", "������״̬");

		

			this.addColumn("HoldTime", "�������");
			this.addColumn("HoldApplyUserID", "���������");
			this.addColumn("HoldApplyOrgID", "����������");
			this.addColumn("HoldApplyTime", "�������ʱ��");
			this.addColumn("HoldUnifiedOrgID", "������");
			this.addColumn("HoldUnifiedUserID", "����Ա");
			this.addColumn("Remark", "��ע");
			this.addColumn("InputUserID", "�Ǽ���");
			this.addColumn("InputUserName", "�Ǽ���");
			this.addColumn("InputOrgID", "�Ǽǻ���");
			this.addColumn("InputOrgName", "�Ǽǻ���");
			this.addColumn("UpdateUserID", "������");
			this.addColumn("UpdateOrgID", "���»���");
			this.addColumn("InputDate", "�Ǽ�����");
			this.addColumn("UpdateDate", "��������");
			
			this.addColumn("PackageNo", "�Ŀ�ƾ֤���");
			this.addColumn("SealNo", "�Ŀ��ǩ��");
			this.addColumn("TotAmount", "�Ŀ�ƾ֤���");
			this.addColumn("TotAmountCurrency", "�Ŀ�ƾ֤����");
			
			this.addColumn("RightDocStatus", "Ȩ֤״̬");
			this.addColumn("RightDocNo", "Ȩ֤���");
			this.addColumn("RightDoc", "Ȩ֤����");
			this.addColumn("RightDocDescrible", "Ȩ֤��������");
			this.addColumn("RightDocName", "Ȩ֤����");
			this.addColumn("RightBeginDate", "����ѺȨ����ʼ����");
			this.addColumn("RightEndDate", "����ѺȨ����������");
			this.addColumn("RightValue", "Ȩ����ֵ��Ȩ֤�б�ע��Ҫ��д��");
			this.addColumn("RightValueCurrency", "Ȩ����ֵ����");
			this.addColumn("IssueOrganization", "��֤����");
			
			this.addColumn("WarrantType", "��������");
			this.addColumn("InsureCertNO", "���յ����");// ԭ��40�������150
			this.addColumn("InsuranceCompany", "���չ�˾����");
			this.addColumn("WarrantyBeginDate", "������Ч��");
			this.addColumn("WarrantyEndDate", "����������");
			this.addColumn("InsureBeneficiary", "��������");
			this.addColumn("InsureSum", "���ս��");
			this.addColumn("InsureValueBy", "Ͷ����ֵ����");
			this.addColumn("IsDocument", "�Ƿ�������");
			this.addColumn("DocumentAmount", "������������");
			this.addColumn("EvalReportEffectiveDate", "����������Ч��");
			this.addColumn("EvalReportLapseDate", "�������浽����");
			
			this.addColumn("ImportNo", "����������",10000);
		if (initWho.equals("��Ѻ-����")) {
			this.addColumn("GuarantyName", "����Ʒ����");
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤��");
			this.addColumn("GuarantySubType", "��������");
			this.addColumn("GuarantyLocation", "������ϸ��ַ");
			this.addColumn("GuarantyAmount1", "�������(ƽ����)");
			this.addColumn("AboutOtherID1", "����֤���");
			this.addColumn("GuarantyDescribe1", "����ʹ��Ȩ��λ");
			this.addColumn("GuarantyDescribe2", "�ض�");
			this.addColumn("GuarantyDescribe3", "��������");
			this.addColumn("ThirdParty1", "������;");
			this.addColumn("OwnerTime", "����ʹ������(��)");
			this.addColumn("GuarantyDate", "���ݽ���ʱ��");
			this.addColumn("GuarantyDescript", "����װ�����");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else if (initWho.equals("��Ѻ-����")) {
			this.addColumn("GUARANTYNAME", "����Ʒ����");
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤��");
			this.addColumn("GuarantyLocation", "����λ��");
			this.addColumn("GuarantySubType", "���ؼ���");
			this.addColumn("GuarantyDescript", "��������");
			this.addColumn("GuarantyAmount1", "�����ƽ���ף�");
			this.addColumn("GuarantyOwnWay", "����ȡ�÷�ʽ");
			this.addColumn("ThirdParty1", "������;");
			this.addColumn("Flag1", "�������޸�����");
			this.addColumn("Purpose", "���ϸ���������");
			this.addColumn("GuarantyAmount2", "���ϸ��������");
			this.addColumn("BeginDate", "��������");
			this.addColumn("AboutSum1", "���س��ü�ֵ(Ԫ)");
			this.addColumn("Flag2", "�Ƿ���ؼ�");
			this.addColumn("OwnerTime", "����ʣ��ʹ������");
			this.addColumn("GuarantyUsing", "������״");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else if (initWho.equals("��Ѻ�ڽ�����")) {
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "����ʹ��Ȩ֤���");
			this.addColumn("GuarantyOwnWay", "���ػ�ȡ��ʽ");
			this.addColumn("GuarantyDescribe1", "�ѽ�����ʹ��Ȩ���ý�");
			this.addColumn("GuarantyDescribe2", "��Ͷ�빤�̿�");
			this.addColumn("GuarantyDescribe3", "����ɹ�����");
			this.addColumn("ThirdParty1", "�ڽ���������");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else if (initWho.equals("��Ѻ-��ͨ����")) {
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤�ţ����ƺţ�");
			this.addColumn("ThirdParty1", "���乤������");
			this.addColumn("AboutOtherID1", "Ʒ��");
			this.addColumn("AboutOtherID2", "��������");
			this.addColumn("AboutOtherID3", "���ܺ�");
			this.addColumn("ThirdParty2", "��ɫ");
			this.addColumn("GuarantyAmount1", "����ʻ������");
			this.addColumn("Flag1", "�Ƿ�����ʻ֤");
			this.addColumn("Flag2", "�Ƿ��г������ø���˰֤");
			this.addColumn("Flag3", "�Ƿ��е��공��ʹ��˰֤");
			this.addColumn("Flag4", "����Ƿ�����");
			this.addColumn("AboutSum1", "�����ֵ(Ԫ)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else // 010040
		if (initWho.equals("��Ѻ-�豸")) {
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ȩ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤��(��Ʊ����)");
			this.addColumn("GuarantyName", "�豸����");
			this.addColumn("GuarantyDescribe1", "�豸��������");
			this.addColumn("GuarantyDescribe2", "�豸���/�ͺ�");
			this.addColumn("GuarantyDescribe3", "Ʒ��");
			this.addColumn("GuarantyAmount1", "����");
			this.addColumn("BeginDate", "��������");
			this.addColumn("AboutSum1", "�����ֵ(�����Ԫ)");
			this.addColumn("GuarantyLocation", "��ŵ�");
			this.addColumn("GuarantyUsing", "�豸��״");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else // 010050
		if (initWho.equals("��Ѻ-����")) {
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤��");
			this.addColumn("GuarantyName", "��Ѻ������");
			this.addColumn("Purpose", "��Ѻ����;");
			this.addColumn("GuarantyAmount", "����");
			this.addColumn("BeginDate", "��������");
			this.addColumn("OwnerTime", "����ʱ��");
			this.addColumn("GuarantyPrice", "��Ѻ��ԭ��ֵ");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else // 010060
		if (initWho.equals("��Ѻ-���ز�")) {
			this.addColumn("OwnerID", "Ȩ���˴���");
			this.addColumn("OwnerName", "��Ѻ������");
			this.addColumn("OwnerType", "��Ѻ������");
			this.addColumn("GuarantyRightID", "��������Ȩ֤��");
			this.addColumn("GuarantySubType", "��������");
			this.addColumn("GuarantyLocation", "������ϸ��ַ");
			this.addColumn("GuarantyDescript", "������;");
			this.addColumn("GuarantyDate", "���ݽ���ʱ��");
			this.addColumn("AboutOtherID1", "����ʹ��Ȩ֤��");
			this.addColumn("GuarantyDescribe1", "����ʹ��Ȩ��λ");
			this.addColumn("GuarantyDescribe2", "����λ��");
			this.addColumn("GuarantyDescribe3", "��������");
			this.addColumn("ThirdParty1", "������;");
			this.addColumn("GuarantyAmount1", "����ʹ��Ȩ���");
			this.addColumn("OwnerTime", "����ʹ������(��)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("Currency", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
			this.addColumn("RegisterOrgID", "��Ѻ�Ǽǻ���");
			this.addColumn("RegisterDate", "��Ѻ�Ǽ�����");
		} else // 020010
		if (initWho.equals("��Ѻ-�浥")) {
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "�浥����");
			this.addColumn("GuarantyLocation", "�浥������");
			this.addColumn("BeginDate", "��Ϣ����");
			this.addColumn("OwnerTime", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "�浥���");
			this.addColumn("GuarantyOwnWay", "�浥֧ȡ��ʽ");
			this.addColumn("AboutSum2", "����ծȨ���");
		} else // 020020
		if (initWho.equals("��Ѻ-����")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("ThirdParty1", "��������");
			this.addColumn("GuarantyName", "��������");
			this.addColumn("AboutSum1", "�������ܶ�(Ԫ)");
			this.addColumn("GuarantyAmount", "��Ѻ����ݶ�(Ԫ)");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutRate", "��Ѻ����ݶ�ռ�ܶ�(%)");
			this.addColumn("GuarantyAmount1", "����ǰһ�ջ������̼�(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020030
		if (initWho.equals("��Ѻ-�ƽ�")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("ThirdParty1", "�ƽ�Ʒ��");
			this.addColumn("GuarantyAmount", "�ƽ����");
			this.addColumn("GuarantyPrice", "��Ѻ�ƽ���м�ֵ");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("AboutRate", "�ƽ���Ѻ��");
		} else if (initWho.equals("��Ѻ-��ծ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyName", "��Ѻ������");
			this.addColumn("GuarantyRightID", "Ȩ֤����");
			this.addColumn("GuarantyAmount", "����");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "���(�����Ԫ)");
			this.addColumn("GuarantyDate", "��������");
			this.addColumn("BeginDate", "�����������");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020050
		if (initWho.equals("��Ѻ-������˰")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ȩ֤����");
			this.addColumn("AboutOtherID1", "������˰�ʻ��ʺ�");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "Ӧ��δ��˰���(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020060
		if (initWho.equals("��Ѻ-����")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "���յ�����");
			this.addColumn("GuarantyResouce", "���չ�˾����");
			this.addColumn("GuarantyDescribe1", "��������");
			this.addColumn("ThirdParty1", "Ͷ����");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("ThirdParty2", "��������");
			this.addColumn("ThirdParty3", "������");
			this.addColumn("AboutSum1", "���ս��(Ԫ)");
		} else // 020070
		if (initWho.equals("��Ѻ-�����ص㽨��ծȯ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "ծȯ����");
			this.addColumn("GuarantyResouce", "ծȯ���е�λ");
			this.addColumn("GuarantyLocation", "ծȯ�����л���");
			this.addColumn("GuarantyName", "ծȯ����");
			this.addColumn("GuarantyAmount", "ծȯ����");
			this.addColumn("GuarantySubType", "ծȯ����");
			this.addColumn("AboutSum1", "ծȯ���(Ԫ)");
			this.addColumn("Flag1", "�Ƿ����ծȯ");
		} else // 020080
		if (initWho.equals("��Ѻ-����֤")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("GuarantyRightID", "����֤����");
			this.addColumn("GuarantyName", "��֤����������");
			this.addColumn("ThirdParty1", "����֤����");
			this.addColumn("ThirdParty2", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "���(Ԫ)");
			this.addColumn("GuarantyDate", "��֤����");
			this.addColumn("OwnerTime", "����֤Ч��");
		} else // 020090
		if (initWho.equals("��Ѻ-��������֤")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("GuarantyRightID", "����֤����");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyName", "��֤����������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "���(Ԫ)");
			this.addColumn("OwnerTime", "Ч��");
			this.addColumn("GuarantyResouce", "��֤������");
			this.addColumn("GuarantyDescribe1", "��֤�й��ҵ���");
			this.addColumn("Flag1", "���ޱ���");
		} else // 020110
		if (initWho.equals("��Ѻ-�ֵ�")) {
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "�ֵ�����");
			this.addColumn("GuarantyName", "��������");
			this.addColumn("GuarantyAmount1", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyPrice", "���ﹺ���ֵ");
			this.addColumn("GuarantyResouce", "�ִ���˾����");
			this.addColumn("GuarantyLocation", "��ŵص�");
			this.addColumn("BeginDate", "�����ʼ����");
			this.addColumn("OwnerTime", "�ֵ���������");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ");
			this.addColumn("AboutSum2", "����ծȨ���");
		} else // 020120
		if (initWho.equals("��Ѻ-�ᵥ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "�ᵥ����");
			this.addColumn("GuarantyName", "��������");
			this.addColumn("GuarantyAmount1", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyPrice", "���ﹺ���ֵ(Ԫ)");
			this.addColumn("GuarantyLocation", "����ص�");
			this.addColumn("GuarantyResouce", "��Ӧ������");
			this.addColumn("OwnerTime", "�ᵥ��������");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020130
		if (initWho.equals("��Ѻ-��ͨ����")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ȩ֤��(���ƺ�)");
			this.addColumn("ThirdParty1", "���乤������");
			this.addColumn("ThirdParty3", "����Ʒ��");
			this.addColumn("AboutOtherID1", "�����ͺ�");
			this.addColumn("AboutOtherID2", "��������");
			this.addColumn("AboutOtherID3", "���ܺ�");
			this.addColumn("ThirdParty2", "��ɫ");
			this.addColumn("GuarantyAmount1", "����ʻ������");
			this.addColumn("Flag1", "�Ƿ�����ʻ֤");
			this.addColumn("Flag2", "�Ƿ��г������ø���˰֤");
			this.addColumn("Flag3", "�Ƿ��е��공��ʹ��˰֤");
			this.addColumn("Flag4", "����Ƿ�����");
			this.addColumn("AboutSum1", "�����ֵ(�����Ԫ)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ֤��");
		} else // 020140
		if (initWho.equals("��Ѻ-�����ϸ�֤")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "Ȩ��������");
			this.addColumn("GuarantyRightID", "�����ϸ�֤����");
			this.addColumn("ThirdParty1", "��������");
			this.addColumn("ThirdParty3", "����Ʒ��");
			this.addColumn("AboutOtherID1", "�����ͺ�");
			this.addColumn("GuarantyAmount", "����");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyPrice", "���������ֵ(Ԫ)");
			this.addColumn("GuarantyLocation", "������ŵص�");
			this.addColumn("AboutOtherID2", "��Ӧ��");
			this.addColumn("GuarantyResouce", "��������");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020150
		if (initWho.equals("��Ѻ-��ҵծȯ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "ծȯ����");
			this.addColumn("GuarantyResouce", "ծȯ���е�λ");
			this.addColumn("GuarantyLocation", "ծȯ�����л���");
			this.addColumn("GuarantyName", "ծȯ����");
			this.addColumn("GuarantyAmount", "ծȯ����");
			this.addColumn("GuarantySubType", "ծȯ����");
			this.addColumn("AboutSum1", "ծȯ���(Ԫ)");
			this.addColumn("Flag1", "�Ƿ����ծȯ");
			this.addColumn("Flag2", "�Ƿ���Ҫ����ֹ��");
			this.addColumn("GuarantyDate", "��������");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020160
		if (initWho.equals("��Ѻ-���й�˾���˹�")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "��Ʊ����");
			this.addColumn("GuarantyName", "��Ʊ����");
			this.addColumn("GuarantyLocation", "ծȯ�����л���");
			this.addColumn("GuarantyAmount", "��Ʊ����(��)");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "���¹����Ĺ�Ʊÿ�ɾ��ʲ�(�����Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ��֤��");
			this.addColumn("Flag1", "���й�˾�Ƿ�ӯ��(�Ƿ�)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020170
		if (initWho.equals("��Ѻ-���й�˾��ͨ��")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("RelativeAccount", "Ȩ�����ʻ��ʺ�");
			this.addColumn("GuarantyRightID", "��Ʊ����");
			this.addColumn("GuarantyName", "��Ʊ����");
			this.addColumn("GuarantyAmount", "��Ʊ����(��)");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyLocation", "��Ʊ�й�ȯ��");
			this.addColumn("AboutSum1", "��Ѻ��Ʊ��һ���������̵�����ֵ(Ԫ)");
			this.addColumn("OtherGuarantyRight", "����Ȩ��֤��");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020180
		if (initWho.equals("��Ѻ-�����й�˾��Ȩ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ȩ֤����");
			this.addColumn("GuarantyName", "��Ȩ����");
			this.addColumn("GuarantyAmount", "��Ȩ����(��)");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "ÿ�ɾ��ʲ�(�����Ԫ)");
			this.addColumn("Flag1", "��˾�Ƿ�ӯ��");
			this.addColumn("OtherGuarantyRight", "����Ȩ��֤��");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020190
		if (initWho.equals("��Ѻ-Ӧ���ʿ�")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ȩ֤����");
			this.addColumn("GuarantyName", "����������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("AboutSum1", "Ӧ���ʿ���(Ԫ)");
			this.addColumn("BeginDate", "���������");
			this.addColumn("OwnerTime", "����(��)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020210
		if (initWho.equals("��Ѻ-���гжһ�Ʊ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "���гжһ�Ʊ����");
			this.addColumn("ThirdParty1", "Ʊ������");
			this.addColumn("GuarantyName", "��Ʊ��");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyResouce", "�ж���");
			this.addColumn("ThirdParty2", "�տ���");
			this.addColumn("ThirdParty3", "������");
			this.addColumn("AboutSum1", "���гжһ�Ʊ���(Ԫ)");
			this.addColumn("GuarantyDate", "��Ʊ��");
			this.addColumn("OwnerTime", "�ж���");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020220
		if (initWho.equals("��Ѻ-��Ʊ����Ʊ��֧Ʊ")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ʊ�ݺ���");
			this.addColumn("ThirdParty1", "Ʊ������");
			this.addColumn("GuarantyName", "��Ʊ��");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyResouce", "��Ʊ��");
			this.addColumn("ThirdParty2", "������");
			this.addColumn("ThirdParty3", "������");
			this.addColumn("AboutSum1", "Ʊ����(Ԫ)");
			this.addColumn("GuarantyDate", "ǩ������");
			this.addColumn("OwnerTime", "��������");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020230
		if (initWho.equals("��Ѻ-��������")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("Guarantyana", "��ŵص�");
			this.addColumn("GuarantyRightID", "Ȩ֤��(��Ʊ����)");
			this.addColumn("GuarantyName", "��Ѻ������");
			this.addColumn("GuarantyAmount", "��Ѻ������");
			this.addColumn("BeginDate", "��������");
			this.addColumn("OwnerTime", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyPrice", "��Ѻ��ԭ��ֵ(�����Ԫ)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020250
		if (initWho.equals("��Ѻ-������ת��Ȩ��")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("OwnerType", "����������");
			this.addColumn("GuarantyRightID", "Ȩ֤����");
			this.addColumn("GuarantyName", "Ȩ������");
			this.addColumn("GuarantyResouce", "Ȩ����׼����");
			this.addColumn("BeginDate", "����/��ʼ����");
			this.addColumn("OwnerTime", "��������");
			this.addColumn("GuarantySubType", "����");
			this.addColumn("GuarantyPrice", "Ȩ��ȡ�ü�ֵ(Ԫ)");
			this.addColumn("EvalMethod", "��Ѻ���ֵ������ʽ");
			this.addColumn("EvalOrgName", "��ֵ������������");
			this.addColumn("EvalDate", "����ʱ��");
			this.addColumn("EvalNetValue", "��Ѻ��������ֵ(Ԫ)");
			this.addColumn("ConfirmValue", "��Ѻ���϶���ֵ(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
		} else // 020270
		if (initWho.equals("��֤��")) {
			this.addColumn("OwnerID", "�����˴���");
			this.addColumn("OwnerName", "����������");
			this.addColumn("GuarantyRightID", "��֤���ʺ�");
			this.addColumn("GuarantyLocation", "��֤������");
			this.addColumn("GuarantySubType", "��֤�����");
			this.addColumn("AboutSum1", "��֤����(Ԫ)");
			this.addColumn("AboutSum2", "����ծȨ���(Ԫ)");
			this.addColumn("AboutRate", "��֤�����(%)");
		} else // 020280
		if (initWho.equals("��Ѻ-��Ʋ�Ʒ")) {
			this.addColumn("OwnerName", "�Ϲ��ͻ�����");
			this.addColumn("OwnerCardType", "�ͻ�֤������");
			this.addColumn("OwnerCardNo", "�ͻ�֤����");
			this.addColumn("GUARANTYNAME", "��Ʒ����");
			this.addColumn("GuarantyRegNO", "��Ʒ���");
			this.addColumn("SapvouchType", "��Ʒ����");
			this.addColumn("GuarantySubType", "�Ϲ�����");
			this.addColumn("AboutSum1", "�Ϲ����");
			this.addColumn("OwnerOrg", "��Ʋ�Ʒ�����������");
			this.addColumn("BeginDate", "������");
			this.addColumn("OwnerTime", "������");
			this.addColumn("GuarantyRightID", "�ɷ������˺�");
		}
	}
	public void initResultSetPara() throws Exception {
		super.initResultSetPara();
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo", sdf.format(new Date())+"000000");
	}
}
