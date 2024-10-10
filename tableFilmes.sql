/**
** Comandos NoSQL para a definição da estrutura de tabelas chave-valor com JSONB
** O JSONB é muito mais rápido para fazer pesquisas, já que você pode indexar o conteúdo das chaves. Em termos de velocidade de escrita, os tempos são bem próximos, mas o JSON é um pouco mais rápido, sendo que isso acontece porque o JSONB precisa transformar os dados em uma estrutura nativa do PostgreSQL.
*/

/**
** Vamos exercitar o modelo chave-valor com o tipo de dado JSONB.
** A seguir será apresentado o código para a criação da tabela “filmes”.
*/

CREATE TABLE filmes ( idfilme serial NOT NULL,dados jsonb);

/**
*?código para a inclusão de registros de filmes contendo as respectivas classificações de gêneros em um atributo array em JSONB:
*/
INSERT INTO filmes (dados) VALUES
    ( '{ "titulo": "Filme_A", "generos": ["Curta", "Romance", "Terror"], "publicado": false }' ),
    ( '{ "titulo": "Filme_B", "generos": ["Marketing", "Auto-ajuda", "Psicologia"], "publicado": true }' ),
    ( '{ "titulo": "Filme_C", "generos": ["Justiça", "Política"], "autores": ["Ana","Nei"],"publicado" : true }' ),
    ( '{ "titulo": "Filme_D", "generos": ["Produtividade", "Tecnologia"]," publicado": true }' ),
    ( '{ "titulo": "Filme_E", "generos": ["Ficção", "Infanto-juvenil"], "publicado": true }' );
SELECT * FROM filmes;

/**
*? As consultas a seguir listam os títulos e os gêneros dos filmes em formato JSONB e em texto, respectivamente.
*/
SELECT dados -> 'titulo' as titulo, dados -> 'generos' AS generos
FROM filmes ORDER BY 1;
SELECT dados ->> 'titulo' as titulo, dados ->> 'generos' AS generos
FROM filmes ORDER BY 1;

/**
*? Uma consulta para exibir somente registros que satisfazem a uma determinada condição em uma chave booleana.
*/
SELECT * FROM filmes WHERE dados->'publicado' = 'false';

/**
*? Com a função jsonb_array() pode-se listar cada elemento de um campo JSON em linhas separadas.
*/
SELECT jsonb_array_elements_text(dados -> 'generos') AS genero
FROM filmes WHERE idfilme = 3;

/**
*? Pode-se efetuar a busca na tabela a partir do valor de um elemento do array em JSONB. 
*/
SELECT dados->'titulo' as titulo,dados->'generos' as generos FROM filmes
WHERE dados->'generos' @> '["Ficção"]'::jsonb;

/**
*? Incluindo mais um registro para facilitar o entendimento da resposta apresentada.
*/
INSERT INTO filmes (dados) VALUES
( '{ "titulo": "Filme_F", "generos": ["Curta", "Romance"], "publicado": false }' );
SELECT dados -> 'titulo' as titulo, dados -> 'generos'AS generos
FROM filmes
WHERE dados->'generos' @> '["Curta", "Romance"]'::jsonb;

/**
*?Como o modelo chave-valor é schemaless, muitas vezes é necessário saber quais registros possuem determinadas chaves. As consultas a seguir apresentam os registros que contêm, respectivamente, o total de registros com as chaves ‘autores’ e‘generos’. O resultado é o total igual a 1 para a primeira consulta e 6 para a segunda consulta.
*/
SELECT COUNT(*) as total FROM filmes WHERE dados ? 'autores';
SELECT COUNT(*) as total FROM filmes WHERE dados ? 'generos';

/**
*? Por vezes, é necessária uma visualização “expandida” dos dados para melhor entendimento da estrutura dos tipos de dados em JSONB. Assim, na próxima consulta é apresentada a função jsonb_pretty( ) que possibilita a visão dos dados de forma indentada. Veja o resultado apresentado no banco de dados e, logo a seguir, em forma textual ( o que pode ser feito copiando o resultado da consulta e colando em um texto ).
*/
SELECT dados -> 'titulo' as titulo, dados -> 'generos'AS generos, jsonb_pretty( dados )
FROM filmes
order by 1 ;

/**
*? Caso seja necessário adicionar uma chave, pode-se realizar a concatenação da seguinte forma:
*/
UPDATE filmes
SET dados = dados || '{"ano":"2015"}'::jsonb
WHERE idfilme = 3 ;

/**
*? Uma das vantagens de usar o formato JSONB do PostgreSQL em relação ao formato JSON é a possibilidade de usar índices GIN. Tais índices podem ser usados para pesquisar chaves ou pares de chave-valor com eficiência.
*/
CREATE INDEX idx_publicados ON filmes USING GIN ((dados ->'publicado '));
