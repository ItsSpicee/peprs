import sys
from PyQt5 import uic, QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import (QMessageBox, QTabWidget, QFileDialog,QDialog, QInputDialog, QTextEdit, QLineEdit, QLabel, QFrame, QGridLayout, QHBoxLayout, QVBoxLayout, QWidget, QMainWindow, QMenu, QAction, qApp, QDesktopWidget, QMessageBox, QToolTip, QPushButton, QApplication)
from PyQt5.QtGui import (QCursor, QPen, QPainter, QColor, QIcon, QFont)
from PyQt5.QtCore import (Qt, pyqtSlot, QSize)

from peprs import Ui_peprs

class Window(QMainWindow):
	def __init__(self):
		super(Window,self).__init__()
		#uic.loadUi('peprs.ui',self)
		self.ui = Ui_peprs()
		self.ui.setupUi(self)
		self.initUI()	
		
	def initUI(self):		
		# variables
		purpleButton = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:0.511, x2:1, y2:0, stop:0 rgba(128, 0, 128, 255), stop:1 rgba(154, 0, 154, 255)); border-radius:5px; color:white}"	
		greenButton = "QPushButton{ border:3px dashed #005500;  background-color:qlineargradient(spread:pad, x1:1, y1:0.83, x2:1, y2:0, stop:0 rgba(0, 85, 0, 255), stop:1 rgba(0, 126, 0, 255)); border-radius:5px;color:white}"
		setParams = "QGroupBox{background-color:rgb(247, 247, 247); border:3px solid #515a70}"
		unsetParams = "QGroupBox{background-color:rgb(247, 247, 247)}"
		greyBButton = "QPushButton {border:3px solid rgb(0, 0, 127); background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		greyPButton = "QPushButton{border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		disabledButton = "QPushButton {color:grey}"
		
		# set menu bar actions
		self.ui.actionOpen.triggered.connect(self.openDialog)
		self.ui.actionSave.triggered.connect(self.saveDialog)
		self.ui.actionQuit.triggered.connect(self.closeButton)	
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
		
		# VSG and VSA dropdown changes
		self.ui.vsgSetup.currentIndexChanged.connect(self.displayVsg)
		self.ui.vsaType.currentIndexChanged.connect(self.displayVsa)
		self.ui.demodulationEnable.currentIndexChanged.connect(self.displayVsa)
		self.ui.averagingEnable.currentIndexChanged.connect(self.displayVsa)
		
		# expand/shrink depending on which step tab is clicked
		self.ui.stepTabs.currentChanged.connect(self.changeStepTabWindowSize)
		
		# set scroll area contents
		#self.ui.vsgEquipScroll.setWidget(self.ui.vsgEquipScrollWidgetContents)
		
		# control parameter set buttons
		self.ui.awgSetGeneral.clicked.connect(lambda: self.setGeneralAWG(purpleButton, setParams))
		self.ui.vsgSetGeneral.clicked.connect(lambda: self.setGeneralVSG(purpleButton,setParams))
		self.ui.vsgSetAdv.clicked.connect(lambda: self.setAdvancedVSG(setParams))
		self.ui.awgSetAdv.clicked.connect(lambda: self.setAdvancedAWG(setParams))
		self.ui.upSet.clicked.connect(lambda: self.setUp(greenButton, setParams))
		self.ui.psgSet.clicked.connect(lambda: self.setPSG(greenButton, setParams))
		self.ui.uxaSet.clicked.connect(lambda: self.setUXA(purpleButton,greenButton,setParams))
		self.ui.scopeSet.clicked.connect(lambda: self.setScope(purpleButton,greenButton,setParams))
		self.ui.digSet.clicked.connect(lambda: self.setDig(purpleButton,greenButton,setParams))
		
		# control dash radio buttons
		self.ui.runVSG.toggled.connect(lambda: self.vsgOnlySetup(disabledButton,greyPButton))
		self.ui.runVSA.toggled.connect(lambda: self.vsaOnlySetup(disabledButton,greyBButton,greyPButton))
		
		# control workflow navigation
		self.ui.upButton_vsg.clicked.connect(self.upOnClick)
		self.ui.psgButton_vsg.clicked.connect(self.psgOnClick)
		self.ui.awgButton.clicked.connect(self.awgOnClick)
		self.ui.vsaButton.clicked.connect(lambda: self.changeStack(self.ui.equipStack,2))
		self.ui.vsaButton_vsg.clicked.connect(self.vsaOnClick)
		self.ui.vsgButton_vsa.clicked.connect(lambda: self.changeStack(self.ui.equipStack,0))
		self.ui.awgButton_vsa.clicked.connect(lambda: self.changeStack(self.ui.equipStack,0))
		
		# show on window
		self.show()	
		
	
	# FINISH THIS
	def copyDemod(self,changedModField):
		value = changedModField.toPlainText()
		.setPlainText(value)
		
	# IF GROUPBOX VALUE CHANGED, NO LONGER GREY BOX
	
	def setUXA(self,buttonDoneP,buttonDoneG,boxDone):
		type = self.ui.vsaType.currentIndex()
		if type == 3: #UXA
			averaging = self.ui.averagingEnable.currentIndex()
			demod = self.ui.demodulationEnable.currentIndex()
			if averaging != 0 and demod != 0:
				self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
				demod = self.ui.uxaMod.isEnabled()
				if demod:
					self.ui.digMod.setStyleSheet(boxDone)
					self.ui.scopeMod.setStyleSheet(boxDone)
					self.ui.uxaMod.setStyleSheet(boxDone)
					self.ui.modButton_vsa.setStyleSheet(buttonDoneG)
				self.ui.uxaButton_vsa.setStyleSheet(buttonDoneP)
				self.ui.uxaButton_vsa_2.setStyleSheet(buttonDoneP)
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.fillParametersMsg()
		elif type == 4: #PXA	
			averaging = self.ui.averagingEnable.currentIndex()
			demod = self.ui.demodulationEnable.currentIndex()
			if averaging != 0 and demod != 0:
				self.ui.uxaEquipGeneralVSA.setStyleSheet(boxDone)
				demod = self.ui.uxaMod.isEnabled()
				if demod:
					self.ui.uxaMod.setStyleSheet(boxDone)
					self.ui.digMod.setStyleSheet(boxDone)
					self.ui.scopeMod.setStyleSheet(boxDone)
					self.ui.modButton_vsa.setStyleSheet(buttonDoneG)
				self.ui.pxaButton_vsa.setStyleSheet(buttonDoneP)
				self.ui.pxaButton_vsa_2.setStyleSheet(buttonDoneP)
				self.ui.vsaNextStack.setCurrentIndex(3)
			else:
				self.fillParametersMsg()
	
	def setScope(self,buttonDoneP,buttonDoneG,boxDone):
		averaging = self.ui.averagingEnable.currentIndex()
		demod = self.ui.demodulationEnable.currentIndex()
		if averaging != 0 and demod != 0:
			self.ui.scopeEquipGeneral.setStyleSheet(boxDone)
			demod = self.ui.scopeMod.isEnabled()
			if demod:
				self.ui.scopeMod.setStyleSheet(boxDone)
				self.ui.uxaMod.setStyleSheet(boxDone)
				self.ui.digMod.setStyleSheet(boxDone)
				self.ui.modButton_vsa_2.setStyleSheet(buttonDoneG)
				self.ui.modButton_vsa.setStyleSheet(buttonDoneG)
			self.ui.scopeButton_vsa.setStyleSheet(buttonDoneP)
			self.ui.scopeButton_vsa_2.setStyleSheet(buttonDoneP)
			self.ui.scopeButton_vsa_3.setStyleSheet(buttonDoneP)
			self.ui.scopeButton_vsa_4.setStyleSheet(buttonDoneP)
			#self.ui.vsaNextStack.setCurrentIndex(3)
		else:
			self.fillParametersMsg()
			
	def setDig(self,buttonDoneP,buttonDoneG,boxDone):
		averaging = self.ui.averagingEnable.currentIndex()
		demod = self.ui.demodulationEnable.currentIndex()
		if averaging != 0 and demod != 0:
			self.ui.digEquipGeneral.setStyleSheet(boxDone)
			demod = self.ui.digMod.isEnabled()
			if demod:
				self.ui.digMod.setStyleSheet(boxDone)
				self.ui.scopeMod.setStyleSheet(boxDone)
				self.ui.uxaMod.setStyleSheet(boxDone)
				self.ui.modButton_vsa_2.setStyleSheet(buttonDoneG)
				self.ui.modButton_vsa.setStyleSheet(buttonDoneG)
			self.ui.digButton_vsa.setStyleSheet(buttonDoneP)
			self.ui.digButton_vsa_2.setStyleSheet(buttonDoneP)
			self.ui.digButton_vsa_3.setStyleSheet(buttonDoneP)
			self.ui.digButton_vsa_4.setStyleSheet(buttonDoneP)
			#self.ui.vsaNextStack.setCurrentIndex(3)
		else:
			self.fillParametersMsg()
	
	# def paintEvent(self,e):
		# qp = QPainter()
		# qp.begin(self)
		# self.drawLines(qp)
		# qp.end()
		
	# def drawLines(self,qp):
		# pen = QPen(QtCore.Qt.black, 2, QtCore.Qt.SolidLine)
		# qp.setPen(pen)
		# qp.drawLine(60,100,70,110)
	
	def changeStack(self,stackName,idx):
		stackName.setCurrentIndex(idx)
	
	def vsgOnlySetup(self,greyButton,purpleButton):
		self.ui.vsgDash.setStyleSheet(purpleButton)
		self.ui.meterDash.setStyleSheet(greyButton)
		self.ui.vsaDash.setStyleSheet(greyButton)
		self.ui.saDash.setStyleSheet(greyButton)
		
	def vsaOnlySetup(self,greyButton,purpleButton,blueButton):
		self.ui.vsgDash.setStyleSheet(greyButton)
		self.ui.meterDash.setStyleSheet(blueButton)
		self.ui.vsaDash.setStyleSheet(purpleButton)
		self.ui.saDash.setStyleSheet(purpleButton)
	
	def awgOnClick(self):
		purpleHover = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		purpleBox = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		self.ui.equipStack.setCurrentIndex(0)
		upChecked = self.ui.upSet.isChecked()
		psgChecked = self.ui.psgSet.isChecked()
		if upChecked or psgChecked:
			self.ui.vsaButton_vsg.setStyleSheet(purpleHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
		else:
			self.ui.vsaButton_vsg.setStyleSheet(purpleBox)
	
	def upOnClick(self):
		awgSet = self.ui.awgSetGeneral.isChecked()
		if awgSet:
			self.ui.equipStack.setCurrentIndex(1) # upconverter/psg page
			self.ui.up_psg_stack.setCurrentIndex(0) # upconverter general settings
			self.ui.up_psg_next.setCurrentIndex(0) # upconverter next 
			self.ui.up_psg_workflow.setCurrentIndex(0) # upconverter workflow
		else:
			self.fillParametersMsg()
		
	def psgOnClick(self):
		awgSet = self.ui.awgSetGeneral.isChecked()
		if awgSet:
			self.ui.equipStack.setCurrentIndex(1) #upconverter/psg page
			self.ui.up_psg_stack.setCurrentIndex(1) # upconverter general settings
			self.ui.up_psg_next.setCurrentIndex(1) # upconverter next 
			self.ui.up_psg_workflow.setCurrentIndex(1) # upconverter workflow
		else:
			self.fillParametersMsg()
		
	def fillParametersMsg(self):
		msg = QMessageBox(self)
		msg.setIcon(QMessageBox.Critical)
		msg.setWindowTitle('Parameters Unset')
		msg.setText("Please fill out the current equipment's parameters before moving on.")
		msg.setStandardButtons(QMessageBox.Ok)
		msg.exec_();
	
	def vsaOnClick(self):
		awgChecked = self.ui.awgSetGeneral.isChecked()
		vsgChecked = self.ui.vsgSetGeneral.isChecked()
		upChecked = self.ui.upSet.isChecked()
		psgChecked = self.ui.psgSet.isChecked()
		vsgSetupIdx = self.ui.vsgWorkflows.currentIndex() 
		if vsgSetupIdx == 1:
			if awgChecked:
				self.ui.equipStack.setCurrentIndex(2)
			else:
				self.fillParametersMsg()
		elif vsgSetupIdx == 4:
			if vsgChecked:
				self.ui.equipStack.setCurrentIndex(2)
			else:
				self.fillParametersMsg()
		elif vsgSetupIdx == 2:
			if upChecked:
				self.ui.equipStack.setCurrentIndex(2)
		elif vsgSetupIdx == 3:
			if psgChecked:
				self.ui.equipStack.setCurrentIndex(2)
	
	def setUp(self,buttonColourDone,boxDone):
		self.ui.upButton_up.setStyleSheet(buttonColourDone)
		self.ui.upButton_vsg.setStyleSheet(buttonColourDone)
		self.ui.upEquip.setStyleSheet(boxDone)
		self.ui.up_psg_next.setCurrentIndex(2)
	
	def setPSG(self, buttonColourDone, boxDone):
		self.ui.psgButton_psg.setStyleSheet(buttonColourDone)
		self.ui.psgButton_vsg.setStyleSheet(buttonColourDone)
		self.ui.psgEquip.setStyleSheet(boxDone)
		self.ui.up_psg_next.setCurrentIndex(2)
		
	def setGeneralAWG(self,buttonColourDone, boxDone):
		self.ui.awgWorkflowButton.setStyleSheet(buttonColourDone)
		self.ui.awgWorkflowButton_2.setStyleSheet(buttonColourDone)
		self.ui.awgWorkflowButton_3.setStyleSheet(buttonColourDone)
		self.ui.statusBar.showMessage('Successfully Set: AWG - General Settings',2000)
		self.ui.awgEquipGeneral.setStyleSheet(boxDone)
		setupIdx = self.ui.vsgWorkflows.currentIndex()
		if setupIdx == 1:
			self.ui.vsgNextSteps.setCurrentIndex(5)
		elif setupIdx == 2:
			self.ui.vsgNextSteps.setCurrentIndex(2)
		elif setupIdx == 3:
			self.ui.vsgNextSteps.setCurrentIndex(3)
		
	def setGeneralVSG(self, buttonColourDone, boxDone):
		self.ui.vsgWorkflowButton.setStyleSheet(buttonColourDone)
		self.ui.vsgEquipGeneral.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set: VSG - General Settings',2000)	
		self.ui.vsgNextSteps.setCurrentIndex(5)
		
	def setAdvancedAWG(self, boxDone):
		self.ui.awgEquipAdv.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set: AWG - Advanced Settings',2000)
	
	def setAdvancedVSG(self, boxDone):
		self.ui.vsgEquipAdv.setStyleSheet(boxDone)
		self.ui.statusBar.showMessage('Successfully Set: VSG - Advanced Settings',2000)
	
	def changeStepTabWindowSize(self,i):
		if i == 0 or i == 1 or i == 2:
			self.setMinimumSize(1265,585)
			self.resize(1265, 585)
			self.center()
		elif i == 3:
			self.setMinimumSize(700,550)
			self.resize(700,550)
			self.center()
		
	def center(self):
		# get a rectangle specifying main window geometry
		qr = self.frameGeometry()
		# get screen resolution of monitor, get centre point
		cp = QDesktopWidget().availableGeometry().center()
		# set center of window rectangle to cp, size doesn't change
		qr.moveCenter(cp)
		# move top-left point of the application window to top-left point of qr rectangle
		self.move(qr.topLeft())
	
	def displayVsg(self,i):
		awgChecked = self.ui.awgSetGeneral.isChecked()
		vsgChecked = self.ui.vsgSetGeneral.isChecked()
		purpleBox = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;}"
		purpleHover = "QPushButton{ border:3px solid purple;  background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0, stop:0 rgba(209, 209, 209, 255), stop:1 rgba(254, 254, 254, 255)); border-radius:5px; color:black;} QPushButton:hover{background-color:rgb(243, 243, 243);}"
		if i == 0: # select
			self.ui.vsgEquipStack.setCurrentIndex(2)
			self.ui.vsgEquipStackAdv.setCurrentIndex(2)
			self.ui.vsgNextSteps.setCurrentIndex(0)
			self.ui.vsgWorkflows.setCurrentIndex(0)
			self.ui.vsaButton_vsg.setStyleSheet(purpleBox)
			self.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
		elif i == 1 or i == 2 or i == 3:
			self.ui.vsgEquipStack.setCurrentIndex(0)
			self.ui.vsgEquipStackAdv.setCurrentIndex(0)
			if i == 1: # AWG
				self.ui.vsgWorkflows.setCurrentIndex(1)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(0) # vsa: awg
				self.ui.vsaButton_vsg.setStyleSheet(purpleHover) # make vsa change colour on hover
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor)) # make cursor pointer over vsa
				if awgChecked:
					self.ui.vsgNextSteps.setCurrentIndex(5)
				else:
					self.ui.vsgNextSteps.setCurrentIndex(1)	
			if i == 2: # AWG & Up
				self.ui.vsgWorkflows.setCurrentIndex(2)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(1) # vsa: awg and up
				
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
				if awgChecked:
					self.ui.vsgNextSteps.setCurrentIndex(2)
				else:
					self.ui.vsgNextSteps.setCurrentIndex(1)
			if i == 3: # AWG & PSG
				self.ui.vsgWorkflows.setCurrentIndex(3)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(2) # vsa: awg and psg
				self.ui.vsaButton_vsg.setStyleSheet(purpleBox)
				self.ui.vsaButton_vsg.setCursor(QCursor(Qt.ArrowCursor))
				if awgChecked:
					self.ui.vsgNextSteps.setCurrentIndex(3)
				else:
					self.ui.vsgNextSteps.setCurrentIndex(1)
		elif i == 4: # VSG
			self.ui.vsgEquipStack.setCurrentIndex(1)
			self.ui.vsgEquipStackAdv.setCurrentIndex(1)
			self.ui.vsgNextSteps.setCurrentIndex(4)
			self.ui.vsgWorkflows.setCurrentIndex(4)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(3) # vsa: vsg
			self.ui.vsaButton_vsg.setStyleSheet(purpleHover)
			self.ui.vsaButton_vsg.setCursor(QCursor(Qt.PointingHandCursor))
			if vsgChecked:
				self.ui.vsgNextSteps.setCurrentIndex(5)
			else:
				self.ui.vsgNextSteps.setCurrentIndex(4)
			
	def displayVsa(self):
		vsaIdx = self.ui.vsaType.currentIndex()
		averaging = self.ui.averagingEnable.currentIndex()
		demod = self.ui.demodulationEnable.currentIndex()
		
		if vsaIdx == 0:
			self.ui.vsaWorkflow.setCurrentIndex(0)
			self.ui.vsaEquipStack.setCurrentIndex(3)
			self.ui.vsaAdvancedStack.setCurrentIndex(0)
			self.ui.vsaNextStack.setCurrentIndex(0)
		elif demod == 0:
			self.ui.uxaMod.setEnabled(False)
			self.ui.digMod.setEnabled(False)
			self.ui.scopeMod.setEnabled(False)
			if vsaIdx == 1:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)				
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(2)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(3)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.single_down_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.single_down_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif demod == 1:
			self.ui.uxaMod.setEnabled(True)
			self.ui.digMod.setEnabled(True)
			self.ui.scopeMod.setEnabled(True)
			if averaging != 0:
				self.ui.vsaNextStack.setCurrentIndex(1)
			if vsaIdx == 1:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.single_mod_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.single_mod_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.single_mod_vsa_stack.setCurrentIndex(2)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.single_mod_vsa_stack.setCurrentIndex(3)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(3)
				self.ui.single_mod_down_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(3)
				self.ui.single_mod_down_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
		elif demod == 2:
			self.ui.uxaMod.setEnabled(False)
			self.ui.digMod.setEnabled(False)
			self.ui.scopeMod.setEnabled(False)
			if averaging != 0:
				self.ui.vsaNextStack.setCurrentIndex(1)
			if vsaIdx == 1:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(2)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.single_vsa_stack.setCurrentIndex(3)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.single_down_vsa_stack.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(1)	
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.single_down_vsa_stack.setCurrentIndex(0)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
	
	def closeEvent(self,event):
		reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No,QMessageBox.No)
		if reply == QMessageBox.Yes:
			event.accept()
		else:
			event.ignore()
		
	def openDialog(self):
		fname = QFileDialog.getOpenFileName(self, 'Open file', '/home')
		if fname[0]:
			f = open(fname[0], 'r')
			with f:
				data = f.read()
				self.textEdit.setText(data)
	
	def saveDialog(self):
		name=QFileDialog.getSaveFileName(self,'Save File')
		file = open(name,'w')
		text = self.textEdit.toPlainText()
		file.write(text)
		file.close()
	
	def toggleCheck(self,state):
		if state:
			self.statusBar().showMessage('Safety Check Enabled',2000)
		else:
			self.statusBar().showMessage('Safety Check Disabled',2000)	
			
	def closeButton(self):
		reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No,QMessageBox.No)
		if reply == QMessageBox.Yes:
			qApp.quit()	

if __name__ == '__main__':
	app = QApplication(sys.argv)
	window = Window()
	sys.exit(app.exec_())