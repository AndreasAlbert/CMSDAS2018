# Setup
scram p CMSSW_9_3_6
cd CMSSW_9_3_6;
cmsenv;
cd -;


# TASK 1: USE CMSDRIVER TO SHOWER PRE-EXISTING LHE
# GOALS:
# 1) Students understand how to use config fragments and cmsDriver
# 2) Students understand need for parton showering and its implications: Much larger number of particles in each event, much larger event size, pt(W) now non-zero
#

# Copy the config fragment for showering
CONFIG_PATH=${CMSSW_BASE}/src/CMSDAS/GEN/python
mkdir -p ${CONFIG_PATH}
cp Hadronizer_TuneCP5_13TeV_generic_LHE_pythia8_cff.py ${CONFIG_PATH}
cd ${CMSSW_BASE}/src;
scram b;
cd -;

cmsDriver Configuration/GenProduction/python/Hadronizer_TuneCP5_13TeV_generic_LHE_pythia8_cff.py --mc --eventcontent RAWSIM,LHE --datatier GEN,LHE --conditions 93X_upgrade2023_realistic_v5 --beamspot HLLHC14TeV --step GEN --geometry Extended2023D17 --era Phase2_timing --filein file:unweighted_events.lhe --fileout file:GEN.root -n 1000


# Copy the config fragment for plotting
cp WjetsAnalysis_cfi.py ${CONFIG_PATH}
cd ${CMSSW_BASE}/src;
scram b;
cd -;

# Run plot script and examine output
cmsRun WjetsComparisons_cfg.py
rootbrowse analyzed.root

# Physics questions about parton shower effect go here



# TASK 2: JET MULTIPLICITY MERGING
# We provide a pre-created gridpack for W+0/1/2 jets
# Students run LHE,GEN steps with cmsDriver.py

PATH_TO_GRIDPACK="/afs/cern.ch/work/a/aalbert/public/2018-07-30_CMSDAS/wplustest_4f_012jet_LO_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz"

mkdir unpack
cd unpack
tar xf ${PATH_TO_GRIDPACK}
ls -l gridpack_generation.log InputCards

# Examine gridpack and compare to previous case
#   How are the cards different?
#   How many subprocesses does the process have? How does the computing time to create the gridpack change?
#   What cross-section is reported my MG? Is it consistent?



# Now, we run LHE and GEN steps straight from gridpack
# Previously, we ran LHE manually from the gridpack, but CMSSW can do that for us

cp Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_qCut20_LHE_pythia8_cff.py ${CONFIG_PATH}
# edit the hadronizer accordingly!
cd ${CMSSW_BASE}/src
scram b;
cd -

cmsDriver Configuration/GenProduction/python/Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_qCut20_LHE_pythia8_cff.py .........

# Check the output of the GenXSecAnalyzer:
#   What is the value matching efficiency? What does it mean?
#   How does the cross-section change due to matching? How does the post-matching cross-section compare to the 0-jet component from before?
#     

# Copy the config file and edit it to run with another value of qCut
cp ${CONFIG_PATH}/Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_qCut20_LHE_pythia8_cff.py ${CONFIG_PATH}/Hadronizer_TuneCP5_13TeV_MLM_5f_max2j_qCut40_LHE_pythia8_cff.py


