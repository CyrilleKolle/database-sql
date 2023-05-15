from sqlalchemy import create_engine
from sqlalchemy.engine import URL
from urllib.parse import unquote
from sqlalchemy import text
from tabulate import tabulate

server_name = "localhost"
database_name = "AI22"
username = "sa"
password = "ThisIsHardToGuess"

connection_string = f"DRIVER=ODBC Driver 17 for SQL Server;SERVER={server_name};DATABASE={database_name};UID={username};PWD={password}"
url_string = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})

print("Connecting to database using URL string:")
unquoted_url = unquote(str(url_string))
print(unquoted_url, "\n")

try:
    engine = create_engine(url_string)
    with engine.connect() as connection:
        print(f"Successfully connected to {database_name}!")
except Exception as e:
    print("Error while connecting to database:\n")
    print(e)

while True:
    search_string = input("search books (press q to quit): ")

    if search_string.lower() == "q":
        break

    query = f"""
        select 
            title as 'Title',
            bs.name as 'BookStore',
            left([language ], 3) as 'Language',
            concat(format((price_$ * 10.19), '#####.00'), ' SEK') as 'Price',
            totalAvailable as 'Quantity in Stock',
            releaseDate as 'Release Date',
            concat(datediff(week, orderDate, getdate()), ' Weeks') as 'Last sale',
            g.genreName
        from 
            books b 
            join inventory i on i.isbnBookId = b.isbn13
            join bookStores bs on bs.id = i.storeId
            join orderDetails od on od.isbnBookId = b.isbn13
            join Orders o on o.orderId = od.orderId
            join Genre g on g.genreId = b.genreId
        where 
            title like '%' + :title + '%'
        order by 
            b.title, i.totalAvailable

    """
    with engine.connect() as conn:
        result = conn.execute(text(query), {"title": search_string})
        headers = [column_name.upper() for column_name in result.keys()]
        rows = [row for row in result]
        print(tabulate(rows, headers=headers, tablefmt="double_grid"))

print("Welcome to search another time...quiting")
