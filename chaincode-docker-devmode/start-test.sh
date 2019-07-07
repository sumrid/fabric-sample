# Start network
docker-compose -f docker-compose-simple.yaml down
docker-compose -f docker-compose-simple.yaml up -d
docker ps

# Build & start the chaincode
docker exec -d chaincode bash -c "cd sacc && go build
CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=mycc:0 ./sacc"
sleep 10

# Install chaincode
docker exec cli peer chaincode install -p chaincodedev/chaincode/sacc -n mycc -v 0
sleep 2
docker exec cli peer chaincode instantiate -n mycc -v 0 -c '{"Args":["a","10"]}' -C myc
sleep 2

# Invoke and query
docker exec cli peer chaincode invoke -n mycc -c '{"Args":["set", "a", "20"]}' -C myc
sleep 2
docker exec cli peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C myc
