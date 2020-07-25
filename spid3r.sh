#!/bin/bash --init-file

PS1="\[\e[4m\]spid3r\[\e[0m\] > "

banner () {
    echo -e '
 000000   0000000   000  0000000   000000   0000000
0000000   00000000  000  00000000  0000000  00000000
100       001  000  001  001  000      000  001  000
101       101  010  101  101  010      010  101  010
110011    0100101   110  010  101  010110   0101101
 110111   110111    111  101  111  110101   110101
     1:1  11:       11:  11:  111      11:  11: :11
    1:1   :1:       :1:  :1:  1:1      :1:  :1:  1:1
:::: ::    ::        ::   :::: ::  :: ::::  ::   :::
:: : :     :        :    :: :  :    : : :    :   : :

Author: Perdyx
License: MIT
Version: 2.1.0'
}

target="tesla.com"

options () {
    options="
    Name;Current Setting;Required;Description
    ----;---------------;--------;-----------
    target;$target;yes;Target to enumerate
    "

    options=$(echo "$options" | sed 's/\;\;/\; \;/g')

    echo -e "\nOptions:\n"
    column -t -s ";" <<< "$options"
    echo
}

? () {
    help="
    Command;Description
    -------;-----------
    exit;Quit
    options;Show available options and their current settings (to set an option, use OPTION=\"VALUE\")
    run;Run using using the specified options
    ?;Help
    "

    echo -e "\nCommands:\n"
    column -t -s ";" <<< $help
    echo
}

init () {
    if [ $EUID -ne 0 ]; then
        echo -e "[\e[31m-\e[39m] Error: Root access required."
        exit 1
    fi

    missing_deps=()
    if ! amass --version >/dev/null 2>&1; then
        missing_deps+="Amass"
    fi
    if ! nmap --version >/dev/null 2>&1; then
        missing_deps+="Nmap"
    fi
    if ! tree --version >/dev/null 2>&1; then
        missing_deps+="tree"
    fi
    if [ ${#missing_deps[@]} -ne 0 ]; then
        missing_deps=$(printf -- " %s" ${missing_deps[*]})
        echo -e "[\e[31m-\e[39m] Error: Missing dependencies $missing_deps"
        exit 1
    fi

    banner
    options
    echo -e "Type ? for help.\n"
}

run () {
    data="spid3r"
    if [ -d $data ]; then
        rm -rf $data
    fi
    mkdir $data

    if [ -z $target ]; then
        echo -e "[\e[31m-\e[39m] Error: Target cannot be null\n"
        return
    fi

    if [ -f $data/$target/amass.txt ]; then
        rm -f $data/$target/amass.txt
    fi

    if [ -d $data/$target ]; then
        rm -rf $data/$target
    else
        mkdir $data/$target
    fi

    echo -e "[\e[34m>\e[39m] Exec: amass enum -d \e[34m$target\e[39m -o $data/$target/amass.txt"
    amass enum -d $target -o $data/$target/subdomains.txt 2>&1 | tee $data/$target/amass.txt

    while read subdomain; do
        if [ -d $data/$target/$subdomain ]; then
            rm -rf $data/$target/$subdomain
        else
            mkdir $data/$target/$subdomain
        fi

        echo -e "[\e[34m>\e[39m] Exec: nmap -A -T4 -p- -Pn \e[34m$subdomain\e[39m"
        nmap -A -T4 -p- -Pn $subdomain 2>&1 | tee $data/$target/$subdomain/nmap.txt

        cat $data/$target/$subdomain/nmap.txt
    done < $data/$target/subdomains.txt

    echo -e "[\e[32m+\e[39m] Results saved in \e[32m$data\e[39m"
    tree $data
}

init