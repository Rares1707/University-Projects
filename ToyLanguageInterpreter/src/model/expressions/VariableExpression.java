package model.expressions;

import model.MyException;
import model.myADTs.MyIDictionary;
import model.values.IValue;

public class VariableExpression implements IExpression{
    String idOfVariable;

    public VariableExpression(String idOfVariable) {
        this.idOfVariable = idOfVariable;
    }

    @Override
    public IValue evaluate(MyIDictionary<String, IValue> table) throws MyException {
        IValue value = table.get(idOfVariable);
        return value;
    }

    @Override
    public IExpression deepCopy() {
        return new VariableExpression(idOfVariable);
    }

    @Override
    public String toString() {
        return idOfVariable;
    }
}
