package model;

import model.myADTs.*;
import model.statements.IStatement;
import model.values.IValue;

public class ProgramState {
    private MyIStack<IStatement> executionStack;
    private MyIDictionary<String, IValue> symbolTable;
    private MyIList<IValue> outputList;

    private FileTable fileTable;
    IStatement originalProgram;

    public ProgramState(MyIStack<IStatement> stack, MyIDictionary<String, IValue> symbolTable, MyIList<IValue>
            output, IStatement program, FileTable fileTable){
        executionStack = stack;
        this.symbolTable = symbolTable;
        this.outputList = output;
        originalProgram=program.deepCopy();
        stack.push(program);
        this.fileTable = fileTable;
    }

    public void resetProgramState()
    {
        executionStack.clear();
        symbolTable.clear();
        outputList.clear();
        executionStack.push(originalProgram.deepCopy());
    }

    public FileTable getFileTable() {
        return fileTable;
    }

    public void setFileTable(FileTable fileTable) {
        this.fileTable = fileTable;
    }

    public void setExecutionStack(MyIStack<IStatement> executionStack) {
        this.executionStack = executionStack;
    }

    public void setSymbolTable(MyIDictionary<String, IValue> symbolTable) {
        this.symbolTable = symbolTable;
    }

    public void setOutputList(MyIList<IValue> outputList) {
        this.outputList = outputList;
    }

    public MyIDictionary<String, IValue> getSymbolTable() {
        return symbolTable;
    }

    public IStatement getOriginalProgram() {
        return originalProgram;
    }

    public MyIStack<IStatement> getStack() {
        return executionStack;
    }

    public MyIList<IValue> getOutputList()
    {
        return outputList;
    }

    @Override
    public String toString() {
        return executionStack.toString() + '\n' + symbolTable.toString() + '\n' + outputList.toString();
    }

}
