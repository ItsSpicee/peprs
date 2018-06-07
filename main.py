import sys
from PyQt5 import uic, QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import (QTabWidget, QFileDialog,QDialog, QInputDialog, QTextEdit, QLineEdit, QLabel, QFrame, QGridLayout, QHBoxLayout, QVBoxLayout, QWidget, QMainWindow, QMenu, QAction, qApp, QDesktopWidget, QMessageBox, QToolTip, QPushButton, QApplication)
from PyQt5.QtGui import (QPen, QPainter, QColor, QIcon, QFont)
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
		purpleLabel = "QLabel{background-color:qlineargradient(spread:pad, x1:1, y1:0.767, x2:1, y2:0, stop:0 rgba(128, 0, 128, 255), stop:1 rgba(182, 0, 182, 255)); border-radius:5px; color:white}"
		blueLabelP = "QLabel {background:qlineargradient(spread:pad, x1:1, y1:1, x2:0.994318, y2:0.267, stop:0 rgba(84, 144, 200, 255), stop:1 rgba(107, 186, 255, 255));color:white;border-radius:10px;border:3px solid purple}"
		blueLabelG = "QLabel {background:qlineargradient(spread:pad, x1:1, y1:1, x2:0.994318, y2:0.267, stop:0 rgba(84, 144, 200, 255), stop:1 rgba(107, 186, 255, 255));color:white;border-radius:10px;border:3px solid #005500}"
		purpleButton = "QPushButton{ background-color:qlineargradient(spread:pad, x1:1, y1:0.767, x2:1, y2:0, stop:0 rgba(128, 0, 128, 255), stop:1 rgba(182, 0, 182, 255)); border-radius:5px; color:white}"	
		
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
		self.resize(500,400)
		
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
		
		# expand/shrink depending on which step tab is clicked
		self.ui.stepTabs.currentChanged.connect(self.changeStepTabWindowSize)
		
		# set scroll area contents
		#self.ui.vsgEquipScroll.setWidget(self.ui.vsgEquipScrollWidgetContents)
		
		# control parameter set buttons
		self.ui.awgSetGeneral.clicked.connect(lambda: self.setGeneralAWG(purpleButton,purpleLabel,blueLabelP,blueLabelG))
		self.ui.vsgSetGeneral.clicked.connect(lambda: self.setGeneralVSG(purpleButton,purpleLabel,blueLabelP))
		self.ui.vsgSetAdv.clicked.connect(self.setAdvancedVSG)
		self.ui.awgSetAdv.clicked.connect(self.setAdvancedAWG)
		
		
		# control workflow navigation
		self.ui.upButton.clicked.connect(self.upOnClick)
		self.ui.psgButton.clicked.connect(self.psgOnClick)
		self.ui.awgButton.clicked.connect(lambda: self.changeStack(self.ui.equipStack,0))
		self.ui.vsaButton.clicked.connect(lambda: self.changeStack(self.ui.equipStack,2))
		self.ui.vsaButton_vsg.clicked.connect(self.vsaOnClick)
		#self.ui.saButton.clicked.connect(self.)
		
		# show on window
		self.show()	
	
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
	
	def upOnClick(self):
		self.ui.equipStack.setCurrentIndex(1) # upconverter/psg page
		self.ui.up_psg_stack.setCurrentIndex(0) # upconverter general settings
		self.ui.up_psg_next.setCurrentIndex(0) # upconverter next 
		self.ui.up_psg_workflow.setCurrentIndex(0) # upconverter workflow
		
	def psgOnClick(self):
		self.ui.equipStack.setCurrentIndex(1) #upconverter/psg page
		self.ui.up_psg_stack.setCurrentIndex(1) # upconverter general settings
		self.ui.up_psg_next.setCurrentIndex(1) # upconverter next 
		self.ui.up_psg_workflow.setCurrentIndex(1) # upconverter workflow
		
	def vsaOnClick(self):
		vsgSetupIdx = self.ui.vsgWorkflows.currentIndex() 
		if vsgSetupIdx == 1 or vsgSetupIdx == 4:
			self.ui.equipStack.setCurrentIndex(2) # vsa page
	
	def setGeneralAWG(self,buttonColourDone,labelColourDone,labelColourStart,labelColourStart2):
		self.ui.fillAWG.setStyleSheet(labelColourDone)
		self.ui.awgWorkflowButton.setStyleSheet(buttonColourDone)
		self.ui.fillAWG_2.setStyleSheet(labelColourDone)
		self.ui.awgWorkflowButton_2.setStyleSheet(buttonColourDone)
		self.ui.fillAWG_3.setStyleSheet(labelColourDone)
		self.ui.awgWorkflowButton_3.setStyleSheet(buttonColourDone)
		self.ui.fillVSA.setStyleSheet(labelColourStart)
		self.ui.fillUp.setStyleSheet(labelColourStart2)
		self.ui.fillPSG.setStyleSheet(labelColourStart2)
		self.ui.statusBar.showMessage('Successfully Set: AWG - General Settings',2000)	
		
	def setGeneralVSG(self, buttonColourDone, labelColourDone, labelColourStart):
		self.ui.vsgWorkflowButton.setStyleSheet(buttonColourDone)
		self.ui.fillVSG.setStyleSheet(labelColourDone)
		self.ui.fillVSA_2.setStyleSheet(labelColourStart)
		self.ui.statusBar.showMessage('Successfully Set: VSG - General Settings',2000)	
		
	def setAdvancedAWG(self):
		self.ui.statusBar.showMessage('Successfully Set: AWG - Advanced Settings',2000)
	
	def setAdvancedVSG(self):
		self.ui.statusBar.showMessage('Successfully Set: VSG - Advanced Settings',2000)
	
	def changeStepTabWindowSize(self,i):
		if i == 0 or i == 1 or i == 2:
			self.resize(1265, 585)
			self.center()
		elif i == 3:
			self.resize(500,400)
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
		if i == 0: # select
			self.ui.vsgEquipStack.setCurrentIndex(2)
			self.ui.vsgEquipStackAdv.setCurrentIndex(2)
			self.ui.vsgNextSteps.setCurrentIndex(0)
			self.ui.vsgWorkflows.setCurrentIndex(0)
		elif i == 1 or i == 2 or i == 3:
			self.ui.vsgEquipStack.setCurrentIndex(0)
			self.ui.vsgEquipStackAdv.setCurrentIndex(0)
			if i == 1: # AWG
				self.ui.vsgNextSteps.setCurrentIndex(1)
				self.ui.vsgWorkflows.setCurrentIndex(1)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(0) # vsa: awg
			if i == 2: # AWG & Up
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.vsgWorkflows.setCurrentIndex(2)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(1) # vsa: awg and up
			if i == 3: # AWG & PSG
				self.ui.vsgNextSteps.setCurrentIndex(3)
				self.ui.vsgWorkflows.setCurrentIndex(3)
				self.ui.vsgWorkflowForVSA.setCurrentIndex(2) # vsa: awg and psg
		elif i == 4: # VSG
			self.ui.vsgEquipStack.setCurrentIndex(1)
			self.ui.vsgEquipStackAdv.setCurrentIndex(1)
			self.ui.vsgNextSteps.setCurrentIndex(4)
			self.ui.vsgWorkflows.setCurrentIndex(4)
			self.ui.vsgWorkflowForVSA.setCurrentIndex(3) # vsa: vsg
			
	def displayVsa(self):
		# 0 = vsaGeneral, 1 = scope, 2 = digitizer, 3 = uxa, 4 = pxa, 5 = dig_demod, 6 = scope_demod, 7 = uxa_demod, 8 = pxa_demod, 9 = down_scope_mod, 10 = down_dig_mod, 11 = down_scope, 12 = down_dig
		vsaIdx = self.ui.vsaType.currentIndex()
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
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(3)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(11)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(12)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
		elif demod == 1:
			self.ui.uxaMod.setEnabled(True)
			self.ui.digMod.setEnabled(True)
			self.ui.scopeMod.setEnabled(True)
			if vsaIdx == 1:
				self.ui.vsaWorkflow.setCurrentIndex(6)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(5)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(7)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(8)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(9)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(10)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
		elif demod == 2:
			self.ui.uxaMod.setEnabled(False)
			self.ui.digMod.setEnabled(False)
			self.ui.scopeMod.setEnabled(False)
			if vsaIdx == 1:
				self.ui.vsaWorkflow.setCurrentIndex(1)
				self.ui.vsaEquipStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 2:
				self.ui.vsaWorkflow.setCurrentIndex(2)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 3:
				self.ui.vsaWorkflow.setCurrentIndex(3)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(1)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(0)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 4:
				self.ui.vsaWorkflow.setCurrentIndex(4)
				self.ui.vsaEquipStack.setCurrentIndex(0)
				self.ui.uxa_pxa_titleStack.setCurrentIndex(0)
				self.ui.vsaAdvancedStack.setCurrentIndex(2)
				self.ui.uxa_pxa_titleStackAdv.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(1)
			elif vsaIdx == 5:
				self.ui.vsaWorkflow.setCurrentIndex(11)
				self.ui.vsaEquipStack.setCurrentIndex(1)	
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
			elif vsaIdx == 6:
				self.ui.vsaWorkflow.setCurrentIndex(12)
				self.ui.vsaEquipStack.setCurrentIndex(2)
				self.ui.vsaAdvancedStack.setCurrentIndex(1)
				self.ui.vsaNextStack.setCurrentIndex(2)
	
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