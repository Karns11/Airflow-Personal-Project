from sqlalchemy import create_engine

import pandas as pd

def ingest_weekly_data(user, password, host, port, db, csv_name, table_name):

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()

    print("connection established")



    df = pd.read_csv(csv_name)


    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')


    df.to_sql(name=table_name, con=engine, if_exists='append')

    print("data inserted")

    engine.dispose()


def print_records(user, password, host, port, db, table_name):

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()

    print("connection established")



    query = f"SELECT * FROM {table_name}"

    # Read the SQL query into a DataFrame
    df = pd.read_sql(query, con=engine)

    print("columns: ", df.shape[1], "\n")
    print("records: ", df.shape[0], "\n")