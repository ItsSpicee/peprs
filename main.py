# contains callbacks to ui components and a few miscellaneous functions that function better in main.py (e.g. rely on event, used by multiple files. rely on parameter from signal)
#1265, 950
# tabWidget->setTabEnabled(1, false);

import sys
import os
from PyQt5 import uic, QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import (QDialogButtonBox,QMessageBox, QTabWidget, QFileDialog,QDialog, QInputDialog, QTextEdit, QLineEdit, QLabel, QFrame, QGridLayout, QHBoxLayout, QVBoxLayout, QWidget, QMainWindow, QMenu, QAction, qApp, QDesktopWidget, QMessageBox, QToolTip, QPushButton, QApplication, QProgressBar,QSizePolicy)
from PyQt5.QtGui import (QCursor, QPen, QPainter, QColor, QIcon, QFont,QGuiApplication)
from PyQt5.QtCore import (QEvent,Qt, pyqtSlot, QSize)

from peprs import Ui_peprs
from dutsetup import Ui_DUTSetup
from safetycheck import Ui_safetycheck
from qualitycheck import Ui_qualitycheck
import setParameters as set
import workflowNav as flow
import windowFunctions as menu
import parameterFunctions as param
#import PowerSupplyPkg

# setup matlab engine
import matlab.engine
supply = matlab.engine.start_matlab()
# add all folders and subfolders in peprs to matlab path
currentPath = os.getcwd();
allPaths = supply.genpath(currentPath)
supply.addpath(allPaths)

#supply = PowerSupplyPkg.initialize()

