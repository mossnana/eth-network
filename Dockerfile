FROM ethereum/client-go:v1.10.1

ARG ACCOUNT_PASSWORD

COPY genesis.json .

COPY ./data/keystore /root/.ethereum/keystore

RUN geth init ./genesis.json \
    && rm -f ~/.ethereum/geth/nodekey \
    && echo ${ACCOUNT_PASSWORD} > ./password.txt \
    && geth account new --password ./password.txt \
    && rm -f ./password.txt

ENTRYPOINT ["geth"]
