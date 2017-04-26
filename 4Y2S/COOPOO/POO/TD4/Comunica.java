

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.IOException;
import javax.swing.*;

public class Comunica extends JFrame implements ActionListener{

	/** component */
	private JLabel lmesssend;
	private JLabel lmessrec;
	private JTextArea textToSend;
	private JTextArea textRec;
	private JButton bSend;
	private JButton bReceive;
	/** buffer */
	private BufferedWriter writer;
	/** Listen */
	private ListenSocket lsocket;

	
	/** Creates a Fenetre */
	public Comunica(ListenSocket lsocket, BufferedWriter writer) {
		super("Communication window");
		this.writer = writer;
		this.lsocket = lsocket;
		initComponents();
	}

	/** Action listener */
	public void actionPerformed(ActionEvent e){
		if (e.getSource() == this.bSend){
			try {
				this.writer.write(this.textToSend.getText());
				this.writer.newLine();
				this.writer.flush();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		} else if (e.getSource() == this.bReceive){
			String line = this.lsocket.getLastLine();
			System.out.println("RECEIVE"+line);
			this.textRec.setText(line);
		}
	}
	
	/** component */
	private JPanel initZoneSend(){
		this.lmesssend = new JLabel("Message to send:    ");
		this.lmesssend.setPreferredSize(this.lmesssend.getPreferredSize());
		this.textToSend = new JTextArea(5,20);
		JScrollPane scrollPane = new JScrollPane(this.textToSend);
		scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		scrollPane.setViewportView(this.textToSend);
		
		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(1, 2));
        pane.add(this.lmesssend);
        pane.add(scrollPane);
		return pane;
	}
	
	private JPanel initZoneReceive(){
		this.lmessrec = new JLabel("Message to receive: ");
		this.lmessrec.setPreferredSize(this.lmessrec.getPreferredSize());
		this.textRec = new JTextArea(5,20);
		JScrollPane scrollPane = new JScrollPane(this.textRec);
		scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		scrollPane.setViewportView(this.textRec);
		
		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(1, 2));
        pane.add(this.lmessrec);
        pane.add(scrollPane);
		return pane;
	}
	
	private JPanel initZoneButton(){
		this.bSend = new JButton("Send");
		this.bSend.addActionListener(this);
		this.bReceive = new JButton("Receive");
		this.bReceive.addActionListener(this);
		
		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(1, 2));
        pane.add(this.bSend);
        pane.add(this.bReceive);
		return pane;
	}
	
	
	/** Initializes the JFrame components */
	private void initComponents() {
		// create the components
		JPanel paneSend = initZoneSend();
		JPanel paneButton = initZoneButton();
		JPanel paneReceive = initZoneReceive();
		// composite
		JPanel pane = new JPanel();
		pane.setLayout(new GridLayout(3, 1));
		pane.add(paneSend);
		pane.add(paneButton);
		pane.add(paneReceive);
		this.setContentPane(pane);
		// setting default
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.pack();
		this.setVisible(true);
	}
}