class Window(QMainWindow):
	def __init__(self):
		super(Window,self).__init__()
		self.ui = Ui_DUTSetup()
		self.ui.setupUi(self)
		self.initDutUI()
		
	def initDutUI(self):
		self.ui.dutStackedWidget.setCurrentIndex(0)
		self.ui.dutReadyButton.clicked.connect(self.dutReady)
		self.setWindowTitle('PEPRS - Performance Enhancement for Processing Radio Signals')
		self.ui.backButton.clicked.connect(lambda: self.goBack(0))
		self.show()
		
		
	def goBack(self, index):
		self.ui.dutStackedWidget.setCurrentIndex(index)
		
	def dutReady(self):
		mimoChecked = self.ui.mimoRadio.isChecked()
		misoChecked = self.ui.misoRadio.isChecked()
		simoChecked = self.ui.simoRadio.isChecked()
		if self.ui.sisoRadio.isChecked() == True:
			self.hide()
			self.ui.dutStackedWidget.hide()
			self.ui = Ui_peprs()
			self.ui.setupUi(self)
			self.initMainUI()
			self.show()
		elif mimoChecked == True or misoChecked or simoChecked:
			self.ui.dutStackedWidget.setCurrentIndex(1)
	
	def initMainUI(self):		
		
		# safety and quality check dialog setup and signals
		safety = QDialog(self)
		safety.ui = Ui_safetycheck()
		safety.ui.setupUi(safety)
		safety.setWindowTitle('DUT Information - Safety Check')
		safety.ui.safetyCheckButtons.accepted.connect(lambda: self.safetyComplete(safety))
		safety.ui.safetyCheckButtons.rejected.connect(lambda: self.safetyCancel(safety))
		
		quality = QDialog(self)
		quality.ui = Ui_qualitycheck()
		quality.ui.setupUi(quality)
		quality.setWindowTitle('Quality Check')
		quality.ui.qualityCheckButtons.accepted.connect(lambda: self.qualityComplete(quality))
		quality.ui.qualityCheckButtons.rejected.connect(lambda: self.qualityCancel(quality))
		#quality.closeEvent()
		
		#setting up file import buttons
		self.ui.filePushButton_13.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFileField_algo_3,".\Measurement Data"))
		self.ui.filePushButton_14.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileIField_algo_3,".\Measurement Data"))
		self.ui.filePushButton_15.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileQField_algo_3,".\Measurement Data"))
		self.ui.filePushButton_11.clicked.connect(lambda: menu.fileBrowse(self, self.ui.customIField_algo,".\Measurement Data"))
		self.ui.filePushButton_12.clicked.connect(lambda: menu.fileBrowse(self, self.ui.customQField_algo,".\Measurement Data"))
		self.ui.filePushButton_7.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFileField_algo_2,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_8.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFileField_algo_2,".\Measurement Data"))
		self.ui.filePushButton_9.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileIField_algo_2,".\Measurement Data"))
		self.ui.filePushButton_10.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileQField_algo_2,".\Measurement Data"))
		self.ui.filePushButton_4.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsaCalFileField_algo,".\Measurement Data"))
		self.ui.filePushButton_5.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileIField_algo,".\Measurement Data"))
		self.ui.filePushButton_3.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFileField_algo,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_6.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileQField_algo,".\Measurement Data"))
		self.ui.filePushButton.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFileField_comb,".\Measurement Data\RX_CalResults"))
		self.ui.filePushButton_2.clicked.connect(lambda: menu.fileSave(self, self.ui.vsaCalSaveLocField_comb,".\Measurement Data"))
		self.ui.filePushButton_17.clicked.connect(lambda: menu.fileBrowse(self, self.ui.upCalFileField_vsgMeas_2,".\Measurement Data"))
		self.ui.filePushButton_18.clicked.connect(lambda: menu.fileSave(self, self.ui.upCalSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_20.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFileField_vsgMeas,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_24.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFileField_vsgMeas_2,".\Measurement Data"))
		self.ui.filePushButton_25.clicked.connect(lambda: menu.fileBrowse(self, self.ui.iqFileField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_26.clicked.connect(lambda: menu.fileSave(self, self.ui.iqSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_27.clicked.connect(lambda: menu.fileSave(self, self.ui.vsgCalSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_28.clicked.connect(lambda: menu.fileSave(self, self.ui.calStructSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_29.clicked.connect(lambda: menu.fileBrowse(self, self.ui.upCalFileField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_30.clicked.connect(lambda: menu.fileSave(self, self.ui.upSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_31.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileIField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_32.clicked.connect(lambda: menu.fileBrowse(self, self.ui.calFileQField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_33.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFielField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_36.clicked.connect(lambda: menu.fileBrowse(self, self.ui.iqFileField_vsgMeas_3,".\Measurement Data"))
		self.ui.filePushButton_37.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFileField_vsgMeas_2,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_38.clicked.connect(lambda: menu.fileSave(self, self.ui.iqSaveLocField_vsgMeas_3,".\Measurement Data"))
		self.ui.filePushButton_39.clicked.connect(lambda: menu.fileSave(self, self.ui.vsgCalSaveLocField_vsgMeas_3,".\Measurement Data"))
		self.ui.filePushButton_40.clicked.connect(lambda: menu.fileSave(self, self.ui.calStructSaveLocField_vsgMeas_3,".\Measurement Data"))
		self.ui.filePushButton_41.clicked.connect(lambda: menu.fileBrowse(self, self.ui.awgCalFileField_vsgMeas_2,".\Measurement Data"))
		self.ui.filePushButton_42.clicked.connect(lambda: menu.fileBrowse(self, self.ui.ampCorrFileField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_43.clicked.connect(lambda: menu.fileSave(self, self.ui.awgCalSaveLocField_vsgMeas_2,".\Measurement Data"))
		self.ui.filePushButton_44.clicked.connect(lambda: menu.fileBrowse(self, self.ui.vsaCalFileField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_45.clicked.connect(lambda: menu.fileBrowse(self, self.ui.ampCorrFile_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_46.clicked.connect(lambda: menu.fileBrowse(self, self.ui.awgCalFileField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_47.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFilterFileField_vsgMeas,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_48.clicked.connect(lambda: menu.fileSave(self, self.ui.awgCalSaveLocField_vsgMeas,".\Measurement Data"))
		self.ui.filePushButton_49.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dllFile_uxa,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_50.clicked.connect(lambda: menu.fileBrowse(self, self.ui.setupFile_uxa,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_51.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dataFile_uxa,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_52.clicked.connect(lambda: menu.fileBrowse(self, self.ui.setupFile_scope,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_53.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dllFile_scope,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_54.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dataFile_scope,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_55.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dllFile_dig,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_56.clicked.connect(lambda: menu.fileBrowse(self, self.ui.setupFile_dig,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_57.clicked.connect(lambda: menu.fileBrowse(self, self.ui.dataFile_dig,".\Equipment Setup\Demodulator"))
		self.ui.filePushButton_16.clicked.connect(lambda: menu.fileBrowse(self, self.ui.downFileField_algo_3,".\Measurement Data\\Utility Data"))
		self.ui.filePushButton_19.clicked.connect(lambda: menu.fileBrowse(self, self.ui.refFileField_comb,".\Measurement Data\Comb_Generator_Files"))
		self.ui.filePushButton_21.clicked.connect(lambda: menu.fileBrowse(self,self.ui.driverPath_scope,".\Equipment Setup\Scope"))
		self.ui.filePushButton_58.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsaCalFileField_vsg,".\Measurement Data"))
		self.ui.filePushButton_59.clicked.connect(lambda: menu.fileOpen(self, self.ui.iqFileField_vsg,".\Measurement Data"))
		self.ui.filePushButton_60.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsgFileField_vsg,".\Measurement Data"))
		self.ui.filePushButton_61.clicked.connect(lambda: menu.fileOpen(self, self.ui.calStructField_vsg,".\Measurement Data"))
		self.ui.filePushButton_62.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsaCalFileField_vsa,".\Measurement Data"))
		self.ui.filePushButton_63.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsgCalFileField_vsg,".\Measurement Data"))
		self.ui.filePushButton_64.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsgCalPath_algo,".\Measurement Data"))
		self.ui.filePushButton_65.clicked.connect(lambda: menu.fileOpen(self, self.ui.iqPathField_algo,".\Measurement Data"))
		self.ui.filePushButton_66.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsgCalPathField_algo,".\Measurement Data"))
		self.ui.filePushButton_67.clicked.connect(lambda: menu.fileOpen(self, self.ui.calStructPathField_algo,".\Measurement Data"))
		self.ui.filePushButton_68.clicked.connect(lambda: menu.fileOpen(self, self.ui.calValPathField_algo,".\Measurement Data"))
		self.ui.filePushButton_69.clicked.connect(lambda: menu.fileOpen(self, self.ui.calValPathField_algo_2,".\Measurement Data"))
		self.ui.filePushButton_70.clicked.connect(lambda: menu.fileOpen(self, self.ui.dpdMeasPathField_algo,".\DPD Data"))
		self.ui.filePushButton_71.clicked.connect(lambda: menu.fileOpen(self, self.ui.vsaCalPathField_algo,".\Measurement Data"))
	
		# styling variables
		unsetFocusButton = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:0.994318, y1:0.682, x2:1, y2:0, stop:0 rgba(72, 144, 216, 255), stop:1 rgba(83, 170, 252, 255)); border-radius:5px;color:white;font-weight:bold;}"
		setButton = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(17, 75, 95, 255), stop:1 rgba(22, 105, 132, 255)); border-radius:5px; color:white;border:none;font-weight:bold;}"
		setFocusButton = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(17, 75, 95, 255), stop:1 rgba(22, 105, 132, 255)); border-radius:5px; color:white;border:none;font-weight:700;font-size:11px}"
		setButtonHover = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(17, 75, 95, 255), stop:1 rgba(22, 105, 132, 255)); border-radius:5px; color:white;border:none;font-weight:bold;} QPushButton:hover{background-color:rgb(28, 126, 159);}"
		setParams = "QGroupBox{background-color:rgb(247, 247, 247); border:2px solid #515a70}"
		unsetParams = "QGroupBox{background-color:rgb(247, 247, 247)}"
		greyButton = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		greyHover = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px;color:black} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		blueSelect = "QPushButton{ border:3px solid rgb(0, 0, 127);  background-color:qlineargradient(spread:pad, x1:0.994318, y1:0.682, x2:1, y2:0, stop:0 rgba(72, 144, 216, 255), stop:1 rgba(83, 170, 252, 255)); border-radius:5px;color:white}"
		greenButton = "QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 158, 0, 255));color:white;border-radius: 5px; border: 3px solid green;} QPushButton:hover{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(0, 134, 0, 255), stop:1 rgba(0, 184, 0, 255));}"
		redButton = "QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(179, 0, 0, 255), stop:1 rgba(214, 0, 0, 255));color:white;border-radius: 5px; border: 3px solid rgb(143, 0, 0);} QPushButton:hover{background-color:rgb(217, 0, 0);}"
		
		# set splitters
		sizeList = [450,450]
		self.ui.vsaMeasSplitter.setSizes(sizeList)
		self.ui.vsgMeasSplitter.setSizes(sizeList)
		self.ui.algoSplitter.setSizes(sizeList)
		
		# emergency on and off buttons
		self.ui.emergButtonFirst.clicked.connect(lambda: self.toggleOutput(1,redButton,greenButton))
		self.ui.emergButtonSecond.clicked.connect(lambda: self.toggleOutput(2,redButton,greenButton))
		self.ui.allOffButton.clicked.connect(lambda: self.toggleOutput(3,redButton,greenButton))
		
		# keep widget space when hidden
		retainVsa = QSizePolicy(self.ui.debuggingPanel_vsa.sizePolicy())
		retainVsg = QSizePolicy(self.ui.debuggingPanel_vsg.sizePolicy())
		retainVsa.setRetainSizeWhenHidden(True)
		retainVsg.setRetainSizeWhenHidden(True)
		self.ui.debuggingPanel_vsa.setSizePolicy(retainVsa);
		self.ui.debuggingPanel_vsg.setSizePolicy(retainVsg);
		
		# set menu bar actions
		self.ui.actionOpen.triggered.connect(lambda: menu.openDialog(self))
		self.ui.actionSave.triggered.connect(lambda: menu.saveDialog(self))
		self.ui.actionQuit.triggered.connect(lambda: menu.closeButton(self))	
		self.ui.actionEnable_Safety_Check.triggered.connect(self.toggleCheck)
		
		# set window details
		self.setWindowTitle('PEPRS - Performance Enhancement for Processing Radio Signals')
		#pepper_icon = QtGui.QIcon()
		#pepper_icon.addFile('icons/pepper 24x24.png', QtCore.QSize(24,24))
		#self.setWindowIcon(pepper_icon)
		self.ui.statusBar.showMessage('Ready',2000)	
		self.setMinimumSize(1265,650)
		self.resize(1265,650)
		self.center()
		
		# set appropriate pages in stacks
		self.ui.stepTabs.setCurrentIndex(3) # dashboard
		self.ui.equipStack.setCurrentIndex(0) # vsg settings page
		self.ui.measStack.setCurrentIndex(0)
		# vsg page
		self.ui.vsgEquipTabs.setCurrentIndex(0) # vsg general settings
		self.ui.vsgEquipStack.setCurrentIndex(2) # please select a layout
		self.ui.vsgEquipStackAdv.setCurrentIndex(2) # please select a layout
		self.ui.vsgNextSteps.setCurrentIndex(0) # fill out vsg
		self.ui.vsgWorkflows.setCurrentIndex(0) # general vsg workflow button
		self.ui.vsaWorkflow_vsg.setCurrentIndex(0)
		# upconverter page
		self.ui.upEquipTabs.setCurrentIndex(0) # upconverter general settings
		self.ui.vsaWorkflow_up.setCurrentIndex(0)
		# vsa page
		self.ui.vsaWorkflow.setCurrentIndex(0) # vsa general workflow button
		self.ui.vsaEquipTabs.setCurrentIndex(0) # vsa general settings tab
		self.ui.vsaEquipStack.setCurrentIndex(3) # vsa select setup page
		self.ui.vsaAdvancedStack.setCurrentIndex(0) # select vsa type
		self.ui.vsaNextStack.setCurrentIndex(0) # vsa next
		# downconverter page
		self.ui.downNextStack.setCurrentIndex(0)
		self.ui.downEquipTabs.setCurrentIndex(0)
		# meter page
		self.ui.meterNextStack.setCurrentIndex(0)
		self.ui.meterEquipTabs.setCurrentIndex(0)
		# sa page
		self.ui.saNextStack.setCurrentIndex(4)
		self.ui.saEquipTabs.setCurrentIndex(0)
		self.ui.saEquipStandardStack.setCurrentIndex(1)
		self.ui.saEquipAdvStack.setCurrentIndex(0)
		# power 1 page
		self.ui.power1NextStack.setCurrentIndex(0)
		self.ui.power1EquipTabs.setCurrentIndex(0)
		# power 2 page
		self.ui.power2NextStack.setCurrentIndex(1)
		self.ui.power2EquipTabs.setCurrentIndex(0)
		# power 3 page
		self.ui.power3NextStack.setCurrentIndex(0)
		self.ui.power3EquipTabs.setCurrentIndex(0)
		# vsa meas page
		self.ui.vsaMeasParamTabs.setCurrentIndex(0)
		self.ui.vsaMeasGenStack.setCurrentIndex(0)
		self.ui.rightFlowStack.setCurrentIndex(0)
		self.ui.vsaMeasNextStack.setCurrentIndex(0)
		self.ui.debugVSAStack.setCurrentIndex(1)
		self.ui.resultsVSATabs.setCurrentIndex(0)
		self.ui.vsaResultsStack_vsaMeas.setCurrentIndex(1)
		self.ui.vsaMeasRunStack.setCurrentIndex(1)
		self.ui.downStack_vsaMeas.setCurrentIndex(0)
		self.ui.saMeasTabs.setCurrentIndex(0)
		self.ui.filePushButton_2.setEnabled(False)
		# vsg meas page
		self.ui.debugVSGStack.setCurrentIndex(2)
		self.ui.vsaResultsStack_vsgMeas.setCurrentIndex(1)
		self.ui.vsgResultsStack_vsgMeas.setCurrentIndex(1)
		self.ui.vsgMeasParamTabs.setCurrentIndex(0)
		self.ui.awgParamsStack_vsgMeas.setCurrentIndex(0)
		self.ui.upParamsStack_vsgMeas.setCurrentIndex(0)
		self.ui.advParamsStack_vsgMeas.setCurrentIndex(0)
		self.ui.vsgResultsTabs_vsgMeas.setCurrentIndex(0)
		self.ui.vsgResultsFileStack_vsgMeas.setCurrentIndex(1)
		self.ui.resultsTabs_vsgMeas.setCurrentIndex(1)
		# algo page
		self.ui.algoTabs.setCurrentIndex(0)
		self.ui.algoNextStack.setCurrentIndex(0)
		self.ui.debugAlgoStack.setCurrentIndex(2)
		self.ui.calValResultsStack.setCurrentIndex(1)
		self.ui.resultsAlgoTabs.setCurrentIndex(2)
		self.ui.calWorkflowTabs.setCurrentIndex(0)
		self.ui.dpdAlgoStack.setCurrentIndex(1)
		self.ui.precharAlgoStack.setCurrentIndex(1)
		self.ui.vsaCalResultsStack_algo.setCurrentIndex(0)
		self.ui.vsgCalTabs_algo.setCurrentIndex(0)
		self.ui.vsgCalResults_algo.setCurrentIndex(0)
		
		
		# setting visibility of components
		# vsa meas page
		self.ui.calAdviceText.setVisible(False)
		self.ui.downMark_vsaMeas.setVisible(False)
		self.ui.uxaMark_vsaMeas.setVisible(False)
		self.ui.pxaMark_vsaMeas.setVisible(False)
		self.ui.saMark_vsaMeas.setVisible(False)
		self.ui.saMark_vsaMeas_2.setVisible(False)
		self.ui.scopeMark_vsaMeas.setVisible(False)
		self.ui.scopeMark_vsaMeas_2.setVisible(False)
		self.ui.digMark_vsaMeas.setVisible(False)
		self.ui.digMark_vsaMeas_2.setVisible(False)
		self.ui.downMark_vsgMeas.setVisible(False)
		# self.ui.uxaMark_vsgMeas.setVisible(False)
		# self.ui.pxaMark_vsgMeas.setVisible(False)
		self.ui.saMark_vsgMeas.setVisible(False)
		self.ui.saMark_vsgMeas_2.setVisible(False)
		# self.ui.scopeMark_vsgMeas.setVisible(False)
		# self.ui.scopeMark_vsgMeas_2.setVisible(False)
		# self.ui.digMark_vsgMeas.setVisible(False)
		# self.ui.digMark_vsgMeas_2.setVisible(False)
		self.ui.awgMark_vsgMeas.setVisible(False)
		self.ui.awgMark_vsgMeas_2.setVisible(False)
		self.ui.awgMark_vsgMeas_3.setVisible(False)
		self.ui.vsgMark_vsgMeas.setVisible(False)
		self.ui.psgMark_vsgMeas.setVisible(False)
		self.ui.upMark_vsgMeas.setVisible(False)
		# algo tab
		
		# dropdown and field changes
		self.ui.vsgSetup.currentIndexChanged.connect(lambda: param.displayVsg(self,greyHover,greyButton))
		self.ui.vsaType.currentIndexChanged.connect(lambda: param.displayVsa(self,unsetParams,greyHover,greyButton))
		self.ui.demodulationEnable.currentIndexChanged.connect(lambda: param.displayVsa(self,unsetParams,greyHover,greyButton))
		self.ui.averagingEnable.currentIndexChanged.connect(lambda: param.displayVsa(self,unsetParams,greyHover,greyButton))
		self.ui.saType.currentIndexChanged.connect(lambda: param.displaySa(self,blueSelect,setFocusButton,setButtonHover,greyHover,greyButton))
		self.ui.generateVSACalCheck.stateChanged.connect(lambda: param.enableVSACalFile(self,setParams,unsetParams))
		self.ui.calFilePromptNo.toggled.connect(lambda: self.ui.vsaMeasNextStack.setCurrentIndex(4))
		self.ui.calFilePromptYes.toggled.connect(lambda: self.ui.vsaMeasNextStack.setCurrentIndex(3))
		self.ui.noCalRXButton.clicked.connect(lambda: self.ui.vsaMeasNextStack.setCurrentIndex(4))
		self.ui.yesCalRXButton.clicked.connect(lambda: self.ui.vsaMeasNextStack.setCurrentIndex(3))
		self.ui.vsgFrameTime_vsaMeas.currentIndexChanged.connect(lambda: param.determineFrameTimeEnable(self,self.ui.vsgFrameTime_vsaMeas))
		self.ui.vsgFrameTime_vsaMeas_2.currentIndexChanged.connect(lambda: param.determineFrameTimeEnable(self,self.ui.vsgFrameTime_vsaMeas_2))
		self.ui.calFilePromptNo_vsgMeas.toggled.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(1))
		self.ui.calFilePromptYes_vsgMeas.toggled.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(2))
		self.ui.vsgCalFilePromptYes.toggled.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(3))
		self.ui.vsgCalFilePromptNo.toggled.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(4))
		self.ui.noCalTXButton.clicked.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(3))
		self.ui.yesCalTXButton.clicked.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(4))
		self.ui.noCalRXButton_vsgNext.clicked.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(1))
		self.ui.yesCalRXButton_vsgNext.clicked.connect(lambda: self.ui.vsgMeasNextStack.setCurrentIndex(2))
		self.ui.vsgCalType.currentIndexChanged.connect(lambda: param.displayVSGMeas(self))
		# power supplies
		self.ui.noChannels_p1.currentIndexChanged.connect(lambda: param.enableChannel(self))
		self.ui.noChannels_p2.currentIndexChanged.connect(lambda: param.enableChannel(self))
		self.ui.noChannels_p3.currentIndexChanged.connect(lambda: param.enableChannel(self))
		self.ui.p1Enabled.currentIndexChanged.connect(lambda: param.enableSupplyOne(self))
		self.ui.p2Enabled.currentIndexChanged.connect(lambda: param.enableSupplyTwo(self))
		self.ui.p3Enabled.currentIndexChanged.connect(lambda: param.enableSupplyThree(self))
		# vsa meas page
		self.ui.iChannel_awg.currentIndexChanged.connect(lambda: param.enableChannelOptions(self))
		self.ui.qChannel_awg.currentIndexChanged.connect(lambda: param.enableChannelOptions(self))
	
		# expand/shrink depending on which step tab is clicked
		self.ui.stepTabs.currentChanged.connect(lambda: menu.changeStepTab(self,safety,quality))

		# vsa meas page
		self.ui.vsaMeasParamTabs.currentChanged.connect(lambda: menu.switchMeasTabVSA(self))
		self.ui.vsgMeasParamTabs.currentChanged.connect(lambda: menu.switchMeasTabVSG(self))
		self.ui.algoTabs.currentChanged.connect(lambda: menu.switchAlgoTab(self))
		
		# control parameter set buttons
		# vsg page
		self.ui.awgSetGeneral.clicked.connect(lambda: set.setGeneralAWG(self,setFocusButton,setParams,greyHover,unsetFocusButton,greyButton,self.ui.awgSetGeneral,supply))
		self.ui.vsgSetGeneral.clicked.connect(lambda: set.setGeneralVSG(self,setFocusButton,setParams,greyHover,unsetFocusButton,greyButton,self.ui.vsgSetGeneral))
		self.ui.vsgSetAdv.clicked.connect(lambda: set.setAdvanced(self,self.ui.vsgEquipAdv,setParams,self.ui.vsgSetAdv))
		self.ui.awgSetAdv.clicked.connect(lambda: set.setAdvancedAWG(self,setParams,self.ui.awgSetAdv,supply))
		# upconverter page
		self.ui.upSet.clicked.connect(lambda: set.setUp(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.upSet))
		self.ui.psgSet.clicked.connect(lambda: set.setPSG(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.psgSet))
		# vsa page
		self.ui.uxaSet.clicked.connect(lambda: set.setVSA(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.uxaSet,supply))
		self.ui.pxaSet.clicked.connect(lambda: set.setVSA(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.pxaSet,supply))
		self.ui.uxaVSASetAdv.clicked.connect(lambda: set.setVSAAdv(self,setParams,self.ui.uxaVSASetAdv))
		self.ui.scopeSet.clicked.connect(lambda: set.setVSA(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.scopeSet,supply))
		self.ui.digSet.clicked.connect(lambda: set.setVSA(self,setFocusButton,setButtonHover,setParams,greyHover,greyButton,unsetFocusButton,self.ui.digSet,supply))
		# downconverter page
		self.ui.downSetAdv.clicked.connect(lambda: set.setAdvanced(self,self.ui.downEquipAdv,setParams,self.ui.downSetAdv))
		self.ui.downSet.clicked.connect(lambda: set.setDown(self,setFocusButton,greyHover,setButtonHover,setParams,greyButton,unsetFocusButton,self.ui.downSet))
		# meter page
		self.ui.meterSet.clicked.connect(lambda: set.setMeter(self,setFocusButton,setButtonHover,greyHover,setParams,greyButton,unsetFocusButton,self.ui.meterSet,supply))
		
		# sa page
		self.ui.saSetAdv.clicked.connect(lambda: set.setSAAdv(self,setFocusButton,setButtonHover,greyHover,setParams,self.ui.saSetAdv,greyButton,unsetFocusButton,supply))

		self.ui.saSet.clicked.connect(lambda: set.setSA(self,setFocusButton,setButtonHover,greyHover,setParams,self.ui.saSet,greyButton,unsetFocusButton,supply))

		# power 1 page
		self.ui.p1Set.clicked.connect(lambda: set.setP1(self,setParams,setFocusButton,setButtonHover,greyHover,greyButton,supply,unsetFocusButton,self.ui.p1Set))
		# power 2 page
		self.ui.p2Set.clicked.connect(lambda: set.setP2(self,setParams,setFocusButton,setButtonHover,greyHover,greyButton,supply,unsetFocusButton,self.ui.p2Set))
		# power 3 page
		self.ui.p3Set.clicked.connect(lambda: set.setP3(self,setParams,setFocusButton,setButtonHover,supply,unsetFocusButton,greyHover,self.ui.p3Set))
		# vsa meas page
		self.ui.vsaMeasSet.clicked.connect(lambda: set.setVSAMeasDig(self,setParams,setButtonHover,setButton,self.ui.vsaMeasSet,supply))
		self.ui.vsaMeasSet_2.clicked.connect(lambda: set.setVSAMeasGen(self,setParams,setButtonHover,setButton,self.ui.vsaMeasSet_2,supply))
		self.ui.set_run_vsa.clicked.connect(lambda: set.rxCalRoutine(self,setParams,setButtonHover,self.ui.set_run_vsa,supply))
		self.ui.downSetVSAMeas.clicked.connect(lambda: set.noRXCalRoutine(self,setParams,setButtonHover,self.ui.downSetVSAMeas,supply))
		self.ui.vsaMeasAdvSet.clicked.connect(lambda: set.setVSAMeasAdv(self,setParams,self.ui.vsaMeasAdvSet))
		# vsg meas page
		self.ui.awgSet_vsgMeas.clicked.connect(lambda: set.noAWGCalRoutine(self,setParams,self.ui.awgSet_vsgMeas,supply))
		self.ui.awgPreview_vsgMeas.clicked.connect(lambda: set.awgPreview(self))
		self.ui.awgPreviewRun_vsgMeas.clicked.connect(lambda: set.awgPreview(self))
		self.ui.awgSetRun_vsgMeas.clicked.connect(lambda: set.awgCalRoutine(self,setParams,self.ui.awgSetRun_vsgMeas,supply))
		self.ui.setAdv_vsgMeas.clicked.connect(lambda: set.setAdvAWG_vsgMeas(self,setParams,self.ui.setAdv_vsgMeas))
		self.ui.setAdv_vsgMeas_2.clicked.connect(lambda: set.setAdvAWGVSA_vsgMeas(self,setParams,self.ui.setAdv_vsgMeas_2))
		self.ui.upSet_vsgMeas.clicked.connect(lambda: set.setUpVSGMeas(self,setParams,self.ui.upSet_vsgMeas))
		self.ui.heteroRun.clicked.connect(lambda: set.setHetero(self,setParams,self.ui.heteroRun))
		self.ui.homoRun.clicked.connect(lambda: set.setHomo(self,setParams,self.ui.homoRun))
		
		# control workflow navigation
		# vsg page
		self.ui.upButton_vsg.clicked.connect(lambda: flow.upOnClick(self,greyHover,greyButton))
		self.ui.psgButton_vsg.clicked.connect(lambda: flow.psgOnClick(self,greyHover,greyButton))
		self.ui.vsaButton_vsg.clicked.connect(lambda: flow.vsaOnClick(self))
		self.ui.downButton_vsg.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.downButton_vsg_2.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.scopeButton_vsg.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_vsg_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_vsg_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_vsg_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_vsg.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_vsg_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_vsg_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_vsg_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_vsg.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_vsg_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_vsg.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_vsg_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_vsg.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_vsg_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_vsg.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsg_2.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsg_3.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsg_4.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsg_5.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.saButton_vsg.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsg_2.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsg_3.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsg_4.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsg_5.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.power1Button_vsg.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_vsg.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_vsg_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_vsg.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_vsg_2.clicked.connect(lambda: flow.p3OnClick(self))
		# upconverter page
		self.ui.awgButton_up.clicked.connect(lambda: flow.awgOnClick(self,greyButton,greyHover,setButtonHover))
		self.ui.vsaButton_up.clicked.connect(lambda: flow.vsaOnClick(self))
		self.ui.downButton_up.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.downButton_up_2.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.scopeButton_up.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_up_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_up_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_up_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_up.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_up_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_up_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_up_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_up.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_up_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_up.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_up_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_up.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_up_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_up.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_up_2.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_up_3.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_up_4.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_up_5.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.saButton_up.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_up_2.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_up_3.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_up_4.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_up_5.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.power1Button_up.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_up.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_up.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_up_2.clicked.connect(lambda: flow.p3OnClick(self))
		# vsa page
		self.ui.vsgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack ,1))
		self.ui.psgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.meterButton_vsa.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsa_2.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsa_3.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsa_4.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_vsa_5.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.downButton_vsa.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.downButton_vsa_2.clicked.connect(lambda: flow.downOnClick(self))
		self.ui.saButton_vsa.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsa_2.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsa_3.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsa_4.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_vsa_5.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.power1Button_vsa.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_vsa.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_vsa_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_vsa.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_vsa_2.clicked.connect(lambda: flow.p3OnClick(self))
		# downconverter page
		self.ui.awgButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_down_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_down_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.vsgButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.scopeButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_down_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_down_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_down.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_down.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.meterButton_down_2.clicked.connect(lambda: flow.meterOnClick(self))
		self.ui.saButton_down.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_down_2.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.power1Button_down.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_down.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_down_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_down.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_down_2.clicked.connect(lambda: flow.p3OnClick(self))
		# power meter page
		self.ui.powerMeterFilter.currentIndexChanged.connect(lambda: flow.powerMeterAveraging(self,self.ui.noAveragesField_meter,self.ui.powerMeterFilter.currentIndex(),self.ui.noAveragesLabel_meter))
		self.ui.awgButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_meter_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.vsgButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.downButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.scopeButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_meter_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_meter_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_meter_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_meter_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_meter.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_meter_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.saButton_meter.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_meter_2.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_meter_3.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.saButton_meter_4.clicked.connect(lambda: flow.saOnClick(self))
		self.ui.power1Button_meter.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_meter.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_meter_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_meter.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_meter_2.clicked.connect(lambda: flow.p3OnClick(self))
		# sa page
		self.ui.awgButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_sa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.vsgButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.downButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.scopeButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_sa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_sa_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_sa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_sa_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_sa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_sa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_sa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_sa_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.power1Button_sa.clicked.connect(lambda: flow.p1OnClick(self))
		self.ui.power2Button_sa.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_sa_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_sa.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_sa_2.clicked.connect(lambda: flow.p3OnClick(self))
		# power 1 page
		self.ui.awgButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_p1_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.vsgButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.downButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.scopeButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p1_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p1_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p1_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p1_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p1_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p1_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.saButton_p1.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p1_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p1_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p1_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.power2Button_p1.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power2Button_p1_2.clicked.connect(lambda: flow.p2OnClick(self))
		self.ui.power3Button_p1.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_p1_2.clicked.connect(lambda: flow.p3OnClick(self))
		# power 2 page
		self.ui.awgButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.downButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.scopeButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p2_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p2_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p2_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p2_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.uxaButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.pxaButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p2_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p2_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.saButton_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p2_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p2_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p2_4.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.power1Button_p2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,6))
		self.ui.power3Button_p2.clicked.connect(lambda: flow.p3OnClick(self))
		self.ui.power3Button_p2_2.clicked.connect(lambda: flow.p3OnClick(self))
		# power 3 page
		self.ui.awgButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_p3_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.vsgButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.psgButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.downButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.scopeButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.scopeButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.digButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.modButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.meterButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.meterButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.saButton_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.saButton_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,5))
		self.ui.power1Button_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,6))
		self.ui.power2Button_p3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,7))
		self.ui.power2Button_p3_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,7))
		# vsa meas page
		self.ui.saButton_vsaMeas.clicked.connect(lambda: self.ui.rightFlowStack.setCurrentIndex(1))
		self.ui.saButton_vsaMeas_2.clicked.connect(lambda: self.ui.rightFlowStack.setCurrentIndex(1))
		self.ui.downButton_vsaMeas.clicked.connect(lambda: flow.switchVSAMeas(self,1))
		self.ui.scopeButton_vsaMeas.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.scopeButton_vsaMeas_2.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.digButton_vsaMeas.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.digButton_vsaMeas_2.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.uxaButton_vsaMeas.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.pxaButton_vsaMeas.clicked.connect(lambda: flow.switchVSAMeas(self,0))
		self.ui.awgButton_vsaMeas.clicked.connect(lambda: flow.awgVSAMeasOnClick(self))
		self.ui.awgButton_vsaMeas_2.clicked.connect(lambda: flow.awgVSAMeasOnClick(self))
		self.ui.awgButton_vsaMeas_3.clicked.connect(lambda: flow.awgVSAMeasOnClick(self))
		self.ui.vsgButton_vsaMeas.clicked.connect(lambda: flow.awgVSAMeasOnClick(self))
		# vsg meas page
		self.ui.saButton_vsgMeas.clicked.connect(lambda: flow.saVSGMeasOnClick(self))
		self.ui.saButton_vsgMeas_2.clicked.connect(lambda: flow.saVSGMeasOnClick(self))
		self.ui.downButton_vsgMeas.clicked.connect(lambda: flow.downVSGMeasOnClick(self))
		self.ui.scopeButton_vsgMeas.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.scopeButton_vsgMeas_2.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.digButton_vsgMeas.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.digButton_vsgMeas_2.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.uxaButton_vsgMeas.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.pxaButton_vsgMeas.clicked.connect(lambda: flow.analyzerVSGMeasOnClick(self))
		self.ui.psgButton_vsgMeas.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(1))
		self.ui.upButton_vsgMeas.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(1))
		self.ui.awgButton_vsgMeas.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(0))
		self.ui.awgButton_vsgMeas_2.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(0))
		self.ui.awgButton_vsgMeas_3.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(0))
		self.ui.vsgButton_vsgMeas.clicked.connect(lambda: self.ui.vsgMeasParamTabs.setCurrentIndex(0))
		# algo page
		self.ui.calValPreview.clicked.connect(lambda: set.calValPreview(self))
		self.ui.calValRun.clicked.connect(lambda: set.runCalValidation(self,setParams,self.ui.calValRun))
		self.ui.precharPreview.clicked.connect(lambda: set.preCharPreview(self))
		self.ui.precharRun.clicked.connect(lambda: set.runPrecharacterization(self,setParams,self.ui.precharRun))
		self.ui.dpdPreview.clicked.connect(lambda: set.dpdPreview(self))
		self.ui.dpdRun.clicked.connect(lambda: set.runDPD(self,setParams,self.ui.dpdRun))
		self.ui.algoSetAdv.clicked.connect(lambda: set.setAdvanced(self,self.ui.refRXAdvEquip,setParams,self.ui.algoSetAdv))
		
		# control parameter changes
		# vsa equipment page
		self.ui.dllFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_scope, self.ui.dllFile_uxa, self.ui.dllFile_dig))
		self.ui.setupFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_scope,self.ui.setupFile_uxa,self.ui.setupFile_dig))
		self.ui.dataFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_scope,self.ui.dataFile_uxa,self.ui.dataFile_dig))
		
		self.ui.dllFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_uxa, self.ui.dllFile_scope, self.ui.dllFile_dig))
		self.ui.setupFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_uxa,self.ui.setupFile_scope,self.ui.setupFile_dig))
		self.ui.dataFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_uxa,self.ui.dataFile_scope,self.ui.dataFile_dig))
		
		self.ui.dllFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_dig, self.ui.dllFile_scope, self.ui.dllFile_uxa))
		self.ui.setupFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_dig,self.ui.setupFile_scope,self.ui.setupFile_uxa))
		self.ui.dataFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_dig,self.ui.dataFile_scope,self.ui.dataFile_uxa))
		# vsa equipment page - uxa
		self.ui.trigSource_sa.currentIndexChanged.connect(lambda: param.disableTrigLevelVSA(self))
		# sa page
		self.ui.trigSource_spa.currentIndexChanged.connect(lambda: param.disableTrigLevelSA(self))
		self.ui.averaging_spa.currentIndexChanged.connect(lambda: param.enableAveragingSA(self))
		self.ui.traceAvg_spa.currentIndexChanged.connect(lambda: param.enableTraceAveragingSA(self))
		# awg measurement page
		self.ui.refClockSorce_awg.currentIndexChanged.connect(lambda: param.enableExtClkFreq(self))
		
		
		# show on window
		self.show()	
	
	def safetyComplete(self,safety):
		maxTrue = self.isMaximized()
		screen = QGuiApplication.primaryScreen()
		screenSize = screen.availableSize()
		height = screenSize.height()
		maxHeight = height - 50
		nmse = safety.ui.dutNMSE.text()
		power = safety.ui.dutPower.text()
		gain = safety.ui.dutGain.text()
		papr = safety.ui.paprCheck.text()
		if nmse != "" and power != "" and gain != "" and papr != "":
			safety.done(0)
			self.setMinimumSize(1265,maxHeight)
			self.resize(1265,maxHeight)
			self.center()
		else:
			msg = QMessageBox(self)
			msg.setIcon(QMessageBox.Critical)
			msg.setWindowTitle('Missing Data')
			msg.setText("Please fill out all fields before moving on")
			msg.setStandardButtons(QMessageBox.Ok)
			msg.exec_();
	
	def qualityComplete(self,quality):
		maxTrue = self.isMaximized()
		screen = QGuiApplication.primaryScreen()
		screenSize = screen.availableSize()
		height = screenSize.height()
		maxHeight = height - 50
		rxCheck = quality.ui.qualityReceiverCheck.isChecked()
		txCheck = quality.ui.qualityGeneratorCheck.isChecked()
		if rxCheck and txCheck:
			quality.done(0)
			self.setMinimumSize(1265,maxHeight)
			self.resize(1265,maxHeight)
			self.center()
		else:
			msg = QMessageBox(self)
			msg.setIcon(QMessageBox.Critical)
			msg.setWindowTitle('Missing Data')
			msg.setText("Please fill out all fields before moving on")
			msg.setStandardButtons(QMessageBox.Ok)
			msg.exec_();
			
	def safetyCancel(self,safety):
		safety.done(0)
		menu.tabCounterIncrement(self,"down")
		self.ui.stepTabs.setCurrentIndex(2)
		
	def qualityCancel(self,quality):
		quality.done(0)
		menu.tabCounterIncrement(self,"down")
		self.ui.stepTabs.setCurrentIndex(1)
	
	def closeEvent(self,event):
		reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No,QMessageBox.No)
		if reply == QMessageBox.Yes:
			event.accept()
		else:
			event.ignore()
			
	def toggleCheck(self,state):
		if state:
			self.statusBar().showMessage('Safety Check Enabled',2000)
		else:
			self.statusBar().showMessage('Safety Check Disabled',2000)
		
	def fillParametersMsg(self):
		msg = QMessageBox(self)
		msg.setIcon(QMessageBox.Critical)
		msg.setWindowTitle('Parameters Unset')
		msg.setText("Please fill out the current equipment's parameters before moving on.")
		msg.setStandardButtons(QMessageBox.Ok)
		msg.exec_();
		
	def center(self):
		# get a rectangle specifying main window geometry
		qr = self.frameGeometry()
		# get screen resolution of monitor, get centre point
		cp = QDesktopWidget().availableGeometry().center()
		# set center of window rectangle to cp, size doesn't change
		qr.moveCenter(cp)
		# move top-left point of the application window to top-left point of qr rectangle
		self.move(qr.topLeft())
		
	def toggleOutput(self,button,redButton,greenButton):
		# turn on dc then rf, turn off rf then dc
		# for rf: turn off awg then turn off psg, turn on psg then turn on rf
		firstChecked = self.ui.emergButtonFirst.isChecked()
		secondChecked = self.ui.emergButtonSecond.isChecked()
		p1c1A = self.ui.p1c1Address.text()
		p1c2A = self.ui.p1c2Address.text()
		p1c3A = self.ui.p1c3Address.text()
		p1c4A = self.ui.p1c4Address.text()
		p2c1A = self.ui.p2c1Address.text()
		p2c2A = self.ui.p2c2Address.text()
		p2c3A = self.ui.p2c3Address.text()
		p2c4A = self.ui.p2c4Address.text()
		p3c1A = self.ui.p3c1Address.text()
		p3c2A = self.ui.p3c2Address.text()
		p3c3A = self.ui.p3c3Address.text()
		p3c4A = self.ui.p3c4Address.text()
		addressList = {p1c1A,p1c2A,p1c3A,p1c4A,p2c1A,p2c2A,p2c3A,p2c4A,p3c1A,p3c2A,p3c3A,p3c4A}
		awgType = self.ui.vsgWorkflows.currentIndex()
		awgSet = self.ui.awgSetGeneral.isChecked()
		psgSet = self.ui.psgSet.isChecked()
		
		if button == 1:
			if firstChecked == True:
				if len(addressList) == 1:
					self.statusBar().showMessage("No DC supplies have been set",2000)
					self.ui.emergButtonFirst.setChecked(False)
				for x in addressList:
					if x == "":
						continue
					else:
						supply.Output_Toggle(x,1,nargout=0)
						self.statusBar().showMessage("DC turned ON",2000)
						self.ui.emergButtonFirst.setStyleSheet(redButton)
						self.ui.emergButtonFirst.setText("Turn Off DC")
			else:
				if secondChecked == True:
					msg = QMessageBox(self)
					msg.setIcon(QMessageBox.Critical)
					msg.setWindowTitle('Incorrect Order')
					msg.setText("Please turn off RF before turning off DC")
					msg.setStandardButtons(QMessageBox.Ok)
					msg.exec_();
					self.ui.emergButtonFirst.setChecked(True)
				else:
					for x in addressList:
						if x == "":
							continue
						else:
							supply.Output_Toggle(x,0,nargout=0)
					self.statusBar().showMessage("DC turned OFF",2000)
					self.ui.emergButtonFirst.setStyleSheet(greenButton)
					self.ui.emergButtonFirst.setText("Turn On DC")
		elif button == 2:
			if secondChecked == True:
				if firstChecked == False:
					msg = QMessageBox(self)
					msg.setIcon(QMessageBox.Critical)
					msg.setWindowTitle('Incorrect Order')
					msg.setText("Please turn on DC before turning on RF")
					msg.setStandardButtons(QMessageBox.Ok)
					msg.exec_();
					self.ui.emergButtonSecond.setChecked(False)
				else:
					if awgSet:
						if awgType == 3:
							#turn on psg
							self.statusBar().showMessage("PSG RF turned ON (test)",1500)
							supply.AWG_Output_Toggle(1)
							self.statusBar().showMessage("AWG RF turned ON",1500)
						else:
							supply.AWG_Output_Toggle(1)
							self.statusBar().showMessage("RF turned ON ",2000)
						self.ui.emergButtonSecond.setStyleSheet(redButton)
						self.ui.emergButtonSecond.setText("Turn Off RF")
					else:
						self.statusBar().showMessage("AWG has not been set",2000)
						self.ui.emergButtonSecond.setChecked(False)
			else:
				if awgType == 3:
					supply.AWG_Output_Toggle(0)
					self.statusBar().showMessage("AWG RF turned OFF",1500)
					#turn off psg
					self.statusBar().showMessage("PSG RF turned OFF (test)",1500)
				else:
					supply.AWG_Output_Toggle(0)
					self.statusBar().showMessage("RF turned OFF",2000)
				self.ui.emergButtonSecond.setStyleSheet(greenButton)
				self.ui.emergButtonSecond.setText("Turn On RF")
		elif button == 3:
			if awgType == 3:
				if awgSet:
					supply.AWG_Output_Toggle(0)
				if psgSet:
					#turn off psg
					print("this is filler")
			else:
				if awgSet:
					supply.AWG_Output_Toggle(0)
			if len(addressList) != 1:
				for x in addressList:
					if x == "":
						continue
					else:
						supply.Output_Toggle(x,0,nargout=0)
			
			self.statusBar().showMessage("RF and DC turned OFF (test)",2000)
			self.ui.emergButtonSecond.setStyleSheet(greenButton)
			self.ui.emergButtonSecond.setText("Turn On RF")
			self.ui.emergButtonFirst.setStyleSheet(greenButton)
			self.ui.emergButtonFirst.setText("Turn On DC")	

	# def paintEvent(self,e):
		# qp = QPainter()
		# qp.begin(self)
		# self.drawLines(qp)
		# qp.end()
		
	# def drawLines(self,qp):
		# pen = QPen(QtCore.Qt.black, 2, QtCore.Qt.SolidLine)
		# qp.setPen(pen)
		# qp.drawLine(60,100,70,110)
		
	# void LabelWidget::paintEvent(QPaintEvent*)
	# {
		# QPainter painter(this)
		# painter.setPen(Qt::black);
		# #... Need an appropriate call to painter.translate() for this to work properly
		# painter.rotate(90);
		# painter.drawText(QPoint(0,0), _text);
	# }

if __name__ == '__main__':
	app = QApplication(sys.argv)
	window = Window()
	sys.exit(app.exec_())
	
	
# OLD CODE

#import matlab.engine
#eng = matlab.engine.start_matlab()

# alternative ui file loading method
#uic.loadUi('peprs.ui',self)

# set scroll area contents
#self.ui.vsgEquipScroll.setWidget(self.ui.vsgEquipScrollWidgetContents)

# control dash radio buttons
# disabledButton = "QPushButton {color:grey}"
# self.ui.runStandard.toggled.connect(lambda: flow.standardSetup(self,greyButton))
# self.ui.runVSG.toggled.connect(lambda: flow.vsgOnlySetup(self,disabledButton,greyButton))
# self.ui.runVSA.toggled.connect(lambda: flow.vsaOnlySetup(self,disabledButton,greyButton,greyButton))