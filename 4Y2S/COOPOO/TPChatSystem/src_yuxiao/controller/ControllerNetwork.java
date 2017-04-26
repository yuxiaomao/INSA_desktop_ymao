package controller;

import gui.WindowInterface;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetAddress;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import contact.Contact;
import contact.State;

import model.*;
import network.*;

public class ControllerNetwork implements MyMessageListener{

	private UDPReceiver udpr;
	private UDPSender udps;
	private Thread udprThread;
	private Model model;
	private WindowInterface vue;
	private int fileCounter;

	public ControllerNetwork(Model model, WindowInterface vue) {
		this.udpr = new UDPReceiver();
		this.udps = new UDPSender();
		this.model = model;
		this.vue = vue;
		this.fileCounter = 0;

		this.udpr.addMyMessageListener(this);
		this.udprThread = new Thread(this.udpr);
		this.udprThread.start();
	}

	@Override
	public void aMessageHasBeenReceived(InetAddress ipsrc, Message message) {
		// a message from localuser's broadcast, ignore it
		if (this.model.getUserLocal().getIp().toString().contains(ipsrc.toString())){
			return;
		}

		// a message from other user
		switch (this.model.getUserLocal().getState())
		{
		case CONNECTED:
			// in CONNECTED mode, do not accepte other HELLO_OK and HELLO_NOK
			if (message instanceof MsgHello){
				MsgHello msg = (MsgHello) message;
				if (!msg.isAck()){
					// HELLO
					this.recevedMsgHello(ipsrc,msg);
				}
			}
			else if (message instanceof MsgGoodbye){
				MsgGoodbye msg = (MsgGoodbye) message;
				this.recevedMsgGoodbye(ipsrc,msg);
			}
			else if (message instanceof MsgCheck){
				MsgCheck msg = (MsgCheck) message;
				this.recevedMsgCheck(ipsrc,msg);
			}
			else if (message instanceof MsgTxt){
				MsgTxt msg = (MsgTxt) message;
				this.recevedMsgTxt(ipsrc,msg);
			}
			else if (message instanceof MsgFile){
				MsgFile msg = (MsgFile) message;
				this.recevedMsgFile(ipsrc,msg);
			}
			else if (message instanceof MsgExt){
				MsgExt msg = (MsgExt) message;
				this.recevedMsgExt(ipsrc,msg);
			}
			break;
		case CONNECTING:
			// in CONNECTING phase, only accepte the message for construction of the remote user list
			if (message instanceof MsgHello){
				MsgHello msg = (MsgHello) message;
				if (!msg.isAck()){
					// HELLO
					this.recevedMsgHello(ipsrc,msg);
				} else {
					// HELLO_OK or HELLO_NOK
					this.recevedMsgHelloAck(ipsrc,msg);
				}
			}
			else if (message instanceof MsgGoodbye){
				MsgGoodbye msg = (MsgGoodbye) message;
				this.recevedMsgGoodbye(ipsrc,msg);
			}
			else if (message instanceof MsgCheck){
				MsgCheck msg = (MsgCheck) message;
				this.recevedMsgCheck(ipsrc,msg);
			}
			break;
		case DISCONNECTED:
			break;
		default:
			System.err.println("[cNet]Status unknown: not Connected/Connecting/Disconnected");
			break;
		}
	}


	private void recevedMsgHello(InetAddress ipsrc, MsgHello message){
		String usernameLocal = this.model.getUserLocal().getUsername();
        // default respond HELLO_NOK
		MsgHello mesack = new MsgHello(this.model.getUserLocal().getUsername(), message.getUserSrc(), true, false);
		System.out.println("[cNet] "+ message.getUserSrc() + " say hello to me");
		if (!usernameLocal.equals(message.getUserSrc())){
			// if remote username is different of my name, reply HELLO_OK, add him into my list
			mesack.setConnect(true);
			final String remoteUsername = message.getUserSrc();
			Contact userRemote = new Contact(message.getUserSrc(), ipsrc, new ActionListener()
		    {
			      public void actionPerformed(ActionEvent e)
			      {
			    	  aTimerHasExpired(remoteUsername);
			      }
		    });
			this.addUserRemote(userRemote);
		}
		this.udps.sendMess(mesack, ipsrc);
	}

	private void recevedMsgHelloAck(InetAddress ipsrc, MsgHello message){
		if (message.isConnect()){
			//HELLO_OK, add him into my list
			final String remoteUsername = message.getUserSrc();
			Contact userRemote = new Contact(message.getUserSrc(), ipsrc, new ActionListener()
		    {
			      public void actionPerformed(ActionEvent e)
			      {
			    	  aTimerHasExpired(remoteUsername);
			      }
		    });
			this.addUserRemote(userRemote);
			System.out.println("[cNet] "+ message.getUserSrc() + " repond à ma connection");
		}else{
			//HELLO_NOK, local username is not valid, disconnect and tells others by sending GOODBYE
			this.vue.setUIDisconnected();
			this.writeAndDisplayLogLine("[cNet] Your username is used by another user!\n");
			this.model.getUserLocal().stopTimer();
			this.model.getUserLocal().setState(State.DISCONNECTED);
			this.sendMsgGoodbye();
			this.model.removeAllUserListElement();
			this.closeSocketUDP();
		}
	}

	private void recevedMsgGoodbye(InetAddress ipsrc, MsgGoodbye message){
		this.removeUserRemote(message.getUserSrc(), ipsrc);
	}

	private void recevedMsgCheck(InetAddress ipsrc, MsgCheck message){
		if (!message.getAck()){
			// if CHECK, reply CHECK_OK
			MsgCheck msgack = new MsgCheck(this.model.getUserLocal().getUsername(), message.getUserSrc(), true);
			msgack.setAck(true);
			this.udps.sendMess(msgack, ipsrc);
		}else{
			// if CHECK_OK refresh the status
			this.model.getUserRemoteByName(message.getUserSrc()).restartTimer();
		}
	}

