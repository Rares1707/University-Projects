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

    ArrayList <ProgramState> listOfPrograms;

    String logFilePath;

    int programIndex;

    public Repository(IStatement program, String logFilePath) {
        //This might become a newThread() function later
//        MyIStack<IStatement> executionStack = new MyStack<IStatement>();
//        MyIDictionary<String, IValue> symbolTable = new MyDictionary<String, IValue>();
//        MyIList<IValue> outputOfProgram = new MyList<IValue>();
//
        listOfPrograms = new ArrayList<ProgramState>();
        addProgram(program);
        this.logFilePath = logFilePath;
        programIndex = 0;

//        ProgramState firstProgramState = new ProgramState(executionStack, symbolTable, outputOfProgram, program);
//        listOfPrograms.add(firstProgramState);
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

        ProgramState programState = new ProgramState(executionStack, symbolTable, outputOfProgram, program);
        listOfPrograms.add(programState);
    }

    @Override
    public void writeCurrentStateToLogFile() throws MyException {
        String stateToBePrinted = listOfPrograms.get(programIndex).toString() + '\n';
        try {
            PrintWriter logFile = new PrintWriter(new BufferedWriter(new FileWriter(logFilePath, true)));
            logFile.println(stateToBePrinted);
            logFile.close();

//            FileWriter fileWriter = new FileWriter(logFilePath);
//            fileWriter.write(stateToBePrinted);
//            fileWriter.close();
        }
        catch (IOException error)
        {
            throw new MyException(error.getMessage());
        }
    }

}
