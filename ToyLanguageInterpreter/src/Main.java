import model.MyException;
import controller.Controller;
import model.expressions.ArithmeticExpression;
import model.expressions.ValueExpression;
import model.expressions.VariableExpression;
import model.statements.*;
import model.types.BoolType;
import model.types.IntType;
import model.values.BoolValue;
import model.values.IntValue;
import view.View;
import repository.IRepository;
import repository.Repository;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws MyException {
        IStatement programFAIL = new CompoundStatement(new CompoundStatement(new VariableDeclarationStatement("v",
                new IntType()), new CompoundStatement(new AssignmentStatement("v",
                new ValueExpression(new IntValue(2))), new PrintStatement(new VariableExpression("v")))),
                new VariableDeclarationStatement("v", new IntType()));

        IStatement program1 = new CompoundStatement(new CompoundStatement(new VariableDeclarationStatement("v",
                new IntType()), new CompoundStatement(new AssignmentStatement("v",
                new ValueExpression(new IntValue(2))), new PrintStatement(new VariableExpression("v")))),
               new CompoundStatement(new NopStatement(), new VariableDeclarationStatement("a", new BoolType())));

        IStatement program2 = new CompoundStatement(new VariableDeclarationStatement("a", new IntType()),
                new CompoundStatement(new VariableDeclarationStatement("b", new IntType()),
                        new CompoundStatement(new AssignmentStatement("a", new ArithmeticExpression( '+',
                                new ValueExpression(new IntValue(2)), new ArithmeticExpression('*',
                                        new ValueExpression(new IntValue(3)), new ValueExpression(new IntValue(5)) ) )),
                                new CompoundStatement(new AssignmentStatement("b", new ArithmeticExpression(
                                        '+', new VariableExpression("a"), new ValueExpression(
                                                new IntValue(1)))), new PrintStatement(new VariableExpression("b"))))));

        IStatement program3 = new CompoundStatement(new VariableDeclarationStatement("a", new BoolType()),
                new CompoundStatement(new VariableDeclarationStatement("v", new IntType()),
                        new CompoundStatement(new AssignmentStatement("a", new ValueExpression(new BoolValue(true))),
                                new CompoundStatement(new IfStatement(new VariableExpression("a"),
                                        new AssignmentStatement("v", new ValueExpression(new IntValue(2))),
                                        new AssignmentStatement("v", new ValueExpression(new IntValue(3)))),
                                        new PrintStatement(new VariableExpression("v"))))));

        IRepository repository = new Repository(program1, "C:\\Users\\Rares\\IdeaProjects\\ToyLanguageInterpreter\\src\\textFiles\\logFile.txt");
        repository.addProgram(program2);
        repository.addProgram(program3);
        Controller controller = new Controller(repository);
        View view = new View(controller);

        try
        {
            view.startProgram();
        }
        catch (MyException error)
        {
            System.out.println(error.getMessage());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}