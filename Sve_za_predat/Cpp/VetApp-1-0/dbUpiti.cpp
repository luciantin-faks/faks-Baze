//
// Created by tin on 11/27/19.
//   stupce broji od 1, ne od 0 , com[0] = SAException
// prvo treba fetch za dobit coll type pa ih zato ctamo na kraju unosa  com u Data

#include "dbUpiti.h"
#include <SQLAPI.h>
#include <string>
#include <iostream>
#include <cstdio>
#include <list>
#include <vector>
#include "dbTablice.h"


using namespace std;

string dbUserType(SAConnection &con){

    string command = "select * from USER_ROLE_PRIVS where USERNAME = USER AND ADMIN_OPTION = 'NO' ";
    SAString SAScomm = command.c_str();

    //cout<<endl<<command<<endl;

    SACommand com;
    com.setConnection(&con);
    com.setCommandText(SAScomm);

    try {com.Execute();}
    catch(SAException & x) {printf("%s\n", (const char*)x.ErrText()); }

    //com.FetchNext();

    while(com.FetchNext()){
        SAString test = com[2];
        return (string)(const char*)test;
    }
   // SAString test = com[2];

    //return  (string)(const char*)test;

}

int SelectAllFromTable(string table,SAConnection &con){
    string command = "Select * from veterinar_sys." + table;

    SAString SAScomm = command.c_str();

    //cout<<endl<<command<<endl;

    SACommand com;
    com.setConnection(&con);
    com.setCommandText(SAScomm);

    try {com.Execute();}
    catch(SAException & x) {printf("%s\n", (const char*)x.ErrText()); }

    while(com.FetchNext()){
        SAString test = com[2];
        printf("Test : %s, %d \n", (const char*)test,1);
    }

    return 1;

}




void CommandToTable(string CommandString,dbTable &Table,SAConnection &con){


    SAString SAScomm = CommandString.c_str();
    SACommand com;
    com.setConnection(&con);
    com.setCommandText(SAScomm);


    try {com.Execute();}
    catch(SAException & x) {printf("%s\n", (const char*)x.ErrText()); }


    //get RowCount i popuni Data sa prazim poljima
    Table.RowCnt = 0;
    Table.ColCnt = com.FieldCount();

    //cout<<endl<<"BROJ STUPACAC : " << Table.ColCnt<<endl;

    for(int i = 1; i <= Table.ColCnt; i++) Table.Data.emplace_back();
    //com.FetchNext();


    //unos redova
    while(com.FetchNext()){
        Table.RowCnt ++;
        for(int i = 1; i <= Table.ColCnt ; i++){
            SAString tmp = com[i];
            Table.Data[i-1].push_back( (string)(const char*)tmp ); //com pocinje od 1 a Table od 0
            //cout<<endl<<(string)(const char*)tmp;
        }
    }


    //unos imena redova
    for(int i = 1; i <= Table.ColCnt; i++) {
        SAString tmp = com[i].Name();
        Table.CollName.push_back( (string)(const char*)tmp );
    }


    //cout<<endl<<"TU3"<<endl;
}












