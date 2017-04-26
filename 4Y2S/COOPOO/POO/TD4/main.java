import java.io.IOException;
import java.net.InetAddress;


public class main {

	public main() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int port = 12015;
		try{
			InetAddress address = InetAddress.getLocalHost();
			ComunicaTCPServer server = new ComunicaTCPServer(port);
			ComunicaTCPClient client = new ComunicaTCPClient(address, port);
			ComunicaTCPClient client2 = new ComunicaTCPClient(address, port);
			server.start();
			client.start();
			client2.start();
			/* le 2e client ne semble pas reçoit*/
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
