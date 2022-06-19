/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     17/06/2022 13:10:03                          */
/*==============================================================*/
/* Table: ESTUDIANTE                                            */
/*==============================================================*/
create table ESTUDIANTE (
   ID_ESTUDIANTE        INT4                 not null,
   NOMBRES_ESTUDIANTE   VARCHAR(30)          	 null,
   FECHAINGRESO_ESTUDIANTE DATE                	 null,
   NUMEROREPETICIONES_ESTUDIANTE serial      not null,
   constraint PK_ESTUDIANTE primary key (ID_ESTUDIANTE)
);

/*==============================================================*/
/* Table: MATRICULA                                             */
/*==============================================================*/
create table MATRICULA (
   ID_MATRICULA         INT4                 not null,
   ID_ESTUDIANTE        INT4                 not null,
   FECHA_MATRICULA      DATE                 null,
   NIVEL_MATRICULA      INT4                 null,
  constraint PK_MATRICULA primary key (ID_MATRICULA)

);
-- Llave foranea en la entidad Matricula 
alter table MATRICULA
add constraint FK_MATRICUL_TIENE_ESTUDIAN foreign key (ID_ESTUDIANTE)
references ESTUDIANTE (ID_ESTUDIANTE)
on delete restrict on update restrict;

--Primer inserccion en la tabla estudiante
insert into ESTUDIANTE (ID_ESTUDIANTE, NOMBRES_ESTUDIANTE, FECHAINGRESO_ESTUDIANTE, NUMEROREPETICIONES_ESTUDIANTE)
values (1, 'Robert Moreira', '12-02-2021',1)

--Primer inserccion en la tabla matricula
insert into MATRICULA (ID_MATRICULA,ID_ESTUDIANTE, FECHA_MATRICULA, NIVEL_MATRICULA)
values (100,1,'12-02-2021',1)


/*El trigger debe sumar el número de repeticiones por nivel en el caso de que repita un mismo nivel,
y el mismo trigger debe borrar el número de repeticiones si el registro se borra,*/

--Función del trigger
create function trigg_1() returns trigger
as 
$$
begin 
UPDATE ESTUDIANTE SET NUMEROREPETICIONES_ESTUDIANTE = NUMEROREPETICIONES_ESTUDIANTE+1
WHERE ID_ESTUDIANTE=NEW.ID_ESTUDIANTE;
UPDATE ESTUDIANTE SET NUMEROREPETICIONES_ESTUDIANTE = NUMEROREPETICIONES_ESTUDIANTE-1
WHERE ID_ESTUDIANTE=OLD.ID_ESTUDIANTE and NUMEROREPETICIONES_ESTUDIANTE>0;
return new;
end
$$
language plpgsql

---- Trigger a ejecutar en tabla específica----------------
create trigger trigg_1 after insert or delete on MATRICULA
for each row
execute procedure trigg_1()

--------------Ingresar daros en matrícula-------------------------
insert into MATRICULA (ID_MATRICULA,ID_ESTUDIANTE, FECHA_MATRICULA, NIVEL_MATRICULA)
			values  
					(101,1,'12-02-2021',1),
					(102,1,'12-02-2022',1),
					(103,1,'12-02-2023',1);

----.---------Mostrar tablas--------------------
select * from ESTUDIANTE
select * from MATRICULA

---------------Borrar matriculas-------------------
delete from MATRICULA where ID_ESTUDIANTE=1 AND ID_MATRICULA=100
delete from MATRICULA where ID_ESTUDIANTE=1 AND ID_MATRICULA=101
delete from MATRICULA where ID_ESTUDIANTE=1 AND ID_MATRICULA=102
delete from MATRICULA where ID_ESTUDIANTE=1 AND ID_MATRICULA=103


----------------Mostrar tablas----------------
select * from ESTUDIANTE
select * from MATRICULA