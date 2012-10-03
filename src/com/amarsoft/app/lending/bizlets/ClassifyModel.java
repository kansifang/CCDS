package com.amarsoft.app.lending.bizlets;
/**
 * �弶����ģ�ͼ���
 * @author zrli
 	01		����
	0101	����1
	0102	����2
	0103	����3
	02		��ע
	0201	��ע1
	0202	��ע2
	0203	��ע3
	03		�μ�
	0301	�μ�1
	0302	�μ�2
	04		����
	0400	����
	05		��ʧ
	0500	��ʧ
 */
public class ClassifyModel {
	//С��ҵʮ���ͷ��� �������Ӧ����
	public static final String[][] M1 ={{"0","0101"},
										{"30","0103"},
										{"90","0103"},
										{"180","0203"},
										{"360","0302"},
										{"999","0302"}
										};
	//С��ҵʮ���ǵͷ��յ�����������������
	public static final String[][] M2 ={{"005","0","0103"},
										{"005","30","0201"},
										{"005","90","0301"},
										{"005","180","0400"},
										{"005","360","0400"},
										{"005","999","0500"},
										{"010","0","0103"},
										{"010","30","0103"},
										{"010","90","0202"},
										{"010","180","0301"},
										{"010","360","0400"},
										{"010","999","0500"},
										{"020","0","0102"},
										{"020","30","0103"},
										{"020","90","0202"},
										{"020","180","0203"},
										{"020","360","0302"},
										{"020","999","0400"},
										{"040","0","0102"},
										{"040","30","0103"},
										{"040","90","0202"},
										{"040","180","0203"},
										{"040","360","0302"},
										{"040","999","0400"}
										};	
	//һ����ҵʮ���ͷ������ھ���
	public static final String[][] M5 ={{"0","0101"},
										{"30","0103"},
										{"90","0103"},
										{"180","0203"},
										{"360","0302"},
										{"999","0302"}
										};
	//һ����ҵʮ���ǵͷ������������������ ��������߷�����
	public static final String[][] M6 ={{"0","0101"},
										{"30","0202"},
										{"90","0203"},
										{"180","0302"},
										{"999","0400"}
										};
	

