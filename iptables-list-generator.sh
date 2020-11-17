#!/bin/bash
curl --location --request GET 'https://reputation.serpro.gov.br' > ipsbaixareputacao

echo -n "criando o limparegras.sh"
cat > limparegras.sh <<- EOF
#!/bin/bash
    echo "limpando regras antigas."
    iptables-save | sed -r '/INPUT.*comment.*block-list-serpro-input/s/-A/iptables -D/e'
    sleep 1
    iptables-save | sed -r '/OUTPUT.*comment.*block-list-serpro-output/s/-A/iptables -D/e'
    sleep 1
    iptables-save | sed -r '/FORWARD.*comment.*block-list-serpro-s-forward/s/-A/iptables -D/e'
    sleep 1
    iptables-save | sed -r '/FORWARD.*comment.*block-list-serpro-d-forward/s/-A/iptables -D/e'
    sleep 1
EOF
sleep 0.5;echo -n " [ OK ]"; echo 

FILE=importa.sh
if [ -f "$FILE" ]; then
    echo "$FILE ja existe, vou limpar e recriar."
    rm importa.sh ;
    touch importa.sh ;
        if [ $? -eq 0 ]
        then
        echo "importa.sh criado com sucesso"
        else
        echo "nao foi possivel criar o importa.sh"
        chattr -i importa.sh
        fi
    echo '#!/bin/bash' > importa.sh
    echo "iniciando criacao de regras no $FILE"
    echo "limpando regras antigas."
    sleep 2 ; 
    bash limparegras.sh ;     
    echo "regras limpas."
else 
    echo "$FILE nao existe, vou criar."
    touch importa.sh ;
        if [ $? -eq 0 ]
        then
        echo "importa.sh criado com sucesso"
        else
        echo "nao foi possivel criar o importa.sh"
        chattr -i importa.sh        
        fi    
    echo '#!/bin/bash' > importa.sh
    echo "iniciando criacao de regras no $FILE"    
fi

    for line in $(cat ipsbaixareputacao); do echo "iptables -I INPUT -s $line -m comment --comment "block-list-serpro-input" -j DROP" >> importa.sh ; done 
    echo "regras de INPUT foram criadas."
    for line in $(cat ipsbaixareputacao); do echo "iptables -I OUTPUT -d $line -m comment --comment "block-list-serpro-output" -j DROP" >> importa.sh ; done
    echo "regras de OUTPUT foram criadas."
    for line in $(cat ipsbaixareputacao); do echo "iptables -I FORWARD -s $line -m comment --comment "block-list-serpro-s-forward" -j DROP" >> importa.sh ; done
    echo "regras de src FORWARD foram criadas."
    for line in $(cat ipsbaixareputacao); do echo "iptables -I FORWARD -d $line -m comment --comment "block-list-serpro-d-forward" -j DROP" >> importa.sh ; done
    echo "regras de dst FORWARD foram criadas."
    
    echo "iniciando import das regras no firewall"

    # sleep 5 ; 
    # bash importa.sh ; 
    # sleep 0.5;
    # echo -n " [ OK ]";
    # sleep 5 ;
    echo "regras de INPUT, OUTPUT, src FORWARD e dst FORWARD foram carregadas no seu firewall."