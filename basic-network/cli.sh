#!/bin/bash

########################
#   switch to p0.org1  #
########################
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
CORE_PEER_ADDRESS=peer0.org1.example.com:7051
CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

########################
#   สร้าง channel name   #
########################
export CHANNEL_NAME=mychannel

##################
# Create channel #
##################
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

###### Join ######
peer channel join -b mychannel.block



# My script
# sudo docker exec cli bash -c \
# 'CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp
# CORE_PEER_ADDRESS=peer0.org1.example.com:7051
# CORE_PEER_LOCALMSPID="Org1MSP"
# CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

# export CHANNEL_NAME=mychannel

# peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./config/channel.tx

# peer channel join -b mychannel.block

# CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp
# CORE_PEER_ADDRESS=peer1.org1.example.com:8051
# CORE_PEER_LOCALMSPID="Org1MSP"
# CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
# peer channel join -b mychannel.block'
