## PEPRS - Performance Enhancement for Processing Radio Signals
PEPRS is a Spring 2018 Co-op project that aims to streamline the process of running signal processing algorithms. It also helps developers use algorithms developed by other people. It can perform RX calibration, TX calibration, and DPD.

----

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

----

## Installation Procedures
PEPRS is created with PyQt5 and MATLAB.

Installation requirements:

- MATLAB 2018 and up
   - Instrument Control Toolbox
   - Python drivers
   - matplotlib
- Qt 5.11.1
    - XCode (for Mac)
- Python 3.6.5
- PyQt5
- Keysight Libraries & Command Expert

To install MATLAB, visit: https://www.mathworks.com/downloads/ 
<br>If a license is needed, visit the IST Webstore: https://cas.uwaterloo.ca/cas/login?service=https%3a%2f%2fstrobe.uwaterloo.ca%2fist%2fsaw%2fwebstore%2f 
<br>The research license should automatically come with the instrument control toolbox.

To install Python, visit: https://www.python.org/downloads/release/python-365/. 
<br>Make sure to install a version that is compatible with your MATLAB version (64-bit or 32-bit). In the installation wizard, check the field that adds the python directories to your PATH. Make sure to add the directories to your system environment variables as well as your local PATH so python can be used as an admin.

To install Qt, visit: https://www.qt.io/download. 
<br>In the installation wizard, make sure the correct version of Qt is selected to be installed. The most recent version is not selected by default.

To install PyQt5, visit: https://www.riverbankcomputing.com/software/pyqt/download5

To install MATLAB Python drivers, follow this link: https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html 
<br>Administrator privileges are most likely needed to run the `python setup.py install` command. It is therefore important to make sure your python directories are in the system environment variables (for Windows) and that your python and MATLAB bit versions are the same. If you need to reinstall Python, make sure to reinstall PyQt5 as well.

To install matplotlib, run: `pip install matplotlib`

To install the Keysight IO Libraries and add ons, follow this link: https://www.keysight.com/en/pd-1985909/io-libraries-suite?cc=US&lc=eng

## How to Use the GUI
### Copying the Repository
The repository can be located in the working drive in the 'peprs' folder. Clone this repo to your local computer.
<br>For more information on setting up and using a git repo on a server, visit this link: https://gist.github.com/wlbr/1685405
### Starting the GUI
To start the GUI, there are two possible methods. 

1. Open the 'main.py' file in your file explorer 
2. Open command prompt (windows) or terminal (mac). Navigate to your cloned repository (using the cd command) and run `main.py`. Command prompt will allow you to see extra feedback typically displayed in matlab when running scripts. This information is not always displayed in the GUI.

### Welcoming Dialog
After running main, the first thing that appears is a dialog window asking you to choose your desired DUT setup. Currently, the only option that is accessible and functional is the SISO DUT.
### Next Steps
Throughout the GUI, there is a 'Next Step' section that will prompt you on what action you should take if you ever need guidance.
### Dashboard Tab
The dashboard tab is the landing page after the DUT setup is selected. It shows the setup of the equipment workbench.
### Step 1 - Set Equipment
The Set Equipment tab provides the ability to configure equipment to have different parameters. For example, the center frequency of the AWG and UXA can be set. Different instruments can be navigated to via the dashboard in the top left corner.
### Step 2 - Set Measurements & Calibrate
In the Set Measurements tab, parameters related to measurements are set and so are calibration parameters.
### Step 3 - Set & Run Algorithms
In the Set & Run Algorithms tab, algorithm related parameters are set and three algorithms can be run: Calibration Validation, Precharacterization Setup, and DPD.
### Opening and Saving Parameter Settings
In the top menu bar under File, there is the ability to save and open parameter setups. The appropriate text fields, drop downs, checkboxes, and radio buttons will be set to the appropriate value when saved and loaded. However, you will still have to set all of the appropriate buttons in the GUI i.e. push the "Set" or "Set & Run" buttons.
### Enabling Safety and Quality Checks
In the top menu bar under Preferences, there is the ability to enable or disable the safety and quality checks. These checks appear before you can move to the Step 2 tab or the DPD tab respectively.

## Developer's Guide
### Code Structure/Layout

