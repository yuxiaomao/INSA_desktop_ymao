package part4;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.*;

public class Fenetre extends JFrame implements ActionListener{

	/** a label for the name */
	private JLabel label;
	private JLabel message;
	/** a textfield for the name */
	private JTextField text;
	/** a button to perform an action: e.g. say hello (TBD) */
	private JButton button;

	public void actionPerformed(ActionEvent e){
		if (e.getSource() == this.button){
			this.message.setText("Hello "+this.text.getText());
		}
		
	}

	/** Creates a Fenetre */
	public Fenetre() {
		initComponents();
	}

	/** Initializes the Fenetre components */

	private void initComponents() {
		// create the components
		// a new label with the "Nom" as value
		this.label = new JLabel("Nom: ");
		this.message = new JLabel("Entrer votre nom");
		// a new text field with 20 columns
		this.text = new JTextField(20);
		// a new button identified as OK
		this.button = new JButton("OK");
		this.button.addActionListener(this);
		// configures the JFrame layout using a border layout
		this.setLayout(new BorderLayout());
		// places the components in the layout
		this.add("West",label);
		this.add("Center",text);
		this.add("East",button);
		this.add("South",message);
		// packs the fenetre: size is calculated
		// regarding the added components
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.pack();
		// the JFrame is visible now
		this.setVisible(true);
	}

	/** main entry point */
	public static void main(String[] args) {
		Fenetre f = new Fenetre();
	}
}

