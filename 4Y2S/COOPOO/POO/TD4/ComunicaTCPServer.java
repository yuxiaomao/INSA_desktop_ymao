import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;



public class ComunicaTCPServer extends Thread{
	
	public ServerSocket serveur;
	public Socket socket;
    BufferedReader readerS = null;
    BufferedWriter writerS = null;
    ListenSocket ls;
    
    public ComunicaTCPServer(int port) throws IOException{
    	this.serveur = new ServerSocket(port);
    }

	public void run(){
		while (true){
			try {
				this.socket = this.serveur.accept();
				this.readerS = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
				this.writerS = new BufferedWriter(new OutputStreamWriter(this.socket.getOutputStream()));
				this.ls = new ListenSocket(readerS);
				Comunica cS = new Comunica(ls, writerS);
				cS.setLocation(0, 300);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	


}
