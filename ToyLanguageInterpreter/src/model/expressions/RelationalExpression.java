package model.expressions;

import model.MyException;
import model.myADTs.MyIDictionary;
import model.types.BoolType;
import model.types.IntType;
import model.values.BoolValue;
import model.values.IValue;
import model.values.IntValue;

public class RelationalExpression implements IExpression{
    String operator;
    IExpression firstExpression;
    IExpression secondExpression;

    public RelationalExpression(String operator, IExpression firstExpression, IExpression secondExpression) {
        this.operator = operator;
        this.firstExpression = firstExpression;
        this.secondExpression = secondExpression;
    }

    @Override
    public IValue evaluate(MyIDictionary<String, IValue> table) throws MyException {
        if (operator != "<" && operator != "<=" && operator != ">=" && operator != ">"
                && operator != "==" && operator != "!=")
            throw new MyException("operator not supported");

        IValue firstValue = firstExpression.evaluate(table);
        IValue secondValue = secondExpression.evaluate(table);
        if (firstValue.getType().equals(secondValue.getType()) && firstValue.getType().equals(new IntType()))
        {
            int firstValueAsInt = ((IntValue) firstValue).getValue();
            int secondValueAsInt = ((IntValue) secondValue).getValue();
            if (operator.equals("=="))
                return new BoolValue(firstValueAsInt==secondValueAsInt);
            if (operator.equals("!="))
                return new BoolValue(firstValueAsInt!=secondValueAsInt);
            if (operator.equals("<="))
                return new BoolValue(firstValueAsInt<=secondValueAsInt);
            if (operator.equals("<"))
                return new BoolValue(firstValueAsInt<secondValueAsInt);
            if (operator.equals(">"))
                return new BoolValue(firstValueAsInt>secondValueAsInt);
            if (operator.equals(">="))
                return new BoolValue(firstValueAsInt>=secondValueAsInt);
        }
        else
        {
            throw new MyException("both operands should be of type int");
        }
        return null;
    }

    @Override
    public IExpression deepCopy() {
        return new RelationalExpression(operator, firstExpression.deepCopy(), secondExpression.deepCopy());
    }

    @Override
    public String toString() {
        return firstExpression.toString() + operator + secondExpression.toString();
    }
}
