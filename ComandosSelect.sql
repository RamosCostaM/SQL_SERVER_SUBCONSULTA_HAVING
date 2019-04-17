CREATE DATABASE BD12042019

USE BD12042019

CREATE TABLE Pessoa(
	RA int PRIMARY KEY,
	Nome varchar(100),
	CPF varchar(14),
	telefone varchar(14)
	)

CREATE TABLE Aluno(
	RA int PRIMARY KEY FOREIGN KEY REFERENCES Pessoa(RA),
	Curso varchar(30),
	AnoMatricula int,
	Semestre int
	)

CREATE TABLE Professor(
	RA int PRIMARY KEY FOREIGN KEY REFERENCES Pessoa(RA),
	Departamento varchar(20)
	)

create table Disciplina (
	Codigo int PRIMARY KEY, 
	ProfRA int FOREIGN KEY REFERENCES Professor(RA), 
	Carga int);

create table Nota (
	AlunoMat int FOREIGN KEY REFERENCES Aluno(RA), 
	DiscCod int FOREIGN KEY REFERENCES Disciplina(Codigo), 
	Nota float);
	
Declare @count INT = 0;
Declare @countSTR INT = 0;

WHILE @count < 100
	BEGIN
		SET @countSTR = @count;
		
		insert into  Pessoa(RA, Nome, CPF, telefone) VALUES (@count, 'ALUNOS'+ CAST(@countSTR as varchar(10)), '123.123.123-12', '12345-1234')
		insert into  Pessoa(RA, Nome, CPF, telefone) VALUES (@count+101, 'PROFESSOR'+ CAST(@countSTR as varchar(10)), '123.123.123-12', '12345-1234')
		
		insert into  Aluno(RA, Curso, AnoMatricula, Semestre) VALUES (@count, 'Ciencia da computação', 2016, 3)
		insert into  Professor(RA, Departamento) VALUES (@count+101, 'Informatica')
		insert into  Disciplina(Codigo, Carga, ProfRA) VALUES (@count, rand()*100, @count/5+101)

		SET @count = @count + 1;
	END	
		
	SET @count = 0;
	DECLARE @count2 INT = 0;

	WHILE @count < 100
		BEGIN
		
			SET @count2 = 0;
			
			WHILE @count2 < 100
				BEGIN

					insert into  Nota(AlunoMat, DiscCod, Nota) VALUES (@count, @count2, rand()*10);
						
					SET @count2 = @count2 + 1;
					
				END
					
			SET @count = @count + 1;
		END

--Listar o nome de todos os professores.
SELECT Nome FROM Pessoa
JOIN Professor ON Pessoa.RA = Professor.RA

--Listar o nome todos os professores no banco.
SELECT ProfRA, SUM(Carga) as soma FROM Disciplina
group by ProfRA

--Listar as tabelas Pessoa, Aluno, Disciplina e Nota, concatenado as tabelas corretamente por junção interna.
SELECT * FROM Pessoa
JOIN Aluno ON Pessoa.RA = Aluno.RA
JOIN Nota ON Aluno.RA = Nota.AlunoMat
JOIN Disciplina ON Nota.DiscCod = Disciplina.Codigo

--Listar o nome e o CPF de todo professor associado a uma disciplina. Cada professor deve aparecer apenas uma vez.
SELECT DISTINCT Pessoa.Nome, Pessoa.CPF
FROM Pessoa
JOIN Professor ON Professor.RA = Pessoa.RA
JOIN Disciplina ON Professor.RA = Disciplina.ProfRA


--Listar o nome e o CPF de todo professor associado a uma disciplina e o código da disciplina que o professor leciona. 
--Neste caso cada professor deve aparecer múltiplas vezes (uma para cada disciplina). 
--Se o professor não tiver disciplina deve aparecer NULL nos campos da disciplina. 
SELECT Pessoa.Nome, Pessoa.CPF, Disciplina.Codigo FROM Pessoa
JOIN Professor ON Pessoa.RA = Professor.RA
FULL JOIN Disciplina ON Professor.RA = Disciplina.ProfRA

--Listar a nota média de cada disciplina
SELECT DiscCod, Media=AVG(nota) FROM Nota
GROUP BY DiscCod

--Listar o nome e a nota média de cada professor.
SELECT Pessoa.Nome, Media=AVG(nota) FROM Pessoa
JOIN Professor ON Pessoa.RA = Professor.RA
JOIN Disciplina ON Professor.RA = Disciplina.ProfRA
JOIN Nota ON Disciplina.Codigo = Nota.DiscCod
GROUP BY Pessoa.Nome,Pessoa.RA

--Listar os nomes dos alunos que tem média geral > 5,0
SELECT Pessoa.Nome, Media=AVG(nota) FROM Pessoa
JOIN Aluno ON Pessoa.RA = Aluno.RA
JOIN Nota ON Aluno.RA = Nota.AlunoMat
GROUP BY Pessoa.RA, Pessoa.Nome
HAVING AVG(nota) > 5

--Retornar qual a disciplina com a melhor nota média. Em um segundo comando SELECT apresente a disciplina com a pior nota média.
SELECT TOP 1 Disciplina.Codigo, MEDIA = AVG(Nota) FROM Disciplina
JOIN Nota ON Disciplina.Codigo = Nota.DiscCod
GROUP BY Disciplina.Codigo
ORDER BY MEDIA DESC

SELECT TOP 1 Disciplina.Codigo, media = AVG(nota) from Disciplina
JOIN Nota ON Disciplina.Codigo = Nota.DiscCod
GROUP BY Disciplina.Codigo
ORDER BY media

--Retornar qual o professor com a melhor nota média. Em um segundo comando SELECT apresente o professor com a pior nota média.
SELECT TOP 1 Professor.RA, MEDIA = AVG(nota) FROM Professor
JOIN Disciplina ON Disciplina.ProfRA = Professor.RA
JOIN Nota ON Disciplina.Codigo = Nota.DiscCod
GROUP BY Professor.RA
ORDER BY MEDIA DESC

SELECT TOP 1 Professor.RA, MEDIA = AVG(nota) FROM Professor
JOIN Disciplina ON Disciplina.ProfRA = Professor.RA
JOIN Nota ON Disciplina.Codigo = Nota.DiscCod
GROUP BY Professor.RA
ORDER BY MEDIA

--Listar os alunos que tiraram mais do que 5 em pelo menos metade das disciplinas, sabendo que todos os alunos
--fizeram todas as disciplinas e temos 100 disciplinas na universidade.
SELECT COUNT(AlunoMat), AlunoMat  AS RA, MEDIA=AVG(Nota)  FROM NOTA
WHERE Nota.Nota>5.0
GROUP BY AlunoMat
HAVING COUNT(AlunoMat)>50
ORDER BY AlunoMat













	