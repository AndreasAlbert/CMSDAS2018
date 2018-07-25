# Set up CMSSW environment
source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW_7_1_30
cd CMSSW_7_1_30/src
cmsenv
cd -

# Get cards repository
git clone git@github.com:AndreasAlbert/genproductions.git -b CMSDAS2018

# Look at the cards for W+ production
ls genproductions/bin/MadGraph5_aMCatNLO/cards/examples/wplustest_4f_LO/
# wplustest_4f_LO_proc_card.dat
# wplustest_4f_LO_run_card.dat

# Here, can explain proc_card syntax, possibly describe run_card


# TASK 1: USE CARDS TO GENERATE EVENTS WITH STANDALONE MG

# Download standalone Madgraph
wget https://cms-project-generators.web.cern.ch/cms-project-generators/MG5_aMC_v2.6.0.tar.gz
tar xf MG5_aMC_v2.6.0.tar.gz
rm MG5_aMC_v2.6.0.tar.gz
cd MG5_aMC_v2_6_0

# Open the interpreter
./bin/mg5

# Copy proc_card line-by-line, look at console output
# Start the production, navigate questions, make sure to use centrally provided run_card
launch
ENTER
/path/to/run_card.dat

# Check cross-section number, have a look at output LHE, try to understand LHE format


# TASK 2: USE CARDS TO GENERATE GRIDPACK, CREATE LHE FROM GRIDPACK
cd genproductions/bin/Madgraph5_aMCatNLO
time ./gridpack_generation.sh wplustest_4f_LO cards/examples/wplustest_4f_LO local

mkdir work
cd work
tar xf ../*.xz
./runcmsgrid.sh 10000 1 1234















