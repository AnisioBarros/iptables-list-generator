# iptables-list-generator

## Projeto

Com o objetivo de facilitar o download de uma lista e automatizar a criação
de regras no iptables.

## Tipos de regras

### Regras de bloqueio

- Quando a origem é um ip da lista tenta acessar o seu servidor.

```
iptables -I INPUT -s $line -m comment --comment "block-list-serpro-input" -j DROP" >> importa.sh ; done 
```

- Quando o destino do seu servidor é algum ip da blacklist.

``` 
iptables -I OUTPUT -d $line -m comment --comment "block-list-serpro-output" -j DROP" >> importa.sh ; done
``` 

- Quando a origem é um ip rede interna com destino a algum ip da blacklist.

``` 
iptables -I FORWARD -s $line -m comment --comment "block-list-serpro-s-forward" -j DROP" >> importa.sh ; done
``` 

- Quando a origem é algum ip da blacklist um ip com destino a rede interna.

``` 
iptables -I FORWARD -d $line -m comment --comment "block-list-serpro-d-forward" -j DROP" >> importa.sh ; done
``` 


clone o repositorio na maquina onde precisa proteger e

execute o comando:
``` 
$ sudo bash iptables-list-generator.sh
``` 
caso precise limpar as regras apenas, rode o comando:
``` 
$ sudo bash limparegras.sh
``` 
## Referências
```
https://www.serpro.gov.br/