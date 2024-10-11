-- Active: 1728645870488@@127.0.0.1@27017@aula

/**
** Criaçaõ de coleção pedidos
*/
db.createCollection("pedidos", {capped : true, size : 1310720, max : 500})

/**
** Para ver se a coleção foi criada, execute o comando a seguir:
*/
show collections

/**
** Incluir um documento na cloeção
*/
db.pedidos.insert (
    {
         cliente : 'Nei',
         produto : 'Produto_1',
         autor : 'curso NOSQL',
         qtd : 8,
         peso: 1,
         unidade_medida: 'kg' 
    } )

db.pedidos.find()

db.pedidos.insert([
    {
        cliente: 'Rui',
        produto: 'Produto_2',
        autor: 'curso NOSQL',
        qtd: 9,
        peso: 10,
        unidade_medida: 'kg'
    },
    { 
        cliente: 'Lia',
        produto: 'Produto_3',
        autor: 'curso NOSQL',
        qtd: 15,
        peso: 200,
        unidade_medida: 'kg'
    }
])

/**
** Listar todos os documentos de uma coleção 
*/
db.pedidos.find({ produto : 'Produto_3'})

/**
** Listar os dados do produto de nome Produto_3
*/

/**
** LIstar os dados dos produtos com quantidade igual a 9 ou a 15
*/
db.pedidos.find({ qtd:{$in:[9, 15]}})

/**
**Para atualizar o valor de um documento, podemos usar o comando apresentado no exemplo a seguir. No caso, alteraremos o valor da chave qtd para 25 onde o nome do produto é igual a Produto_3:
*/

/**
** Atualizar  o valor de um documento
*/
try {db.pedidos.updateOne({"produto" : "Produto_3"},{ $set: {"qtd" : 25}});} catch(e){print(e);}
    
/**
** Atualizar muitos documentos em uma só operação
*/
try {db.pedidos.updateMany({autor: "Curso NOSQL"}, {$set: {"autor": "Curso de DB NOSQL"}});} catch(e) {print(e)}


/**
** PAra verificar os valores de documentos de uma chave dem repetição, basta usar a opção distinct, assim como na SQL
*/
db.pedidos.distinct("autor")


/**
** Para contar a quantidade de documenos de uma coleção, pode-se usar este comando
*/
db.pedidos.countDocuments({})


/**
** Quando for necssário excluir um documento de uma coleção, pode-se usar o co0mando deleteOne()
*/
try {db. Pedidos.deleteOne({ “_id” : ObjectId(“5f7f89161ef8d02630563a3a”)});} catch(e){print(e);}