# README for "Multi-Phase Sit-to-Stand Transition Dynamics Represented with a Koopman Operator Incorporating Segmented Local Dynamics in a Globally Linear Model"

## System Requirements
Requires MATLAB to run, with the following toolboxes installed:
* Control System Toolbox
* Curve Fitting Toolbox
* Optimization Toolbox
* Statistics and Machine Learning Toolbox

Tested on MATLAB R2023a running on Windows 11, though it likely works on some earlier versions of MATLAB as well.

No non-standard hardware required to run.

## Installation Guide
Assuming MATLAB and the required toolboxes are installed, open the folder directly containing this README file as MATLAB's "Current Folder".  No installation is required.

## Data Set
A selected portion of sit-to-stand (STS) data from ["Perturbative Sit-to-Stand Experiment Dataset and Stability Basin Code"](https://doi.org/10.7302/mhjr-k798), by Patrick Holmes, is included here under the `holmes_2019_STS_trajectories` folder, in the same form as it was additionally published.  This STS data is licensed under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.

## Demo / Instructions for Use
The demo can be run in two parts:
1. Generating models, simulation data, and analyses from human data and first principles
2. Generating figures and videos from models, simulation data and analyses

Either part can be run independently as-is, since the output from Part 1 is saved in the folder `results_for_figures`, and the code in Part 2 loads data from this same folder.  Since the Part 1 code is a key implementation of the contributions, it is completely described using pseudocode in the Supplemental Materials, SM-4.

### Part 1: Analytical Work
There exist four different scripts in the root folder that, if run in MATLAB, will run the entirety of the analysis code.  Each of these can be run from the MATLAB terminal, or by opening the file in MATLAB and clicking "Run".
* `run_autonomous_system.m`
    * Autonomous system modeling with an SMP-Koopman autonomous model, constructed with $M=4$ membership functions with shape factor $\epsilon=1.8$, trained from the human STS dataset.  Also calculates the local affine systems from this at three states of interest.
    * Takes roughly 5 seconds to run.
* `run_autonomous_system_hyperparameter_study.m` *Takes roughly 5 seconds to run*
    * Iterates the autonomous modeling process through different values of $M$ and $\epsilon$, evaluating leave-one-out cross validation (LOOCV) prediction error over the human dataset as a performance metric.
    * Takes roughly 24 hours to run, though this time can be severely reduced by reducing the number of $(M,\epsilon)$ combinations tested.  24 hours corresponds to 1200 hyperparameter combinations.
* `run_feedback_analysis.m`
    * Generates the open-loop SMP-Koopman model for the human body, modeled as a triple-inverted pendulum with seat contact, and with a simplified actuator model for input.  Then optimizes an LQR model to close the loop of this model, simulating STS.
    * Takes roughly 5 hours to run.  This can be reduced by reducing the number of times the LQR hyperparameter optimization algorithm cycles through the LQR hyperparameters (currently 6 times).
* `run_terminal_convergence_analysis.m`
    * Runs a direct analysis of the human STS dataset to determine the convergence rate of the terminal portion of each trajectory.
    * Takes roughly 9 seconds to run.

### Part 2: Generating Figures and Videos
The remaining two scripts in the root folder generate figures and video frames, respectively, if run in MATLAB.  As the bulk of this runtime is drawing graphics, the runtime of these scripts is likely to be heavily dependent on the graphics processing capabilities of your computer's CPU (as these operations are not optimized for GPU usage).  Each of these can be run from the MATLAB terminal, or by opening the file in MATLAB and clicking "Run".
* `run_figure_scripts_from_stored_data.m`
    * Draws the raw forms of all figures, based on the stored outputs from Part 1 in the `results_for_figures` folder.
    * Takes roughly 80 seconds to run.
* `run_video_scripts_from_stored_data.m`
    * Draws 60 fps video frames used to generate the clips for the Supplemental Video, based on the stored outputs from Part 1 in the `results_for_figures` folder.
    * Output frames from this are excluded from the GitHub (via `.gitignore`) to save space.  They are generated in the `video` directory.
    * Takes roughly 4 hours to run.

