package repository;

import model.MyException;
import model.ProgramState;
import model.myADTs.*;
import model.statements.IStatement;
import model.values.IValue;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class Repository implements IRepository{

    private ArrayList <ProgramState> listOfPrograms;

    private String logFilePath;

    private int programIndex;

    public Repository(IStatement program, String logFilePath) {
        listOfPrograms = new ArrayList<ProgramState>();
        addProgram(program);
        this.logFilePath = logFilePath;
        programIndex = 0;
    }


    @Override
    public ProgramState getCurrentProgramState() {
        return listOfPrograms.get(programIndex);
    }

    @Override
    public void setIndexOfProgram(int index) throws MyException {
        if (programIndex < 0 || programIndex >= listOfPrograms.size())
            throw new MyException("index out of bounds");
        programIndex = index;
    }

    @Override
    public int size() {
        return listOfPrograms.size();
    }

    @Override
    public void addProgram(IStatement program) {
        MyIStack<IStatement> executionStack = new MyStack<IStatement>();
        MyIDictionary<String, IValue> symbolTable = new MyDictionary<String, IValue>();
        MyIList<IValue> outputOfProgram = new MyList<IValue>();
        FileTable fileTable = new FileTable();

        ProgramState programState = new ProgramState(executionStack, symbolTable, outputOfProgram, program, fileTable);
        listOfPrograms.add(programState);
    }

    @Override
    public void writeCurrentStateToLogFile() throws MyException {
        String stateToBePrinted = listOfPrograms.get(programIndex).toString() + '\n';
        try {
            PrintWriter logFile = new PrintWriter(new BufferedWriter(new FileWriter(logFilePath, true)));
            logFile.println(stateToBePrinted);
            logFile.close();
        }
        catch (IOException error)
        {
            throw new MyException(error.getMessage());
        }
    }

    void addFileToCurrentProgram(String filePath)
    {
        //TODO maybe
    }

}
