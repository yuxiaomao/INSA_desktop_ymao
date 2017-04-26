import java.io.BufferedReader;
import java.io.IOException;
import java.util.concurrent.locks.ReentrantLock;


public class ListenSocket extends Thread{

	private BufferedReader reader;
	private String lastLine;
	private final ReentrantLock lock = new ReentrantLock();
	
	public ListenSocket(BufferedReader reader) {
		this.reader = reader;
		this.lastLine = "";
		this.start();
	}
	
	
	public String getNextLine() throws IOException{
		String nextLine;
		while(!this.reader.ready()){}
		nextLine = this.reader.readLine();
		return nextLine;
	}

	public void run(){
		String line;
		while(true){
			try {
				line = this.reader.readLine();
				this.lastLine = line;
				/*Si votre producteur de lignes et plus rapide que votre consommateur, 
				 * y a t-il des problèmes de pertes de lignes?. 
				 * Homework: Préparer la solution..*/
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public String getLastLine(){
		return this.lastLine;
	}
	
}
