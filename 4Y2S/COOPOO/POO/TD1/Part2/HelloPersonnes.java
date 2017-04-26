import perso.*;

public class HelloPersonnes
{

    public static void main (String[] args)
    {
	Personne person = new Personne ("P1", 20);
	Etudiant student = new Etudiant ("S1", 21, 14.5f);
	Enseignant teacher = new Enseignant ("E1", 31, 40);

	System.out.println("This is a person,"+person.toString());
	System.out.println("This is a student,"+student.toString());
	System.out.println("This is a teacher,"+teacher.toString());
    }

}
