# KiCAD pcb2pdf
Export KiCAD PCB files to PDF

Exports all copper layers, one layer per page, with frame, top and bottom layers also include the corresponding silkscreen layer.

## Usage
1. Navigate to the directory containing your PCB file
2. Run `pcb2pdf.sh`

## Behaviour
Running the script will export every PCB in the current directory to PDF. The output filename is the filename of the PCB file (including extension) with `.pdf` appended. If the output file already exists, the script requests confirmation to overwrite it.