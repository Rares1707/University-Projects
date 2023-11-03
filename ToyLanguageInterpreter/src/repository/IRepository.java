package repository;

import model.MyException;
import model.ProgramState;
import model.statements.IStatement;

import java.io.IOException;

public interface IRepository {
    ProgramState getCurrentProgramState() throws MyException;
    void setIndexOfProgram(int index) throws MyException;

    int size();

    void addProgram(IStatement program);

    void writeCurrentStateToLogFile() throws MyException;
}
