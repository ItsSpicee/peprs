# contains callbacks to ui components and a few miscellaneous functions that function better in main.py (e.g. rely on event, used by multiple files. rely on parameter from signal)

import sys
from PyQt5 import uic, QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import (QMessageBox, QTabWidget, QFileDialog,QDialog, QInputDialog, QTextEdit, QLineEdit, QLabel, QFrame, QGridLayout, QHBoxLayout, QVBoxLayout, QWidget, QMainWindow, QMenu, QAction, qApp, QDesktopWidget, QMessageBox, QToolTip, QPushButton, QApplication, QProgressBar)
from PyQt5.QtGui import (QCursor, QPen, QPainter, QColor, QIcon, QFont)
from PyQt5.QtCore import (Qt, pyqtSlot, QSize)

from peprs import Ui_peprs
import setParameters as set
import workflowNav as flow
import windowFunctions as menu
import parameterFunctions as param

class Window(QMainWindow):
	def __init__(self):
		super(Window,self).__init__()
		self.ui = Ui_peprs()
		self.ui.setupUi(self)
		self.initUI()	
		
	def initUI(self):		
		# styling variables
		purpleButton = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:0.511, x2:1, y2:0, stop:0 rgba(128, 0, 128, 255), stop:1 rgba(154, 0, 154, 255)); border-radius:5px; color:white;}"	
		greenButton = "QPushButton{ border:3px dashed #005500;  background-color:qlineargradient(spread:pad, x1:1, y1:0.83, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 126, 0, 255)); border-radius:5px;color:white;}"
		setParams = "QGroupBox{background-color:rgb(247, 247, 247); border:3px solid #515a70}"
		unsetParams = "QGroupBox{background-color:rgb(247, 247, 247)}"
		greyBButton = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		greyPButton = "QPushButton{border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		disabledButton = "QPushButton {color:grey}"
		greyBHover = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		greyGHover = "QPushButton {border:3px dashed #005500; background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		greyPHover = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		greyBox = "QGroupBox{background-color:rgb(247, 247, 247);}"
		
		# set menu bar actions
		self.ui.actionOpen.triggered.connect(lambda: menu.openDialog(self))
		self.ui.actionSave.triggered.connect(lambda: menu.saveDialog(self))
		self.ui.actionQuit.triggered.connect(lambda: menu.closeButton(self))	
		self.ui.actionEnable_Safety_Check.triggered.connect(self.toggleCheck)
		
		# set window details
		self.setWindowTitle('PEPRS - Performance Enhancement for Processing Radio Signals')
		pepper_icon = QtGui.QIcon()
		pepper_icon.addFile('icons/pepper 24x24.png', QtCore.QSize(24,24))
		self.setWindowIcon(pepper_icon)
		self.ui.statusBar.showMessage('Ready',2000)	
		self.setMinimumSize(700,550)
		self.resize(700,550)
		
		# set appropriate pages in stacks
		self.ui.stepTabs.setCurrentIndex(3) # dashboard
		self.ui.equipStack.setCurrentIndex(0) # vsg settings page
		self.ui.vsgEquipTabs.setCurrentIndex(0) # vsg general settings
		self.ui.vsgEquipStack.setCurrentIndex(2) # please select a layout
		self.ui.vsgEquipStackAdv.setCurrentIndex(2) # please select a layout
		self.ui.vsgNextSteps.setCurrentIndex(0) # fill out vsg
		self.ui.vsgWorkflows.setCurrentIndex(0) # general vsg workflow button
		self.ui.upEquipTabs.setCurrentIndex(0) # upconverter general settings
		self.ui.vsaWorkflow.setCurrentIndex(0) # vsa general workflow button
		self.ui.vsaEquipTabs.setCurrentIndex(0) # vsa general settings tab
		self.ui.vsaEquipStack.setCurrentIndex(3) # vsa select setup page
		self.ui.vsaAdvancedStack.setCurrentIndex(0) # select vsa type
		self.ui.vsaNextStack.setCurrentIndex(0) # vsa next
		
		# VSG and VSA dropdown changes
		self.ui.vsgSetup.currentIndexChanged.connect(lambda: param.displayVsg(self))
		self.ui.vsaType.currentIndexChanged.connect(lambda: param.displayVsa(self,greyBox))
		self.ui.demodulationEnable.currentIndexChanged.connect(lambda: param.displayVsa(self,greyBox))
		self.ui.averagingEnable.currentIndexChanged.connect(lambda: param.displayVsa(self,greyBox))
		
		# expand/shrink depending on which step tab is clicked
		self.ui.stepTabs.currentChanged.connect(lambda: menu.changeStepTabWindowSize(self))
		
		# control parameter set buttons
		self.ui.awgSetGeneral.clicked.connect(lambda: set.setGeneralAWG(self,purpleButton, setParams))
		self.ui.vsgSetGeneral.clicked.connect(lambda: set.setGeneralVSG(self,purpleButton,setParams))
		self.ui.vsgSetAdv.clicked.connect(lambda: set.setAdvanced(self,self.ui.vsgEquipAdv,setParams))
		self.ui.awgSetAdv.clicked.connect(lambda: set.setAdvanced(self,self.ui.awgEquipAdv,setParams))
		self.ui.upSet.clicked.connect(lambda: set.setUp(self,greenButton, setParams))
		self.ui.psgSet.clicked.connect(lambda: set.setPSG(self,greenButton, setParams))
		self.ui.uxaSet.clicked.connect(lambda: set.setVSA(self,purpleButton,greenButton,setParams,greyBHover, greyGHover))
		self.ui.pxaSet.clicked.connect(lambda: set.setVSA(self,purpleButton,greenButton,setParams,greyBHover, greyGHover))
		self.ui.scopeSet.clicked.connect(lambda: set.setVSA(self,purpleButton,greenButton,setParams,blueHover, greenHover))
		self.ui.digSet.clicked.connect(lambda: set.setVSA(self,purpleButton,greenButton,setParams,greyBHover, greyGHover))
		self.ui.set_run_vsa.clicked.connect(lambda: set.rxCalRoutine(self))
		
		# control dash radio buttons
		self.ui.runVSG.toggled.connect(lambda: flow.vsgOnlySetup(self,disabledButton,greyPButton))
		self.ui.runVSA.toggled.connect(lambda: flow.vsaOnlySetup(self,disabledButton,greyBButton,greyPButton))
		
		# control workflow navigation
		self.ui.upButton_vsg.clicked.connect(lambda: flow.upOnClick(self))
		self.ui.psgButton_vsg.clicked.connect(lambda: flow.psgOnClick(self))
		self.ui.awgButton.clicked.connect(lambda: flow.awgOnClick(self,greyPButton,greyPHover))
		self.ui.vsaButton.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,2))
		self.ui.vsaButton_vsg.clicked.connect(lambda: flow.vsaOnClick(self))
		self.ui.vsgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.awgButton_vsa_3.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,0))
		self.ui.upButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack ,1))
		self.ui.psgButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,1))
		self.ui.meterButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,4))
		self.ui.downButton_vsa.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		self.ui.downButton_vsa_2.clicked.connect(lambda: flow.changeStack(self,self.ui.equipStack,3))
		
		# control parameter changes
		self.ui.dllFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_scope, self.ui.dllFile_uxa, self.ui.dllFile_dig))
		self.ui.setupFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_scope,self.ui.setupFile_uxa,self.ui.setupFile_dig))
		self.ui.dataFile_scope.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_scope,self.ui.dataFile_uxa,self.ui.dataFile_dig))
		
		self.ui.dllFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_uxa, self.ui.dllFile_scope, self.ui.dllFile_dig))
		self.ui.setupFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_uxa,self.ui.setupFile_scope,self.ui.setupFile_dig))
		self.ui.dataFile_uxa.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_uxa,self.ui.dataFile_scope,self.ui.dataFile_dig))
		
		self.ui.dllFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.dllFile_dig, self.ui.dllFile_scope, self.ui.dllFile_uxa))
		self.ui.setupFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.setupFile_dig,self.ui.setupFile_scope,self.ui.setupFile_uxa))
		self.ui.dataFile_dig.textChanged.connect(lambda: param.copyDemod(self, self.ui.dataFile_dig,self.ui.dataFile_scope,self.ui.dataFile_uxa))
		
		# show on window
		self.show()	
	
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
	
	# def paintEvent(self,e):
		# qp = QPainter()
		# qp.begin(self)
		# self.drawLines(qp)
		# qp.end()
		
	# def drawLines(self,qp):
		# pen = QPen(QtCore.Qt.black, 2, QtCore.Qt.SolidLine)
		# qp.setPen(pen)
		# qp.drawLine(60,100,70,110)

if __name__ == '__main__':
	app = QApplication(sys.argv)
	window = Window()
	sys.exit(app.exec_())
	
	
# OLD CODE

# alternative ui file loading method
#uic.loadUi('peprs.ui',self)

# set scroll area contents
#self.ui.vsgEquipScroll.setWidget(self.ui.vsgEquipScrollWidgetContents)