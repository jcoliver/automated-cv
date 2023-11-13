#/bin/bash
# Create pdf of CV
# Jeff Oliver
# 2020-01-09

# Requires the following packages
# pandoc
# pandoc-citeproc
# texlive
# texlive-xelatex

# Make sure bib/publications.bib and apa-cv.csl exist (they are referenced by
# cv-2-publications.md)

# Indication of which files to use for start and end of CV
# possible values: csp, light, cues, imls, ul, long, sab
VERSION="sab"

# Only want full list of publications for some versions
if [[ "$VERSION" == "light" ]] || [[ "$VERSION" == "csp" ]] || [[ "$VERSION" == "ul" ]] || [[ "$VERSION" == "long" ]]  || [[ "$VERSION" == "sab" ]]
then
  # TEXTFILE="cv-2-publications.txt"
  # First create text version of publications
  # pandoc -f markdown cv-2-publications.md -o $TEXTFILE --filter=pandoc-citeproc
  
  # Prior implementation (above) no longer works (2021-04-20)
  # Workaround is to create temporary tex file and then convert to md
  TEXFILE="tmp-pubs.tex"
  TEXTFILE="tmp-pubs.md"
  pandoc -f markdown cv-2-publications.md -o $TEXFILE --csl=apa-cv.csl --bibliography=bib/publications.bib --filter=pandoc-citeproc
  pandoc $TEXFILE -o $TEXTFILE

  # Run sed in place to bold all occurrences of Oliver, J. C.
  sed -i 's/Oliver, J. C./\*\*Oliver, J. C.\*\*/g' $TEXTFILE

  # Also sed to get name added for BioTIME paper
  sed -i 's/others. (2018). BioTIME/\*\*Oliver, J. C.\*\* and 263 additional authors. (2018). BioTIME/g' $TEXTFILE

  # Change author ending of Miadlikowska et al. 2014 to match BioTIME format
  sed -i 's/others. (2014). Multigene/and 20 additional authors. (2014). Multigene/g' $TEXTFILE

  # Fix eButterfly capitalization
  sed -i 's/EButterfly/eButterfly/g' $TEXTFILE

  # Italicize and capitalize scientific names (dangerous if they
  # break over multiple lines)
  sed -i 's/bicyclus anynana/\*Bicyclus anynana\*/g' $TEXTFILE
  sed -i 's/lycaena xanthoides/\*Lycaena xanthoides\*/g' $TEXTFILE
  sed -i 's/cotesia theclae/\*Cotesia theclae\*/g' $TEXTFILE
  sed -i 's/rana aurora/\*Rana aurora\*/g' $TEXTFILE
  sed -i 's/draytonii/\*draytonii\*/g' $TEXTFILE

  # One known case of breaking over a line
  sed -i 's/ambystoma$/\*Ambystoma\*/g' $TEXTFILE
  sed -i 's/^californiense/\*californiense\*/g' $TEXTFILE

  # Italicize and capitalize bicyclus
  sed -i 's/bicyclus/\*Bicyclus\*/g' $TEXTFILE

  # Capitalizations
  sed -i 's/lepidoptera/Lepidoptera/g' $TEXTFILE
  sed -i 's/lecanoromycetes/Lecanoromycetes/g' $TEXTFILE
  sed -i 's/ascomycota/Ascomycota/g' $TEXTFILE
  sed -i 's/(godart)/(Godart)/g' $TEXTFILE
  sed -i 's/(riley)/(Riley)/g' $TEXTFILE
  sed -i 's/Ecological archives/Ecological Archives/g' $TEXTFILE
  sed -i 's/california/California/g' $TEXTFILE
  sed -i 's/arizona/Arizona/g' $TEXTFILE
  sed -i 's/batesian mimic/Batesian mimic/g' $TEXTFILE
  sed -i 's/american/American/g' $TEXTFILE
  sed -i 's/palmer/Palmer/g' $TEXTFILE
  sed -i 's/lehman/Lehman/g' $TEXTFILE

  # Stitch the sections together to create single file
  cat cv-1-start-$VERSION.md $TEXTFILE cv-3-end-$VERSION.md > cv-full.md

  # Remove temporary text file of publications
  rm $TEXTFILE
  rm $TEXFILE
else
  # cues & imls have abbreviated publications, following expertise section
  cat cv-1-start-$VERSION.md cv-2-middle-$VERSION.md cv-3-end-$VERSION.md > cv-full.md
fi

# Use pandoc to create pdf
pandoc -f markdown cv-full.md -o OliverJC-CV-$VERSION.pdf --pdf-engine=xelatex

# Remove temporary markdown CV
rm cv-full.md
