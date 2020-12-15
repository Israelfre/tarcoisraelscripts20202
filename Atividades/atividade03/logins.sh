#!/bin/bash

grep -v 'sshd'

grep -E 'sshd[[[:digit:]]*]:[[:space:]]*Accepted'

grep -E 'sshd.*root'  

grep -E 'Dec[[:space:]]*4.*Accepted' 

