import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;

public class ComunicaTCPClient extends Thread{
	
	public Socket socket;
	BufferedReader readerC;
	BufferedWriter writerC;
	ListenSocket ls;
	
	public ComunicaTCPClient(InetAddress address, int port) throws UnknownHostException, IOException{
		this.socket = new Socket(address,port);
	}

	public void run(){
		try {
			this.readerC = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
			this.writerC = new BufferedWriter(new OutputStreamWriter(this.socket.getOutputStream()));
			this.ls = new ListenSocket(readerC);
			Comunica cC = new Comunica(ls, writerC);
			cC.setLocation(500, 300);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

}
