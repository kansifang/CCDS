package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.io.File;
import java.io.IOException;

import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.labels.StandardPieToolTipGenerator;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PiePlot3D;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.util.Rotation;

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
	public static void setStyle(boolean is3D,JFreeChart chart){
		// �õ�ͼ����⣬��������������
		chart.getTitle().setFont(new Font("����",0,20));
		// �õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		// �õ���״ͼ��ʽ����ʽ
		PiePlot plot = (PiePlot)chart.getPlot();
		if(is3D){
			plot = (PiePlot3D) chart.getPlot(); 
		}
		// ���ñ�״ͼ����
		plot.setLabelFont(new Font("����",0,12));
		// ���ñ�ͼ����ʾ��Ϣ
		plot.setSectionOutlinePaint("����",Color.white);
		 // ͼƬ����ɫ    
        chart.setBackgroundPaint(Color.red);  
        //���ÿ�ʼ�Ƕ� 
        plot.setStartAngle(150D); 
        //���÷���Ϊ��˳ʱ�뷽�� 
        plot.setDirection(Rotation.CLOCKWISE); 
        //����͸���ȣ�0.5FΪ��͸����1Ϊ��͸����0Ϊȫ͸�� 
        plot.setForegroundAlpha(0.5F); 
        plot.setNoDataMessage("��������ʾ"); 
        // ͼ�α߿���ɫ    
        plot.setBaseSectionOutlinePaint(Color.RED);    
        plot.setBaseSectionPaint(Color.WHITE); 
        //ָ�� section �����ߵĺ��
        plot.setBaseSectionOutlineStroke(new BasicStroke(0));
        // ͼ�α߿��ϸ    
        plot.setBaseSectionOutlineStroke(new BasicStroke(1.0f));    
        // ָ��ͼƬ��͸����(0.0-1.0)    
        plot.setForegroundAlpha(0.65f);    
        // ָ����ʾ�ı�ͼ��Բ��(false)����Բ��(true)    
        plot.setCircular(true);    
        // ���������ͣ��ʾ    
        plot.setToolTipGenerator(new StandardPieToolTipGenerator());    
        // ����ͻ����ʾ�����ݿ�    
        plot.setExplodePercent("One", 0.1D);    
		
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
