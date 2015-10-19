#!/bin/bash

# Scriptet kommer att gå till mappen "sektionsmote_##". Om du har tex 15
# mappar, så hittar scriptet den mapp med högst nummer. I den mappen
# så kommer scriptet att kompilera mote.tex och generera tre PDF:er,
# agenda.pdf, dagordning.pdf och kallelse.pdf.
#
# Om du vill se outputten från xelatex (användbart framförallt om du
# får kompileringsfel), så kör ./makescript -l

if [ "$1" == "--help" ]; then
    echo "makescript 1.0, by Johan Sjöblom. The code is public domain."
    echo "Usage:"
    echo "./makescript          Finds the last sektionsmote-folder and compiles there"
    echo "./makescript -l       Compiles loudly, eg prints the output from xelatex"
    exit 0
fi

ARRAY=('agenda' 'dagordning' 'kallelse')
FILENAME="mote.tex"
STANDARDDIR="./sektionsmote_"

# pdflatex will produce some auxilary temp files. Remove them, if
# they are created:
EXTARRAY=('aux' 'log' 'toc' 'nav' 'out' 'snm' 'dvi')


DIRECTORY=""
for (( i=0;i<256;i++)); do
    dir="$STANDARDDIR"
    if [ $i -lt 10 ]; then
        dir+="0"
    fi
    dir+="$i"
    if [ -d $dir ]; then
        DIRECTORY="$dir"
    else
        # The first directory doesn't have to be called 00,
        # it's ok if the first directory is 01:
        if [ $i -eq 0 ]; then
            continue
        fi
        i=256
    fi
done

if [ "$DIRECTORY" == "" ]; then
    while true; do
        echo "Could not find directory to work in. Please enter the directory:"
        read dir
        if [ -d $dir ]; then
            DIRECTORY="$dir"
            break
        fi
    done
fi
CMD="cd $DIRECTORY"
eval $CMD


# Check to make sure that the filename exists in that dir:
if [ ! -e $FILENAME ]; then
    while true; do
        echo "Could not find input *.tex-file. Please enter the filename:"
        read file
        if [ -e $file ]; then
            FILENAME="$file"
            break
        fi
    done
fi

for (( i=0;i<${#ARRAY[@]};i++)); do
    COUNT=0
    MD5=0
    SUCCESS=0

    echo -n "Compiling ${ARRAY[${i}]} "
    while [ $COUNT -lt 10 ] && [ $SUCCESS -eq 0 ]; do
        echo -n "."

        # For dagordning, the command we run is:
        # pdflatex -jobname dagordning '\providecommand{\dagordning}{true}\input{mote.tex}'
        CMD="xelatex -jobname ${ARRAY[${i}]} '\providecommand{\\${ARRAY[${i}]}}{true}\input{$FILENAME}'"

        # If argument to script is -l, then we run the script loudly,
        # eg, print out the output from pdflatex. Otherwise, we supress
        # the output
        if [ "$1" == "-l" ]; then
            eval $CMD
        else
            TMP=`eval $CMD`
        fi

        # Since it is rather arbitrary how many times we need to typeset
        # document to make it correct we run xelatex until two identical
        # md5sums are generated
        TMP=$(md5sum ${ARRAY[${i}]}.pdf)
        
        let COUNT=COUNT+1
        if [ "$MD5" == "$TMP" ]; then
            SUCCESS=1
            echo " done!"
        else
            MD5="$TMP"
        fi

    done
    if [ $SUCCESS -eq 0 ]; then
        echo " - Error! Could not consistently compile ${ARRAY[${i}]}"
    fi


    # Remove the auxilary temp files, if they exist:
    for (( j=0;j<${#EXTARRAY[@]};j++)); do
        RMFILE="${ARRAY[${i}]}.${EXTARRAY[${j}]}"
        rm -f $RMFILE 2>&1 >/dev/null
    done
done

# Remove texput.log, if it was created:
RMFILE="texput.log"
rm -f $RMFILE 2>&1 >/dev/null
