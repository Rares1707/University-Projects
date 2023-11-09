package model.statements;

import model.MyException;
import model.ProgramState;
import model.expressions.IExpression;
import model.types.BoolType;
import model.values.BoolValue;

import java.util.Objects;

public class IfStatement implements IStatement{

    private IExpression expression;
    private IStatement thenStatement;
    private IStatement elseStatement;

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
        if ( ((BoolValue) expression.evaluate(state.getSymbolTable())).getValue() == true)
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
