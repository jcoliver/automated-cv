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
# cv-5-publications.md)

# Indication of which files to use for start and end of CV
# possible values: csp, long, sab
VERSION="csp"

# Whether or not to include collaborators list
# possible values = "true", "false"
COLLABLIST="false"

# Start by creating variable that holds header information
if [[ "$VERSION" == "csp" ]]
then
  # CS&P has special yaml header which includes header information
  HEADERFILE="cv-0-yaml-csp.md"
else
  # Other versions do not have header
  HEADERFILE="cv-0-yaml.md"
fi

# Add the yaml header to the next few sections
NEWLINE="\n"
# the - in the cat command reads standard input as first argument
# TODO: would be nice to do this in one line...
echo -e $NEWLINE | cat $HEADERFILE cv-1-name.md - cv-2-education.md > cv-tmp-1.md
echo -e $NEWLINE | cat cv-tmp-1.md - cv-3-employment.md > cv-tmp-2.md
echo -e $NEWLINE | cat cv-tmp-2.md - cv-4-service.md > cv-tmp-3.md

rm cv-tmp-1.md
rm cv-tmp-2.md

# Only want full list of publications for some versions
if [[ "$VERSION" == "csp" ]] || [[ "$VERSION" == "long" ]] || [[ "$VERSION" == "sab" ]]
then
  # TEXTFILE="cv-2-publications.txt"
  # First create text version of publications
  # pandoc -f markdown cv-2-publications.md -o $TEXTFILE --filter=pandoc-citeproc
  
  # Prior implementation (above) no longer works (2021-04-20)
  # Workaround is to create temporary tex file and then convert to md
  TEXFILE="tmp-pubs.tex"
  TEXTFILE="tmp-pubs.md"
  pandoc -f markdown cv-5-publications.md -o $TEXFILE --csl=apa-cv.csl --bibliography=bib/publications.bib --filter=pandoc-citeproc
  pandoc $TEXFILE -o $TEXTFILE

  # Run sed in place to bold all occurrences of Oliver, J. C.
  sed -i 's/Oliver, J. C./\*\*Oliver, J. C.\*\*/g' $TEXTFILE
  # Multi-line breaks requires these hacks...
  # Assumes lines starting with J. C. or C. will *always* be part of citation
  # Tried whitespace matches, but sed doesn't recognize newline as whitespace
  sed -i 's/Oliver,$/\*\*Oliver,\*\*/g' $TEXTFILE
  sed -i 's/^J. C./\*\*J. C.\*\*/g' $TEXTFILE
  sed -i 's/Oliver, J.$/\*\*Oliver, J.\*\*/g' $TEXTFILE
  sed -i 's/^C./\*\*C.\*\*/g' $TEXTFILE

  # Also sed to get name added for BioTIME paper
  sed -i 's/others. (2018). BioTIME/\*\*Oliver, J. C.\*\* and 263 additional authors. (2018). BioTIME/g' $TEXTFILE

  # Change author ending of Miadlikowska et al. 2014 to match BioTIME format
  sed -i 's/others. (2014). Multigene/and 20 additional authors. (2014). Multigene/g' $TEXTFILE

  # Change future years to italicized "in press"
  sed -i 's/(2025)/(*in press*)/g' $TEXTFILE
  
  # Change parenthetical ds2f to upper case
  sed -i 's/(ds2f)/(DS2F)/g' $TEXTFILE
  
  # Fix eButterfly capitalization
  sed -i 's/EButterfly/eButterfly/g' $TEXTFILE

  # Italicize and capitalize scientific names (dangerous if they
  # break over multiple lines)
  sed -i 's/bicyclus anynana/\*Bicyclus anynana\*/g' $TEXTFILE
  sed -i 's/lycaena xanthoides/\*Lycaena xanthoides\*/g' $TEXTFILE
  sed -i 's/cotesia theclae/\*Cotesia theclae\*/g' $TEXTFILE
  sed -i 's/rana aurora/\*Rana aurora\*/g' $TEXTFILE
  sed -i 's/draytonii/\*draytonii\*/g' $TEXTFILE
  sed -i 's/ambystoma californiense/\*Ambystoma californiense\*/g' $TEXTFILE

  # Some cases of breaking over a line (but depends on margins)
  sed -i 's/ambystoma$/\*Ambystoma\*/g' $TEXTFILE
  sed -i 's/^californiense/\*californiense\*/g' $TEXTFILE
  sed -i 's/rana$/\*Rana\*/g' $TEXTFILE
  sed -i 's/^aurora/\*aurora\*/g' $TEXTFILE
 
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

  # Need to add asterisk to pubs done as graduate student. Only really 
  # necessary for CS&P; eight citations at this point in $TEXTFILE, relevant 
  # lines pasted below:
  # []{#ref-oliver2011evolution} **Oliver, J. C.**, & Stein, L. R. (2011).
  # []{#ref-oliver2008augist} **Oliver, J. C.** (2008). AUGIST: Inferring
  # []{#ref-oliver2007parasitism} **Oliver, J. C.**, Prudic, K. L., & Pauly, G.
  # []{#ref-oliver2007genetic} **Oliver, J. C.**, & Shapiro, A. M. (2007).
  # []{#ref-c2006population} **Oliver, J. C.** (2006). Population genetic
  # []{#ref-oliver2006boulder} **Oliver, J. C.**, Prudic, K. L., & Collinge, S.
  # []{#ref-prudic2005soil} Prudic, K. L., **Oliver, J. C.**, & Bowers, M. D.
  # []{#ref-collinge2003effects} Collinge, S. K., Prudic, K. L., & **Oliver,**
  #   **J. C.** (2003). Effects of local habitat characteristics and landscape

  if [[ "$VERSION" == "csp" ]]
  then
    sed -i 's/2011evolution} \*\*Oliver, J. C.\*\*/2011evolution} \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/2008augist} \*\*Oliver, J. C.\*\*/2008augist} \*\*Oliver, J. C.\*\*\\\* (2008). AUGIST/g' $TEXTFILE  
    sed -i 's/2007parasitism} \*\*Oliver, J. C.\*\*/2007parasitism} \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/2007genetic} \*\*Oliver, J. C.\*\*/2007genetic} \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/2006population} \*\*Oliver, J. C.\*\*/2006population} \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/2006boulder} \*\*Oliver, J. C.\*\*/2006boulder} \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/2005soil} Prudic, K. L., \*\*Oliver, J. C.\*\*/2005soil} Prudic, K. L., \*\*Oliver, J. C.\*\*\\\*/g' $TEXTFILE
    sed -i 's/\*\*J. C.\*\* (2003). Effects of local/\*\*J. C.\*\*\\\* (2003). Effects of local/g' $TEXTFILE
  fi

  # Write what we have so far to file
  echo -e $NEWLINE | cat cv-tmp-3.md - $TEXTFILE > cv-tmp-4.md

  # Remove temporary text file of publications
  rm $TEXTFILE
  rm $TEXFILE
