import sys
from PyQt5 import QtCore, QtGui, QtWidgets, uic
from PyQt5.QtWidgets import (QTabWidget, QFileDialog,QDialog, QInputDialog, QTextEdit, QLineEdit, QLabel, QFrame, QGridLayout, QHBoxLayout, QVBoxLayout, QWidget, QMainWindow, QMenu, QAction, qApp, QDesktopWidget, QMessageBox, QToolTip, QPushButton, QApplication)
from PyQt5.QtGui import (QIcon, QFont)
from PyQt5.QtCore import (pyqtSlot, QSize)
from peprs import Ui_peprs

class Window(QMainWindow):
	def __init__(self):
		super(Window,self).__init__()
		#uic.loadUi('peprs.ui',self)
		self.ui = Ui_peprs()
		self.ui.setupUi(self)
		self.initUI()	
		
	def initUI(self):		
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
		self.ui.vsgEquipStack.setCurrentIndex(2) # please select a layout
		self.ui.vsgEquipStackAdv.setCurrentIndex(2) # please select a layout
		self.ui.vsgNextSteps.setCurrentIndex(0) # fill out vsg
		self.ui.vsgWorkflows.setCurrentIndex(0) # general vsg workflow button
		self.ui.upEquipTabs.setCurrentIndex(0) # upconverter general settings
		
		# VSG setup selected, control stack displays related to it (workflow, next steps, parameters)
		self.ui.vsgSetup.currentIndexChanged.connect(self.displayVsg)
		
		# expand/shrink depending on which step tab is clicked
		self.ui.stepTabs.currentChanged.connect(self.changeStepTabWindowSize)
		
		# set scroll area contents
		#self.ui.vsgEquipScroll.setWidget(self.ui.vsgEquipScrollWidgetContents)
		
		# control parameter set buttons
		self.ui.awgSetGeneral.clicked.connect(self.setColoursAWG)
		self.ui.vsgSetGeneral.clicked.connect(self.setColoursVSG)
		
		# control workflow navigation
		self.ui.upButton.clicked.connect(self.upOnClick)
		self.ui.psgButton.clicked.connect(self.psgOnClick)
		
		# show on window
		self.show()	
		
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
	
	def setColoursAWG(self):
		self.ui.fillAWG.setStyleSheet("QLabel{background-color:purple;color:white;border-radius:10px}")
		self.ui.awgWorkflowButton.setStyleSheet("QPushButton{background-color:purple;color:white;border-radius:5px}")
		self.ui.fillAWG_2.setStyleSheet("QLabel{background-color:purple;color:white;border-radius:10px}")
		self.ui.awgWorkflowButton_2.setStyleSheet("QPushButton{background-color:purple;color:white;border-radius:5px;}")
		self.ui.fillAWG_3.setStyleSheet("QLabel{background-color:purple;color:white;border-radius:10px}")
		self.ui.awgWorkflowButton_3.setStyleSheet("QPushButton{background-color:purple;color:white;border-radius:5px;}")
		
	def setColoursVSG(self):
		self.ui.vsgWorkflowButton.setStyleSheet("QPushButton{background-color:purple;color:white;border-radius:5px}")
		self.ui.fillVSG.setStyleSheet("QLabel{background-color:purple;color:white;border-radius:10px}")
		#005500, green
	
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
				self.ui.fillAWG.setStyleSheet("QLabel{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); color:white; border:3px solid purple; border-radius:10px}")
				self.ui.awgWorkflowButton.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); border:3px solid purple; border-radius: 5px; color:white;}")
			if i == 2: # AWG & Up
				self.ui.vsgNextSteps.setCurrentIndex(2)
				self.ui.vsgWorkflows.setCurrentIndex(2)
				self.ui.fillAWG_2.setStyleSheet("QLabel{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); color:white; border:3px solid purple; border-radius:10px}")
				self.ui.awgWorkflowButton_2.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); border:3px solid purple; border-radius: 5px; color:white;}")
			if i == 3: # AWG & PSG
				self.ui.vsgNextSteps.setCurrentIndex(3)
				self.ui.vsgWorkflows.setCurrentIndex(3)
				self.ui.fillAWG_3.setStyleSheet("QLabel{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); color:white; border:3px solid purple; border-radius:10px}")
				self.ui.awgWorkflowButton_3.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); border:3px solid purple; border-radius: 5px; color:white;}")
		elif i == 4: # VSG
			self.ui.vsgEquipStack.setCurrentIndex(1)
			self.ui.vsgEquipStackAdv.setCurrentIndex(1)
			self.ui.vsgNextSteps.setCurrentIndex(4)
			self.ui.vsgWorkflows.setCurrentIndex(4)
			self.ui.fillVSG.setStyleSheet("QLabel{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); color:white; border:3px solid purple; border-radius:10px}")
			self.ui.vsgWorkflowButton.setStyleSheet("QPushButton{background-color:qlineargradient(spread:pad, x1:1, y1:1, x2:1, y2:0.21, stop:0 rgba(90, 154, 215, 255), stop:1 rgba(107, 186, 255, 255)); border:3px solid purple; border-radius: 5px; color:white;}")
	
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