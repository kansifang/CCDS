package com.lmt.app.display;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.RenderingHints;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.TimeZone;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.StandardChartTheme;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.NumberTickUnit;
import org.jfree.chart.axis.PeriodAxis;
import org.jfree.chart.axis.PeriodAxisLabelInfo;
import org.jfree.chart.block.BlockContainer;
import org.jfree.chart.block.BorderArrangement;
import org.jfree.chart.block.EmptyBlock;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardXYItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.DatasetRenderingOrder;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.chart.title.CompositeTitle;
import org.jfree.chart.title.LegendTitle;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.time.Month;
import org.jfree.data.time.RegularTimePeriod;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.data.time.Year;
import org.jfree.data.xy.XYDataset;
import org.jfree.ui.RectangleEdge;
import org.jfree.ui.RectangleInsets;
import org.jfree.ui.TextAnchor;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class BarALineChart {
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
	public static XYDataset createDataset(String sSql,Transaction Sqlca) throws Exception {
		// ������������  
		TimeSeries series = new TimeSeries("������"); 
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		// �������
		while(rs.next()){
			String date=rs.getString(3);
			int year=Integer.valueOf(date.substring(0, 4));
			int month=Integer.valueOf(date.substring(5, 7));
			RegularTimePeriod YM=new Month(month,year);
			series.add(YM, rs.getDouble(1));  
		}
         // ���������з���һ�����ݼ�����  
         TimeSeriesCollection dataset = new TimeSeriesCollection();  
         dataset.addSeries(series);   
         return dataset;  
     }
	 /** 
     * �����������,�Զ���λ��ʱ�������ϵ���һ��ʱ��㣬�������ݵ���뵽���������� 
     * 
     * @param series    �������ж��� 
     * @param baseData  ���ɵ�������ݵĻ�׼ֵ 
     * @param regularTime   ������ʱ����(�ꡢ�¡��ա�ʱ���֡����) 
     * @param sampleNum  ���ɵ����ݵ���� 
     */  
    public static void setSeriesData(TimeSeries series, double baseData, RegularTimePeriod regularTime, int sampleNum) {  
        // �������ģ������  
        double value = baseData;  
        for (int i = 0; i < sampleNum; i++) {  
            series.add(regularTime, value);       
            regularTime = regularTime.next();   //�Զ���λ����һ��ʱ���  
            value *= (1.0D + (Math.random() - 0.495D) / 4.0D);  
        }  
    }  
    public static JFreeChart getJfreeChart(String sSql,Transaction Sqlca) throws Exception{
    	String []ASql=sSql.split("YJFGF");
    	//1����״ͼ��ȡ����
    	HashSet<String> bars=new HashSet<String>();
		// ������״���ݶ���
		DefaultCategoryDataset PDBar = new DefaultCategoryDataset();
		ASResultSet rs=Sqlca.getASResultSet(ASql[0]);
		// �������
		while(rs.next()){
			String barlable=rs.getString(2);
			PDBar.setValue(rs.getDouble(1), barlable,rs.getString(3));
			bars.add(barlable);			
		}
		rs.getStatement().close();
    	// 2������ͼ��ȡ����
    	HashSet<String> lines=new HashSet<String>();
		// �����������ݶ���
		DefaultCategoryDataset PDLine = new DefaultCategoryDataset();
		rs=Sqlca.getASResultSet(ASql[1]);
		// �������
		while(rs.next()){
			String linelable=rs.getString(2);
			PDLine.setValue(rs.getDouble(1), linelable,rs.getString(3));
			lines.add(linelable);			
		}
		rs.getStatement().close();
		//��������״ͼ��Ȼ������ͼ���������
		JFreeChart jf = ChartFactory.createBarChart3D("", "", "", PDBar, PlotOrientation.VERTICAL, true, true, false);//PlotOrientation.HORIZONTAL ��ʾ������ͺ����껥��
		// ����״ͼ����������ʽ
		BarALineChart.setBarStyle(jf,bars.size(),PDLine,lines.size());

    	//JFreeChart jf =ChartFactory.createLineChart("", "", "", PDLine, PlotOrientation.VERTICAL, true, true, false);
		// ������ͼ����������ʽ
		//BarALineChart.setLineStyle(jf,lines.size());
		return jf;
    }
    /*
	 * ��ͼ�����������ʽ
	 */
	public static void setBarStyle(JFreeChart chart,int bars,DefaultCategoryDataset PDLine,int lines ){
		chart.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		// �õ�ͼ����⣬��������������
		//1�����ñ�������� 
		TextTitle textTitle = chart.getTitle(); 
		String fontA = "����"; 
		textTitle.setFont(new Font(fontA,Font.PLAIN,13)); 
		textTitle.setBackgroundPaint(new GradientPaint(0.0F, 0.0F, Color.decode("#EEF7FF"), 250F, 0.0F, Color.white, true)); 
		textTitle.setExpandToFitSpace(true); 
		//�õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		chart.getLegend().setVisible(false);
		//��jfreechart��RenderingHints��������Ⱦ�������޸�
				//VALUE_TEXT_ANTIALIAS_OFF��ʾ�����ֵĿ���ݹر�.
				//ʹ�õĹرտ���ݺ����御��ѡ��12��14�ŵ������֡�
				//���������������ÿ� 
		chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_OFF);

		//�õ���״ͼ��ʽ����ʽ
		CategoryPlot plot = (CategoryPlot) chart.getCategoryPlot(); 
		//for(int i=1;i<=lines;i++){
			//plot.setDataset(i, PDLine);
		//}
		plot.setDataset(1, PDLine);//��һ�����ߣ�������Լ������
		plot.mapDatasetToRangeAxis(1, 1); 
        plot.setBackgroundPaint(Color.white); 
        plot.setRangeGridlinePaint(Color.white); 
        plot.setOutlinePaint(Color.white);  //����ͼƬ�߿���ɫ��ȥ���߿� 
 
        //�������ʽ��� 
        BarRenderer renderer = (BarRenderer) plot.getRenderer(); 
        renderer.setSeriesPaint(0, Color.orange); 
        renderer.setDrawBarOutline(false); 
        //������������,API�о�Ȼû��StandardCategoryItemLabelGenerator����� 
        renderer.setItemLabelGenerator(new StandardCategoryItemLabelGenerator()); 
        renderer.setSeriesItemLabelsVisible(0, true); 
 
        /*------����Y��----*/ 
        double unit=1d;//�̶ȵĳ��� 
        //�ұ�Y�ᣬ����������� 
        NumberAxis numberaxis1 = new NumberAxis(""); 
        numberaxis1 .setAutoTickUnitSelection(true);  
        //unit=Math.floor(10);//�̶ȵĳ��� 
       // NumberTickUnit ntu= new NumberTickUnit(unit); 
        //numberaxis1.setTickUnit(ntu); 
        //numberaxis1.setRange(0,100);//�̶ȷ�Χ 
        numberaxis1.setUpperMargin(0.35); 
        plot.setRangeAxis(1, numberaxis1); 
        
        //���Y�� 
        NumberAxis numberaxis = (NumberAxis) plot.getRangeAxis(); 
        numberaxis .setAutoTickUnitSelection(true);         
        //numberaxis.setRange(0.0, 100.0);//�̶ȵķ�Χ 
        //ntu= new NumberTickUnit(unit); 
        //numberaxis .setTickUnit(ntu); 
        /*------������״����ͼƬ�߿�����¼��---*/ 
        numberaxis.setUpperMargin(0.51); 
        numberaxis.setLowerMargin(0.05); 
 
        /*------����X��----*/ 
        CategoryAxis domainAxis = plot.getDomainAxis(); 
        domainAxis.setCategoryLabelPositions(CategoryLabelPositions.STANDARD); 
        /*------����X��������б�̶�----*/ 
        domainAxis.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI / 6.0)); 
        //domainAxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45); //������������б45�� 
        
        domainAxis.setLabelFont(new Font(fontA,Font.PLAIN,14)); 
        //���ú���������ʾ����ҵ����������� 
        domainAxis.setTickLabelFont(new Font(fontA,Font.HANGING_BASELINE,13)); 
        domainAxis.setMaximumCategoryLabelLines(100); 
        domainAxis.setMaximumCategoryLabelWidthRatio(100); 
        
      //��ֹ��������̫�ٶ���̬���������ȣ�JFreeChartĬ���Ǹ���������ٶ���ʾ�����ȵģ� 
        if (bars == 1) { 
        	/*------������״����ͼƬ�߿�����Ҽ��--*/ 
        	domainAxis.setLowerMargin(0.26); 
            domainAxis.setUpperMargin(0.66); 
        } else if (bars< 6) { 
            double margin = (1.0 - bars * 0.08) / 3; 
            domainAxis.setLowerMargin(margin); 
            domainAxis.setUpperMargin(margin); 
            renderer.setItemMargin(margin); 
        } else { 
        	renderer.setItemMargin(0.1); 
        } 
        
        
        //��������ͼ����ʽ 
        LineAndShapeRenderer lineandshaperenderer = new LineAndShapeRenderer(); 
        lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator()); 
        lineandshaperenderer.setBaseItemLabelsVisible(true); 
        lineandshaperenderer.setBaseItemLabelFont(new Font("����", Font.BOLD, 10)); 
 
        plot.setRenderer(1, lineandshaperenderer); 
        plot.setDatasetRenderingOrder(DatasetRenderingOrder.FORWARD); 
        //ͼ��1�����������ʽ���� 
        LegendTitle legendtitle = new LegendTitle(plot.getRenderer(0)); 
        //ͼ��2�����������ʽ���� 
        LegendTitle legendtitle1 = new LegendTitle(plot.getRenderer(1)); 
        BlockContainer blockcontainer = new BlockContainer(new BorderArrangement()); 
        blockcontainer.add(legendtitle, RectangleEdge.LEFT); 
        blockcontainer.add(legendtitle1, RectangleEdge.RIGHT); 
        blockcontainer.add(new EmptyBlock(20D, 0.0D)); 
        CompositeTitle compositetitle = new CompositeTitle(blockcontainer); 
        compositetitle.setPosition(RectangleEdge.BOTTOM); 
        chart.addSubtitle(compositetitle); 
 
        chart.setAntiAlias(false); 
        chart.getRenderingHints().put(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_OFF); 
	}
	/*
	 * ��ͼ�����������ʽ
	 */
	public static void setLineStyle(JFreeChart chart,int lines){
		// �õ�ͼ����⣬��������������
		chart.getTitle().setFont(new Font("����",0,20));
		// �õ�ͼ��ײ���𣬲�������������
		chart.getLegend().setItemFont(new Font("����",0,12));
		// �õ�����ͼ��ʽ����ʽ���������ø�����Զ����������        
		CategoryPlot plot = (CategoryPlot)chart.getPlot();
		// �õ�Y�����ᣬ��������˵������
		plot.getRangeAxis().setLabelFont(new Font("����",0,12));
		// �õ�Y�����ᣬ����������������
		plot.getRangeAxis().setTickLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ��������˵������
		plot.getDomainAxis().setLabelFont(new Font("����",0,12));
		// �õ�X�����ᣬ����������������
		plot.getDomainAxis().setTickLabelFont(new Font("����",0,12));
		
		GradientPaint bg = new GradientPaint(0, 50, new Color(248, 253, 255),0, 250, new Color(205, 237, 252));  
		plot.setBackgroundPaint(bg); 
		plot.setDomainGridlinePaint(Color.BLACK);  
		plot.setDomainGridlinesVisible(true);   
		plot.setRangeGridlinePaint(Color.RED); 
		//�������񱳾���ɫ
        plot.setBackgroundPaint(new Color(255, 255, 204)); 
        //��������������ɫ
        plot.setDomainGridlinePaint(Color.pink);
        //�������������ɫ
        plot.setRangeGridlinePaint(Color.pink);
        //��������ͼ��xy��ľ���
        plot.setAxisOffset(new RectangleInsets(5D, 0D, 0D, 10D));
		// ���ú����������� 
		CategoryAxis domainAxis = plot.getDomainAxis(); 
		domainAxis.setLabelFont(new Font("����", Font.BOLD, 15)); 
		domainAxis.setMinorTickMarksVisible(true);
		domainAxis.setMinorTickMarkInsideLength(50);//ÿ10���̶���ʾһ���̶�ֵ
		//domainAxis.setCategoryLabelPositionOffset(10);
		domainAxis.setCategoryLabelPositions(CategoryLabelPositions.DOWN_45);//����ֵ����ת
		// ��������������ֵ����弰����ת����  
		NumberAxis rangeAxis = (NumberAxis)plot.getRangeAxis(); 
		rangeAxis.setLabelFont(new Font("����", Font.BOLD, 15)); 
		rangeAxis.setLabelAngle(Math.PI/2);   
		//rangeAxis.setAutoTickUnitSelection(false);
		//double unit=5d;//�̶ȵĳ���
		//NumberTickUnit ntu= new NumberTickUnit(unit);
		//rangeAxis.setTickUnit(ntu);
		//rangeAxis.setLowerBound(10);
		//rangeAxis.setAutoRangeMinimumSize(100);//����չʾ��ֵ�÷�Χ
		//rangeAxis.setTickMarksVisible(true);
		//rangeAxis.setTickMarkOutsideLength(30);
		// ��ȡ��Ⱦ����        �ߺ����ϱ�ǩ
		LineAndShapeRenderer lineandshaperenderer = (LineAndShapeRenderer) plot.getRenderer(); 
        //���������Ƿ���ʾ���ݵ�
        lineandshaperenderer.setBaseShapesVisible(true);
        lineandshaperenderer.setItemLabelAnchorOffset(1D);//ʱ�������ݱ�ǩ�ľ���
        //����������ʾλ��
        /**/
		// �Զ����߶εĻ��Ʒ�� 
		for (int i = 0; i < lines; i++)  { 
			//���ö���
			if (i % 3 == 0){   
				lineandshaperenderer.setSeriesStroke(i,new BasicStroke(2.0f)); //
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.TOP_LEFT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("����", Font.BOLD,12));
			}else if (i % 3 == 1){   
				lineandshaperenderer.setSeriesStroke(i,new BasicStroke(2.0f)); //
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.BOTTOM_LEFT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("����", Font.ITALIC,12));
			}else{   
				lineandshaperenderer.setSeriesStroke(i, new BasicStroke(2.0f,BasicStroke.CAP_ROUND,BasicStroke.JOIN_ROUND,10.f,new float[]{20F, 6F},0.0f));  //����  �߳��ȣ�20F, ȱ�ڳ���6F,�߳��ȣ�20F, ȱ�ڳ���6F...
				lineandshaperenderer.setSeriesPositiveItemLabelPosition(i,new ItemLabelPosition(ItemLabelAnchor.INSIDE1, TextAnchor.BOTTOM_RIGHT)); 
				lineandshaperenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
				lineandshaperenderer.setSeriesItemLabelsVisible(i, true);
				lineandshaperenderer.setSeriesItemLabelFont(i, new Font("����", Font.CENTER_BASELINE,12));
			}
		}        
		// �����Զ���ͼ����Ƶ��������    
		//ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());  
		// ����ͼƬ���ɸ�ʽ       
		//String fileName =      ServletUtilities.saveChartAsPNG(chart, width, height, info, session);        
		// ����ͼƬ����·��  
		//String graphURL =      request.getContextPath() + "/servlet/DisplayChart?filename=" + fileName; 
	}
	 /** 
     * ����jfreechartͼ�� 
     * */  
    public static JFreeChart createChart(String sSql,Transaction Sqlca) {  
        // ����ͼ�����ݼ���  
        XYDataset xyDataset=null;
		try {
			//xyDataset = (XYDataset) getDataSet(sSql,Sqlca);
			xyDataset = createDataset(sSql,Sqlca);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}   
        // ���Ӻ���֧��  
        StandardChartTheme standardChartTheme=new StandardChartTheme("CN");     //����������ʽ            
        standardChartTheme.setExtraLargeFont(new Font("����",Font.BOLD,20));    //���ñ�������         
        standardChartTheme.setRegularFont(new Font("SimSun",Font.PLAIN,15));    //����ͼ��������      
        standardChartTheme.setLargeFont(new Font("����",Font.PLAIN,15));      //�������������     
        //�������񱳾���ɫ    
        //standardChartTheme.setBaselinePaint(Color.WHITE); 
        //��������������ɫ   
        //standardChartTheme.setDomainGridlinePaint(Color.blue);
        //�������������ɫ   
        standardChartTheme.setRangeGridlinePaint(Color.green);
        standardChartTheme.setAxisOffset(new RectangleInsets(0D, 1D, 0D, 30D));
        ChartFactory.setChartTheme(standardChartTheme); //Ӧ��������ʽ      
          
        // ����һ��ʱ������ͼ���JFreeChart  
        JFreeChart jFreeChart = ChartFactory.createTimeSeriesChart(  
                "����ͼչʾ",   // ͼ����  
                "ʱ��",               // �����ǩ����  
                "��ֵ",               // �����ǩ����  
                xyDataset,          // ͼ������ݼ���  
                true,               // �Ƿ���ʾͼ����ÿ���������е�˵��  
                false,              // �Ƿ���ʾ������ʾ  
                false);             // �Ƿ���ʾͼ�������õ�url��������  
      
        // XYPlotͼ����������ö���,��������ͼ���һЩ��ʾ����  
        XYPlot xyPlot = (XYPlot) jFreeChart.getPlot();    
 	 		
     // ��ȡ��Ⱦ����    
        // �������ݵ�������ߵ���ʾ��ʽ  
        XYItemRenderer item = xyPlot.getRenderer();
        if (item instanceof XYLineAndShapeRenderer) {  
            XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer) item;  
            renderer.setBaseShapesVisible(true);    // ���ݵ���ʾ���  
            renderer.setBaseShapesFilled(true); // ���ݵ���������  
            
        }  
         //����������ʾ�����ݵ��ֵ
         //���������Ƿ���ʾ���ݵ�
         //item.setBaseSeriesVisible(true);
         //����������ʾλ��
         item.setBaseItemLabelsVisible(true);
         item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_LEFT));
         //item.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER));
         //���������Ƕ���������ͼ���ݱ�ʾ�Ĺؼ�����
         item.setBaseItemLabelGenerator(new StandardXYItemLabelGenerator());
         item.setBaseItemLabelFont(new Font("Dialog", 1, 14));
         xyPlot.setRenderer(item);
          
         ///////////////////////////////  �¹��ܵ� /////////////////////////////////////////    
        // �Զ����µ�ʱ���ᣬ������ʾ����ʱ���ǩ  
        PeriodAxis periodAxis = new PeriodAxis("ʱ��");   // �Զ���Xʱ����  
        periodAxis.setTimeZone(TimeZone.getDefault());  // ʹ��Ĭ��ʱ��  
        periodAxis.setAutoRangeTimePeriodClass(Month.class); // ���ø�ʱ����Ĭ���Զ�����ʱ�䵥λΪ�� �� Day.class
        // ���ò�ͬ�ص�ʱ����ʾ��ʽ  
        PeriodAxisLabelInfo[] arrayOfPeriodAxisLabelInfo = new PeriodAxisLabelInfo[2];  
        //arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Day.class, new SimpleDateFormat("dd")); // ��һ����ʾ��  
        arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"), new RectangleInsets(2.0D,2.0D,2.0D,2.0D), new Font("SansSerif", 1, 10), Color.blue, false, new BasicStroke(5.0F), Color.lightGray); // �ڶ�����ʾ��  
       // arrayOfPeriodAxisLabelInfo[0] = new PeriodAxisLabelInfo(Month.class, new SimpleDateFormat("MM"));
        arrayOfPeriodAxisLabelInfo[1] = new PeriodAxisLabelInfo(Year.class, new SimpleDateFormat("yyyy")); // ��������ʾ��  
        periodAxis.setLabelInfo(arrayOfPeriodAxisLabelInfo); // ����ʱ�����ϵ�ʱ����ʾ��ʽ  
        xyPlot.setDomainAxis(periodAxis);   // ����Xʱ����  
        
        ChartUtilities.applyCurrentTheme(jFreeChart); // ʹ�õ�ǰ����  
          
        //setStyle(jFreeChart);
        return jFreeChart;  
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
