
import java.io.File;

import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.AddImport;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLAnnotation;
import org.semanticweb.owlapi.model.OWLAnnotationAssertionAxiom;
import org.semanticweb.owlapi.model.OWLAnnotationProperty;
import org.semanticweb.owlapi.model.OWLAnnotationSubject;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLClassAssertionAxiom;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLDataProperty;
import org.semanticweb.owlapi.model.OWLDataPropertyAssertionAxiom;
import org.semanticweb.owlapi.model.OWLDatatype;
import org.semanticweb.owlapi.model.OWLImportsDeclaration;
import org.semanticweb.owlapi.model.OWLLiteral;
import org.semanticweb.owlapi.model.OWLNamedIndividual;
import org.semanticweb.owlapi.model.OWLObjectProperty;
import org.semanticweb.owlapi.model.OWLObjectPropertyAssertionAxiom;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyFormat;
import org.semanticweb.owlapi.model.OWLOntologyID;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.model.PrefixManager;
import org.semanticweb.owlapi.util.DefaultPrefixManager;
import org.semanticweb.owlapi.util.SimpleIRIMapper;
import org.semanticweb.owlapi.vocab.OWL2Datatype;
import org.semanticweb.owlapi.vocab.OWLRDFVocabulary;

/*
 * import for java files open functions
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.util.ArrayList;
import java.util.Iterator;

public class Parser {

	public static String[] film;
	public static ArrayList<String[]> filmlist = new ArrayList<String[]>();
	public static OMDBProxy omdbProxy = new OMDBProxy();

//	private static final String FILENAME_MTP = "/home/ymao/bureau/algo/algo4a2s/websem/tp2/villemtp_mtp_filmstournes.csv";
	private static final String FILENAME_MTP = "/Users/ramalechat/Desktop/INSA/Semestre 8/Web_semantique/TP2/TP2/villemtp_mtp_filmstournes.csv";
//	private static final String FILENAME_PARIS = "/home/ymao/Bureau/Algo/Algo4A2S/WebSem/TP2/VillePARIS_PARIS_FilmsTournes.csv";
	private static final String FILENAME_PARIS = "/Users/ramalechat/Desktop/INSA/Semestre 8/Web_semantique/TP2/TP2/VillePARIS_PARIS_FilmsTournes.csv";

	public Parser() {
	};

	public static void main(String[] args) {
		BufferedReader br = null;
		FileReader fr = null;

		/* try transform table MTP to list
		 * */
		try {
			System.out.println("DEBUT creation table");

			String sCurrentLine;

			fr = new FileReader(FILENAME_MTP);
			br = new BufferedReader(fr);

			br = new BufferedReader(new FileReader(FILENAME_MTP));

			sCurrentLine = br.readLine();// on lit la première ligne pour masquer les noms des colonnes en csv

			while ((sCurrentLine = br.readLine()) != null) {
				String[] parts = sCurrentLine.split(";",-1);// System.out.println(parts.length);
				film = new String[16]; // 15 car possibilité de mettre 6 lieus de tournage différents + note + duree + ville
				film[0] = parts[0]; // titre
				film[1] = parts[1]; // réalisateur
				film[2] = parts[2]; // Année de tournage
				String[] partsdatef = parts[3].split("/");//date de sortie format français
				if (parts[3].length() > 0){
					film[3] = partsdatef[2] + "-"
							+ partsdatef[1] + "-"
							+ partsdatef[0]; // date de sortie forma normal
				} else{
					film[3] = "";
				}
				film[4] = parts[10]; // url film
				film[5] = parts[11]; // url image
				film[6] = ""; // geo_cords
				film[7] = parts[4]; // lieu1
				film[8] = parts[5]; // lieu2
				film[9] = parts[6]; // lieu3
				film[10] = parts[7]; // lieu4
				film[11] = parts[8]; // lieu5
				film[12] = parts[9]; // lieu6
				film[13] = "";// note
				film[14] = "";// durée
				film[15] = "Montpellier";// ville Montpellier
				
				filmlist.add(film);
			}

			System.out.println("FIN creation table MTP");
			
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
				if (fr != null)
					fr.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}

		
		/* try transform PARIS to list
		 * */
		try {
			String sCurrentLine;

			fr = new FileReader(FILENAME_PARIS);
			br = new BufferedReader(fr);

			br = new BufferedReader(new FileReader(FILENAME_PARIS));

			sCurrentLine = br.readLine();

			while ((sCurrentLine = br.readLine()) != null) {

				String[] parts = sCurrentLine.split(";",-1);
				film = new String[16]; // 15 car possibilité de mettre 6 lieus de tournage différents + note + duree +ville
				film[0] = parts[0]; // titre
				film[1] = parts[1]; // réalisateur
				String[] partsdatey = parts[3].split("-");
				film[2] = partsdatey[0]; // Année de tournage
				film[3] = ""; // date de sortie
				film[4] = ""; // url film
				film[5] = ""; // url image
				film[6] = parts[9]; // geo_cords
				film[7] = parts[5] + " " +parts[6]; // lieu1
				film[8] = ""; // lieu2
				film[9] = ""; // lieu3
				film[10] = ""; // lieu4
				film[11] = ""; // lieu5
				film[12] = ""; // lieu6
				film[13] = "";// note
				film[14] = "";// durée
				film[15] = "Paris";// ville Paris

				
				filmlist.add(film);
			}

			System.out.println("FIN creation table PARIS");

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
				if (fr != null)
					fr.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		
		
		/* try write .owl
		 * */
		try{
			
			System.out.println("DEBUT traitement owl");
			OWLOntologyManager manager = OWLManager.createOWLOntologyManager();
			
			//fichier contenant l'ontologie
			File file = new File("/Users/ramalechat/Desktop/INSA/Semestre 8/Web_semantique/TP2/TP2/onto/onto.owl"); //modifier et mettre le bon chemin
			//parsage du fichier pour obtenir un objet onto de type OWLOntology 
			OWLOntology onto = manager.loadOntologyFromOntologyDocument(file);
			System.out.println("Loaded ontology: " + onto);
			
			//récupération de l'IRI de l'ontologie onto 
			IRI IRIonto = onto.getOntologyID().getOntologyIRI();
			
			/*création d'une nouvelle ontologie ontoPeup 
			* qui contiendra les instances et relations entre instances extraites des sources
			* et décrites à partir du vocabulaire défini dans l'ontologie onto
			 */
			
			//création d'une nouvelle IRI à partir de l'IRI de l'ontologie onto
			IRI IRIontoPeup = IRI.create(IRIonto.toString()+"peup");
			// création de la nouvelle ontologie ontoPeupidentifiée à partir de cette IRI
			OWLOntology ontoPeup = manager.createOntology(new OWLOntologyID(IRIontoPeup));
			// création du fichier qui permettra de sauvegarder ontoPeup une fois peuplée
//			File fileOut = new File("/home/ymao/Bureau/Algo/Algo4A2S/WebSem/Eclipse/TP2/onto/ontoPeup.owl");
			File fileOut = new File("/Users/ramalechat/Desktop/INSA/Semestre 8/Web_semantique/TP2/TP2/onto/ontoPeup.owl");
			
			//récupération de l'ensemble des données contenues dans les ontologies chargées
			OWLDataFactory factory = manager.getOWLDataFactory();

			//import de l'ontologie onto dans l'ontologie ontoPeup de façon à faire évoluer les deux indépedamment
			OWLImportsDeclaration importDeclaraton = factory.getOWLImportsDeclaration(IRIonto);
			manager.applyChange(new AddImport(ontoPeup, importDeclaraton));
			
			// définitions de prefixes à partir des IRI des deux ontologies pour accéder plus facilement à leur élément
			PrefixManager pmonto = new DefaultPrefixManager(IRIonto.toString()+"#");
			PrefixManager pmontoP = new DefaultPrefixManager(IRIontoPeup.toString()+"#");
			
			/* Récupération des classes onto */
			OWLClass Film = factory.getOWLClass(":film", pmonto);
			OWLClass Realisateur = factory.getOWLClass(":réalisateur", pmonto);
			OWLClass UrlFilm = factory.getOWLClass(":url_film", pmonto);
			OWLClass UrlImage = factory.getOWLClass(":url_image", pmonto);
			OWLClass CoordsGeo = factory.getOWLClass(":coordonées_géographiques", pmonto);
			OWLClass Ville = factory.getOWLClass(":ville", pmonto);
			OWLClass Pays = factory.getOWLClass(":pays", pmonto);
			OWLClass Adresse = factory.getOWLClass(":adresse", pmonto);
			
			/* Récuperation des data type*/
			OWLDatatype positiveIntegerDatatype = factory.getOWLDatatype(OWL2Datatype.XSD_POSITIVE_INTEGER.getIRI());
			OWLDatatype dateTimeDatatype = factory.getOWLDatatype(OWL2Datatype.XSD_DATE_TIME.getIRI());
			
			/* Récuperation des data property*/
			OWLDataProperty dpAnneeTournage = factory.getOWLDataProperty(":a_été_tourné_en",pmonto);
			OWLDataProperty dpDateDeSortie = factory.getOWLDataProperty(":est_sorti_en",pmonto);
			OWLDataProperty dpNote = factory.getOWLDataProperty(":a_une_note_de",pmonto);
			OWLDataProperty dpDuree = factory.getOWLDataProperty(":a_une_durée_en_minuites",pmonto);
			
			/* Récupération des objet property*/
			OWLObjectProperty opRealisePar =factory.getOWLObjectProperty(":réalisé_par",pmonto);
			OWLObjectProperty opUrlFilm =factory.getOWLObjectProperty(":dont_l'url_film_est",pmonto);
			OWLObjectProperty opUrlImage =factory.getOWLObjectProperty(":dont_l'url_image_est",pmonto);
			OWLObjectProperty opCoordsGeo =factory.getOWLObjectProperty(":a_comme_geo-coordonnées",pmonto);
			OWLObjectProperty opLieuTournage =factory.getOWLObjectProperty(":est_tourné_dans",pmonto);
			OWLObjectProperty opSitueDans =factory.getOWLObjectProperty(":situe_dans",pmonto);
			
			/* Definition variable */
			OWLClassAssertionAxiom classAssertion;
			OWLDataPropertyAssertionAxiom dataassersion;
			OWLAnnotationAssertionAxiom labassertion;
			OWLAnnotation lab;
			OWLObjectPropertyAssertionAxiom objectassersion;
			
			/* Creation individual commun */
			/* Ville Montpellier */
    		OWLNamedIndividual iVilleMontpellier = factory.getOWLNamedIndividual(":iVilleMontpellier",pmontoP);
        	classAssertion = factory.getOWLClassAssertionAxiom(Ville, iVilleMontpellier);
        	manager.addAxiom(ontoPeup, classAssertion);
        	// ajouter nom:label
        	lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral("Montpellier","fr"));
    		labassertion= factory.getOWLAnnotationAssertionAxiom(iVilleMontpellier.getIRI(), lab);
    		manager.addAxiom(ontoPeup, labassertion);
			/* Ville Paris */
        	OWLNamedIndividual iVilleParis = factory.getOWLNamedIndividual(":iVilleParis",pmontoP);
        	classAssertion = factory.getOWLClassAssertionAxiom(Ville, iVilleParis);
        	manager.addAxiom(ontoPeup, classAssertion);
        	// ajouter nom:label
        	lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral("Paris","fr"));
    		labassertion= factory.getOWLAnnotationAssertionAxiom(iVilleParis.getIRI(), lab);
    		manager.addAxiom(ontoPeup, labassertion);
    		

			/** boucle **/
			System.out.println("DEBUT ajouter individuals");
	        Iterator<String[]> iterator = filmlist.iterator();
	        int i=0;
	        while (iterator.hasNext()) {			
	        	// film = film actuel
	        	film = iterator.next();
	        	i++;
	        	
	        	System.out.println("Traitement film : "+film[0]);
	        	
	        	// creation individual film
	        	OWLNamedIndividual iFilm = factory.getOWLNamedIndividual(":iFilm"+i,pmontoP);
	        	classAssertion = factory.getOWLClassAssertionAxiom(Film, iFilm);
	        	manager.addAxiom(ontoPeup, classAssertion);
	        	// ajouter titre:label film
	        	lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[0],"fr"));
	    		labassertion= factory.getOWLAnnotationAssertionAxiom(iFilm.getIRI(), lab);
	    		manager.addAxiom(ontoPeup, labassertion);
	    		
	    		// ajouter Realisateur:individual
	    		if(!film[1].equals("")){
	    			OWLNamedIndividual iRealisateur = factory.getOWLNamedIndividual(":iRealisateur"+i,pmontoP);
	    			//PAS BESOIN définir la classe CAR OBJET property
	    			// ajouter son nom
	    			lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[1],"fr"));
	    			labassertion= factory.getOWLAnnotationAssertionAxiom(iRealisateur.getIRI(), lab);
	    			manager.addAxiom(ontoPeup, labassertion);
	    			// ajouter realiserPar:objetProperty
	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opRealisePar, iFilm, iRealisateur);
	    			manager.addAxiom(ontoPeup, objectassersion);
	    		}
	    		
	    		// ajouter anneeTournage:dataproperty
	    		if(!film[2].equals("")){
	    			OWLLiteral literalAnnee = factory.getOWLLiteral(film[2], positiveIntegerDatatype); 
	    			dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpAnneeTournage, iFilm, literalAnnee);
	    			manager.addAxiom(ontoPeup, dataassersion);
	    		}
				
				// ajouter dateDeSortie:dataproperty
	    		if(!film[3].equals("")){
	    			OWLLiteral literalDateDeSortie = factory.getOWLLiteral(film[3]+"T00:00:00", dateTimeDatatype);
	    			dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpDateDeSortie, iFilm, literalDateDeSortie);
	    			manager.addAxiom(ontoPeup, dataassersion);	
	    		}
    			
	    		// ajouter dateDeSortie:dataproperty
	    		if(film[3].equals("")){
	    			//On est dans les films Parisiens
	    			String date_sortie = omdbProxy.getMovieInfos(film[0]).get("Year");
    				if(date_sortie!=null){
//    					System.out.println(date_sortie);
    					OWLLiteral literalDateDeSortie = factory.getOWLLiteral(date_sortie+"T00:00:00", dateTimeDatatype);
    					dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpDateDeSortie, iFilm, literalDateDeSortie);
    					manager.addAxiom(ontoPeup, dataassersion);	
    					film[3]=date_sortie;
    				}
	    		}
	    		
				// ajouter UrlFilm:individual
	    		if(!film[4].equals("")){
//	    			System.out.println("Url film : "+film[4]);
	    			//création de l'instance
	    			OWLNamedIndividual iUrlFilm = factory.getOWLNamedIndividual(":iUrlFilm"+i,pmontoP);
	    			// ajouter son url
	    			lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[4],"fr"));
	    			labassertion= factory.getOWLAnnotationAssertionAxiom(iUrlFilm.getIRI(), lab);
	    			manager.addAxiom(ontoPeup, labassertion);
	    			// ajouter opUrlFilm:object property
	    			//System.out.println(opUrlFilm);
	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opUrlFilm, iFilm, iUrlFilm);
	    			manager.addAxiom(ontoPeup, objectassersion);
	    		}
				
	    		// ajouter UrlImage:individual
	    		if(!film[5].equals("")){
//	    			System.out.println("Url film : "+film[5]);
	    			OWLNamedIndividual iUrlImage = factory.getOWLNamedIndividual(":iUrlImage"+i,pmontoP);
	    			// ajouter son url
	    			lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[5],"fr"));
	    			labassertion= factory.getOWLAnnotationAssertionAxiom(iUrlImage.getIRI(), lab);
	    			manager.addAxiom(ontoPeup, labassertion);
	    			// ajouter dontUrlImage:object property
	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opUrlImage, iFilm, iUrlImage);
	    			manager.addAxiom(ontoPeup, objectassersion);
	    		}
	    		
	    		// ajouter UrlImage:individual
	    		if(film[5].equals("")){
	    			//On est dans les films Parisiens
	    			String affiche = omdbProxy.getMovieInfos(film[0]).get("Poster");
    				if(!((affiche==null)||(affiche.contains("N/A")))){
//    					System.out.println(affiche);
    					OWLNamedIndividual iUrlImage = factory.getOWLNamedIndividual(":iUrlImage"+i,pmontoP);
    	    			// ajouter son url
    	    			lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(affiche,"fr"));
    	    			labassertion= factory.getOWLAnnotationAssertionAxiom(iUrlImage.getIRI(), lab);
    	    			manager.addAxiom(ontoPeup, labassertion);
    	    			// ajouter dontUrlImage:object property
    	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opUrlImage, iFilm, iUrlImage);
    	    			manager.addAxiom(ontoPeup, objectassersion);
    	    			film[5]=affiche;
    				}
	    		}
	    		
	    		
	    		
	    		// ajouter lieu 1 à lieu 6, indice dans tableau film de 7 à 14
	    		for(int index = 0; index < 6; index ++){
	    			// ajouter GeoCoords:individual
	    			if(!film[7+index].equals("")){
	    				OWLNamedIndividual iLieu = factory.getOWLNamedIndividual(":iLieu"+index+i,pmontoP);
	    				// ajouter son coord
	    				lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[7+index],"fr"));
	    				labassertion= factory.getOWLAnnotationAssertionAxiom(iLieu.getIRI(), lab);
	    				manager.addAxiom(ontoPeup, labassertion);
	    				// ajouter opCoordsGeo:object property
	    				objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opLieuTournage, iFilm, iLieu);
	    				manager.addAxiom(ontoPeup, objectassersion);
	    				
	    				// ajouter GeoCoords:individual
	    	    		if(!film[6].equals("") && (index==0)){
	    	    			OWLNamedIndividual iCoordsGeo = factory.getOWLNamedIndividual(":iCoordsGeo"+i,pmontoP);
	    	    			// ajouter son coord
	    	    			lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral(film[6],"fr"));
	    	    			labassertion= factory.getOWLAnnotationAssertionAxiom(iCoordsGeo.getIRI(), lab);
	    	    			manager.addAxiom(ontoPeup, labassertion);
	    	    			// ajouter opCoordsGeo:object property
	    	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opCoordsGeo, iLieu, iCoordsGeo);
	    	    			manager.addAxiom(ontoPeup, objectassersion);
	    	    		}
	    				
	    	    		if (film[15].equals("Montpellier")){
	    	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opSitueDans, iLieu, iVilleMontpellier);
	    		    		manager.addAxiom(ontoPeup, objectassersion);
	    	    		}else if(film[15].equals("Paris")){
	    	    			objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opSitueDans, iLieu, iVilleParis);
	    		    		manager.addAxiom(ontoPeup, objectassersion);
	    	    		}
	    			}
	    		}
	    		
	    		
	    		// ajouter note:dataproperty
	    		if(!film[13].equals("")){
	    			OWLLiteral literalNote = factory.getOWLLiteral(film[13], positiveIntegerDatatype);
	    			dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpNote, iFilm, literalNote);
	    			manager.addAxiom(ontoPeup, dataassersion);
	    		}
	    		
	    		if(film[13].equals("")){
	    			//Film sans note encore
	    			String note = omdbProxy.getMovieInfos(film[0]).get("imdbRating");
    				if(!((note==null)||(note.contains("N/A")))){
//    					System.out.println(note);
    					OWLLiteral literalNote = factory.getOWLLiteral(note, positiveIntegerDatatype);
    					dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpNote, iFilm, literalNote);
    					manager.addAxiom(ontoPeup, dataassersion);
    					film[13]=note;
    				}
	    		}
	    		
	    		// ajouter duree
	    		if(!film[14].equals("")){
	    			OWLLiteral literalDuree = factory.getOWLLiteral(film[14], positiveIntegerDatatype);
	    			dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpDuree, iFilm, literalDuree);
	    			manager.addAxiom(ontoPeup, dataassersion);
	    		}
	    		
	    		if(film[14].equals("")){
	    			//Film sans note encore
	    			String duree = omdbProxy.getMovieInfos(film[0]).get("Runtime");
    				if(!((duree==null)||(duree.contains("N/A")))){
//    					System.out.println(duree);
    					OWLLiteral literalDuree = factory.getOWLLiteral(film[14], positiveIntegerDatatype);
    	    			dataassersion = factory.getOWLDataPropertyAssertionAxiom(dpDuree, iFilm, literalDuree);
    	    			manager.addAxiom(ontoPeup, dataassersion);
    	    			film[14]=duree;
    				}
	    		}
	    		
	        }
	        System.out.println("FIN ajouter individuals");
	        /** fin boucle **/
	        
	        // des informations supplémentaires
	        /* pays france*/
	        OWLNamedIndividual iPaysFrance = factory.getOWLNamedIndividual(":iPaysFrance",pmontoP);
        	classAssertion = factory.getOWLClassAssertionAxiom(Pays, iPaysFrance);
        	manager.addAxiom(ontoPeup, classAssertion);
        	// ajouter nom:label
        	lab = factory.getOWLAnnotation(factory.getRDFSLabel(),factory.getOWLLiteral("France","fr"));
    		labassertion= factory.getOWLAnnotationAssertionAxiom(iPaysFrance.getIRI(), lab);
    		manager.addAxiom(ontoPeup, labassertion);
    		// ajouter opSitueDans
    		objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opSitueDans, iVilleMontpellier, iPaysFrance);
    		manager.addAxiom(ontoPeup, objectassersion);
    		objectassersion = factory.getOWLObjectPropertyAssertionAxiom(opSitueDans, iVilleParis, iPaysFrance);
    		manager.addAxiom(ontoPeup, objectassersion);

	        
			//sauvegarde de l'ontologie peuplée dans le fichier fileOut
			manager.saveOntology(ontoPeup, IRI.create(fileOut.toURI()));
			System.out.println("Sauvegarde de l'ontologie peuplée :" + fileOut.toURI());
			
	        
	        
			
		}catch (Exception ie){
			System.out.print("b"+ie);
		}

	}// fin main
}
