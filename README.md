<h1> PEPRS - Performance Enhancement for Processing Radio Signals </h1>
<p> PEPRS is a Spring 2018 Co-op project that aims to streamline the process of running signal processing algorithms. It also makes it easier for developers to use algortighms developed by other people. It can perform RX calibration, TX calibration, and DPD. </p> 

<h2>Installation Procedures for Developers</h2>
<p>PEPRS is created with PyQt5 and MATLAB. <br> Installation requirements: </p>
<ul>
<li>MATLAB 2014 and up</li>
    <ul>
    <li>Instrument Control Toolbox</li>
    <li>Python drivers</li>
    </ul>
<li>Qt (most recent version)</li>
<li>Python 3.6</li>
<li>PyQt5</li>
<li>Keysight Libraries & Command Expert</li>
</ul>

<p> To install MATLAB, visit: https://www.mathworks.com/downloads/ <br> If a license is needed, visit the IST Webstore: https://cas.uwaterloo.ca/cas/login?service=https%3a%2f%2fstrobe.uwaterloo.ca%2fist%2fsaw%2fwebstore%2f <br> The research license should automatically come with the instrument control toolbox.</p>
<p> To install Python, visit: https://www.python.org/downloads/release/python-365/. Make sure to install a version that is compatible with your MATLAB version (64-bit or 32-bit). In the installation wizard, check the field that adds the python directories to your PATH. Make sure to add the directories to your system environment variables as well as your local PATH so python can be used as an admin.</p> 
<p> To install Qt, visit: https://www.qt.io/download. In the installation wizard, make sure the correct version of Qt is selected to be installed. The most recent version is not selected by default.</p>
<p> To install PyQt5, visit: https://www.riverbankcomputing.com/software/pyqt/download5 </p>
<p> To install MATLAB Python drivers, follow this link: https://www.mathworks.com/help/matlab/matlab_external/install-the-matlab-engine-for-python.html <br> Administrator privileges are most likely needed to run the "python setup.py install" command. It is therefore important to make sure your python directories are in the system environment variables (for Windows) and that your python and MATLAB bit versions are the same. If you need to reinstall Python, make sure to reinstall PyQt5 as well.</p>
<p> To install the Keysight IO Libraries and add ons, follow this link: https://www.keysight.com/en/pd-1985909/io-libraries-suite?cc=US&lc=eng </p>