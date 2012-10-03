
package com.amarsoft.impl.tjnh_als.bizlets;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Date;

/**
 * @author Anthony Cao
 *
 */
public class SocketManager {

	public Socket client = null;

	//private BufferedReader socketReader = null;

	//private PrintWriter socketWriter = null;

	private String hostIp = "";

	private int hostPort = 0;
	private int timeOut= 0;
	
	private DataInputStream inpS = null;
	private OutputStream outpS = null;

	/**
	 * ���������ַ����˿ں�
	 */
	public SocketManager(String theHostIp, String theHostPort) {
		hostIp = theHostIp;
		hostPort = Integer.parseInt(theHostPort);
	}
	/**
	 * ���������ַ����˿ں�,��ʱʱ��
	 */
	public SocketManager(String theHostIp, String theHostPort, String theTimeout) {
		hostIp = theHostIp;
		hostPort = Integer.parseInt(theHostPort);
		timeOut = Integer.parseInt(theTimeout);
		
	}

	/**
	 * �����������ֶ˿ں�
	 */
	public SocketManager(String theHostIp, int theHostPort) {
		hostIp = theHostIp;
		hostPort = theHostPort;
	}

	/**
	 * �������������ͨѶ
	 */
	public boolean setupConnection() {
	
		
		try {
		   //client = new Socket(hostIp, hostPort);
			SocketConn socketconn= new SocketConn(hostIp, hostPort);
			socketconn.connect(hostIp, hostPort,timeOut);
			client = socketconn.getSocket();
			//������δ������BUG������ȴ�����ʱ���������ô������ʱ���ܻ�û���õ����Ӿ��˳��ˣ��������ӵȴ�ʱ��
			long startTime = new Date().getTime();
			while(client==null){
				if((new Date().getTime() - startTime) >= timeOut && timeOut>0)
					return false;
				try
				{
					wait(1000);
				}
				catch(InterruptedException e)
				{
					e.printStackTrace();
				}
			}
			//socketReader = new BufferedReader(new InputStreamReader(client.getInputStream()));
			//socketWriter = new PrintWriter(client.getOutputStream());
			inpS = new DataInputStream(new BufferedInputStream(
					client.getInputStream()));
			outpS = new DataOutputStream(new BufferedOutputStream(
					client.getOutputStream()));
			System.out.println("Init socket success!");
			return true;
		} catch (UnknownHostException e) {
			System.out.println("Error setting up socket connection: unknown host at " + hostIp + ":" + hostPort);
			return false;
		} catch (IOException e) {
			System.out.println("Error setting up socket connection: " + e);
			return false;
		}
	}

	/**
	 * �Ͽ����������ͨѶ
	 */
	public void teardownConnection() {
		try {
			if (inpS != null) {
				inpS.close();
				inpS = null;
			}
			if (outpS != null) {
				outpS.close();
				outpS = null;
			}
			if (client != null) {
				client.close();
				client = null;
			}
		} catch (IOException e) {
			System.out.println("Error tearing down socket connection: " + e);
		}
	}
	
	/**
	 * ��ϱ���
	 */
	public void write(byte[] bBuf) {
		try {
			outpS.write(bBuf);
		} catch (IOException e) {
			System.out.println("д������ʱ����: " + e);
		}
	}
	/**
	 * ���ͱ���
	 */
	public void flush() {
		try {
			outpS.flush();
		} catch (IOException e) {
			System.out.println("��������ʱ����: " + e);
		}
	}
	/**
	 * ���ձ���ͷ
	 */
	public void read(byte[] bBuf) {
		try {
			inpS.read(bBuf);
		} catch (IOException e) {
			System.out.println("��������ʱ����: " + e);
		}
	}	
	/**
	 * ���ձ�����
	 */
	public void readFully(byte[] bBuf) {
		try {
			inpS.readFully(bBuf);
		} catch (IOException e) {
			System.out.println("��������ʱ����: " + e);
		}
	}
	
	/**
	 * ����main����
	 * @param args
	 */
	public static void main(String[] args) {

	}

}

//--------------
class SocketConn implements Runnable {

	private String ip;
	private int port;
	private java.net.Socket sock = null;

	public SocketConn(String ip, int port) {
		this.ip = ip;
		this.port = port;
	}

	public Socket getSocket() {
		return sock;
	}

	public void run() {
		try {
			sock = new Socket(ip, port);
		} catch (UnknownHostException ex) {
			System.out.println(
				"Error-UnknownHostException:Socket connect-->>>"
					+ ex.getMessage());
		} catch (IOException ex) {
			System.out.println(
				"Error-IOException:Socket connect--->>>" + ex.getMessage());
		}
	}
	public  void connect(String ip, int port, int timeout) {
	//	Socket sock = null;
		Runnable run = new SocketConn(ip, port);
		try {
			Thread t = new Thread(run);
			t.start();
			t.join(timeout);
		} catch (IllegalThreadStateException ex) {
			System.out.println(
				"Error-IllegalThreadStateException:connect " + ex.getMessage());
		} catch (InterruptedException ex) {
			System.out.println(
				"Error-InterruptedException:connect " + ex.getMessage());
		}

		this.sock = ((SocketConn) run).getSocket();

	//	return sock;
	}

}
