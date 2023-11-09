package view;

import controller.Controller;
import model.MyException;

import java.io.IOException;

public class RunExampleCommand extends Command{

    Controller controller;

    public RunExampleCommand(String key, String description, Controller controller) {
        super(key, description);
        this.controller = controller;
    }

    @Override
    public void execute() {
        int indexOfFirstProgram = 0;
        try
        {
            controller.completeExecutionOfTheProgram(indexOfFirstProgram);
        }
        catch (MyException error)
        {
            System.out.println(error.getMessage());
        }
    }
}
