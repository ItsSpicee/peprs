# windowFunctions.py contains all the functions that are needed to control the window size, display, and menu functionality

from PyQt5.QtWidgets import (QMessageBox, QFileDialog, qApp)
	
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
		
def closeButton(self):
	reply=QMessageBox.question(self,'Exit Confirmation',"Are you sure you want to close the program?",QMessageBox.Yes|QMessageBox.No,QMessageBox.No)
	if reply == QMessageBox.Yes:
		qApp.quit()	
		
def changeStepTab(self):
	i = self.ui.stepTabs.currentIndex()
	if i == 2:
		self.setMinimumSize(1265,585)
		self.resize(1265, 585)
		self.center()
	elif i == 1:
		self.setMinimumSize(1265,528)
		self.resize(1265,528)
		self.center()
	elif i == 0:
		self.setMinimumSize(1265,950)
		self.resize(1265,950)
		self.center()
	elif i == 3:
		self.setMinimumSize(700,550)
		self.resize(700,550)
		self.center()
	
def switchMeasTab(self):
	currentTab = self.ui.vsaMeasParamTabs.currentIndex()
	if currentTab == 0 or currentTab == 2:
		self.setMinimumSize(1265,528)
		self.resize(1265,528)
		self.center()
		self.ui.calAdviceText.setVisible(False)
	elif currentTab == 1:
		self.setMinimumSize(1265,950)
		self.resize(1265,950)
		self.center()
		self.ui.calAdviceText.setVisible(True)

def switchAlgoTab(self):
	currentTab = self.ui.algoTabs.currentIndex()
	if currentTab == 2:
		self.ui.rfButton.setVisible(True)
	else:
		self.ui.rfButton.setVisible(False)