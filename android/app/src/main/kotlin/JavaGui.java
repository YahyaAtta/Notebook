package com.example.note_book ; 
import javax.swing.* ; 
public class MyGui {
    public static void showWindow() {
        JFrame frame = new JFrame("Hello From Java GUI") ; 
        JButton btn = JButton("Click Me") ; 
        btn.addActionListener(e-> JOptionPane.showMessageDialog(frame,"Clicked Me")) ; 
        frame.add(btn) ; 
        frame.setSize(300,150) ; 
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE) ; 
        frame.setLocationRelativeTo(null) ; 
        frame.setVisible(true) ; 
    }
}