	private void recevedMsgTxt(InetAddress ipsrc, MsgTxt message){
		System.out.println("[CNet]Received MsgTxt from<"+ipsrc.toString()+">: "+message.toString());
		this.writeAndDisplayChatHistoryMessage(0, message);
	}

	private void recevedMsgFile(InetAddress ipsrc, MsgFile message){
		byte[] bytesArray = new byte[8192];
		bytesArray=message.getData();

		Path file = Paths.get("tmp"+this.fileCounter+message.getUserSrc()+"File.txt");
		this.fileCounter ++;

	    try (OutputStream out = new BufferedOutputStream(
	      Files.newOutputStream(file, StandardOpenOption.CREATE, StandardOpenOption.APPEND))) {
	      out.write(bytesArray, 0, bytesArray.length);
	    } catch (IOException x) {
	      System.err.println(x);
	    }

		this.writeAndDisplayChatHistoryMessage(0,message);
	}

	private void recevedMsgExt(InetAddress ipsrc, MsgExt message){
		//TODO
		System.out.println("[CNet]Received MsgExt from<"+ipsrc.toString()+">: "+message.toString());
	}

	void sendMsgHello(){
		System.out.println("[cNet] sendMsgHello to all");
		MsgHello msg = new MsgHello(this.model.getUserLocal().getUsername(), "all", false, true);
		msg.setConnect(true);//hello
		this.udps.sendMessBroadcast(msg);
		this.writeAndDisplayLogLine("User sended Hello\n");
	}

	void sendMsgGoodbye(){
		System.out.println("[cNet] sendMsgGoodbye to all");
		MsgGoodbye msg = new MsgGoodbye(this.model.getUserLocal().getUsername(), "all");
		this.udps.sendMessBroadcast(msg);
		this.writeAndDisplayLogLine("User sended Goodbye\n");
	}

	void sendMsgCheck(){
		System.out.println("[cNet] sendMsgCheck to all");
		MsgCheck msg = new MsgCheck(this.model.getUserLocal().getUsername(), "all", false);
		this.udps.sendMessBroadcast(msg);
	}

	void sendMsgTxt(MsgTxt message, InetAddress iptosend){
		this.udps.sendMess(message, iptosend);
		this.writeAndDisplayChatHistoryMessage(1, message);
	}

	void sendMsgTxtToAll(MsgTxt message){
		this.udps.sendMessBroadcast(message);
		this.writeAndDisplayChatHistoryMessage(2, message);
	}

	void sendMsgFile(MsgFile message, InetAddress iptosend){
		this.udps.sendMess(message, iptosend);
		this.writeAndDisplayChatHistoryMessage(1, message);
	}

	void sendMsgFileToAll(MsgFile message){
		this.udps.sendMessBroadcast(message);
		this.writeAndDisplayChatHistoryMessage(2, message);
	}

	void sendMsgExt(MsgExt message, InetAddress iptosend){
		// TODO
	}

	// public only for jUnit test
	public void aTimerHasExpired(String remoteUsername) {
		System.out.println("[cNet] Contact "+ remoteUsername + "'s timer has expired");
		Contact userRemote = this.model.getUserRemoteByName(remoteUsername);
		if (userRemote != null){
			userRemote.stopTimer();
			this.model.removeUserRemote(userRemote);
		}
	}

	void closeSocketUDP(){
		this.udpr.setStopThread(true);
		this.udpr.closeSocket();
		this.udps.closeSocket();
	}

	private void addUserRemote(Contact userRemote){
		this.model.addUserRemote(userRemote);
		this.vue.getDefaultListModel().addElement(userRemote.getUsername());
	}

	private void removeUserRemote(String username, InetAddress ipremote){
		Contact userRemote = this.model.getUserRemoteByIP(ipremote);
		if (userRemote == null){
			// he isn't in the user list
		}else {
			userRemote.stopTimer();
			this.model.removeUserRemote(userRemote);
			this.vue.getDefaultListModel().removeElement(userRemote.getUsername());
		}
	}

	private void writeAndDisplayChatHistoryMessage(int send, Message message){
		// send = 0 -> receive
		// send = 1 -> send
		// send = 2 -> send to all
		String srcUsername = null;
		String destUsername = null;
		String remoteUsername = null;
		String line = null;

		srcUsername = message.getUserSrc();
		destUsername = message.getUserDest();

		if (send == 0){
			remoteUsername = srcUsername;
		}else{
			remoteUsername = destUsername;
		}

		if (message instanceof MsgTxt){
			line = "["+srcUsername+"] to ["+destUsername+"]:"+ ((MsgTxt) message).getData()+"\n";
		}else if (message instanceof MsgFile){
			line = "["+srcUsername+"] to ["+ destUsername+"], send a file\n";
		}else{
			line = "[cNet] writeAndDisplayChatHistoryMessage has some message not Txt or File\n";
		}

		if (send == 2){
			System.out.print("[CNet] write to localLog"+line);
			this.model.writeLog(line);
		}else {
			System.out.print("[CNet] write to chatHistory"+line);
			ModelContactRemote mcr = this.model.getModelContactRemoteByName(remoteUsername);
			if (mcr != null){
				mcr.writeChatHistory(line);
			}else{
				System.err.print("[CNet] Remote user not found"+line);
			}
		}
		this.vue.getMessageDisplay().append("\n"+line);
	}

	private void writeAndDisplayLogLine(String line){
		System.out.print("[CNet] write to localLog"+line);
		this.model.writeLog(line);
		this.vue.getMessageDisplay().append("\n"+line);
	}
}
