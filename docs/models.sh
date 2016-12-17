#!/bin/bash


mix phoenix.gen.html User users name:string age:integer
mix phoenix.gen.json API.User users name:string age:integer --no-model
mix phoenix.gen.html Profile profiles agender:string height:decimal
mix phoenix.gen.json API.Profile profiles agender:string height:decimal --no-model
mix gen.connect UserToProfile user_to_profiles user_id:integer profile_id:integer