	//һ����ҵʮ���ǵͷ������õȼ���������ʽ������� ��������߷�����
	public static final String[][] M9 ={{"AAA","005","0101"},//����
										{"AA","005","0101"},//����
										{"A","005","0102"},//����
										{"BBB","005","0103"},//����
										{"BB","005","0201"},//����
										{"B","005","0202"},//����
										{"","005","0103"},//����
										
										{"AAA","0105010","0101"},//��ҵ��֤-AAA��
										{"AAA","0105070","0101"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"AAA","0101010","0101"},//��֤-�С�ũ����������������������������
										{"AAA","0101020","0101"},//��֤-�ɷ�����ҵ����
										{"AA","0105010","0101"},//��ҵ��֤-AAA��
										{"AA","0105070","0101"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"AA","0101010","0101"},//��֤-�С�ũ����������������������������
										{"AA","0101020","0101"},//��֤-�ɷ�����ҵ����
										{"A","0105010","0101"},//��ҵ��֤-AAA��
										{"A","0105070","0101"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"A","0101010","0101"},//��֤-�С�ũ����������������������������
										{"A","0101020","0101"},//��֤-�ɷ�����ҵ����
										{"BBB","0105010","0101"},//��ҵ��֤-AAA��
										{"BBB","0105070","0101"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"BBB","0101010","0101"},//��֤-�С�ũ����������������������������
										{"BBB","0101020","0101"},//��֤-�ɷ�����ҵ����
										{"BB","0105010","0102"},//��ҵ��֤-AAA��
										{"BB","0105070","0102"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"BB","0101010","0102"},//��֤-�С�ũ����������������������������
										{"BB","0101020","0102"},//��֤-�ɷ�����ҵ����
										{"B","0105010","0201"},//��ҵ��֤-AAA��
										{"B","0105070","0201"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"B","0101010","0201"},//��֤-�С�ũ����������������������������
										{"B","0101020","0201"},//��֤-�ɷ�����ҵ����
										{"","0105010","0101"},//��ҵ��֤-AAA��
										{"","0105070","0101"},//��ҵ��֤-�ҹ���������Ͷ�ʵĹ�����ҵ
										{"","0101010","0101"},//��֤-�С�ũ����������������������������
										{"","0101020","0101"},//��֤-�ɷ�����ҵ����
										
										{"AAA","0105020","0101"},//��ҵ��֤-AA��
										{"AAA","0101030","0101"},//��֤-�������
										{"AAA","0101040","0101"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"AAA","0101050","0101"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"AAA","0101060","0101"},//��֤-��������֤
										{"AAA","0102010","0101"},//��֤-���չ�˾��Լ����
										{"AAA","0102020","0101"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"AAA","0102030","0101"},//��֤- �������ñ���
										{"AAA","0103010","0101"},//������˾��֤-AAA��
										{"AAA","0104010","0101"},//��֤-�м�����
										{"AA","0105020","0101"},//��ҵ��֤-AA��
										{"AA","0101030","0101"},//��֤-�������
										{"AA","0101040","0101"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"AA","0101050","0101"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"AA","0101060","0101"},//��֤-��������֤
										{"AA","0102010","0101"},//��֤-���չ�˾��Լ����
										{"AA","0102020","0101"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"AA","0102030","0101"},//��֤- �������ñ���
										{"AA","0103010","0101"},//������˾��֤-AAA��
										{"AA","0104010","0101"},//��֤-�м�����
										{"A","0105020","0101"},//��ҵ��֤-AA��
										{"A","0101030","0101"},//��֤-�������
										{"A","0101040","0101"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"A","0101050","0101"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"A","0101060","0101"},//��֤-��������֤
										{"A","0102010","0101"},//��֤-���չ�˾��Լ����
										{"A","0102020","0101"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"A","0102030","0101"},//��֤- �������ñ���
										{"A","0103010","0101"},//������˾��֤-AAA��
										{"A","0104010","0101"},//��֤-�м�����
										{"BBB","0105020","0102"},//��ҵ��֤-AA��
										{"BBB","0101030","0102"},//��֤-�������
										{"BBB","0101040","0102"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"BBB","0101050","0102"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"BBB","0101060","0102"},//��֤-��������֤
										{"BBB","0102010","0102"},//��֤-���չ�˾��Լ����
										{"BBB","0102020","0102"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"BBB","0102030","0102"},//��֤- �������ñ���
										{"BBB","0103010","0102"},//������˾��֤-AAA��
										{"BBB","0104010","0102"},//��֤-�м�����
										{"BB","0105020","0201"},//��ҵ��֤-AA��
										{"BB","0101030","0201"},//��֤-�������
										{"BB","0101040","0201"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"BB","0101050","0201"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"BB","0101060","0201"},//��֤-��������֤
										{"BB","0102010","0201"},//��֤-���չ�˾��Լ����
										{"BB","0102020","0201"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"BB","0102030","0201"},//��֤- �������ñ���
										{"BB","0103010","0201"},//������˾��֤-AAA��
										{"BB","0104010","0201"},//��֤-�м�����
										{"B","0105020","0202"},//��ҵ��֤-AA��
										{"B","0101030","0202"},//��֤-�������
										{"B","0101040","0202"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"B","0101050","0202"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"B","0101060","0202"},//��֤-��������֤
										{"B","0102010","0202"},//��֤-���չ�˾��Լ����
										{"B","0102020","0202"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"B","0102030","0202"},//��֤- �������ñ���
										{"B","0103010","0202"},//������˾��֤-AAA��
										{"B","0104010","0202"},//��֤-�м�����
										{"","0105020","0102"},//��ҵ��֤-AA��
										{"","0101030","0102"},//��֤-�������
										{"","0101040","0102"},//��֤-���и��赣�����Ŷ�ȵ����м������磨���ˣ�
										{"","0101050","0102"},//��֤-����������У�Ʊ�ݰ��򡢳������֡�����Ѻ�㣩
										{"","0101060","0102"},//��֤-��������֤
										{"","0102010","0102"},//��֤-���չ�˾��Լ����
										{"","0102020","0102"},//��֤-���и��赣�����Ŷ�ȵ����������н��ڻ���
										{"","0102030","0102"},//��֤- �������ñ���
										{"","0103010","0102"},//������˾��֤-AAA��
										{"","0104010","0102"},//��֤-�м�����
										
										{"AAA","0105030","0101"},//��ҵ��֤-A��
										{"AAA","0103020","0101"},//������˾��֤-AA��
										{"AAA","0104020","0101"},//��֤-���ؼ�����
										{"AA","0105030","0101"},//��ҵ��֤-A��
										{"AA","0103020","0101"},//������˾��֤-AA��
										{"AA","0104020","0101"},//��֤-���ؼ�����
										{"A","0105030","0102"},//��ҵ��֤-A��
										{"A","0103020","0102"},//������˾��֤-AA��
										{"A","0104020","0102"},//��֤-���ؼ�����
										{"BBB","0105030","0103"},//��ҵ��֤-A��
										{"BBB","0103020","0103"},//������˾��֤-AA��
										{"BBB","0104020","0103"},//��֤-���ؼ�����
										{"BB","0105030","0202"},//��ҵ��֤-A��
										{"BB","0103020","0202"},//������˾��֤-AA��
										{"BB","0104020","0202"},//��֤-���ؼ�����
										{"B","0105030","0203"},//��ҵ��֤-A��
										{"B","0103020","0203"},//������˾��֤-AA��
										{"B","0104020","0203"},//��֤-���ؼ�����
										{"","0105030","0103"},//��ҵ��֤-A��
										{"","0103020","0103"},//������˾��֤-AA��
										{"","0104020","0103"},//��֤-���ؼ�����
										
										{"AAA","0105040","0101"},//��ҵ��֤-BBB��
										{"AAA","0103030","0101"},//������˾��֤-A��
										{"AAA","0103040","0101"},//������˾��֤-BBB��
										{"AAA","0104030","0101"},//��֤-�򼶲���
										{"AAA","0106010","0101"},//��Ȼ�˱�֤-AAA��
										{"AAA","0106020","0101"},//��Ȼ�˱�֤-AA��
										{"AAA","0106030","0101"},//��Ȼ�˱�֤-A��
										{"AAA","0106040","0101"},//��Ȼ�˱�֤-BBB��������
										{"AAA","01065","0101"},//����С�黥��
										{"AA","0105040","0101"},//��ҵ��֤-BBB��
										{"AA","0103030","0101"},//������˾��֤-A��
										{"AA","0103040","0101"},//������˾��֤-BBB��
										{"AA","0104030","0101"},//��֤-�򼶲���
										{"AA","0106010","0101"},//��Ȼ�˱�֤-AAA��
										{"AA","0106020","0101"},//��Ȼ�˱�֤-AA��
										{"AA","0106030","0101"},//��Ȼ�˱�֤-A��
										{"AA","0106040","0101"},//��Ȼ�˱�֤-BBB��������
										{"AA","01065","0101"},//����С�黥��
										{"A","0105040","0102"},//��ҵ��֤-BBB��
										{"A","0103030","0102"},//������˾��֤-A��
										{"A","0103040","0102"},//������˾��֤-BBB��
										{"A","0104030","0102"},//��֤-�򼶲���
										{"A","0106010","0102"},//��Ȼ�˱�֤-AAA��
										{"A","0106020","0102"},//��Ȼ�˱�֤-AA��
										{"A","0106030","0102"},//��Ȼ�˱�֤-A��
										{"A","0106040","0102"},//��Ȼ�˱�֤-BBB��������
										{"A","01065","0102"},//����С�黥��
										{"BBB","0105040","0201"},//��ҵ��֤-BBB��
										{"BBB","0103030","0201"},//������˾��֤-A��
										{"BBB","0103040","0201"},//������˾��֤-BBB��
										{"BBB","0104030","0201"},//��֤-�򼶲���
										{"BBB","0106010","0201"},//��Ȼ�˱�֤-AAA��
										{"BBB","0106020","0201"},//��Ȼ�˱�֤-AA��
										{"BBB","0106030","0201"},//��Ȼ�˱�֤-A��
										{"BBB","0106040","0201"},//��Ȼ�˱�֤-BBB��������
										{"BBB","01065","0201"},//����С�黥��
										{"BB","0105040","0202"},//��ҵ��֤-BBB��
										{"BB","0103030","0202"},//������˾��֤-A��
										{"BB","0103040","0202"},//������˾��֤-BBB��
										{"BB","0104030","0202"},//��֤-�򼶲���
										{"BB","0106010","0202"},//��Ȼ�˱�֤-AAA��
										{"BB","0106020","0202"},//��Ȼ�˱�֤-AA��
										{"BB","0106030","0202"},//��Ȼ�˱�֤-A��
										{"BB","0106040","0202"},//��Ȼ�˱�֤-BBB��������
										{"BB","01065","0202"},//����С�黥��
										{"B","0105040","0203"},//��ҵ��֤-BBB��
										{"B","0103030","0203"},//������˾��֤-A��
										{"B","0103040","0203"},//������˾��֤-BBB��
										{"B","0104030","0203"},//��֤-�򼶲���
										{"B","0106010","0203"},//��Ȼ�˱�֤-AAA��
										{"B","0106020","0203"},//��Ȼ�˱�֤-AA��
										{"B","0106030","0203"},//��Ȼ�˱�֤-A��
										{"B","0106040","0203"},//��Ȼ�˱�֤-BBB��������
										{"B","01065","0203"},//����С�黥��
										{"","0105040","0201"},//��ҵ��֤-BBB��
										{"","0103030","0201"},//������˾��֤-A��
										{"","0103040","0201"},//������˾��֤-BBB��
										{"","0104030","0201"},//��֤-�򼶲���
										{"","0106010","0201"},//��Ȼ�˱�֤-AAA��
										{"","0106020","0201"},//��Ȼ�˱�֤-AA��
										{"","0106030","0201"},//��Ȼ�˱�֤-A��
										{"","0106040","0201"},//��Ȼ�˱�֤-BBB��������
										{"","01065","0201"},//����С�黥��
										
										{"AAA","0105050","0101"},//��ҵ��֤-BB��
										{"AAA","0103050","0101"},//������˾��֤-BB��
										{"AAA","0103060","0101"},//������˾��֤-B��
										{"AAA","01070","0101"},//������֤
										{"AA","0105050","0101"},//��ҵ��֤-BB��
										{"AA","0103050","0101"},//������˾��֤-BB��
										{"AA","0103060","0101"},//������˾��֤-B��
										{"AA","01070","0101"},//������֤
										{"A","0105050","0102"},//��ҵ��֤-BB��
										{"A","0103050","0102"},//������˾��֤-BB��
										{"A","0103060","0102"},//������˾��֤-B��
										{"A","01070","0102"},//������֤
										{"BBB","0105050","0201"},//��ҵ��֤-BB��
										{"BBB","0103050","0201"},//������˾��֤-BB��
										{"BBB","0103060","0201"},//������˾��֤-B��
										{"BBB","01070","0201"},//������֤
										{"BB","0105050","0202"},//��ҵ��֤-BB��
										{"BB","0103050","0202"},//������˾��֤-BB��
										{"BB","0103060","0202"},//������˾��֤-B��
										{"BB","01070","0202"},//������֤
										{"B","0105050","0203"},//��ҵ��֤-BB��
										{"B","0103050","0203"},//������˾��֤-BB��
										{"B","0103060","0203"},//������˾��֤-B��
										{"B","01070","0203"},//������֤
										{"","0105050","0201"},//��ҵ��֤-BB��
										{"","0103050","0201"},//������˾��֤-BB��
										{"","0103060","0201"},//������˾��֤-B��
										{"","01070","0201"},//������֤
										
										{"AAA","0105060","0101"},//��ҵ��֤-B��
										{"AA","0105060","0101"},//��ҵ��֤-B��
										{"A","0105060","0102"},//��ҵ��֤-B��
										{"BBB","0105060","0201"},//��ҵ��֤-B��
										{"BB","0105060","0203"},//��ҵ��֤-B��
										{"B","0105060","0203"},//��ҵ��֤-B��
										{"","0105060","0201"},//��ҵ��֤-B��
										
										{"AAA","0201020","0101"},//��Ѻ-��Ʒ����סլ��
										{"AA","0201020","0101"},//��Ѻ-��Ʒ����סլ��
										{"A","0201020","0101"},//��Ѻ-��Ʒ����סլ��
										{"BBB","0201020","0102"},//��Ѻ-��Ʒ����סլ��
										{"BB","0201020","0201"},//��Ѻ-��Ʒ����סլ��
										{"B","0201020","0202"},//��Ѻ-��Ʒ����סլ��
										{"","0201020","0102"},//��Ѻ-��Ʒ����סլ��
										
										{"AAA","0202010","0101"},//��Ѻ-��׼�������������ڣ�
										{"AAA","0203010","0101"},//��Ѻ-���л�������ʹ��Ȩ
										{"AAA","0201010","0101"},//��Ѻ-��Ʒ�������ã�
										{"AAA","0201030","0101"},//��Ѻ-��Ʒ�����칫�ã�
										{"AAA","0203020","0101"},//��Ѻ-���г�������ʹ��Ȩ
										{"AA","0202010","0101"},//��Ѻ-��׼�������������ڣ�
										{"AA","0203010","0101"},//��Ѻ-���л�������ʹ��Ȩ
										{"AA","0201010","0101"},//��Ѻ-��Ʒ�������ã�
										{"AA","0201030","0101"},//��Ѻ-��Ʒ�����칫�ã�
										{"AA","0203020","0101"},//��Ѻ-���г�������ʹ��Ȩ
										{"A","0202010","0102"},//��Ѻ-��׼�������������ڣ�
										{"A","0203010","0102"},//��Ѻ-���л�������ʹ��Ȩ
										{"A","0201010","0102"},//��Ѻ-��Ʒ�������ã�
										{"A","0201030","0102"},//��Ѻ-��Ʒ�����칫�ã�
										{"A","0203020","0102"},//��Ѻ-���г�������ʹ��Ȩ
										{"BBB","0202010","0102"},//��Ѻ-��׼�������������ڣ�
										{"BBB","0203010","0102"},//��Ѻ-���л�������ʹ��Ȩ
										{"BBB","0201010","0102"},//��Ѻ-��Ʒ�������ã�
										{"BBB","0201030","0102"},//��Ѻ-��Ʒ�����칫�ã�
										{"BBB","0203020","0102"},//��Ѻ-���г�������ʹ��Ȩ
										{"BB","0202010","0201"},//��Ѻ-��׼�������������ڣ�
										{"BB","0203010","0201"},//��Ѻ-���л�������ʹ��Ȩ
										{"BB","0201010","0201"},//��Ѻ-��Ʒ�������ã�
										{"BB","0201030","0201"},//��Ѻ-��Ʒ�����칫�ã�
										{"BB","0203020","0201"},//��Ѻ-���г�������ʹ��Ȩ
										{"B","0202010","0202"},//��Ѻ-��׼�������������ڣ�
										{"B","0203010","0202"},//��Ѻ-���л�������ʹ��Ȩ
										{"B","0201010","0202"},//��Ѻ-��Ʒ�������ã�
										{"B","0201030","0202"},//��Ѻ-��Ʒ�����칫�ã�
										{"B","0203020","0202"},//��Ѻ-���г�������ʹ��Ȩ
										{"","0202010","0102"},//��Ѻ-��׼�������������ڣ�
										{"","0203010","0102"},//��Ѻ-���л�������ʹ��Ȩ
										{"","0201010","0102"},//��Ѻ-��Ʒ�������ã�
										{"","0201030","0102"},//��Ѻ-��Ʒ�����칫�ã�
										{"","0203020","0102"},//��Ѻ-���г�������ʹ��Ȩ
										
										{"AAA","0202020","0101"},//��Ѻ-һ�㳧��
										{"AA","0202020","0101"},//��Ѻ-һ�㳧��
										{"A","0202020","0102"},//��Ѻ-һ�㳧��
										{"BBB","0202020","0103"},//��Ѻ-һ�㳧��
										{"BB","0202020","0201"},//��Ѻ-һ�㳧��
										{"B","0202020","0202"},//��Ѻ-һ�㳧��
										{"","0202020","0103"},//��Ѻ-һ�㳧��
										
										{"AAA","0204010","0101"},//��Ѻ-ͨ���豸
										{"AAA","02050","0101"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"AAA","0202030","0101"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"AA","0204010","0101"},//��Ѻ-ͨ���豸
										{"AA","02050","0101"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"AA","0202030","0101"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"A","0204010","0102"},//��Ѻ-ͨ���豸
										{"A","02050","0102"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"A","0202030","0102"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"BBB","0204010","0103"},//��Ѻ-ͨ���豸
										{"BBB","02050","0103"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"BBB","0202030","0103"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"BB","0204010","0202"},//��Ѻ-ͨ���豸
										{"BB","02050","0202"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"BB","0202030","0202"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"B","0204010","0203"},//��Ѻ-ͨ���豸
										{"B","02050","0203"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"B","0202030","0203"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										{"","0204010","0103"},//��Ѻ-ͨ���豸
										{"","02050","0103"},//��ͨ���乤�ߵ�Ѻ�����������ɻ���
										{"","0202030","0103"},//��Ѻ-һ�㳧�������幤ҵ�أ���Ȩ�鼯����ҵ���У�
										
										{"AAA","0204020","0101"},//��Ѻ-�����豸
										{"AAA","02060","0101"},//������Ѻ
										{"AA","0204020","0101"},//��Ѻ-�����豸
										{"AA","02060","0101"},//������Ѻ
										{"A","0204020","0102"},//��Ѻ-�����豸
										{"A","02060","0102"},//������Ѻ
										{"BBB","0204020","0201"},//��Ѻ-�����豸
										{"BBB","02060","0201"},//������Ѻ
										{"BB","0204020","0202"},//��Ѻ-�����豸
										{"BB","02060","0202"},//������Ѻ
										{"B","0204020","0203"},//��Ѻ-�����豸
										{"B","02060","0203"},//������Ѻ
										{"","0204020","0201"},//��Ѻ-�����豸
										{"","02060","0201"},//������Ѻ
										
										{"AAA","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"AAA","0401020","0101"},//��Ѻ-������Ҵ浥
										{"AAA","0402010","0101"},//��Ѻ-��������ծȯ
										{"AAA","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"AAA","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"AAA","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"AAA","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"AAA","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"AAA","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"AA","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"AA","0401020","0101"},//��Ѻ-������Ҵ浥
										{"AA","0402010","0101"},//��Ѻ-��������ծȯ
										{"AA","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"AA","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"AA","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"AA","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"AA","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"AA","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"A","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"A","0401020","0101"},//��Ѻ-������Ҵ浥
										{"A","0402010","0101"},//��Ѻ-��������ծȯ
										{"A","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"A","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"A","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"A","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"A","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"A","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"BBB","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"BBB","0401020","0101"},//��Ѻ-������Ҵ浥
										{"BBB","0402010","0101"},//��Ѻ-��������ծȯ
										{"BBB","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"BBB","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"BBB","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"BBB","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"BBB","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"BBB","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"BB","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"BB","0401020","0101"},//��Ѻ-������Ҵ浥
										{"BB","0402010","0101"},//��Ѻ-��������ծȯ
										{"BB","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"BB","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"BB","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"BB","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"BB","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"BB","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"B","0401010","0102"},//��Ѻ-��������Ҵ浥
										{"B","0401020","0102"},//��Ѻ-������Ҵ浥
										{"B","0402010","0102"},//��Ѻ-��������ծȯ
										{"B","0402020","0102"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"B","0402030","0102"},//��Ѻ-�����н��ڻ���ծȯ
										{"B","0402040","0102"},//��Ѻ-���һ����е�������ҵծȯ
										{"B","0402050","0102"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"B","0404010","0102"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"B","0404030","0102"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										{"","0401010","0101"},//��Ѻ-��������Ҵ浥
										{"","0401020","0101"},//��Ѻ-������Ҵ浥
										{"","0402010","0101"},//��Ѻ-��������ծȯ
										{"","0402020","0101"},//��Ѻ-�С�ũ���������������������������С�ȫ���ɷ�������ծȯ
										{"","0402030","0101"},//��Ѻ-�����н��ڻ���ծȯ
										{"","0402040","0101"},//��Ѻ-���һ����е�������ҵծȯ
										{"","0402050","0101"},//��Ѻ-�����н��ڻ�����������ҵծȯ
										{"","0404010","0101"},//��Ѻ-���гжһ�Ʊ�������Ŷ�ȵģ�
										{"","0404030","0101"},//��Ѻ-���гжһ�Ʊ���ּ�ת���֣������Ŷ�ȵģ�
										
										{"AAA","0402060","0101"},//��Ѻ-��ҵծȯ
										{"AAA","0403010","0101"},//��Ѻ-���й�˾��ͨ��
										{"AAA","0403020","0101"},//��Ѻ-���й�˾���˹�
										{"AAA","0403030","0101"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"AAA","0404040","0101"},//��Ѻ-����
										{"AAA","0405010","0101"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"AAA","0406040","0101"},//��Ѻ-�м�֤ȯ
										{"AA","0402060","0101"},//��Ѻ-��ҵծȯ
										{"AA","0403010","0101"},//��Ѻ-���й�˾��ͨ��
										{"AA","0403020","0101"},//��Ѻ-���й�˾���˹�
										{"AA","0403030","0101"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"AA","0404040","0101"},//��Ѻ-����
										{"AA","0405010","0101"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"AA","0406040","0101"},//��Ѻ-�м�֤ȯ
										{"A","0402060","0101"},//��Ѻ-��ҵծȯ
										{"A","0403010","0101"},//��Ѻ-���й�˾��ͨ��
										{"A","0403020","0101"},//��Ѻ-���й�˾���˹�
										{"A","0403030","0101"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"A","0404040","0101"},//��Ѻ-����
										{"A","0405010","0101"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"A","0406040","0101"},//��Ѻ-�м�֤ȯ
										{"BBB","0402060","0102"},//��Ѻ-��ҵծȯ
										{"BBB","0403010","0102"},//��Ѻ-���й�˾��ͨ��
										{"BBB","0403020","0102"},//��Ѻ-���й�˾���˹�
										{"BBB","0403030","0102"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"BBB","0404040","0102"},//��Ѻ-����
										{"BBB","0405010","0102"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"BBB","0406040","0102"},//��Ѻ-�м�֤ȯ
										{"BB","0402060","0103"},//��Ѻ-��ҵծȯ
										{"BB","0403010","0103"},//��Ѻ-���й�˾��ͨ��
										{"BB","0403020","0103"},//��Ѻ-���й�˾���˹�
										{"BB","0403030","0103"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"BB","0404040","0103"},//��Ѻ-����
										{"BB","0405010","0103"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"BB","0406040","0103"},//��Ѻ-�м�֤ȯ
										{"B","0402060","0103"},//��Ѻ-��ҵծȯ
										{"B","0403010","0103"},//��Ѻ-���й�˾��ͨ��
										{"B","0403020","0103"},//��Ѻ-���й�˾���˹�
										{"B","0403030","0103"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"B","0404040","0103"},//��Ѻ-����
										{"B","0405010","0103"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"B","0406040","0103"},//��Ѻ-�м�֤ȯ
										{"","0402060","0102"},//��Ѻ-��ҵծȯ
										{"","0403010","0102"},//��Ѻ-���й�˾��ͨ��
										{"","0403020","0102"},//��Ѻ-���й�˾���˹�
										{"","0403030","0102"},//��Ѻ-�ɷ�����ҵ���й�Ȩ
										{"","0404040","0102"},//��Ѻ-����
										{"","0405010","0102"},//��Ѻ-��Ʒ��������׼�ֵ�
										{"","0406040","0102"},//��Ѻ-�м�֤ȯ
										
										{"AAA","0403040","0101"},//��Ѻ-�����н��ڻ�����Ȩ
										{"AAA","0403050","0101"},//��Ѻ-�������ڻ�����Ȩ
										{"AAA","0405020","0101"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"AAA","0405030","0101"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"AAA","0405040","0101"},//��Ѻ-�����ϸ�֤
										{"AA","0403040","0101"},//��Ѻ-�����н��ڻ�����Ȩ
										{"AA","0403050","0101"},//��Ѻ-�������ڻ�����Ȩ
										{"AA","0405020","0101"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"AA","0405030","0101"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"AA","0405040","0101"},//��Ѻ-�����ϸ�֤
										{"A","0403040","0102"},//��Ѻ-�����н��ڻ�����Ȩ
										{"A","0403050","0102"},//��Ѻ-�������ڻ�����Ȩ
										{"A","0405020","0102"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"A","0405030","0102"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"A","0405040","0102"},//��Ѻ-�����ϸ�֤
										{"BBB","0403040","0102"},//��Ѻ-�����н��ڻ�����Ȩ
										{"BBB","0403050","0102"},//��Ѻ-�������ڻ�����Ȩ
										{"BBB","0405020","0102"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"BBB","0405030","0102"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"BBB","0405040","0102"},//��Ѻ-�����ϸ�֤
										{"BB","0403040","0103"},//��Ѻ-�����н��ڻ�����Ȩ
										{"BB","0403050","0103"},//��Ѻ-�������ڻ�����Ȩ
										{"BB","0405020","0103"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"BB","0405030","0103"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"BB","0405040","0103"},//��Ѻ-�����ϸ�֤
										{"B","0403040","0103"},//��Ѻ-�����н��ڻ�����Ȩ
										{"B","0403050","0103"},//��Ѻ-�������ڻ�����Ȩ
										{"B","0405020","0103"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"B","0405030","0103"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"B","0405040","0103"},//��Ѻ-�����ϸ�֤
										{"","0403040","0102"},//��Ѻ-�����н��ڻ�����Ȩ
										{"","0403050","0102"},//��Ѻ-�������ڻ�����Ȩ
										{"","0405020","0102"},//��Ѻ-�����ϿɵķǱ�׼�ֵ�
										{"","0405030","0102"},//��Ѻ-�ᵥ��Ψһ���ƾ֤��
										{"","0405040","0102"},//��Ѻ-�����ϸ�֤
										
										{"AAA","0403060","0101"},//��Ѻ-������Ȩ
										{"AAA","0404050","0101"},//��Ѻ-������ת��Ʊ��
										{"AAA","0406010","0101"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"AAA","0406020","0101"},//��Ѻ-��·�շ�Ȩ
										{"AAA","0406030","0101"},//��Ѻ-Ӧ���˿�
										{"AAA","04070","0101"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"AAA","04080","0101"},//��Ѻ-����
										{"AAA","0404020","0101"},//��Ѻ-��ҵ�жһ�Ʊ
										{"AA","0403060","0101"},//��Ѻ-������Ȩ
										{"AA","0404050","0101"},//��Ѻ-������ת��Ʊ��
										{"AA","0406010","0101"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"AA","0406020","0101"},//��Ѻ-��·�շ�Ȩ
										{"AA","0406030","0101"},//��Ѻ-Ӧ���˿�
										{"AA","04070","0101"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"AA","04080","0101"},//��Ѻ-����
										{"AA","0404020","0101"},//��Ѻ-��ҵ�жһ�Ʊ
										{"A","0403060","0102"},//��Ѻ-������Ȩ
										{"A","0404050","0102"},//��Ѻ-������ת��Ʊ��
										{"A","0406010","0102"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"A","0406020","0102"},//��Ѻ-��·�շ�Ȩ
										{"A","0406030","0102"},//��Ѻ-Ӧ���˿�
										{"A","04070","0102"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"A","04080","0102"},//��Ѻ-����
										{"A","0404020","0102"},//��Ѻ-��ҵ�жһ�Ʊ
										{"BBB","0403060","0103"},//��Ѻ-������Ȩ
										{"BBB","0404050","0103"},//��Ѻ-������ת��Ʊ��
										{"BBB","0406010","0103"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"BBB","0406020","0103"},//��Ѻ-��·�շ�Ȩ
										{"BBB","0406030","0103"},//��Ѻ-Ӧ���˿�
										{"BBB","04070","0103"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"BBB","04080","0103"},//��Ѻ-����
										{"BBB","0404020","0103"},//��Ѻ-��ҵ�жһ�Ʊ
										{"BB","0403060","0103"},//��Ѻ-������Ȩ
										{"BB","0404050","0103"},//��Ѻ-������ת��Ʊ��
										{"BB","0406010","0103"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"BB","0406020","0103"},//��Ѻ-��·�շ�Ȩ
										{"BB","0406030","0103"},//��Ѻ-Ӧ���˿�
										{"BB","04070","0103"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"BB","04080","0103"},//��Ѻ-����
										{"BB","0404020","0103"},//��Ѻ-��ҵ�жһ�Ʊ
										{"B","0403060","0103"},//��Ѻ-������Ȩ
										{"B","0404050","0103"},//��Ѻ-������ת��Ʊ��
										{"B","0406010","0103"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"B","0406020","0103"},//��Ѻ-��·�շ�Ȩ
										{"B","0406030","0103"},//��Ѻ-Ӧ���˿�
										{"B","04070","0103"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"B","04080","0103"},//��Ѻ-����
										{"B","0404020","0103"},//��Ѻ-��ҵ�жһ�Ʊ
										{"","0403060","0103"},//��Ѻ-������Ȩ
										{"","0404050","0103"},//��Ѻ-������ת��Ʊ��
										{"","0406010","0103"},//��Ѻ-�м۵Ŀ�ת�õ�Ȩ��
										{"","0406020","0103"},//��Ѻ-��·�շ�Ȩ
										{"","0406030","0103"},//��Ѻ-Ӧ���˿�
										{"","04070","0103"},//��Ѻ-�м۵Ŀ�ת��Ȩ��
										{"","04080","0103"},//��Ѻ-����
										{"","0404020","0103"},//��Ѻ-��ҵ�жһ�Ʊ
										};	
	//ũ������������������������ʽ�������
	public static final String[][] M10 ={{"005","0","01"},//����
										{"005","30","02"},//����
										{"005","60","03"},//����
										{"005","180","04"},//����
										{"005","360","04"},//����
										{"005","999","05"},//����
										{"010","0","01"},//����
										{"010","30","02"},//����
										{"010","60","03"},//����
										{"010","180","03"},//����
										{"010","360","04"},//����
										{"010","999","05"},//����
										{"020","0","01"},//��Ѻ
										{"020","30","02"},//��Ѻ
										{"020","60","02"},//��Ѻ
										{"020","180","03"},//��Ѻ
										{"020","360","04"},//��Ѻ
										{"020","999","05"},//��Ѻ
										{"040","0","01"},//��Ѻ
										{"040","30","01"},//��Ѻ
										{"040","60","02"},//��Ѻ
										{"040","180","03"},//��Ѻ
										{"040","360","04"},//��Ѻ
										{"040","999","05"},//��Ѻ
										};
	//������Ȼ�˴���������������������ʽ�������
	public static final String[][] M11 ={{"005","0","01"},//����
										{"005","30","02"},//����
										{"005","90","03"},//����
										{"005","180","04"},//����
										{"005","360","04"},//����
										{"005","540","05"},//����
										{"005","999","05"},//����
										{"010","0","01"},//����
										{"010","30","02"},//����
										{"010","90","02"},//����
										{"010","180","03"},//����
										{"010","360","04"},//����
										{"010","540","05"},//����
										{"010","999","05"},//����
										{"020","0","01"},//��Ѻ
										{"020","30","02"},//��Ѻ
										{"020","90","02"},//��Ѻ
										{"020","180","03"},//��Ѻ
										{"020","360","04"},//��Ѻ
										{"020","540","04"},//��Ѻ
										{"020","999","05"},//��Ѻ
										{"040","0","01"},//��Ѻ
										{"040","30","01"},//��Ѻ
										{"040","90","02"},//��Ѻ
										{"040","180","03"},//��Ѻ
										{"040","360","04"},//��Ѻ
										{"040","540","04"},//��Ѻ
										{"040","999","05"},//��Ѻ
										};

	/**
	 * �����������������γɷ��շ�����
	 * @param overdueDays
	 * @param vouchType
	 * @return classifyResult
	 */
	public static String ClassifyModelWithOverDueDays(int overdueDays,String[][] M){
		String classifyResult = "";
		int overdueDaysofModel = 0;	
		for(int i=0;i<M.length;i++){
			try{
				overdueDaysofModel = Integer.parseInt(M[i][0]);
			}catch(NumberFormatException ex){
				System.out.println("ģ�����������ڲ������ô������⣡");
			}
			if(overdueDays<=overdueDaysofModel || overdueDaysofModel>=999){
				classifyResult = M[i][1];
				break;
			}
		}
		return classifyResult;
	}
	/**
	 * �������õȼ������γɷ��շ�����
	 * @param creditLevel
	 * @param vouchType
	 * @return classifyResult
	 */
	public static String ClassifyModelWithCreditLevel(String creditLevel,String[][] M){
		String classifyResult = "";
		if(creditLevel == null) creditLevel = "";
		String creditLevelofModel = "";	
		for(int i=0;i<M.length;i++){
			creditLevelofModel = M[i][0];
			if(creditLevel.equals(creditLevelofModel)){
				classifyResult = M[i][1];
				break;
			}
		}
		return classifyResult;
	}
	/**
	 * �������õȼ���������ʽ�����γɷ��շ�����
	 * @param creditLevel
	 * @param vouchType
	 * @return classifyResult
	 */
	public static String ClassifyModelWithCreditLevelVouchType(String creditLevel,String vouchType,String[][] M){
		String classifyResult = "";
		if(creditLevel == null) creditLevel = "";
		if(vouchType == null) vouchType = "";
		String creditLevelofModel = "";	
		String vouchTypeofModel = "";
		for(int i=0;i<M.length;i++){
			creditLevelofModel = M[i][0];
			vouchTypeofModel = M[i][1];
			if(creditLevel.equals(creditLevelofModel)&&vouchType.equals(vouchTypeofModel)){
				classifyResult = M[i][2];
				break;
			}
		}
		return classifyResult;
	}
	/**
	 * ���ݵ�����ʽ���������������γɷ��շ�����
	 * @param creditLevel
	 * @param vouchType
	 * @return classifyResult
	 */
	public static String ClassifyModelWithVouchTypeOverdueDays(String vouchType,int overdueDays,String[][] M){
		String classifyResult = "";
		if(vouchType == null) vouchType = "";
		int overdueDaysofModel = 0;	
		String vouchTypeofModel = "";
		for(int i=0;i<M.length;i++){
			vouchTypeofModel = M[i][0];
			try{
				overdueDaysofModel = Integer.parseInt(M[i][1]);
			}catch(NumberFormatException ex){
				System.out.println("ģ�����������ڲ������ô������⣡");
			}
			
			if(vouchType.equals(vouchTypeofModel)&&(overdueDays <= overdueDaysofModel || overdueDaysofModel>=999)){
				classifyResult = M[i][2];
				break;
			}
		}
		return classifyResult;
	}

	/**
	 * ����������
	 * @param args
	 */
	public static void main(String[] args){
//		System.out.println(ClassifyModelWithOverDueDays(91,M1));
//		System.out.println(ClassifyModel.ClassifyModelWithVouchTypeOverdueDays("020",91,M2));
//		System.out.println(ClassifyModel.ClassifyModelWithOverDueDays(100000, ClassifyModel.M5));
//		System.out.println(ClassifyModel.ClassifyModelWithOverDueDays(181, ClassifyModel.M6));
//		System.out.println(ClassifyModel.ClassifyModelWithCreditLevelVouchType("B","0401010",ClassifyModel.M9));
//		System.out.println(ClassifyModelWithCreditLevel("BB",M9));
		//System.out.println(ClassifyModelWithCreditLevelVouchType("BBB","0103010",M9));
		//System.out.println(ClassifyModelWithVouchTypeOverdueDays("010",89,M10));
	}
}