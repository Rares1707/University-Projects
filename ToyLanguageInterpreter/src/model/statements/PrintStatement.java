package model.statements;

import model.MyException;
import model.ProgramState;
import model.expressions.IExpression;


public class PrintStatement implements IStatement{
    private IExpression expression;

    public PrintStatement(IExpression expression) {
        this.expression = expression;
    }

    @Override
    public String toString() {
        return "print(" + expression.toString() + ")";
    }

    @Override
    public ProgramState execute(ProgramState state) throws MyException {
        state.getOutputList().add(expression.evaluate(state.getSymbolTable()));
        return state;
    }

    @Override
    public IStatement deepCopy() {
        return new PrintStatement(expression.deepCopy());
    }
}
