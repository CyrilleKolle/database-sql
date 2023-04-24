SELECT * FROM Students

SELECT * FROM Students WHERE id = 1

SELECT name FROM Students

CREATE DATABASE everyloop

RESTORE DATABASE everyloop
    FROM DISK = '/var/opt/mssql/backup/everyloop.bak'
    WITH  RECOVERY;