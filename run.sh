# run.sh - This is script is the first invoked when I build the output site
# Copyright (C) 2024  Sophia Elizabeth Shapira
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

ACTIVFROM=`pwd`
export ACTIVFROM

cd "$(dirname "${0}")" || exit

LTG_LANG_PROC=liturgscr
export LTG_LANG_PROC


mkdir -p lcinf
perl scrip/special/primar.pl

cp out/primaria.css .
rm -rf out
mkdir out
cp primaria.css out/.


X_OUTPUT="$(pwd)/out"
X_SCRIP="$(pwd)/scrip"
X_RES_BASE="$(pwd)"
export X_OUTPUT
export X_SCRIP
export X_RES_BASE

X_DESTIN_DIR="$( cd out && pwd )"
export X_DESTIN_DIR

X_MODE_TYPE=stable
export X_MODE_TYPE

X_X_LANG_MAIN_TX="$(liturgscr-lookup "${X_RES_BASE}/lcconf/resources.cnf" main-tx-res)"
export X_X_LANG_MAIN_TX

X_X_LANG_CODE="$(liturgscr-lookup "${X_X_LANG_MAIN_TX}/info.cnf" lang-code)"
export X_X_LANG_CODE

#echo ": ${X_X_LANG_MAIN_TX} : 4 :" sleep 2
#echo ": ${X_X_LANG_MAIN_TX} : 3 :" sleep 2
#echo ": ${X_X_LANG_MAIN_TX} : 2 :" sleep 2
#echo ": ${X_X_LANG_MAIN_TX} : 1 :" sleep 2

"${LTG_LANG_PROC}"-gener  -scf "${X_SCRIP}/main-dx.skd" > out/index.html


