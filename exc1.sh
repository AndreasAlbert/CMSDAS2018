# Set up CMSSW environment
source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW_7_1_30
cd CMSSW_7_1_30/src
cmsenv
cd -

# Get cards repository
git clone git@github.com:AndreasAlbert/genproductions.git -b CMSDAS2018

# TASK 1: USE CARDS TO GENERATE EVENTS WITH STANDALONE MG
# GOALS:
# 1) Students get a basic understanding of what proc_card and run_card do
# 2) Students get a feeling for how to use Madgraph as a standalone tool.  Most of all, they should see that there is no magic involved, MG interface is easy to use.
#    While navigating the menu structure, they should notice that many interface options are provided, such as a native pythia interface
# 3) Students learn to read the MG output, and get a basic understanding of what an LHE file is

# Look at the cards for W+ production
ls genproductions/bin/MadGraph5_aMCatNLO/cards/examples/wplustest_4f_LO/
# wplustest_4f_LO_proc_card.dat
# wplustest_4f_LO_run_card.dat

# Here, can explain proc_card syntax, possibly describe run_card


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

# TASK3: MAKE COMPARISON PLOT
# GOALS:
# 1) Introduce MadAnalysis as a simple tool to make LHE-level plots
# 2) Demonstrate that standalone and genproductions give identical results
# 3) Physics understanding: PT(W) always 0, no l- in sample, M(W) shape

cd MG5_aMC_v2_6_0
./bin/mg5
install MadAnalysis5

./HEPTools/madanalysis5/madanalysis5/bin/ma5
import /path/to/first/lhe
import /path/to/second/lhe
plot PT(mu+)
plot PT(mu-)
plot PT(W)
plot M(mu+ vnu)
submit

firefox ANALYSIS_0/HTML/index.html















