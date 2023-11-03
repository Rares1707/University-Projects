package model.expressions;

import model.MyException;
import model.myADTs.MyIDictionary;
import model.values.IValue;

public interface IExpression {
    IValue evaluate(MyIDictionary<String, IValue> table) throws MyException;

    IExpression deepCopy();
}