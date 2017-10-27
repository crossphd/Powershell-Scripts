<# 
Christopher Ross
cross25@uis.edu
CSC386 HW04
10/13/2017

PowerShell Homework 04
This script repeats the project for the Batch file in order to show parameter passing
and control flow of PowerShell scripts. It also allows for a comparison of language
features in Windows scripting.

Pseudocode
    Define parameter names

    If <directory parameter> does not specify a directory
        display an error message
        exit the script
    If the sub-directory <directory parameter>\bob does not exist
        create the sub-directory

    For each <file> in the directory <directory parameter>
        If <file> is an image of type <extension parameter>
            magick <file> -resize 640x <directory parameter>\web-img\_<file>
#>

Param (
    [string] $filePath,
    [string] $fileExt = 'jpg'
)

if (!(Test-Path $filePath -PathType Container)){
    Write-Host "ERROR The specified file path doesn't exist" -ForegroundColor Red
    Break
}  

# create variable for web-img path
$imageDir = "$filePath\web-img"

# EXTRA CREDIT: check if web-img folder exists and
# create it if it doesn't exist
if (!(Test-Path $imageDir -PathType Container)){
    New-Item -ItemType directory -Path $imageDir
}

# resize every file with specified extension and place in web-img folder
foreach ($img in (get-childitem $filePath\*.$fileExt)) {
    $currentImg = (Split-Path -Path $img -Leaf)
    Write-Host "Working on $currentImg"
    convert $img -resize 640x “$imageDir\$currentImg”
} 





