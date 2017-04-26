package network;

import java.net.InetAddress;
import java.util.EventListener;

import model.Message;

public interface MyMessageListener extends EventListener {
	
	void aMessageHasBeenReceived(InetAddress ipsrc, Message message);
	
}
