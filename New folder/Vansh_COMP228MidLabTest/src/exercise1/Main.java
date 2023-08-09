package exercise1;
import javax.swing.JOptionPane;

public class Main {

	public static void main(String[] args) {
		 //  For  science book information
        String scienceTitle = JOptionPane.showInputDialog(null, "Enter science book title:");
        String scienceISBN = JOptionPane.showInputDialog(null, "Enter science book ISBN:");
        String sciencePublisher = JOptionPane.showInputDialog(null, "Enter science book publisher:");
        int scienceYear = Integer.parseInt(JOptionPane.showInputDialog(null, "Enter science book year:"));
        double sciencePrice = Double.parseDouble(JOptionPane.showInputDialog(null, "Enter science book price:"));

        
        ScienceBook scienceBook = new ScienceBook(scienceTitle, scienceISBN, sciencePublisher, scienceYear);
        scienceBook.setPrice(sciencePrice);

     //For  children book information
        String childrenTitle = JOptionPane.showInputDialog(null, "Enter children book title:");
        String childrenISBN = JOptionPane.showInputDialog(null, "Enter children book ISBN:");
        String childrenPublisher = JOptionPane.showInputDialog(null, "Enter children book publisher:");
        int childrenYear = Integer.parseInt(JOptionPane.showInputDialog(null, "Enter children book year:"));
        double childrenPrice = Double.parseDouble(JOptionPane.showInputDialog(null, "Enter children book price:"));

        // Creating childrenBook object 
        ChildrenBook childrenBook = new ChildrenBook(childrenTitle, childrenISBN, childrenPublisher, childrenYear);
        childrenBook.setPrice(childrenPrice);
        
        // Display book information 
        String scienceBookInfo = "Science Book:\n" + scienceBook.toString() + "\nGenre: " + scienceBook.getGenre();
        JOptionPane.showMessageDialog(null, scienceBookInfo);

        String childrenBookInfo = "Children Book:\n" + childrenBook.toString() + "\nGenre: " + childrenBook.getGenre();
        JOptionPane.showMessageDialog(null, childrenBookInfo);
	}
}



