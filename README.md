<h1> PEPRS - Performance Enhancement for Processing Radio Signals </h1>
<p> PEPRS is a Spring 2018 Co-op project that aims to streamline the process of running signal processing algorithms. It also makes it easier for developers to use algortighms developed by other people. It can perform RX calibration, TX calibration, and DPD. </p> 

<h2>Installation Procedures for Developers</h2>
<p>PEPRS is created with PyQt5 and MATLAB. <br> Installation requirements: </p>
<ul>
<li>MATLAB 2014 and up</li>
    <ul>
    <li>Instrument Control Toolbox</li>
    <li>Python drivers</li>
    <li>matplotlib</li>
    </ul>
<li>Qt 5.11.1</li>
    <ul>
    <li>XCode (for Mac)</li>
    </ul>
<li>Python 3.6.5</li>
<li>PyQt5</li>
<li>Keysight Libraries & Command Expert</li>
</ul>

<p> To install MATLAB, visit: https://www.mathworks.com/downloads/ <br> If a license is needed, visit the IST Webstore: https://cas.uwaterloo.ca/cas/login?service=https%3a%2f%2fstrobe.uwaterloo.ca%2fist%2fsaw%2fwebstore%2f <br> The research license should automatically come with the instrument control toolbox.</p>
<p> To install Python, visit: https://www.python.org/downloads/release/python-365/. Make sure to install a version that is compatible with your MATLAB version (64-bit or 32-bit). In the installation wizard, check the field that adds the python directories to your PATH. Make sure to add the directories to your system environment variables as well as your local PATH so python can be used as an admin.</p> 
<p> To install Qt, visit: https://www.qt.io/download. In the installation wizard, make sure the correct version of Qt is selected to be installed. The most recent version is not selected by default.</p>
<p> To install PyQt5, visit: https://www.riverbankcomputing.com/software/pyqt/download5 </p>
<p> To install MATLAB Python drivers, follow this link: https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html <br> Administrator privileges are most likely needed to run the "python setup.py install" command. It is therefore important to make sure your python directories are in the system environment variables (for Windows) and that your python and MATLAB bit versions are the same. If you need to reinstall Python, make sure to reinstall PyQt5 as well.</p>
<p> To install matplotlib, run: pip install matplotlib </p>
<p> To install the Keysight IO Libraries and add ons, follow this link: https://www.keysight.com/en/pd-1985909/io-libraries-suite?cc=US&lc=eng </p>

<h2>Using MATLAB with Python</h2>
<h3>Method 1: Import MATLAB engine into python</h3>
<p>Documentation on the engine: https://www.mathworks.com/help/matlab/matlab_external/start-the-matlab-engine-for-python.html</p>
<p>To use this method, you must have the python drivers installed. It will only work on computers with a MATLAB license</p>
<p>import matlab.engine <br> eng = matlab.engine.start_matlab() <br> eng.Function_Name(parameter,nargout=#)</p>
<h3>Method 2: Creating Python packages</h3>
<p>In order to create and use a Python library from MATLAB code, follow this link: https://www.mathworks.com/help/compiler_sdk/gs/create-a-python-application-with-matlab-code.html</p>
<p>If you use this method, method 1 will no longer work. You cannot use MATLAB compiler-generated software components within a running instance of MATLAB (which is what the engine is).</p>
<p>This method does not require the user of the application to have MATLAB installed as it relies on MATLAB Runtime.</p>
<p>When creating a package, do not include the runtime installer in the package but use the web option instead. The installer is very large and makes the repository very buky.</p>
<h3>MATLAB Runtime</h3>
<p>To install MATLAB Runtime: https://www.mathworks.com/products/compiler/matlab-runtime.html</p>
<p>For details: https://www.mathworks.com/help/compiler/deployment-process.html</p>
<p>The first time a Python package is created, you will be prompted to install MATLAB Runtime. Anyone else using the app needs to install it as well.</p>
<h3>MATLAB on Mac</h3>
<p>Make sure MATLAB Runtime is installed </p>
<p>Append the path given by the installation wizard to the DYLD_LIBRARY_PATH environment variable. This can be done in terminal with "export DYLD_LIBRARY_PATH=path". To check your path, run "echo $DYLD_LIBRARY_PATH"</p>
<p>To run a script from terminal, the mwpython has to be used: https://www.mathworks.com/help/compiler_sdk/python/integrate-.html</p>

<h2>Deploying Qt Application</h2>
<p>To deploy a Qt app, follow this documentation: http://doc.qt.io/qt-5/deployment.html </p>
<p>To create a python exe file to use during deployment, choose one of these methods: https://wiki.python.org/moin/PyQt/Deploying_PyQt_Applications </p>
<p>The application will be statically deployed, so it is very important that the correct qt version is installed </p>

<h2>Usage</h2>
<h3>Opening and Saving Parameter Settings</h3>
<p>In the top menu bar, there is the ability to save and open parameter setups. The appropriate text fields, drop downs, checkboxes, and radio buttons will be set to the appropriate value when saved and loaded. However, you will still have to set all of the appropriate buttons in the GUI i.e. push the "Set" or "Set & Run" buttons.</p>

