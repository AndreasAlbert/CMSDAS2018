# Set up CMSSW environment
source /cvmfs/cms.cern.ch/cmsset_default.sh
scram p CMSSW_7_1_30
cd CMSSW_7_1_30/src
cmsenv
cd -

# Get cards repository
git clone git@github.com:AndreasAlbert/genproductions.git -b CMSDAS2018_26x

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

# Open the interpreter, say no to updates
./bin/mg5
n

# Copy proc_card line-by-line, look at console output
# Start the production, navigate questions, make sure to use centrally provided run_card
!cat ../genproductions/bin/MadGraph5_aMCatNLO/cards/examples/wplustest_4f_LO/wplustest_4f_LO_proc_card.dat
launch
ENTER
/path/to/run_card.dat

# Check cross-section number, have a look at output LHE, try to understand LHE format


# TASK 2: USE CARDS TO GENERATE GRIDPACK, CREATE LHE FROM GRIDPACK
# GOALS:
# 1) Familiarize with genproductions setup: One-click solution (if everything goes well) to standardize MG running
# 2) Familiarize with gridpack concept: Autonomous exectuable package to be run anywhere, anytime
# 3) Learn to produce events from gridpack manually, confirm that LHE output is as expected.
#
# PDF weights: The gridpack setup creates a large number of PDF weights.
# Two ways to go here:
# a) Allow this to happen, explain to students what the point is, let them look at the file size to see the effect / event
# b) Patch genproductions branch to it does not happen, which saves a bunch of time (PDF weights take ~ 5 minutes on my machine for 10k events)
#
cd genproductions/bin/Madgraph5_aMCatNLO
time ./gridpack_generation.sh wplustest_4f_LO cards/examples/wplustest_4f_LO local

mkdir work
cd work
tar xf ../*.xz
./runcmsgrid.sh 10000 1234 1

# Inspect output LHE file

# TASK3: MAKE COMPARISON PLOT
# GOALS:
# 1) Introduce MadAnalysis as a simple tool to make LHE-level plots
# 2) Demonstrate that standalone and genproductions give identical results
# 3) Physics understanding: PT(W) always 0, no l- in sample, M(W) shape
#
# Variable degree of difficuly: Could also provide link to madanalysis tutorial slides and let them figure out how to plot e.g. the mass

cd MG5_aMC_v2_6_0
./bin/mg5
install MadAnalysis5

./HEPTools/madanalysis5/madanalysis5/bin/ma5
import wplustest_4f_LO/Events/run_01/unweighted_events.lhe as STANDALONE
import ../genproductions/bin/MadGraph5_aMCatNLO/work/cmsgrid_final.lhe as GRIDPACK

set STANDALONE.xsection = 1
set GRIDPACK.xsection = 1

plot PT(mu+) 20 0 100
plot PT(mu-) 20 0 100
plot PT(l+) 20 0 100
plot PT(mu+ vm) 20 0 100
plot M(mu+ vm) 40 40 120
plot M(e+ ve) 40 40 120
plot M(ta+ vt) 40 40 120
plot M(l+ vl) 40 40 120



set main.stacking_method = superimpose
submit

firefox ANALYSIS_0/HTML/index.html


# Example output at https://aalbert.web.cern.ch/aalbert/CMSDAS2018/ex1/















