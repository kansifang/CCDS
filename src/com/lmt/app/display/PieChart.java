package com.lmt.app.display;

import java.awt.Color;
import java.awt.Font;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PiePlot;
import org.jfree.data.general.DefaultPieDataset;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class PieChart {
	/*
	 * �������
	 */
	public static void main(String[] args) {
		// ������״ͼ����
		//JFreeChart ��״ͼ = ChartFactory.createPieChart("ˮ���г�ռ��ͳ��", getDataSet(), true, true, true);
		// ����״ͼ����������ʽ
		//setStyle(��״ͼ);
		// �Ա�״ͼ��������ͼƬ
		//����ͼƬ("E:\\��״ͼ.jpg",��״ͼ,800,600);
	}
	/*
	 * �õ�����
	 */
	public static DefaultPieDataset getDataSet(String sSql,Transaction Sqlca) throws Exception{
		// ������״���ݶ���
		DefaultPieDataset PD = new DefaultPieDataset();
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			PD.setValue(rs.getString(1), rs.getDouble(2));
		}
		// ��������
		return PD;
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
		PiePlot ��״ͼ��ʽ = (PiePlot)ͼ��.getPlot();
		// ���ñ�״ͼ����
		��״ͼ��ʽ.setLabelFont(new Font("����",0,12));
		// ���ñ�ͼ����ʾ��Ϣ
		��״ͼ��ʽ.setSectionOutlinePaint("����",Color.white);
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
