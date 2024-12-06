# data_generation_microservice.py
from db_utils import connect_to_database, commit_and_close
from faker import Faker

def generate_and_insert_data():
    fake = Faker()

    try:
        connection, cursor = connect_to_database()

        for _ in range(10):
            name = fake.name()
            email = fake.email()
            address = fake.address()

            insert_data_query = f'''
            INSERT INTO new (name, email, address)
            VALUES ('{name}', '{email}', '{address}');
            '''
            cursor.execute(insert_data_query)

        commit_and_close(connection)

    except Exception as error:
        print(f'Ошибка при генерации и вставке данных: {error}')

if __name__ == "__main__":
    generate_and_insert_data()
