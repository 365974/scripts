# create_table_microservice.py
from db_utils import connect_to_database, commit_and_close

def create_table():
    try:
        connection, cursor = connect_to_database()

        create_table_query = '''
        CREATE TABLE IF NOT EXISTS new (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255),
            email VARCHAR(255),
            address VARCHAR(255)
        );
        '''
        cursor.execute(create_table_query)
        print('Таблица "new" создана успешно')

        commit_and_close(connection)

    except Exception as error:
        print(f'Ошибка при создании таблицы: {error}')

if __name__ == "__main__":
    create_table()
