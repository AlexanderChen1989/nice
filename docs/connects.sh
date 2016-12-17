#!/bin/bash



mix gen.connect CatToRat cat_to_rats cat_id:integer rat_id:integer
sleep 2
mix phoenix.gen.json API.CatToRat cat_to_rats cat_id:integer rat_id:integer --no-model
