package network;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

import model.Message;

public class UDPSender {
	
	private DatagramSocket socket;
	
	public UDPSender(){
		try {
			this.socket = new DatagramSocket();
		} catch (SocketException e) {
			System.err.println("Socket couldn't be created.");
			e.printStackTrace();
		}
	}
	
	public void sendMess(Message mes, InetAddress iptosend){
		int port = 1234;
		byte[] buf = new byte[2048];
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(baos);
			oos.writeObject(mes);
			oos.close();
			buf=baos.toByteArray();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		DatagramPacket mestosend = new DatagramPacket(buf, buf.length, iptosend, port);
		try {
			this.socket.send(mestosend);
		} catch (IOException e) {
			System.err.println("Message failed to send");
			e.printStackTrace();
		}
	}
	
	public void sendMessBroadcast(Message mes){
		int port = 8041;
		byte[] buf = new byte[2048];
		
		// create packet to send
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(baos);
			oos.writeObject(mes);
			oos.close();
			buf=baos.toByteArray();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		// send packet broadcast
		try {
			InetAddress iptosend = InetAddress.getByName("255.255.255.255");
			DatagramPacket mestosend = new DatagramPacket(buf, buf.length, iptosend, port);
			this.socket.send(mestosend);
		}catch (SocketException e){
			System.err.println("java.net.SocketException: [UDPS]Socket closed");
		}catch (UnknownHostException e1) {
			System.err.println("UnknownHostException for broadcast 255.255.255.255");
			e1.printStackTrace();
		} catch (IOException e) {
			System.err.println("Message failed to send");
			e.printStackTrace();
		}
	}
	
	public void closeSocket(){
		if (!this.socket.isClosed()){
			this.socket.close();
		}
	}
	
	@Override
	protected void finalize(){
		if (!this.socket.isClosed()){
			this.socket.close();
		}
	}

}
