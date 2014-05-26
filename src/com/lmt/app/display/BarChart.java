package com.lmt.app.display;

import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

import com.lmt.frameapp.sql.Transaction;

public class BarChart {
	/*
	 * �������
	 */
	public static void main(String[] args) {
		// ������״ͼ����
		//JFreeChart ��״ͼ = ChartFactory.createBarChart3D("ˮ������ͳ��", "ˮ��", "����", �õ�����(), PlotOrientation.VERTICAL, true, true, true);
		// ����״ͼ����������ʽ
		//setStyle(��״ͼ);
		// ����״ͼ��������ͼƬ
		//����ͼƬ("D:\\��״ͼ.jpg",��״ͼ,800,600);
	}
	/*
	 * �õ�����
	 */
	public static DefaultCategoryDataset getDataSet(String sSql,Transaction Sqlca){
		// ������״���ݶ���
		DefaultCategoryDataset ��״���� = new DefaultCategoryDataset();
		// �������
		��״����.addValue(200, "����", "ƻ��");
		��״����.addValue(100, "����", "ƻ��");
		��״����.addValue(200, "�½�", "ƻ��");
		��״����.addValue(50, "����", "�㽶");
		��״����.addValue(30, "����", "�㽶");
		��״����.addValue(10, "�½�", "�㽶");
		��״����.addValue(10, "����", "����");
		��״����.addValue(20, "����", "����");
		��״����.addValue(200, "�½�", "����");
		// ��������
		return ��״����;
	}
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart ͼ��){
		// �õ�ͼ����⣬��������������
		ͼ��.getTitle().setFont(new Font("����",0,20));
		// �õ�ͼ��ײ���𣬲�������������
		ͼ��.getLegend().setItemFont(new Font("����",0,12));
		// �õ���״ͼ��ʽ����ʽ
		CategoryPlot ��״ͼ��ʽ = (CategoryPlot)ͼ��.getPlot();
		// �õ�Y�����ᣬ��������˵������
		��״ͼ��ʽ.getRangeAxis().setLabelFont(new Font("����",0,12));
		// �õ�Y�����ᣬ����������������
		��״ͼ��ʽ.getRangeAxis().setTickLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ��������˵������
		��״ͼ��ʽ.getDomainAxis().setLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ����������������
		��״ͼ��ʽ.getDomainAxis().setTickLabelFont(new Font("����",0,12));
	}
	/*
	 * ����ͼƬ
	 */
	public static void ����ͼƬ(String �ļ���ַ,JFreeChart ͼ��,int ���,int �߶�){
		try {
			// ʹ��ͼ���߱����ļ�
			ChartUtilities.saveChartAsJPEG(new File(�ļ���ַ),ͼ��,��� ,�߶�);
		}catch (IOException e) {
			e.printStackTrace();
		}
	}
}
