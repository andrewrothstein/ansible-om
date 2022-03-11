#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/pivotal-cf/om/releases/download
APP=om

dl()
{
    local ver=$1
    local lchecksums=$2
    local os=$3
    local dot_exe=${4:-}
    local platform="${os}"
    local file=${APP}-${platform}-${ver}${dot_exe}
    local url=$MIRROR/$ver/$file

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $os `egrep -e "$file\$" $lchecksums | awk '{print $1}'`
}

dl_ver() {
    local ver=$1
    local lchecksums=$DIR/${APP}_${ver}_checksums.txt
    local rchecksums=$MIRROR/$ver/checksums.txt
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $rchecksums
    fi
    printf "  # %s\n" $rchecksums
    printf "  '%s':\n" $ver


    dl $ver $lchecksums darwin
    dl $ver $lchecksums linux
    dl $ver $lchecksums windows .exe
}

dl_ver ${1:-7.6.0}
