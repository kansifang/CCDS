CREATE PROCEDURE sales_status()	 ---�洢���̿����趨����������������
LANGUAGE SQL                   ----DB2�����ö������Ա�д�洢���̣������õ��Ǵ�SQL
BEGIN                          ---��ʼ
DECLARE vID   smallint;        ---������� ��Oracleһ�� DECLARE   ������ ��������������;
FOR V AS SELECT userid FROM user_ifo where userid='system'   ---forѭ�� tmp_brnd_cdԤ�ȴ�����
DO                                         ---ѭ���忪ʼ
SET vID=BRND_CD;                       ---��vID��ֵ��db2������set��ֵ��Ҳ������values��ֵ���������д��values(BRND_CD) into vID
INSERT INTO WWM_FORINSERT_TEST VALUES(vID); ---��wwm_forinsert_test ��������
END FOR;                              -----ѭ�������
END                              -----�洢���̽���
