#!/bin/bash


mix phoenix.gen.html Cat cats name:string age:integer
mix phoenix.gen.json API.Cat cats name:string age:integer --no-model
mix phoenix.gen.html Rate rates agender:string height:decimal
mix phoenix.gen.json API.Rate rates agender:string height:decimal --no-model
mix gen.connect CatToRate cat_to_rates cat_id:integer rate_id:integer
