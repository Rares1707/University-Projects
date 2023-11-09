package model.statements;

import com.sun.jdi.Value;
import model.MyException;
import model.ProgramState;
import model.expressions.IExpression;
import model.myADTs.MyIDictionary;
import model.myADTs.MyIStack;
import model.types.IType;
import model.values.IValue;


public class AssignmentStatement implements IStatement{
    private String idOfVariable;
    private IExpression expressionToBeAssigned;

    public AssignmentStatement(String idOfVariable, IExpression expressionToBeAssigned) {
        this.idOfVariable = idOfVariable;
        this.expressionToBeAssigned = expressionToBeAssigned;
    }

    @Override
    public String toString() {
        return idOfVariable + '=' + expressionToBeAssigned.toString();
    }

    public ProgramState execute(ProgramState state) throws MyException
    {
        MyIDictionary<String, IValue> symbolTable = state.getSymbolTable();

        if (symbolTable.get(idOfVariable) != null)
        {
            IValue value = expressionToBeAssigned.evaluate(symbolTable);
            IType typeOfVariable = symbolTable.get(idOfVariable).getType();
            if (value.getType().equals(typeOfVariable))
            {
                symbolTable.put(idOfVariable, value);
            }
            else
            {
                throw new MyException("declared type of variable"+idOfVariable+" and type of" +
                        " the assigned expression do not match");
            }
        }
        else
        {
            throw new MyException("the used variable" + idOfVariable + " was not declared before");
        }

        return state;
    }

    @Override
    public IStatement deepCopy() {
        return new AssignmentStatement(idOfVariable, expressionToBeAssigned.deepCopy());
    }

    //TODO deepcopy()
}
