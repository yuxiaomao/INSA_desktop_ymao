

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;

import javax.swing.*;

public class Comunica extends JFrame implements ActionListener{

	/** a label for the name */
	private JLabel lmesssend;
	private JLabel lmessrec;
	/** a textfield for the name */
	private JTextArea textToSend;
	private JTextArea textRec;
	/** a button to perform an action: e.g. say hello (TBD) */
	private JButton bSend;
	private JButton bReceive;
	/** buffer*/
	private BufferedWriter writer;
	private BufferedReader reader;

	/** Creates a Fenetre */
	public Comunica(BufferedReader reader, BufferedWriter writer) {
		super("Communication window");
		initComponents();
		this.writer = writer;
		this.reader = reader;
	}

	/** Action listener */
	public void actionPerformed(ActionEvent e){
		if (e.getSource() == this.bSend){
			System.out.println(this.toString()+"Button Send appuyé");
			this.lmesssend.setText("Button appuyé");
			try {
				this.writer.write(this.textToSend.getText());
				this.writer.newLine();
				this.writer.flush();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		} else if (e.getSource() == this.bReceive){
			System.out.println(this.toString()+"Button Receive appuyé");
			this.lmessrec.setText("Button appuyé");
			try {
				this.textRec.setText(this.reader.readLine());
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	/** Box layout*/
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
		
		
		JPanel pane = new JPanel();
        pane.setLayout(new GridLayout(1, 2));
        pane.add(this.lmessrec);
        pane.add(this.textRec);
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
	
	
	/** Initializes the Fenetre components */
	private void initComponents() {
		// create the components
		JPanel paneSend = initZoneSend();
		JPanel paneButton = initZoneButton();
		JPanel paneReceive = initZoneReceive();
		// composite
		JPanel pane = new JPanel();
		pane.add(paneSend);
		pane.add(paneButton);
		pane.add(paneReceive);
		pane.setLayout(new GridLayout(3, 1));
		this.setContentPane(pane);
		// setting default
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.pack();
		this.setVisible(true);
	}
}

