import 'package:postgres/postgres.dart';

class PostgresDatabase {
  final String host = '192.168.8.100';
  final int port = 5432;
  final String username = 'postgres';
  final String password = 'root';
  final String database = 'tarBUS';

  late PostgreSQLConnection postgreSQLConnection;
  
  Future<void> initConnection() {
    postgreSQLConnection = PostgreSQLConnection(host, port, database, username: username, password: password);
    return postgreSQLConnection.open();
  }
}

PostgresDatabase postgresDatabase = PostgresDatabase();