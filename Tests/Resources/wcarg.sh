#!/bin/sh

#  wcarg.sh
#  Morione
#
#  Created by Marco Conti on 02/06/16.
#  Copyright © 2016 com.marco83. All rights reserved.

ADDRESS_VALUES=`printf "$@" | od -t d1 | head -n1`
echo "${ADDRESS_VALUES[@]:11}"