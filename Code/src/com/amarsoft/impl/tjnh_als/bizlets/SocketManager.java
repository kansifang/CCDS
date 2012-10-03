
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
	 * 构造器，字符串端口号
	 */
	public SocketManager(String theHostIp, String theHostPort) {
		hostIp = theHostIp;
		hostPort = Integer.parseInt(theHostPort);
	}
	/**
	 * 构造器，字符串端口号,超时时间
	 */
	public SocketManager(String theHostIp, String theHostPort, String theTimeout) {
		hostIp = theHostIp;
		hostPort = Integer.parseInt(theHostPort);
		timeOut = Integer.parseInt(theTimeout);
		
	}

	/**
	 * 构造器，数字端口号
	 */
	public SocketManager(String theHostIp, int theHostPort) {
		hostIp = theHostIp;
		hostPort = theHostPort;
	}

	/**
	 * 建立与服务器的通讯
	 */
	public boolean setupConnection() {
	
		
		try {
		   //client = new Socket(hostIp, hostPort);
			SocketConn socketconn= new SocketConn(hostIp, hostPort);
			socketconn.connect(hostIp, hostPort,timeOut);
			client = socketconn.getSocket();
			//下面这段代码存在BUG，如果等待连接时间过长，那么程序到这时可能还没有拿到连接就退出了，所以增加等待时间
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
	 * 断开与服务器的通讯
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
	 * 组合报文
	 */
	public void write(byte[] bBuf) {
		try {
			outpS.write(bBuf);
		} catch (IOException e) {
			System.out.println("写入数据时出错: " + e);
		}
	}
	/**
	 * 发送报文
	 */
	public void flush() {
		try {
			outpS.flush();
		} catch (IOException e) {
			System.out.println("发送数据时出错: " + e);
		}
	}
	/**
	 * 接收报文头
	 */
	public void read(byte[] bBuf) {
		try {
			inpS.read(bBuf);
		} catch (IOException e) {
			System.out.println("接收数据时出错: " + e);
		}
	}	
	/**
	 * 接收报文体
	 */
	public void readFully(byte[] bBuf) {
		try {
			inpS.readFully(bBuf);
		} catch (IOException e) {
			System.out.println("接收数据时出错: " + e);
		}
	}
	
	/**
	 * 调试main函数
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
