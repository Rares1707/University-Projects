package controller;

import model.MyException;
import model.ProgramState;
import model.myADTs.MyIStack;
import model.statements.IStatement;
import repository.IRepository;

import java.io.IOException;

public class Controller {
    IRepository repository;
    boolean displayExecution;

    public Controller(IRepository repository) {
        this.repository = repository;
        displayExecution = true;
    }

    public ProgramState executeOneStep(ProgramState currentStateOfProgram) throws MyException {
        MyIStack<IStatement> stack = currentStateOfProgram.getStack();

        if (stack.isEmpty())
        {
            throw new MyException("program stack is empty");
        }
        IStatement statementToBeExecuted = stack.pop();
        return statementToBeExecuted.execute(currentStateOfProgram);
    }

    public void completeExecutionOfTheProgram(int programIndex) throws MyException {
        repository.setIndexOfProgram(programIndex);
        ProgramState currentStateOfProgram = repository.getCurrentProgramState();

        currentStateOfProgram.resetProgramState();

        MyIStack<IStatement> stack = currentStateOfProgram.getStack();

        while (!stack.isEmpty())
        {
            if (displayExecution)
                repository.writeCurrentStateToLogFile();
            executeOneStep(currentStateOfProgram);
        }

        repository.writeCurrentStateToLogFile();
    }


    public int repositorySize()
    {
        return repository.size();
    }
}
