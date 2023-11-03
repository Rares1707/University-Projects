package model;

import model.myADTs.MyIDictionary;
import model.myADTs.MyIList;
import model.myADTs.MyIStack;
import model.statements.IStatement;
import model.values.IValue;

public class ProgramState {
    MyIStack<IStatement> executionStack;
    MyIDictionary<String, IValue> symbolTable;
    MyIList<IValue> outputList;
    IStatement originalProgram; //optional field, but good to have
    public ProgramState(MyIStack<IStatement> stack, MyIDictionary<String, IValue> symbolTable, MyIList<IValue>
            output, IStatement program){
        executionStack = stack;
        this.symbolTable = symbolTable;
        this.outputList = output;
        originalProgram=program.deepCopy();//recreate the entire original prg
        stack.push(program);
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
