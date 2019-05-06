# Resolucao P1 2018 - SisProg

## Questao 1:

![Questao 1 - Solucao](./Questao1.png)

A imagem mostra os componentes basicos de um sistema de programacao:
1. **Montador**: Responsavel por traduzir um programa escrito em linguagem simbolica (*Assembly*) em linguagem de maquina, sendo esta em representacao binaria, hexadecimal, ASCII, ou qualquer outro tipo de representacao dos dados, desde que esteja em concordancia com o funcionamento dos outros programas de sistema. Os arquivos gerados pelo montador representam dois tipos de programas:
	1. **Programas Absolutos**: Apresenta todas as suas referencias a enderecos absolutos, podendo ser carregado diretamente para a memoria, estando pronto para execucao.
	2. **Programas Relocaveis**: Apresentam outros tipos de referencias a enderecos:
		1. *Relocaveis*: Trata-se de um caso particular do enderecamento relativo, no qual ponto de referencia fica implicito, e corresponde ao endereco relativo zero do programa relocavel.
		2. *Simbolicos*: Usados para permitir referencias mutuas (externas ou internas) atraves de rotulos simbolicos, importados ou exportados entre modulos distintos.
Esse tipo de programação permite maior modularidade e reutilizacao de codigo.
2. **Ligador / Relocador**: O ligador e responsavel por resolver referencias simbolicas externas (entre os modulos) nos programas relocaveis, produzindo um programa objeto relocavel sem referencias simbolicas. O relocador, por sua vez, resolve enderecamentos relativos, principalmente aqueles entre modulos, gerando um codigo objeto absoluto, contendo apenas enderecos abosultos ou relativos a uma base de relocacao comum (para posterior alocacao final).
3. **Alocador**: Encarregado de distribuir na memoria e associar uma base de relocacao aos programas objeto gerados pelo programas de sistema descritos acima. Desta forma, todos os enderecos do codigo serao alocados a enderecos absolutos em regioes de memoria adequadas. Nota-se que opapel do Alocador normalmente e feito pelo sistema operacional.

## Questao 2:

Existem diversas formas de se implementar um sistema de login, alem de poder se empregar tecnicas de encriptacao dos dados atraves de algoritmos de hashing, por exemplo. Porem, trago aqui a mais simples implementacao possivel, que se baseia na insercao de usuarios e senhas em um arquivo de ttexto chamado "users". Esse arquivo apresenta uma estrutura definida, na qual cada linha representa um usuario e contem duas colunas: usuario e senha. Desta maneira, o sistema de login simplesmente verifica se os dados informados pelo usuario constam no arquivo "users". Uma possivel implementacao desse sistema esta representado abaixo em C++:

	bool login () {
		cout << "User: ";
		string user;
		cin >> user;
		cout << "Senha: ";
		string senha;
		cin >> senha;
		cin.ignore(256, '\n');
		fstream file("users", ios_base::in);
		
		while (file) {
			string u, p;
			file >> u >> p;
			if (user.compare(u) == 0 && senha.compare(p) == 0) {
				return true;
			}
		}
		return false;
	}

## Questao 4:

![Questao 4 - Solucao](./Questao4.png)


## Questao 5:

Trata-se de um conjunto de instrucoes (CI) bastante reduzido, sem suporte para diferentes tipos de enderecamento, contendo apenas enderecamentos absolutos com opcao de leitura de memoria em modo direto ou indireto. Nao implementa enderecamento relativo. 
Ao se discutir um CI estamos tratando sobre a arquitetura do computador, que deve apresentar certos componentes para dar suporte as suas instrucoes. Poderiamos pensar aqui em mudancas de arquitetura utilizando-se nao apenas de um registrador acumulador, mas sim um conjunto de registradores de proposito geral, que abririam possibilidades de outros tipos de intrucoes de acesso aos registradores e memoria. Alem disso o CI atual nao apresenta suporte "nativo" a implementacao de pilhas (stacks) de memoria, muito uteis na comunicacao entre modulos ou funcoes do programa. Tal implementacao poderia ser feita integrando um registrador para a base da pilha, assim como instrucoes de manejo do stack, isto e: PUSH e POP.
Uma outra observacao sobre esse CI e a falta de um conjunto de instrucoes voltadas a numeros fracionarios, sejam eles de ponto fixo ou flutuante. Um CI que contenha instrucoes de manejo de numeros fracionarios deve conter registradores e operacoes especiais para tratar esse tipo de dado.
Por fim, nota-se a adocao de instrucoes especiais de manejo de IO. Uma outra possivel solucao para esse tipo de comunicacao é o chamado *Memory Mapped IO* que aloca espacos especificos de memoria para funcionarem como ponto de entrada e saida de dispositivos de comunicacao, nao sendo necessario implementar instrucoes exclusivamente para tratamento de IO, reaproveitando instrucoes de leitura e escrita em memoria.

## Questao 6:

