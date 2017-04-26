package controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.URLConnection;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.List;

import javax.swing.DefaultListModel;
import javax.swing.JFileChooser;
import javax.swing.Timer;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import model.Model;
import gui.Window;
import contact.*;
import network.*;

import model.Message;
import model.MsgCheck;
import model.MsgExt;
import model.MsgFile;
import model.MsgGoodbye;
import model.MsgHello;
import model.MsgTxt;

public class Controller implements Runnable, NewMessageListener, ActionListener {

	private Model modele;
	private Window vue;
	/*
	 * TCP class if message need to be sent with TCP protocol
	 * private TCPClient tcpc;
	 * private TCPServer tcps;*/
	private UDPSender udps;
	private UDPReceiver udpr;
	private Timer timer_controller;
	private Timer timer_check;
	private File file_local;
	private int fileCounter; //integer used to save files received with a different name in ascending number
	private Date date;
	
	public Controller(){
		InetAddress addr=null;
		try {
			addr = InetAddress.getLocalHost();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		Contact anonym=new Contact("anonymous",addr,new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		    	  aTimerHasExpired("anonymous");
		      }
		    });
		this.modele=new Model(anonym);
		this.vue=null;
	}
	
	public Controller(String username, Window _vue){
		this.fileCounter=0;
		this.file_local=null;
		final String nickname=username;
		InetAddress addr=null;
		try {
			addr = InetAddress.getLocalHost();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		Contact user=new Contact(nickname,addr,new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		    	  aTimerHasExpired(nickname);
		      }
		    });
		this.modele=new Model(user);
		this.vue=_vue;
		//this.tcps=new TCPServer();
		//this.tcpc=new TCPClient();
		this.udps=new UDPSender();
		this.udpr=new UDPReceiver();
		this.udpr.addNewMessageListener(this);
		this.timer_controller=new Timer(6000,this);
		//Lancement du thread de reception
		(new Thread(this.udpr)).start();
		
		//Adding Disconnection action by clicking on Disconnection button
		this.vue.addActionDisconnect(new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		    	  udps.sendBye(modele.getLocalUser().getUsername(), "All");
		    	  cleanUI();
		    	  vue.setUIDisconnected();
		    	  File dir = new File(System.getProperty("user.dir"));
		    	  for(File file: dir.listFiles()){ 
		    		    if (!file.isDirectory()) {
		    		    	if(!file.getName().contains("tmp")){
		    		    		file.delete();
		    		    	}
		    		    }
		    	  }
		    	  modele.getLocalUser().setState(Contact.State.DISCONNECTED);
		    	  timer_check.stop();
		    	  udps.closeSocket();
		    	  udpr.closeSocket();
		    	  udpr.interruption();//interrupt dans le udpr
		    	  //To call Garbage collector, launch finalize functions() and close socket
		    	  //udpr=null; 
		    	  //udps=null;
		    	  Thread.currentThread().interrupt();
		      }
		    });
		
		//Adding sending a message action by clicking on "Send" button or pressing Enter
		this.vue.addActionSendMsg(new ActionListener(){
			@SuppressWarnings({ "deprecation" })
			public void actionPerformed(ActionEvent e){
		    	  String content=vue.getMessageContent().getText();
		    	  String message="["+modele.getLocalUser().getUsername() + "]("+date.getHours()+":"+date.getMinutes()+"): "+content+"\n";
		    	  vue.getMessageDisplay().append(message);
		    	  //tab user selected in JList
		          List<String> selectedUsers = vue.getListUser().getSelectedValuesList();
		          for (String usrname : selectedUsers) {
		        	  if(usrname.equals("All")){
		        		  udps.sendMessageNormalAll(content, modele.getLocalUser().getUsername(), "All");
		        		  DefaultListModel<Contact> local = modele.getRemoteUsers();
		        		  for(int i=0;i<local.getSize();i++){
		        			   File f=new File(local.getElementAt(i)+".txt");
								if(f.exists()){
									try {
										FileWriter fw = new FileWriter (f,true);
										fw.write(message);
										fw.close();
									} catch (IOException e4) {
										e4.printStackTrace();
									}
								}
								else{
									System.out.println("File not found");
								}
		        		  }
		        		  break;
		        	  }
		        	  else{
		        		  File f=new File(usrname+".txt");
							if(f.exists()){
								try {
									FileWriter fw = new FileWriter (f,true);
									fw.write(message);
									fw.close();
								} catch (IOException e4) {
									e4.printStackTrace();
								}
							}
							else{
								System.out.println("File not found");
							}
		        		  Contact tmp = modele.checkRemoteUserName(usrname);
		        		  udps.sendMessageNormal(tmp.getIp(), content, modele.getLocalUser().getUsername(), tmp.getUsername());
		        	  }
		          }
		          vue.getMessageContent().setText(" ");
		      }
		    }, new KeyListener() {
				@Override
				@SuppressWarnings({ "deprecation" })
				public void keyPressed(KeyEvent arg0) {
					if(arg0.getKeyCode() == KeyEvent.VK_ENTER) {
						  //We can send a message by clicking Send button or pressing Enter
				    	  date=new Date();
				    	  String content=vue.getMessageContent().getText();
				    	  String message="["+modele.getLocalUser().getUsername() + "]("+date.getHours()+":"+date.getMinutes()+"): "+content+"\n";
				    	  vue.getMessageDisplay().append(message);
				          List<String> selectedUsers = vue.getListUser().getSelectedValuesList();
				          for (String usrname : selectedUsers) {
				        	  if(usrname.equals("All")){
				        		  udps.sendMessageNormalAll(content, modele.getLocalUser().getUsername(), "All");
				        		  DefaultListModel<Contact> local = modele.getRemoteUsers();
				        		  for(int i=0;i<local.getSize();i++){
				        			   File f=new File(local.getElementAt(i)+".txt");
										if(f.exists()){
											try {
												FileWriter fw = new FileWriter (f,true);
												fw.write(message);
												fw.close();
											} catch (IOException e4) {
												e4.printStackTrace();
											}
										}
										else{
											System.out.println("File not found");
										}
				        		  }
				        		  break;
				        	  }
				        	  else{
				        		  File f=new File(usrname+".txt");
								  if(f.exists()){
										try {
											FileWriter fw = new FileWriter (f,true);
											fw.write(message);
											fw.close();
										} catch (IOException e4) {
											e4.printStackTrace();
										}
								  }
							      else{
										System.out.println("File not found");
								  }
				        		  Contact tmp = modele.checkRemoteUserName(usrname);
				        		  udps.sendMessageNormal(tmp.getIp(), content, modele.getLocalUser().getUsername(), tmp.getUsername());
				        	  }
				          }
				          vue.getMessageContent().setText(" ");
					}
				}

				@Override
				public void keyReleased(KeyEvent arg0) {
				}

				@Override
				public void keyTyped(KeyEvent arg0) {
				}
		    });
		
		//Adding action of selection a file by clickin on "..." button
		this.vue.addActionChooseFile(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				int returnVal = vue.getFileChoose().showOpenDialog(vue);
		        if (returnVal == JFileChooser.APPROVE_OPTION) {
		        	file_local = vue.getFileChoose().getSelectedFile();
		            //This is where a real application would open the file.
		            vue.getMessageDisplay().append("Opening: " + file_local.getName() + ".\n" );
		        } else {
		        	vue.getMessageDisplay().append("Open command cancelled by user.\n");
		        }
		        if((int)file_local.length()>8192){
		        	vue.getMessageDisplay().append("File too big to be sent. Please choose a smaller file.\n" );
		        	vue.getFileContent().setText("");
		        }
		        else{
		        	vue.getMessageDisplay().setCaretPosition(vue.getMessageDisplay().getDocument().getLength());
		        	vue.getFileContent().setText(file_local.getAbsolutePath());
		        }
			}
		});
		
		//Add sending a file action by cliking on "Send" button
		this.vue.addActionSendFile(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				vue.getMessageDisplay().append("Sending: " + file_local.getName() + ".\n" );
				byte[] bytesArray = new byte[(int) file_local.length()];
				FileInputStream fis;
				try {
					fis = new FileInputStream(file_local);
					fis.read(bytesArray); //read file into bytes[]
					fis.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				List<String> selectedUsers = vue.getListUser().getSelectedValuesList();
		        for (String usrname : selectedUsers) {
		        	if(usrname.equals("All")){
		        		udps.sendMessageFileAll(modele.getLocalUser().getUsername(), "All", bytesArray);
		        	}
		        	else{
		        		Contact tmp = modele.checkRemoteUserName(usrname);
		        		udps.sendMessageFile(tmp.getIp(), modele.getLocalUser().getUsername(), tmp.getUsername(),bytesArray);
		        	}
		        }
		        vue.getFileContent().setText(" ");
		        File f=new File(nickname+".txt");
				if(f.exists()){
					try {
						FileWriter fw = new FileWriter (f,true);
						fw.write("Sending: " + file_local.getName() + ".\n");
						fw.close();
					} catch (IOException e2) {
						e2.printStackTrace();
					}
				}
				else{
					System.out.println("File not found");
				}
			}
		});
		
		//Add periodical check sending every 7s
		this.timer_check=new Timer(7000,new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		    	  System.out.println(modele.getLocalUser().getUsername()+" send a check in broadcast");
		    	  udps.sendCheckAll(modele.getLocalUser().getUsername(), "All");
		      }
		    });
		this.timer_check.start();
		if(this.modele.getLocalUser().getState().toString().equals("CONNECTED")){
			this.displayErrorUI("You are alraedy connected. You can't connect anymore");
		}
		else{
			this.sayHello();
		}
		
		//adding EventListener on the connected users
		this.vue.addListUserAction(new ListSelectionListener() {
            @Override
            public void valueChanged(ListSelectionEvent arg0) {
            	if(!vue.getListUser().isSelectionEmpty()){
	                if (!arg0.getValueIsAdjusting()) {
	                	File f = new File(vue.getListUser().getSelectedValue().toString()+".txt");
	                	if(f.exists()){
	                		try {
								BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f));
								byte[] buf = new byte[1];
								vue.getMessageDisplay().setText("");
								while(bis.read(buf)!=-1){
									String v = new String( buf, Charset.forName("UTF-8") );
									vue.getMessageDisplay().append(v);
								}
								bis.close();
							} catch (FileNotFoundException e) {
								e.printStackTrace();
							} catch (IOException e) {
								e.printStackTrace();
							}
	                	}
	                	else{
	    					System.out.println("File not found");
	    				}
	                }
            	}
            }
        });
		
		//Creating a File called "All" for broadcast purpose
		File f = new File("All.txt");
    	if(!f.exists()){
    		try {
    			byte[] bytesArray = new byte[1];
    			String directory =System.getProperty("user.dir");
    			FileOutputStream fos;
    			fos = new FileOutputStream(directory+"/All.txt");
    			fos.write(bytesArray);
    			fos.close();
    		}
    		catch (IOException e) {
    			e.printStackTrace();
    		}
    	}
    	else{
			System.out.println("File not found");
		}
	}
	
	/*
	 * Clean all UI at every new connection
	 */
	public void cleanUI(){
		System.out.println("Cleaning UI");
		this.vue.getMessageDisplay().setText("");
		this.vue.getMessageContent().setText("");
		this.vue.getFileContent().setText("");
		DefaultListModel<String> listModel = this.vue.getDefaultListModel();
        listModel.removeAllElements();
        listModel.addElement("All");
	}
	
	/*
	 * Add a new Contact to the ConnectedList
	 */
	public void updateConnectedListUI(Contact c){
		//We add the username in the list of connected users
		this.vue.getDefaultListModel().addElement(c.getUsername());
		//We create a file in the current directory in order to save the current discussion
		File f = new File(c.getUsername());
    	if(!f.exists()){
    		try {
    			byte[] bytesArray = new byte[1];
    			String directory =System.getProperty("user.dir");
    			FileOutputStream fos;
    			fos = new FileOutputStream(directory+"/"+c.getUsername()+".txt");
    			fos.write(bytesArray);
    			fos.close();
    		}
    		catch (IOException e) {
    			e.printStackTrace();
    		}
    	}
    	else{
			System.out.println("File not found");
		}
	}
	
	/*
	 * Display an error message on the window interface
	 */
	public void displayErrorUI(String message){
		this.vue.getMessageDisplay().append(message);
	}
	
	/*
	 * Notify all User on Broadcast and change state to Connecting
	 */
	public void sayHello(){
		modele.getLocalUser().setState(Contact.State.CONNECTING);
		this.timer_controller.start();
		System.out.println("J'ai lancé le timer");
		this.udps.sendHelloAll(this.modele.getLocalUser().getUsername(), "All");
	}
	
	/*
	 * Prepare variable in order to check instance of Message
	 */
	Message messageCourant;
	int indexMessage = 0;
	@Override
	public void aMessageHasBeenReceived(InetAddress address) {
		//If we receive a message intended to us, we ignore it
		if(this.modele.getLocalUser().getIp().toString().contains(address.toString())){
			this.udpr.setReceptionMessage(false);
			indexMessage = (indexMessage+1)%10;
		}
		else{
			System.out.println("Reading the message at index : "+indexMessage);
			messageCourant = this.udpr.getMessagewithip(indexMessage);
			this.udpr.setReceptionMessage(false);
			indexMessage = (indexMessage+1)%10;
			final String nickname=messageCourant.getUserSrc();
			
			//If the message received is an instance of MsgHello
			if (messageCourant instanceof MsgHello) {
				MsgHello msg= (MsgHello) messageCourant;
				if(!msg.isAck()){
					System.out.println(nickname + " just joined the Chat");
					if(!(nickname.equals(this.modele.getLocalUser().getUsername()))){
						//If the name of the issuer isn't our username, we send back Hello_Ok
						//We start the contact timer
						Contact local=new Contact(nickname,address,new ActionListener(){
						      public void actionPerformed(ActionEvent e){
						    	  aTimerHasExpired(nickname);
						      }
						    });
						this.modele.addRemoteUser(local);
						local.startTimer();
						//update view
						updateConnectedListUI(local);
						this.udps.sendHello(2, address, this.modele.getLocalUser().getUsername(), nickname);
					}
					else{
						//Otherwise we send Hello_Not_Ok
						this.udps.sendHello(3, address, this.modele.getLocalUser().getUsername(), nickname);
					}
				}
				else{
					if(msg.isConnect()){
						//If the message received is Hello_Ok
						System.out.println(nickname + " is answering my connection request");
						Contact local=new Contact(nickname,address,new ActionListener(){
						      public void actionPerformed(ActionEvent e){
						    	  aTimerHasExpired(nickname);
						      }
						    });
						this.modele.addRemoteUser(local);
						local.startTimer();
						updateConnectedListUI(local);
					}
					else{
						//If the message received is Hello_Not_Ok, the user gets disconnected
						this.cleanUI();
						this.modele.getLocalUser().setState(Contact.State.DISCONNECTED);
						this.displayErrorUI("The username given is already used by another user.\nPlease try to reconnect with another username");
						this.vue.getUsernameContent().setText("- Enter an username -");
						udps.sendBye(modele.getLocalUser().getUsername(), "All");
				    	vue.setUIDisconnected();
				    	modele.getLocalUser().setState(Contact.State.DISCONNECTED);
				    	//Closing the socket for UDP transmission
				    	udpr.closeSocket();
				    	udps.closeSocket();
				    	udpr.interruption();//interrupt UDPReceiver thread
				    	Thread.currentThread().interrupt();
					}
				}
			}
			
			//If the message received is an instance of MsgGoodbye
			else if(messageCourant instanceof MsgGoodbye){
				//Delete the user from which we received a Goodbye message
				System.out.println(nickname + "has left the chat");
				Contact local=new Contact(nickname,address,new ActionListener(){
				      public void actionPerformed(ActionEvent e){
				    	  aTimerHasExpired(nickname);
				      }
				    });
				this.modele.delRemoteUser(local);
				this.vue.getDefaultListModel().removeElement(nickname);
			}
			
			//If the message received is an instance of MsgText
			else if(messageCourant instanceof MsgTxt){
				date=new Date();
				MsgTxt msg= (MsgTxt) messageCourant;
				String content=msg.getData();
				//I had to use Date Object instead of LocalTime because of Java Version at INSA
				@SuppressWarnings("deprecation")
				String message="["+nickname + "]("+date.getHours()+":"+date.getMinutes()+"): "+content+"\n";
				this.vue.getMessageDisplay().append(message);
				File f=new File(nickname+".txt");
				if(f.exists()){
					try {
						FileWriter fw = new FileWriter (f,true);
						fw.write(message);
						fw.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				else{
					System.out.println("File not found");
				}
			}
			
			//If the message received is an instance of MsgCheck
			else if(messageCourant instanceof MsgCheck){
				MsgCheck msg= (MsgCheck) messageCourant;
				if(msg.getAck()){
					//If we receive a Check_Ok, we restart the contact Timer
					this.modele.checkRemoteUserName(nickname).restartTimer();
				}
				else{
					//If the message is a check, we just send a Check_Ok
					this.udps.sendCheck(2, address, this.modele.getLocalUser().getUsername(), nickname);
				}
			}
			
			//If the message received is an instance of MsgFile
			else if(messageCourant instanceof MsgFile){
				MsgFile msg=(MsgFile) messageCourant;
				byte[] bytesArray = new byte[8192];
				bytesArray=msg.getData();
				
				//We try to guess the Type of the file from it's byte[] content
				String mimeType="";
				InputStream is = new ByteArrayInputStream(bytesArray);
				try {
					mimeType = URLConnection.guessContentTypeFromStream(is);
					if(mimeType!=null){
						if(mimeType.contains("png")){
							mimeType="png";
						}
						else if(mimeType.contains("jpg")){
							mimeType="jpg";
						}
						else if(mimeType.contains("jpeg")){
							mimeType="jpeg";
						}
						else if(mimeType.contains("txt")){
							mimeType="txt";
						}
						else if(mimeType.contains("c")){
							mimeType="c";
						}
						else if(mimeType.contains("java")){
							mimeType="java";
						}
						else if(mimeType.contains("doc")){
							mimeType="doc";
						}
					}
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				
				//We save the file in the current directory
				String directory =System.getProperty("user.dir");
				FileOutputStream fos;
				try {
					fos = new FileOutputStream(directory+"/tmp"+this.fileCounter+mimeType);
					fos.write(bytesArray);
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
				vue.getMessageDisplay().append("Saving file tmp" + this.fileCounter + " at "+directory+"/.\n" );
				this.fileCounter++;
				
				File f=new File(nickname+".txt");
				if(f.exists()){
					try {
						FileWriter fw = new FileWriter (f,true);
						fw.write("Saving file tmp" + this.fileCounter + " at "+directory+"/.\n");
						fw.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				else{
					System.out.println("File not found");
				}
			}
			
			//If the message received is an instance of MsgExt
			else if(messageCourant instanceof MsgExt){
				//MsgExt is an instance created if we needed to send other things
				//As it doesn't have any utility yet we just print the content on the window
				MsgExt msg= (MsgExt) messageCourant;
				String content=msg.getTabOctet().toString();
				this.vue.getMessageDisplay().append("00:00:00"+" : "+content);
			}
			
			//If the message received is non of the previous instance
			else{
				System.out.println("Message type not recongized : Error");
			}
		}
	}
	
	/*
	 * Action given to a contact timer
	 * If the timer expire, we deduct that the user has disconnected and we remove him from the ConnectedList
	 */
	public void aTimerHasExpired(String username){
		Contact tmp = this.modele.checkRemoteUserName(username);
		tmp.stopTimer();
		this.modele.delRemoteUser(tmp);
		this.vue.getDefaultListModel().removeElement(username);
	}
	
	/*
	 * Allow Controller thread to be stopped
	 */
	@Override
	public void run() {
		while(!Thread.currentThread().isInterrupted()) {
		}
	}
	
	public Model getModel(){
		return this.modele;
	}
	
	public Window getWindow(){
		return this.vue;
	}
	
	public Timer getCheckTimer(){
		return this.timer_controller;
	}

	/*
	 * When the timer from the connection process expires, set the user as Connected
	 */
	@Override
	public void actionPerformed(ActionEvent e) {
		if(this.modele.getLocalUser().getState().equals(Contact.State.DISCONNECTED)){
			this.timer_controller.stop();
			this.timer_check.stop();
		}
		else{
			System.out.println("Je suis connecté");
			this.modele.getLocalUser().setState(Contact.State.CONNECTED);
			this.vue.setUIConnected();
			this.timer_controller.stop();
		}
	}
}
