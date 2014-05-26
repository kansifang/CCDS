package com.lmt.app.display;

import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class LineChart {
	/*
	 * �������
	 */
	public static void main(String[] args) {
		// ��������ͼ����
		//JFreeChart ����ͼ = ChartFactory.createLineChart("ˮ������ͳ��", "ʱ��", "����", �õ�����(), PlotOrientation.VERTICAL, true, true, true);
		// ������ͼ����������ʽ
		//setStyle(����ͼ);
		// ������ͼ��������ͼƬ
		//����ͼƬ("E:\\����ͼ.jpg",����ͼ,800,600);
	}
	/*
	 * �õ�����
	 */
	public static CategoryDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// ������״���ݶ���
		DefaultCategoryDataset PD = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			PD.setValue(rs.getDouble(1), rs.getString(2),rs.getString(3));
		}
		// ��������
		return PD;
		// �����������ݶ���
	}
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setStyle(JFreeChart ͼ��){
		// �õ�ͼ����⣬��������������
		ͼ��.getTitle().setFont(new Font("����",0,20));
		// �õ�ͼ��ײ���𣬲�������������
		ͼ��.getLegend().setItemFont(new Font("����",0,12));
		// �õ�����ͼ��ʽ����ʽ
		CategoryPlot ����ͼ��ʽ = (CategoryPlot)ͼ��.getPlot();
		// �õ�Y�����ᣬ��������˵������
		����ͼ��ʽ.getRangeAxis().setLabelFont(new Font("����",0,12));
		// �õ�Y�����ᣬ����������������
		����ͼ��ʽ.getRangeAxis().setTickLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ��������˵������
		����ͼ��ʽ.getDomainAxis().setLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ����������������
		����ͼ��ʽ.getDomainAxis().setTickLabelFont(new Font("����",0,12));
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