O **Codigo Objeto Absoluto** deve apresentar um formato bem definido, uma vez que deve ser processado por diferentes componentes de um sistema de programacao. Dentre as possiveis informacoes contidas no codigo objeto, pode-se mostrar um esquema geral de um Codigo Objeto Absoluto generico:
1. Tamanho do arquivo: Mostra quantos bytes de instrucoes de maquina e dados estao contidos no arquivo
2. Endereco Inicial: Endereco de memoria no qual o segmento de codigo deve ser inserido
3. Instrucoes e dados: Conjunto de instrucoes de ja traduzidos em codigo de maquina, com todos os seus enderecos ja resolvidos (absolutos). Alem de possiveis dados guardados em memoria, uma vez que nao se tem distincao de dados e instrucoes quanto a estrutura dessas informacoes ou local onde devem ser armazenadas.
4. Check Sum: Byte (ou bytes) de verificacao, que tem como objetivo verificar a integridade dos dados carregados. Trata-se do valor negado da soma de todos os bytes de dados do programa. O loader, utiliza-se desse campo para fazer a verificacao de leitura correta dos dados.

Nota-se que essa e uma implementacao bastante simples de um formato de Codigo Objeto, contendo apenas os dados essenciais para seu funcionamento, podendo haver outros tipos de dados e meta dados. O codigo objeto absoluto e utilizado tambem pelo **Alocador** na fase de alocacao de memoria para o programa, escolhendo uma base de relocacao conveniente e pelo loader no momento de carregar o programa objeto na memoria do computador. Alem disso, o codigo objeto em seu formato Relocavel tambem pode ser tratado pelos **Ligadores** e **Relocadores**.

## Questao 7:

O **Loader** tem como funcao principal transpor os bytes do codigo objeto absoluto de uma midia (Papel Perfurado, disco rigido, etc) para a memoria primaria do computador, para que possa ser executada pelo processador futuramente. Para isso as operacoes de leitura de IO e escrita em memoria sao utilizadas com grande intensidade.
Uma possivel alteracao na arquitetura e organizacao desse sistema e a adicao de um modulo de Acesso Direto a Memoria (DMA), que possibilita a utilizacao da unidade central de processamento para execucao de outras instrucoes enquanto os dados sao transferidos das entradas para a memoria pelo modulo DMA. Um sistema de interrupcoes seria util para o controle e comunicacao entre a UCP e o DMA.

## Questao 8:

A unica diferenca entre o loader absoluto binario e o loader ASCII hexadecimal e a forma de representacao dos dados e, consequentemente, a forma de interpreta-los. A representacao binaria pode ser bastante interessante por nao exigir tratamento das informacoes contidas no arquivo a ser carregado, bastanto ao loader copiar as informacoes para a memoria. A grande desvantagem e a dificuldade de leitura de arquivos binarios por seres humanos, uma vez que a representacao dos caracteres reconheciveis utiliza-se da tabela ASCII, sendo que nem todos os possiveis valores tem representacoes graficas. O codigo objeto em formato ASCII hexadecimal, por sua vez, pode ser lido com maior facilidade, uma vez que os valores serao representados por seus caracteres ASCII. O problema aqui e que o loader deve tratar de mais uma camada de abstracao, para transformar os caracteres em seus respectivos valores binarios. Para ilustrar a diferenca entre eles, suponha que temos uma instrucao que se traduz para o codigo objeto a seguir
> HEX: 0x4142 / BIN: 01000001 01000010 - Dois bytes de informacao
Na representacao binaria poderiamos representa-lo nas formas acima, em seu valor hexadecimal ou binario. Mas note que nao teriamos os caracteres 4142 nesse arquivo, mas sim suas representacoes ASCII correspondentes, nesse caso
> 0x41 = 65 = 'A' e 0x42 = 66 = 'B'
Portanto, ao observar o arquivo com o codigo objeto binario obteriamos *AB* 
Ja na representacao ASCII hexadecimal, nos gostariamos de transformar o valor hexadecimal 0x4142 em sua representacao ASCII correspondente os caracteres *4*, *1*, *4*, *2* em sequencia. Para isso, pode-se observar cada nibble (4 bits) dos bytes, e mapear o valor encontrado para seu respectibo valor ASCII somando-se o valor 48 (0x30) caso esteja entre 0 e 9 (inclusive), e 65 (0x41) - 10 = 55 (0x37) caso seja maior que 9 e menor que 15 (inclusive). No exemplo acima teriamos:
> 0x4 ->  0x4 + 0x30 = 0x34 = Digito ASCII '4'
> 0x1 ->  0x1 + 0x30 = 0x31 = Digito ASCII '1' e etc...
Caso tivessemos um numero como por exemplo *0xEF* a seguinte transformacao seria efetuada:
> 0xE -> 0xE + 0x37 = 0x45 = Digito ASCII 'E'
> 0xF -> oxF + 0x37 = ox46 = Digito ASCII 'F'

