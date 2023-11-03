package model.statements;

import model.MyException;
import model.ProgramState;
import model.expressions.IExpression;
import model.types.BoolType;
import model.values.BoolValue;

import java.util.Objects;

public class IfStatement implements IStatement{

    IExpression expression;
    IStatement thenStatement;
    IStatement elseStatement;

    public IfStatement(IExpression expression, IStatement thenStatement, IStatement elseStatement) {
        this.expression = expression;
        this.thenStatement = thenStatement;
        this.elseStatement = elseStatement;
    }

    @Override
    public String toString() {
        return "if (" + expression.toString() +
                ") then {" + thenStatement.toString() +
                "} else {" + elseStatement.toString() +
                '}';
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        if (!expression.evaluate(state.getSymbolTable()).getType().equals(new BoolType()))
        {
            throw new MyException("expression is not a boolean");
        }
        if (expression.evaluate(state.getSymbolTable()) != new BoolValue(false))
        {
            state.getStack().push(thenStatement);
        }
        else
        {
            state.getStack().push(elseStatement);
        }
        return state;
    }

    @Override
    public IStatement deepCopy() {
        return new IfStatement(expression.deepCopy(), thenStatement.deepCopy(), elseStatement.deepCopy());
    }
}
