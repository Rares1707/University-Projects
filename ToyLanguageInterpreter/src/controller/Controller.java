package controller;

import model.MyException;
import model.ProgramState;
import model.myADTs.MyIStack;
import model.statements.IStatement;
import model.values.IValue;
import model.values.ReferenceValue;
import repository.IRepository;

import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


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
            {
                repository.writeCurrentStateToLogFile();
                currentStateOfProgram.getHeap().setContent(garbageCollector(
                        getAllAddresses(currentStateOfProgram.getSymbolTable().getValues(),
                                currentStateOfProgram.getHeap().getContent()),
                                currentStateOfProgram.getHeap().getContent())
                );
                //repository.writeCurrentStateToLogFile();
            }
            executeOneStep(currentStateOfProgram);
        }
        repository.writeCurrentStateToLogFile();
    }

    Map<Integer, IValue> garbageCollector(List<Integer> addressesFromSymbolTable, Map<Integer,IValue> heap)
    {
        return heap.entrySet().stream()
                .filter(entry->addressesFromSymbolTable.contains(entry.getKey()))
                        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    }

    List<Integer> getAllAddresses(Collection<IValue> valuesFromSymbolTable, Map<Integer,IValue> heap)
    {
        List<Integer> listOfAddresses = new LinkedList<Integer>();
        valuesFromSymbolTable.stream().
                filter(value -> value instanceof ReferenceValue).
                forEach(value ->
                {
                    while (value instanceof ReferenceValue)
                    {
                        listOfAddresses.add(((ReferenceValue) value).getAddress());
                        value = heap.get(((ReferenceValue) value).getAddress());
                    }
                });
        return listOfAddresses;
    }

    public int repositorySize()
    {
        return repository.size();
    }
}