else
  # cues & imls have abbreviated publications, following expertise section
  echo -e $NEWLINE | cat cv-tmp-3.md - cv-5-publications-ten.md > cv-tmp-4.md
fi

rm cv-tmp-3.md

# Add remaining sections
echo -e $NEWLINE | cat cv-tmp-4.md - cv-6-other-works.md > cv-tmp-5.md
echo -e $NEWLINE | cat cv-tmp-5.md - cv-7-presentations.md > cv-tmp-6.md

rm cv-tmp-4.md
rm cv-tmp-5.md

# CS&P version has collaborators (sometimes)
if [[ "$VERSION" == "csp" ]] || [[ "$VERSION" == "sab" ]]
then
  if [[ "$COLLABLIST" == "true" ]]
  then 
    echo -e $NEWLINE | cat cv-tmp-6.md - cv-8-collaborators.md > cv-tmp-7.md
    # Some funkyness here, where we overwrite temp file 6, to avoid writing an 
    # else statement to deal with versions that don't need collaborators/grants
    echo -e $NEWLINE | cat cv-tmp-7.md - cv-9-grants.md > cv-tmp-6.md
    rm cv-tmp-7.md
  fi  
fi

# Use pandoc to create pdf
pandoc -f markdown cv-tmp-6.md -o OliverJC-CV-$VERSION.pdf --pdf-engine=xelatex

# Remove temporary markdown CV
rm cv-tmp-6.md
