# db_utils.py
import mysql.connector as mariadb
from mysql.connector import Error
import configparser

def read_db_config(filename='config.ini', section='database'):
    parser = configparser.ConfigParser()
    parser.read(filename)
    db_config = {}
    if parser.has_section(section):
        items = parser.items(section)
        for item in items:
            db_config[item[0]] = item[1]
    else:
        raise Exception(f'{section} не найден в файле {filename}')
    return db_config

def connect_to_database():
    try:
        db_config = read_db_config()
        connection = mariadb.connect(**db_config)
        return connection, connection.cursor()
    except Error as error:
        print(f'Ошибка подключения к БД: {error}')
        raise

def commit_and_close(connection):
    connection.commit()
    connection.close()
