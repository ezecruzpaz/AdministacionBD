--creacion de una base de datos
create database paquitabd
on primary  
(
 Name = paquitabdData, filename='C:\datanueva/paquitabd.mdf'
 ,size = 50MB -- el tamaño minimo es de 12kb el predeterminado es de 1mb
 ,filegrowth=25% -- el defautl es de 10%
 ,maxsize = 400MB 
)
log on 
(
Name = paquitabdLog, filename = 'C:\lognueva/paquita_log.ldf',
 size = 25MB 
 ,filegrowth=25% -- el defautl es de 10% -- el minimo es de 1MB
 )


 --crear un archivo adicional 
alter database paquitabd 
ADD FILE
(
NAME='PaquitaDataNDF',
FILENAME= 'C:\datanueva/paquitabd2.mdf'
,SIZE = 25 MB
,MAXSIZE=500mb
,FILEGROWTH=10MB -- el minimo es de 1MB
)TO FILEGROUP[PRIMARY];

--creacion de una filegroup adicional 

Alter database paquitabd
add filegroup secundario
go

--creacion de un archivo asociado al filegroup
alter database paquitabd 
ADD FILE
(
NAME='Paquitabd_parte1',
FILENAME= 'C:\datanueva/paquita_secundario.mdf'

)TO FILEGROUP[SECUNDARIO];

--crear una tabla en el grupo de archivos(filegropus) secundario 
create table ratadedospatas(
id int not null identity(1,1),
nombre nvarchar (100) not null,
constraint pk_ratadedospatas
primary key (id),
constraint unico_nombre
unique (nombre))
on SECUNDARIO --especificamos el grupo de archivo


create table bichorastrero(
id int not null identity(1,1),
nombre nvarchar (100) not null,
constraint pk_bichorastrero
primary key (id),
constraint unico_nombre2
unique (nombre))


create table comparadacontigo(
id int not null identity(1,1),
nombredelanimal nvarchar (100) not null,
defectos nvarchar (max) not null
constraint pk_comparadocontigo
primary key (id),
constraint unico_nombre3
unique (nombredelanimal))



--mofificamos el grupo secundario 

use master
use paquitabd



alter database paquitabd
modify filegroup [SECUNDARIO] DEFAULT


--revision del estado de la opcion de ajuste automatico del tamaño de archivos 

select DATABASEPROPERTYEX('paquitabd','ISAUTOSHRINK')

--CAMBIA LA OPCION DE AUTOSHRINK A TURE

ALTER DATABASE paquitabd
SET AUTO_SHRINK ON WITH NO_WAIT
GO 

--revision del estado de la opcion de creacion de estadisticas
SELECT DATABASEPROPERTYEX('paquitabd','IsAutoCreateStatistics')

ALTER DATABASE paquitabd
SET AUTO_CREATE_STATISTICS ON
GO 


--consultar informacion de la base de datos 
use master
SP_helpdb paquitabd
GO


--consutlar la informacion de grupos 
SP_HELPFILEGROUP SECUNDARIO