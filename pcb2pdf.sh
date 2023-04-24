#!/bin/bash

# kicad-cli pcb export pdf -o test.pdf -l "F.SilkS,F.Cu,In1.Cu,Edge.Cuts" *.kicad_pcb

tmp_dir=$(mktemp -d -t pcb2pdf-XXXXXXXXXX)

if [[ -e ./_autosave*.kicad_pcb ]]
then
    echo "Unsaved changes detected, try again after saving"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

for pcb_file in ./*.kicad_pcb
do
    echo "Processing $pcb_file"
    output_file=$pcb_file".pdf"
    if [ -e $output_file ]
    then
        read -p "$output_file already exists, overwrite? [yn] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
            [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
        fi
    fi

    layer_count=`grep -E '\([0-9]+ ".*.Cu"' $pcb_file | wc -l`

    case $layer_count in
        2)
            kicad-cli pcb export pdf --ibt -o $tmp_dir/01.pdf -l "F.SilkS,F.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/02.pdf -l "B.SilkS,B.Cu,Edge.Cuts" $pcb_file
            ;;
        4)
            kicad-cli pcb export pdf --ibt -o $tmp_dir/01.pdf -l "F.SilkS,F.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/02.pdf -l "In1.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/03.pdf -l "In2.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/04.pdf -l "B.SilkS,B.Cu,Edge.Cuts" $pcb_file
            ;;
        6)
            kicad-cli pcb export pdf --ibt -o $tmp_dir/01.pdf -l "F.SilkS,F.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/02.pdf -l "In1.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/03.pdf -l "In2.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/04.pdf -l "In3.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/05.pdf -l "In4.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/06.pdf -l "B.SilkS,B.Cu,Edge.Cuts" $pcb_file
            ;;
        8)
            kicad-cli pcb export pdf --ibt -o $tmp_dir/01.pdf -l "F.SilkS,F.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/02.pdf -l "In1.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/03.pdf -l "In2.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/04.pdf -l "In3.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/05.pdf -l "In4.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/06.pdf -l "In5.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/07.pdf -l "In6.Cu,Edge.Cuts" $pcb_file
            kicad-cli pcb export pdf --ibt -o $tmp_dir/08.pdf -l "B.SilkS,B.Cu,Edge.Cuts" $pcb_file
            ;;
        *)
            echo "Unsupported layer count $layer_count in file $pcb_file"
            continue
    esac

    pdfunite `ls $tmp_dir/*.pdf` $output_file 2>/dev/null

done

rm -rf $tmp_dir