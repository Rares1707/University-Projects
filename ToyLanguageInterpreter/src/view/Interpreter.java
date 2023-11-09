package view;

import controller.Controller;
import model.MyException;
import model.expressions.ArithmeticExpression;
import model.expressions.ValueExpression;
import model.expressions.VariableExpression;
import model.statements.*;
import model.types.BoolType;
import model.types.IntType;
import model.types.StringType;
import model.values.BoolValue;
import model.values.IntValue;
import model.values.StringValue;
import repository.IRepository;
import repository.Repository;

import java.io.IOException;

class Interpreter {
    public static void main(String[] args) {
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
                        new CompoundStatement(new AssignmentStatement("a", new ArithmeticExpression('+',
                                new ValueExpression(new IntValue(2)), new ArithmeticExpression('*',
                                new ValueExpression(new IntValue(3)), new ValueExpression(new IntValue(5))))),
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

        IStatement programForFileOperationTesting =
                new CompoundStatement(new VariableDeclarationStatement("varf", new StringType()),
                        new CompoundStatement(new AssignmentStatement("varf", new ValueExpression(new StringValue("C:\\Users\\Rares\\IdeaProjects\\ToyLanguageInterpreter\\src\\textFiles\\text.in"))),
                                new CompoundStatement(new OpenReadFile(new VariableExpression("varf")),
                                        new CompoundStatement(new VariableDeclarationStatement("varc", new IntType()),
                                                new CompoundStatement(new ReadNumberFromFile(new VariableExpression("varf"), "varc"),
                                                        new CompoundStatement(new PrintStatement(new VariableExpression("varc")),
                                                                new CompoundStatement(new ReadNumberFromFile(new VariableExpression("varf"), "varc"),
                                                                        new CompoundStatement(new PrintStatement(new VariableExpression("varc")),
                                                                                new CloseReadFile(new VariableExpression("varf"))
                                                                                ))))))));

        IRepository repository1 = new Repository(programForFileOperationTesting, "C:\\Users\\Rares\\IdeaProjects\\ToyLanguageInterpreter\\src\\textFiles\\logFile1.txt");
        IRepository repository2 = new Repository(program2, "C:\\Users\\Rares\\IdeaProjects\\ToyLanguageInterpreter\\src\\textFiles\\logFile2.txt");
        IRepository repository3 = new Repository(program3, "C:\\Users\\Rares\\IdeaProjects\\ToyLanguageInterpreter\\src\\textFiles\\logFile3.txt");


        Controller controller1 = new Controller(repository1);
        Controller controller2 = new Controller(repository2);
        Controller controller3 = new Controller(repository3);
        TextMenu menu = new TextMenu();
        menu.addCommand(new ExitCommand("0", "exit"));
        menu.addCommand(new RunExampleCommand("1", programForFileOperationTesting.toString(), controller1));
        menu.addCommand(new RunExampleCommand("2", program2.toString(), controller2));
        menu.addCommand(new RunExampleCommand("3", program3.toString(), controller3));
        menu.show();

    }
}