import ballerinax/mssql;
import ballerinax/mssql.driver as _;
import ballerina/http;
import ballerina/io;

service /session1 on new http:Listener(9093) {
    resource function get .() returns string|error? {
        return "service request";
    }

    resource function get firstreq() returns string|error? {
        return "first string";
    }

    resource function get secondReq() returns User[]|error? {
        mssql:Client mssqlEp = getDBClient();

        stream<User, error?> queryResponse = mssqlEp->query(sqlQuery = `select * from dbo.users`);
        User[]|error result = from User item in queryResponse
            select item;
        return result;
    }

}

function getDBClient() returns mssql:Client {
    mssql:Client mssqlEp;
    do {
        mssqlEp = check new (host = "ngarro-texas.database.windows.net",
            user = "nagarro_dbadbmin",
            password = "TexasPathway@1234", database = "texasinternshipapi",
            port = 1433
        );
    } on fail var e {
        io:print(e);
    }

    return mssqlEp;
}

type User record {|
    int id?;
    string first_name;
    string last_name;
    string email;|};

