package view;

import model.MyException;
import controller.Controller;

import java.io.IOException;
import java.util.Scanner;

public class View {
    Controller controller;

    public View(Controller controller) {
        this.controller = controller;
    }

    public void startProgram() throws MyException, IOException {
        while (true)
        {
            System.out.println("Enter the index of the program (1 to " +
                    controller.repositorySize() + ") or 0 to close the application");
            System.out.println();
            Scanner scanner = new Scanner(System.in);
            int userInput = scanner.nextInt();
            if (userInput == 0)
                return;
            controller.completeExecutionOfTheProgram(userInput - 1);
        }
    }

}
