package main

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type User struct {
	StdID  string `json:"stdID"`
	Name   string `json:"name"`
	Tel    string `json:"tel"`
	Status bool   `json:"status"`
}
type Wallet struct {
	WalletName string  `json:"walletName"`
	Money      float64 `json:"money"`
	Owner      string  `json:"owner"`
}

type Chaincode struct {
}

func (C *Chaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success([]byte("Init Success"))
}

func (C *Chaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	fn, args := stub.GetFunctionAndParameters()

	if fn == "query1" {
		return C.query(stub, args)
	} else if fn == "createUser" {
		return C.createUser(stub, args)
	} else if fn == "createWallet" {
		return C.createWallet(stub, args)
	}

	fmt.Println("invoke did not find func: " + fn)
	return shim.Error("Received unknown function invocation")
}

func (C *Chaincode) query(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	var key string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	// เอา key ออกมา
	key = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(key)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + key + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + key + "\"}"
		return shim.Error(jsonResp)
	}

	jsonResp := "{\"Name\":\"" + key + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success(Avalbytes)
}

func (C *Chaincode) createUser(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// Check arguments
	if len(args) != 4 {
		return shim.Error("Incorrect arguments, Want 4 input.")
	}

	// Check if User already exists
	ck, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	} else if ck != nil {
		fmt.Println("This user already exists :" + args[0])
		return shim.Error("This user already exists")
	}

	id := args[0]
	name := args[1]
	tel := args[2]
	status, err := strconv.ParseBool(args[3])
	if err != nil {
		shim.Error("Arguments 4 must be 'boolean'" + err.Error())
	}

	user := &User{id, name, tel, status}
	jsonForm, err := json.Marshal(user)
	if err != nil {
		shim.Error(err.Error())
	}

	return shim.Success([]byte(jsonForm))
}

func (C *Chaincode) createWallet(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	return shim.Success(nil)
}

func main() {
	err := shim.Start(new(Chaincode))
	if err != nil {
		fmt.Printf("Error start chaincode: %s", err)
	}
}
