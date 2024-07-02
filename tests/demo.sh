#!/bin/bash

read -p "A linha a apagar " linha

sed -i "${linha}d" test.txt
