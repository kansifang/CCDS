<%
//���������Ϣ����Ч��
if(sObjectType.equals("CreditApply")) //�������
{
	//չ��
	if(sDisplayTemplet.equals("ApplyInfo0000")) 
	{
		//����չ�ڽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ��(Ԫ)������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ApplyInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//����Ʊ���ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ���ܽ��(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ(Ԫ)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ApplyInfo0040"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ApplyInfo0050"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApplyInfo0060"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ApplyInfo0070"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApplyInfo0080"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ApplyInfo0090"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ��(Ԫ)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ��(Ԫ)������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô����(Ԫ)��Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����(Ԫ)������ڵ���0��\" ");
		//���ð��ŷ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷ�(Ԫ)������ڵ���0��\" ");
		//�����ܳɱ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�(Ԫ)������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ApplyInfo0100"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ApplyInfo0110"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//ת�������������
	if(sDisplayTemplet.equals("ApplyInfo0120"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//ת�����ʽ�����֯����
	if(sDisplayTemplet.equals("ApplyInfo0130"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ApplyInfo0140"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//ת�����Ŵ�
	if(sDisplayTemplet.equals("ApplyInfo0150"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}	
	
	//����ծȯת����
	if(sDisplayTemplet.equals("ApplyInfo0160"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//����ת����
	if(sDisplayTemplet.equals("ApplyInfo0170"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//��������֤�������
	if(sDisplayTemplet.equals("ApplyInfo0180"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ApplyInfo0190"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ��(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//��������֤Ѻ�������֡���������Ѻ�������֡�������ҵ��Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0210"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
	}
	
	//��������֤Ѻ��
	if(sDisplayTemplet.equals("ApplyInfo0240"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����ͥ
	if(sDisplayTemplet.equals("ApplyInfo0270"))
	{
		//�����öɼ۸�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�öɼ۸������ڵ���0��\" ");
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ʊ�ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ�ݽ��(Ԫ)������ڵ���0��\" ");
		//��������Ʊ�������б��۷�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ʊ�������б��۱�����ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApplyInfo0280"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ӧ���ʿ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ӧ���ʿ��(Ԫ)������ڵ���0��\" ");
		//���÷ſ����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�ſ����(%)�ķ�ΧΪ[0,100]\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApplyInfo0290"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApplyInfo0300"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ		
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApplyInfo0320"))
	{
		//�����鸶����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�鸶����(��)�ķ�ΧΪ[0,1000]\" ");
    	//�����鸶�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�鸶�ѽ��(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApplyInfo0330"))
	{
		//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//���ø�������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
		
	//�������
	if(sDisplayTemplet.equals("ApplyInfo0340"))
	{
		//���û����ķ�Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ı�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݽ��(Ԫ)������ڵ���0��\" ");
		//���õ�������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//���Ᵽ��
	if(sDisplayTemplet.equals("ApplyInfo0343"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//������Ч�ڷ�Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ч�ڱ�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��ı�����ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//�����ۺϷ��նȷ�Χ
		doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۺϷ��նȱ�����ڵ���0��\" ");		
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApplyInfo0350"))
	{
		//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApplyInfo0360"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApplyInfo0370"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ApplyInfo0380"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ApplyInfo0390"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰���(Ԫ)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
	}
	
	//���뷵��ҵ��
	if(sDisplayTemplet.equals("ApplyInfo0418"))
	{
		//���û�Ʊ��������������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ������������������ڵ���0��\" ");
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApplyInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ�����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ�����������(Ԫ)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ApplyInfo0430"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ApplyInfo0530"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ApplyInfo0533"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô�����(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ApplyInfo0534"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ApplyInfo0535"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ApplyInfo0536"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�ƽ�����ҵ��
	if(sDisplayTemplet.equals("ApplyInfo0537"))
	{
		//�������޻ƽ������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���޻ƽ����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
	}
	
	//�����޹�˾����
	if(sDisplayTemplet.equals("ApplyInfo0538"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����������(��)������ڵ���0��\" ");
		//�����������ʲ��۸�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ʲ��۸������ڵ���0��\" ");
		//��������ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ܽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ApplyInfo0541"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ApplyInfo0570"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ApplyInfo1010"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ApplyInfo1050"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ApplyInfo1060"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ApplyInfo1080"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ApplyInfo1130"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ApplyInfo1140"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ApplyInfo1160"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ApplyInfo1170"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ApplyInfo1180"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ApplyInfo1190"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ApplyInfo1200"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ApplyInfo1210"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ApplyInfo1220"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ApplyInfo1240"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ApplyInfo1250"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ApplyInfo1260"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ApplyInfo1330"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ApplyInfo1340"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ApplyInfo1350"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ApplyInfo1360"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ApplyInfo1370"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ApplyInfo1390"))
	{
		//����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
	}
}
if(sObjectType.equals("ApproveApply")) //���������������
{
	//չ��
	if(sDisplayTemplet.equals("ApproveInfo0000")) 
	{
		//������׼չ�ڽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼չ�ڽ��(Ԫ)������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ApproveInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//������׼Ʊ���ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼Ʊ���ܽ��(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ApproveInfo0040"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ApproveInfo0050"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApproveInfo0060"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ApproveInfo0070"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ApproveInfo0080"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ApproveInfo0090"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ��(Ԫ)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ��(Ԫ)������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô����(Ԫ)��Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����(Ԫ)������ڵ���0��\" ");
		//���ð��ŷ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷ�(Ԫ)������ڵ���0��\" ");
		//�����ܳɱ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ApproveInfo0100"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ApproveInfo0110"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�������������
	if(sDisplayTemplet.equals("ApproveInfo0120"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�����ʽ�����֯����
	if(sDisplayTemplet.equals("ApproveInfo0130"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ApproveInfo0140"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�����Ŵ�
	if(sDisplayTemplet.equals("ApproveInfo0150"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}	
	
	//����ծȯת����
	if(sDisplayTemplet.equals("ApproveInfo0160"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ת����
	if(sDisplayTemplet.equals("ApproveInfo0170"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤�������
	if(sDisplayTemplet.equals("ApproveInfo0180"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ApproveInfo0190"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ��(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤Ѻ�������֡���������Ѻ�������֡�������ҵ��Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0210"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤Ѻ��
	if(sDisplayTemplet.equals("ApproveInfo0240"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ͥ
	if(sDisplayTemplet.equals("ApproveInfo0270"))
	{
		//�����öɼ۸�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�öɼ۸������ڵ���0��\" ");
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ʊ�ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ�ݽ��(Ԫ)������ڵ���0��\" ");
		//��������Ʊ�������б��۷�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ʊ�������б��۱�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApproveInfo0280"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ӧ���ʿ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ӧ���ʿ��(Ԫ)������ڵ���0��\" ");
		//���÷ſ����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�ſ����(%)�ķ�ΧΪ[0,100]\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApproveInfo0290"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ApproveInfo0300"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApproveInfo0320"))
	{
		//�����鸶����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�鸶����(��)�ķ�ΧΪ[0,1000]\" ");
    	//�����鸶�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�鸶�ѽ��(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//������׼����֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼����֤���(Ԫ)������ڵ���0��\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApproveInfo0330"))
	{
		//������׼����֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼����֤���(Ԫ)������ڵ���0��\" ");
		//���ø�������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}	
	
	//�������
	if(sDisplayTemplet.equals("ApproveInfo0340"))
	{
		//���û����ķ�Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ı�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//������׼���ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���ݽ��(Ԫ)������ڵ���0��\" ");
		//���õ�������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ᵽ��
	if(sDisplayTemplet.equals("ApproveInfo0343"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//������Ч�ڷ�Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ч�ڱ�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��ı�����ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//�����ۺϷ��նȷ�Χ
		doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۺϷ��նȱ�����ڵ���0��\" ");		
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ApproveInfo0350"))
	{
		//������׼����֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼����֤���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApproveInfo0360"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ApproveInfo0370"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ApproveInfo0380"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ApproveInfo0390"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���뷵��ҵ��
	if(sDisplayTemplet.equals("ApproveInfo0418"))
	{
		//���û�Ʊ��������������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ������������������ڵ���0��\" ");
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ApproveInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ�����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ�����������(Ԫ)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ApproveInfo0430"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ApproveInfo0530"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ApproveInfo0533"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô�����(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ApproveInfo0534"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ApproveInfo0535"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ApproveInfo0536"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ƽ�����ҵ��
	if(sDisplayTemplet.equals("ApproveInfo0537"))
	{
		//�������޻ƽ������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���޻ƽ����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����޹�˾����
	if(sDisplayTemplet.equals("ApproveInfo0538"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
		doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0��\" ");
		//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����������(��)������ڵ���0��\" ");
		//�����������ʲ��۸�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ʲ��۸������ڵ���0��\" ");
		//��������ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ܽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ApproveInfo0541"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ApproveInfo0570"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ApproveInfo1010"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ApproveInfo1050"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ApproveInfo1060"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ApproveInfo1080"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ʱ�����ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ApproveInfo1130"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ApproveInfo1140"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ApproveInfo1160"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ApproveInfo1170"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ApproveInfo1180"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ApproveInfo1190"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ApproveInfo1200"))
	{
		//������׼�����ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ApproveInfo1210"))
	{
		//������׼�����ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼�����ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ApproveInfo1220"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ApproveInfo1240"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ApproveInfo1250"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ApproveInfo1260"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ApproveInfo1330"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ApproveInfo1340"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ApproveInfo1350"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ApproveInfo1360"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ApproveInfo1370"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ApproveInfo1390"))
	{
		//������׼���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
}

if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //��ͬ����
{
	//չ��
	if(sDisplayTemplet.equals("ContractInfo0000")) 
	{
		//����չ�ڽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ��(Ԫ)������ڵ���0��\" ");
		//����չ������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ������(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����չ��ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//Э�鸶ϢƱ������
	if(sDisplayTemplet.equals("ContractInfo0020"))
	{
		//����Ʊ������(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ������(��)������ڵ���0��\" ");
		//����Ʊ���ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ���ܽ��(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������Ӧ��������Ϣ(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ӧ��������Ϣ(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0030"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ŀ�������������Ŀ�����������Ŀ����
	if(sDisplayTemplet.equals("ContractInfo0040"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ô��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˹�������
	if(sDisplayTemplet.equals("ContractInfo0050"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���÷������������Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ContractInfo0060"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�����ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�豸���˰���
	if(sDisplayTemplet.equals("ContractInfo0070"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù�������豸��ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������豸��ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������˰���
	if(sDisplayTemplet.equals("ContractInfo0080"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ð����ʲ�ʹ�����޷�Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ�ʹ�����ޱ�����ڵ���0��\" ");
		//���ð����ʲ���ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ʲ���ͬ���(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ŵ���
	if(sDisplayTemplet.equals("ContractInfo0090"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ÿ�����(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(��)������ڵ���0��\" ");
		//�������Ŵ����ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ŵ����ܽ��(Ԫ)������ڵ���0��\" ");
		//�����������(��)��Χ
		doTemp.appendHTMLStyle("DrawingPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������(��)������ڵ���0��\" ");
		//���ó�ŵ����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��ŵ����(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ó�ŵ�Ѽ�����(��)��Χ
		doTemp.appendHTMLStyle("PromisesFeePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�Ѽ�����(��)������ڵ���0��\" ");
		//���ó�ŵ�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ�ѽ��(Ԫ)������ڵ���0��\" ");
		//���ù������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ù���ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("MFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô����(Ԫ)��Χ
		doTemp.appendHTMLStyle("AgentFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����(Ԫ)������ڵ���0��\" ");
		//���ð��ŷ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("DealFee"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ŷ�(Ԫ)������ڵ���0��\" ");
		//�����ܳɱ�(Ԫ)��Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ܳɱ�(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ί�д���
	if(sDisplayTemplet.equals("ContractInfo0100"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ί�л���(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ί�л���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�м�֤ȯ���е���
	if(sDisplayTemplet.equals("ContractInfo0110"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
    	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�������������
	if(sDisplayTemplet.equals("ContractInfo0120"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�����ʽ�����֯����
	if(sDisplayTemplet.equals("ContractInfo0130"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������㴢��ת����
	if(sDisplayTemplet.equals("ContractInfo0140"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//ת�����Ŵ�
	if(sDisplayTemplet.equals("ContractInfo0150"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}	
	
	//����ծȯת����
	if(sDisplayTemplet.equals("ContractInfo0160"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ת����
	if(sDisplayTemplet.equals("ContractInfo0170"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤�������
	if(sDisplayTemplet.equals("ContractInfo0180"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ں�ͬ�������
	if(sDisplayTemplet.equals("ContractInfo0190"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ó�׺�ͬ�ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�׺�ͬ�ܽ��(Ԫ)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤Ѻ�������֡���������Ѻ�������֡�������ҵ��Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0210"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤Ѻ��
	if(sDisplayTemplet.equals("ContractInfo0240"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������֤��Χ
		doTemp.appendHTMLStyle("OldLCSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤��������ڵ���0��\" ");
		//���ö��⸶���Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���⸶���������ڵ���0��\" ");
		//���ÿ�֤��֤�����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ͥ
	if(sDisplayTemplet.equals("ContractInfo0270"))
	{
		//�����öɼ۸�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�öɼ۸������ڵ���0��\" ");
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ʊ�ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("UseArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ�ݽ��(Ԫ)������ڵ���0��\" ");
		//��������Ʊ�������б��۷�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ʊ�������б��۱�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ContractInfo0280"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ӧ���ʿ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ӧ���ʿ��(Ԫ)������ڵ���0��\" ");
		//���÷ſ����(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�ſ����(%)�ķ�ΧΪ[0,100]\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ContractInfo0290"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ڱ���
	if(sDisplayTemplet.equals("ContractInfo0300"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�Ʊ������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����������ڵ���0��\" ");
		//�����򷽱����Ƚ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�򷽱����Ƚ��(Ԫ)������ڵ���0��\" ");
		//�������ʱ���(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
		//��������Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����Ӷ��(Ԫ)������ڵ���0��\" ");
		//���ñ�����Ӷ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PurchaserInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������Ӷ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݴ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BargainorInterest"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݴ����(Ԫ)������ڵ���0��\" ");
		//�������з���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ContractInfo0320"))
	{
		//�����鸶����(��)��Χ
    	doTemp.appendHTMLStyle("PromisesFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�鸶����(��)�ķ�ΧΪ[0,1000]\" ");
    	//�����鸶�ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�鸶�ѽ��(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("MFeeRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//����Զ������֤��������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Զ������֤��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ContractInfo0330"))
	{
		//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//���ø�������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������
	if(sDisplayTemplet.equals("ContractInfo0340"))
	{
		//���û����ķ�Χ
		doTemp.appendHTMLStyle("TotalCast"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ı�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���õ��ݽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ݽ��(Ԫ)������ڵ���0��\" ");
		//���õ�������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���Ᵽ��
	if(sDisplayTemplet.equals("ContractInfo0343"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//������Ч�ڷ�Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ч�ڱ�����ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��ı�����ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//�����ۺϷ��նȷ�Χ
		doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۺϷ��նȱ�����ڵ���0��\" ");		
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������֤
	if(sDisplayTemplet.equals("ContractInfo0350"))
	{
		//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ContractInfo0360"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���������ʽ����
	if(sDisplayTemplet.equals("ContractInfo0370"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ʻ�͸֧
	if(sDisplayTemplet.equals("ContractInfo0380"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������͸֧��(��)��Χ
		doTemp.appendHTMLStyle("OverDraftPeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����͸֧��(��)������ڵ���0��\" ");
		//���ó�ŵ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PromisesFeeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ŵ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������˰�ʻ��йܴ���
	if(sDisplayTemplet.equals("ContractInfo0390"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ý�ֹ����������Ӧ����˰���(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ֹ����������Ӧ����˰���(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0410"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��ı�����ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���뷵��ҵ��
	if(sDisplayTemplet.equals("ContractInfo0418"))
	{
		//���û�Ʊ��������������Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ������������������ڵ���0��\" ");
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ�жһ�Ʊ����
	if(sDisplayTemplet.equals("ContractInfo0420"))
	{
		//���û�Ʊ����(��)��Χ
		doTemp.appendHTMLStyle("BillNum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ʊ����(��)������ڵ���0��\" ");
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");		
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ÿۼ��˴��������ֽ�����������(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�ۼ��˴��������ֽ�����������(Ԫ)������ڵ���0��\" ");
		//���óжһ�Ʊ����ó�׺�ͬ��ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�жһ�Ʊ����ó�׺�ͬ��ͬ��������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���ز���������
	if(sDisplayTemplet.equals("ContractInfo0430"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ԥ�ƿ�����Ŀ�����п������˰��Ҵ���Ľ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���гжһ�Ʊ
	if(sDisplayTemplet.equals("ContractInfo0530"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ó�ױ�����ͬ��Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ó�ױ�����ͬ��������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����
	if(sDisplayTemplet.equals("ContractInfo0533"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ô�����(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"������(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����Ŵ�֤��
	if(sDisplayTemplet.equals("ContractInfo0534"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������
	if(sDisplayTemplet.equals("ContractInfo0535"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ŵ��
	if(sDisplayTemplet.equals("ContractInfo0536"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ƽ�����ҵ��
	if(sDisplayTemplet.equals("ContractInfo0537"))
	{
		//�������޻ƽ������Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���޻ƽ����������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����޹�˾����
	if(sDisplayTemplet.equals("ContractInfo0538"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//��������������(��)��Χ
		doTemp.appendHTMLStyle("GracePeriod"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����������(��)������ڵ���0��\" ");
		//�����������ʲ��۸�Χ
		doTemp.appendHTMLStyle("TradeSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ʲ��۸������ڵ���0��\" ");
		//��������ܽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ܽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������������𳥻�������͸֧�黹��������˰��������������ó�ױ���������������������Ա�����
	//Ͷ�걣������Լ������Ԥ��������а����̱���������ά�ޱ��������±���������ó�ױ��������ϱ�����
	//���ý𱣺����ӹ�װ��ҵ����ڱ����������������Ա���
	if(sDisplayTemplet.equals("ContractInfo0541"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//������Ŀ��ͬ��ķ�Χ
		doTemp.appendHTMLStyle("DiscountSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ��ͬ��ı�����ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�ۺ����Ŷ��
	if(sDisplayTemplet.equals("ContractInfo0570"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס������
	if(sDisplayTemplet.equals("ContractInfo1010"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ���ס������
	if(sDisplayTemplet.equals("ContractInfo1050"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ҵ�÷�������
	if(sDisplayTemplet.equals("ContractInfo1060"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�����ٽ�����ҵ�÷�����
	if(sDisplayTemplet.equals("ContractInfo1080"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ý��������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˱�֤����
	if(sDisplayTemplet.equals("ContractInfo1130"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������Ѻ������˵�Ѻ����
	if(sDisplayTemplet.equals("ContractInfo1140"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס��װ�޴���
	if(sDisplayTemplet.equals("ContractInfo1160"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫ����
	if(sDisplayTemplet.equals("ContractInfo1170"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ί�д���
	if(sDisplayTemplet.equals("ContractInfo1180"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˸����
	if(sDisplayTemplet.equals("ContractInfo1190"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//������������(��)��Χ
    	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
    	//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˷��ݴ��������Ŀ
	if(sDisplayTemplet.equals("ContractInfo1200"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
    	//������Ŀ�������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��Ŀ�������ƽ�ף�������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��������������
	if(sDisplayTemplet.equals("ContractInfo1210"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����ס�����������
	if(sDisplayTemplet.equals("ContractInfo1220"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���÷����������/���������ƽ�ף���Χ
		doTemp.appendHTMLStyle("ConstructionArea"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����������/���������ƽ�ף�������ڵ���0\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����Ӫ����������
	if(sDisplayTemplet.equals("ContractInfo1240"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������������
	if(sDisplayTemplet.equals("ContractInfo1250"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���ô������(%)��Χ
		doTemp.appendHTMLStyle("BusinessProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�������(%)�ķ�ΧΪ[0,100]\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//�������Ѵ������������
	if(sDisplayTemplet.equals("ContractInfo1260"))
	{
		//�������볨���ܶ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���볨���ܶ��(Ԫ)������ڵ���0��\" ");
		//���ö����Ч����(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����Ч����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
    	//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˾�Ӫѭ������
	if(sDisplayTemplet.equals("ContractInfo1330"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//���˵�Ѻѭ������
	if(sDisplayTemplet.equals("ContractInfo1340"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����С�����ô���
	if(sDisplayTemplet.equals("ContractInfo1350"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//��ҵ��ѧ����
	if(sDisplayTemplet.equals("ContractInfo1360"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ(%)��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ(%)������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ñ�֤����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BailSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��֤����(Ԫ)������ڵ���0��\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//������ѧ����
	if(sDisplayTemplet.equals("ContractInfo1370"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
	
	//����������Ѻ����
	if(sDisplayTemplet.equals("ContractInfo1390"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��(��)������ڵ���0��\" ");
		//���û�׼������(%)��Χ
    	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��׼������(%)������ڵ���0\" ");
    	//�������ʸ���ֵ��Χ
		doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���ʸ���ֵ������ڵ���0��\" ");
		//����ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(��)������ڵ���0��\" ");
		//���ü��Ƶ��(��)��Χ
		doTemp.appendHTMLStyle("ClassifyFrequency"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ƶ��(��)������ڵ���0��\" ");
	}
}

if(sObjectType.equals("PutOutApply")) //���ʶ���
{
	if(sDisplayTemplet.equals("PutOutInfo0"))
	{
		//����չ�ڽ�Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ�ڽ�������ڵ���0��\" ");
		//����չ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"չ��������(%)������ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo1"))
	{
		//���ú�ͬ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ���(Ԫ)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo2"))
	{
		//���÷��Ž��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž��(Ԫ)������ڵ���0��\" ");
		//���������ѽ��(Ԫ)��Χ
		doTemp.appendHTMLStyle("PdgSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�����ѽ��(Ԫ)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//����ΥԼ������(%)��Χ
		doTemp.appendHTMLStyle("BackRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ΥԼ������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo3"))
	{
		//���÷��Ž��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž��(Ԫ)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
	}	
	
	if(sDisplayTemplet.equals("PutOutInfo4"))
	{
		//���÷��Ž��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž��(Ԫ)������ڵ���0��\" ");
		//���ñ��з��Ž�Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���з��Ž�������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo5"))
	{
		//���÷��Ž��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž��(Ԫ)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���ù̶����ڷ�Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶����ڱ�����ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo6"))
	{
		//����Ʊ����(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"Ʊ����(Ԫ)������ڵ���0��\" ");
		//�����򷽸�Ϣ����(%)��Χ
		doTemp.appendHTMLStyle("BillRisk"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"�򷽸�Ϣ����(%)�ķ�ΧΪ[0,100]\" ");
		//��������ִ��������(��)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����ִ��������(��)������ڵ���0��\" ");
		//���õ���������Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������������ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo7"))
	{
		//���ý��׽��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���׽��(Ԫ)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//���ø�������(��)��Χ
		doTemp.appendHTMLStyle("TermDay"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��������(��)������ڵ���0��\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo8"))
	{
		//���ý��׽��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���׽��(Ԫ)������ڵ���0��\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo9"))
	{
		//���÷��Ž��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���Ž��(Ԫ)������ڵ���0��\" ");
		//���ú�ͬ��Χ
		doTemp.appendHTMLStyle("ContractSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��ͬ��������ڵ���0��\" ");
		//���÷�չ�̱�֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("FZGuaBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��չ�̱�֤���(Ԫ)������ڵ���0��\" ");
		//����ִ��������(%)��Χ
		doTemp.appendHTMLStyle("BusinessRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ִ��������(%)������ڵ���0��\" ");
		//���÷�չ�����ʾ���(Ԫ)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"��չ�����ʾ���(Ԫ)������ڵ���0��\" ");
		//���ù̶�������Χ
		doTemp.appendHTMLStyle("FixCyc"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�̶�����������ڵ���0��\" ");
		//���ô������ϵ����Χ
    	doTemp.appendHTMLStyle("RiskRate"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"�������ϵ��������ڵ���0\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo10"))
	{
		//��������֤���(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����֤���(Ԫ)������ڵ���0��\" ");
		//�����鸶����(��)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"�鸶����(��)�ķ�ΧΪ[0,1000]\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo11"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
		
	if(sDisplayTemplet.equals("PutOutInfo12"))
	{
		//���ý��(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"���(Ԫ)������ڵ���0��\" ");
		//������������(��)��Χ
		doTemp.appendHTMLStyle("FZANBalance"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"��������(��)�ķ�ΧΪ[0,1000]\" ");
		//���ñ�֤�����(%)��Χ
		doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"��֤�����(%)�ķ�ΧΪ[0,100]\" ");
	}
	
	if(sDisplayTemplet.equals("PutOutInfo13"))
	{
		//���ö���޶�(Ԫ)��Χ
		doTemp.appendHTMLStyle("BusinessSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����޶�(Ԫ)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermYear"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
		//��������(��)��Χ
		doTemp.appendHTMLStyle("TermMonth"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"����(��)������ڵ���0��\" ");
	}
}
%>