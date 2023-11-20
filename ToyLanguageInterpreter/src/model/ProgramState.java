package model;

import model.myADTs.*;
import model.statements.IStatement;
import model.values.IValue;

public class ProgramState {
    private MyIStack<IStatement> executionStack;
    private MyIDictionary<String, IValue> symbolTable;
    private MyIList<IValue> outputList;

    private FileTable fileTable;

    private MyIHeap heap;

    IStatement originalProgram;

    public ProgramState(MyIStack<IStatement> stack, MyIDictionary<String, IValue> symbolTable, MyIList<IValue>
            output, IStatement program, FileTable fileTable, MyIHeap heap){
        executionStack = stack;
        this.symbolTable = symbolTable;
        this.outputList = output;
        originalProgram=program.deepCopy();
        stack.push(program);
        this.fileTable = fileTable;
        this.heap = heap;
    }

    public void resetProgramState()
    {
        executionStack.clear();
        symbolTable.clear();
        outputList.clear();
        fileTable.clear();
        heap.clear();
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

    public MyIHeap getHeap() {
        return heap;
    }

    public void setHeap(MyIHeap heap) {
        this.heap = heap;
    }

    @Override
    public String toString() {
        return executionStack.toString() + '\n' + symbolTable.toString() + '\n' +
                outputList.toString() + '\n' + fileTable.toString() + '\n' + heap.toString();
    }


}
