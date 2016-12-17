#!/bin/bash
mix phoenix.gen.html Cat cats name:string age:integer
sleep 2
mix phoenix.gen.html Rat rats name:string agender:string height:decimal
sleep 2
mix phoenix.gen.json API.Cat cats name:string age:integer --no-model
mix phoenix.gen.json API.Rat rats name:string agender:string height:decimal --no-model
