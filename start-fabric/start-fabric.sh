#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

starttime=$(date +%s)
CC_SRC_LANGUAGE=${1:-"go"}
CC_SRC_LANGUAGE=$(echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:])
if [ "$CC_SRC_LANGUAGE" = "go" -o "$CC_SRC_LANGUAGE" = "golang" ]; then
	CC_RUNTIME_LANGUAGE=golang
	CC_SRC_PATH=github.com/chaincode_example02/go
	# CC_SRC_PATH=/opt/gopath/src/github.com/chaincode_example02/go
elif [ "$CC_SRC_LANGUAGE" = "javascript" ]; then
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js
	CC_SRC_PATH=/opt/gopath/src/github.com/fabcar/javascript
elif [ "$CC_SRC_LANGUAGE" = "typescript" ]; then
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js
	CC_SRC_PATH=/opt/gopath/src/github.com/fabcar/typescript
	echo Compiling TypeScript code into JavaScript .../gopath/s/gopath/src/github.com/hyperledger/fabric/peerrc/github.com/hyperledger/fabric/peer
	pushd ../chaincode/fabcar/typescript
	npm install
	npm run build
	popd
	echo Finished compiling TypeScript code into JavaScript
else
	echo The chaincode language ${CC_SRC_LANGUAGE} is not supported by this script
	echo Supported chaincode languages are: go, javascript, and typescript
	exit 1
fi

# clean the keystore
rm -rf ./hfc-key-store

# launch network; create channel and join peer to channel
# เริ่มเครือข่าย สร้างชาแนล และ เข้าร่วมชาแนล
# cd ../basic-network
# ./start.sh
cd ../my_network
./start.sh

sleep 3

#########################
#     ติดตั้ง chaincode
#########################
echo "===========  Install CHAINCODE ============="
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org1MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer0.org1.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org1MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer1.org1.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE

docker exec \
	-e "CORE_PEER_LOCALMSPID=Org2MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer0.org2.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org2MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer1.org2.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE

docker exec \
	-e "CORE_PEER_LOCALMSPID=Org3MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer0.org3.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org3MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
	-e 'CORE_PEER_ADDRESS=peer1.org3.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt' \
	cli \
	peer chaincode install \
	-n mycc \
	-v 1.0 \
	-p $CC_SRC_PATH \
	-l $CC_RUNTIME_LANGUAGE

### exe peer0.ogr1 ###
# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer0.org1.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org1MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt' \
# 	peer0.org1.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang
# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer1.org1.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org1MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt' \
# 	peer1.org1.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang

# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer0.org2.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org2MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt' \
# 	peer0.org2.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang
# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer1.org2.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org2MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt' \
# 	peer1.org2.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang

# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org3.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer0.org3.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org3MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt' \
# 	peer0.org3.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang
# docker exec \
# 	-e 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org3.example.com/msp' \
# 	-e 'CORE_PEER_ADDRESS=peer1.org3.example.com:7051' \
# 	-e 'CORE_PEER_LOCALMSPID=Org3MSP' \
# 	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt' \
# 	peer1.org3.example.com \
# 	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode_example02/go \
# 	-l golang

### exec cli container ###
# docker exec \
# 	-e "CORE_PEER_LOCALMSPID=Org2MSP" \
# 	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" \
# 	cli peer chaincode install -n mycc -v 1.0 \
# 	-p $CC_SRC_PATH \
# 	-l $CC_RUNTIME_LANGUAGE

# docker exec -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" cli peer chaincode install -n mycc -v 1.0 -p $CC_SRC_PATH -l $CC_RUNTIME_LANGUAGE


#########################
# instantiate chaincode
#########################
echo "========= Instantiate chaincode ========="
echo "## mychanel-1 ##"
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org1MSP" \
	-e 'CORE_PEER_ADDRESS=peer0.org1.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt' \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
	cli \
	peer chaincode instantiate \
	-o orderer.example.com:7050 \
	-C mychannel-1 -n mycc -l golang -v 1.0 \
	-c '{"Args":["Init", "c", "99", "d", "299"]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
	# -c '{"Args":["Init", "c", "500", "d", "100"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"

echo "## mychannel-2 ##"
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org3MSP" \
	-e 'CORE_PEER_ADDRESS=peer0.org3.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt' \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
	cli \
	peer chaincode instantiate \
	-o orderer.example.com:7050 \
	-C mychannel-2 -n mycc -l golang -v 1.0 \
	-c '{"Args":["Init", "c", "399", "d", "499"]}' -P "OR ('Org2MSP.member','Org3MSP.member')"
	# -c '{"Args":["Init", "c", "500", "d", "100"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')"

sleep 3

##########
# invoke
##########
echo "============== Invoke ============="
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org1MSP" \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
	cli peer chaincode invoke \
	-o orderer.example.com:7050 \
	-C mychannel-1 -n mycc -c '{"Args":["query", "d"]}' \
	--peerAddresses peer0.org1.example.com:7051 \

echo "=============== Query mychannel-1 ============="
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org1MSP" \
	-e 'CORE_PEER_ADDRESS=peer0.org1.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt' \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" \
	cli peer chaincode query \
	-C mychannel-1 \
	-n mycc \
	-c '{"Args":["query", "c"]}'

echo "=============== Query mychannel-2 ============="
docker exec \
	-e "CORE_PEER_LOCALMSPID=Org3MSP" \
	-e 'CORE_PEER_ADDRESS=peer0.org3.example.com:7051' \
	-e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt' \
	-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" \
	cli peer chaincode query \
	-C mychannel-2 \
	-n mycc \
	-c '{"Args":["query", "d"]}'