### Qt
Qt applications are intended to be coded in C++. However, for this GUI, everything is written in Python. 
<br>
Qt is used to create the structure/layout of the GUI (i.e. all of the widgets, compoenents, text etc.) in the 'peprs.ui' file. This UI file is created using Qt Designer (installation instructions shown above) which is a simple drag and drop interface. This file is then converted into the 'peprs.py' file using the following command:
```
pyuic5 -x peprs.ui -o peprs.py
```
The 'peprs.py' file is then called in 'main.py' and initiated as ```self.ui```. Widgets/components can then be referenced in main.py with self.ui.For example, `self.ui.algoTabs` refers to the Step 3 tabs containing calibration validation, precharacterization setup and DPD. The components have a variety of functions that can be used to add functionality to the GUI (see 'Explanations on Signals and Slots' in the Resources section). Some examples are below:

```
self.ui.algoTabs.currentIndexChanged.connect(functionName)
idx = self.ui.algoTabs.currentIndex()
self.ui.lineEdit.textChanged.connect()
text = self.ui.lineEdit.text()
```

#### Common Widgets

- Stacked Widget: Used to show changing content in the same area 
   - e.g. each equipment page in step 1 is a separate page in a stacked widget, the next step sections are made from stacked widgets
   - can use `currentIndex()`, `currentIndexChanged()`, `setCurrentIndex()`, to easily manipulate these widgets and thus the GUI contents   
- Combo box: drop down lists
- Line edit: text fields
- Tabs
- Splitters: provide draggable bar to expand or collapse certain GUI sections
- Horizaontal/Vertical Spacers: provides dynamic spacing for GUI components
- Horizontal/Vertical/Grid Layout: aligns components in the corresponding setup, works dynamically

#### Resources
Qt has very thorough documentation that can be found here: http://doc.qt.io/
<br>
PyQt also has documentation albeit not as nice: http://pyqt.sourceforge.net/Docs/PyQt5/
<br>
Fortunately, there are plenty of online miscellaneous PyQt tutorials that can be found.

A walkthrough of basic PyQt classes and usage:

Explanations on Signals and Slots:

- http://doc.qt.io/archives/qt-4.8/signalsandslots.html
- https://wiki.qt.io/New_Signal_Slot_Syntax
- https://wiki.qt.io/How_to_Use_Signals_and_Slots

**Note**: Qt's signals and slots system was changed recently in version 5. There is documentation for Qt4 and Qt5 so keep this in mind.

A nice tutorial on threading in PyQT:
<br>
Note: Uses the old version of signals and slots from Qt4

## Using MATLAB with Python
### Method 1: Import MATLAB engine into python
Documentation on the engine: https://www.mathworks.com/help/matlab/matlab_external/start-the-matlab-engine-for-python.html
<br> To use this method, you must have the python drivers installed. It will only work on computers with a MATLAB license.
```
import matlab.engine
eng = matlab.engine.start_matlab()
eng.Function_Name(parameter,nargout=#)
```
### Method 2: Creating Python packages
In order to create and use a Python library from MATLAB code, follow this link: https://www.mathworks.com/help/compiler_sdk/gs/create-a-python-application-with-matlab-code.html
<br>If you use this method, method 1 will no longer work. You cannot use MATLAB compiler-generated software components within a running instance of MATLAB (which is what the engine is). This method does not require the user of the application to have MATLAB installed as it relies on MATLAB Runtime. When creating a package, do not include the runtime installer in the package but use the web option instead. The installer is very large and makes the repository very buky.
### MATLAB Runtime
To install MATLAB Runtime: https://www.mathworks.com/products/compiler/matlab-runtime.html
<br>For details: https://www.mathworks.com/help/compiler/deployment-process.html
<br>The first time a Python package is created, you will be prompted to install MATLAB Runtime. Anyone else using the app needs to install it as well.
### MATLAB on Mac
Make sure MATLAB Runtime is installed
<br>Append the path given by the installation wizard to the DYLD_LIBRARY_PATH environment variable. This can be done in terminal with `export DYLD_LIBRARY_PATH=path` . To check your path, run `echo $DYLD_LIBRARY_PATH`
<br>To run a script from terminal, the mwpython has to be used: https://www.mathworks.com/help/compiler_sdk/python/integrate-.html

## Deploying Qt Applications
To deploy a Qt app, follow this documentation: http://doc.qt.io/qt-5/deployment.html
<br> To create a python exe file to use during deployment, choose one of these methods: https://wiki.python.org/moin/PyQt/Deploying_PyQt_Applications
<br> The application will be statically deployed, so it is very important that the correct qt version is installed

## Miscellaneous Resources
Generating README Table of Contents: https://github.com/thlorenz/doctoc

Markdown Guide: https://about.gitlab.com/handbook/product/technical-writing/markdown-guide/#table-of-contents-toc