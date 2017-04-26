package network;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

import javax.swing.event.EventListenerList;

import model.Message;

public class UDPReceiver implements Runnable{
	
	private DatagramSocket socket;
	private EventListenerList listeners;
	private Boolean stopThread;
	
	
	public UDPReceiver() {
		this.stopThread = false;
		listeners = new EventListenerList();
		try {
			this.socket = new DatagramSocket(1234);
		} catch (SocketException e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public void run(){
        byte[] buf = new byte[2048];
        Message message = null;
        
        while(!this.stopThread){
        	// receive a message
        	DatagramPacket packet = new DatagramPacket(buf, buf.length);
        	try {
				socket.receive(packet);
				// unpackage to a message
	        	ByteArrayInputStream bais = new ByteArrayInputStream(packet.getData());
				try {
					ObjectInputStream ois = new ObjectInputStream(bais);
					message = (Message) ois.readObject() ;
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				// tell who want the message
				this.newMessageReceived(packet.getAddress(), message);
			}
			 catch (SocketException e){
				System.err.println("java.net.SocketException: [UDPR]Socket closed");
				this.stopThread = true;
			} catch (IOException e) {
				e.printStackTrace();
			}
        }
	}

    public void addMyMessageListener (MyMessageListener listener){
    	this.listeners.add(MyMessageListener.class, listener);
    }
    
    public void removeMyMessageListener (MyMessageListener listener){
    	this.listeners.remove(MyMessageListener.class, listener);
    }
    
	public MyMessageListener[] getListeners() {
		return listeners.getListeners(MyMessageListener.class);
	}
	
	protected void newMessageReceived(InetAddress ipsrc, Message message){
		for (MyMessageListener listener : getListeners()){
			listener.aMessageHasBeenReceived(ipsrc, message);
		}
	}
	
	public void setStopThread(Boolean stop){
		this.stopThread = stop;
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
