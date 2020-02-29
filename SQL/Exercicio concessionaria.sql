/*
1)criar um banco de dados de uma concessionaria de carros que tenha os carros a venda e tambem opcionais
cada opcional tem seu preco proprio, porem nao sao todos que aceitam os opcionais


2) criar uma view, que ao passar o modelo do carro e os opcionais, retorne o preco total do carro com e sem
opcionais e o preco de cada opcional escolhido. Caso for passado algum opcional nao permitido, retorne o preco 
do carro como sendo 1 milhao
*/

--	carro-opcionais
	--	id
	--	id_carro
	--	id_opcional

	/*
3) criar uma funcao para verificar se determinado opcional pode ser escolhido para determinado carro
ex.: verifica_opcional('fusca','teto_solar');
*/

create database concessionaria;

use concessionaria;

create table carros 
(
	idCarro int identity primary key,
	nomeCarro varchar(30) not null,
	precoCarro decimal(10,2) not null
)

create table Opcionais 
(
	idOpcional int identity primary key,
	nomeopcional varchar(30) not null,
	precoopcional decimal(10,2) not null
)

create table carro_opcionais
(
	id int identity primary key,
	idCarro int not null,
	idOpcional int not null
	constraint fk_carro foreign key (idcarro) references carros(idcarro),
	constraint fk_opcional foreign key (idopcional) references opcionais (idopcional)
)

create proc Carro @nomeCarro varchar(30), @precoCarro decimal(10,2)
as
begin
	insert into carros
	values
	(@nomeCarro, @precoCarro)
	select * from carros
end

--inserir em carros
--exec Carro 'Sumarino',1000000.00

create proc Opcional @opcional varchar(30), @valor decimal(10,2)
as
begin
	insert into opcionais
	values
	(@opcional, @valor)
	select * from Opcionais
end

--inserir em opcionais
--exec Opcional 'Radar MegaUltraSonico',75000

insert into carro_opcionais
values
(1,3),
(2,2),
(2,3),
(2,4),
(3,3),
(3,4),
(4,2),
(4,3),
(4,4),
(5,2),
(5,3),
(5,4),
(6,5),
(6,6);

/*
2) criar uma view, que ao passar o modelo do carro e os opcionais, retorne o preco total do carro com e sem
opcionais e o preco de cada opcional escolhido. Caso for passado algum opcional nao permitido, retorne o preco 
do carro como sendo 1 milhao
*/

create proc soma @id_Carro int
as
begin
	select   
		sum(Opcionais.precoopcional) ValorTotalOpcionais
	from carros Carros
		join carro_opcionais opcao on Carros.idCarro = opcao.idCarro
		join Opcionais Opcionais on Opcionais.idOpcional = opcao.idOpcional
	where
		Carros.idCarro = 2
end

create function soma_opcionais(@soma decimal(10,2))
returns decimal(10,2)
begin
	return cast(@soma as decimal(10,2))
end

--exec soma 2

select distinct   
	carros.nomeCarro Carro, 
	carros.precoCarro ValorCarroSemOpcional,
	Opcionais.nomeopcional Opcional, 
	Opcionais.precoopcional PrecoPorOpcional,
	--sum(dbo.soma_opcionais(opcionais.precoOpcional)) soma,
	sum(distinct Opcionais.precoopcional) ValorTotalOpcionais
	--carros.precoCarro + ValorTotalOpcionais ValorTotalComOpcionais
from carros Carros
	join carro_opcionais opcao on Carros.idCarro = opcao.idCarro
	join Opcionais Opcionais on Opcionais.idOpcional = opcao.idOpcional
where
	Carros.idCarro = 2
group by carros.nomeCarro, carros.precoCarro, Opcionais.nomeopcional, Opcionais.precoopcional 