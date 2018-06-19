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
	measTab = self.ui.vsaMeasParamTabs.currentIndex()
	if i == 2:
		self.setMinimumSize(1265,585)
		self.resize(1265, 585)
		self.center()
	elif i == 1:
		if measTab == 1:
			self.setMinimumSize(1265,950)
			self.resize(1265,950)
			self.center()
		else:
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
	vsaChecked = self.ui.vsaMeasSet.isChecked()
	vsaChecked_2 = self.ui.vsaMeasSet_2.isChecked()
	vsaDownChecked = self.ui.downSetVSAMeas.isChecked()
	vsaDownRunChecked = self.ui.set_run_vsa.isChecked()
	downStack = self.ui.downStack_vsaMeas.currentIndex()
	vsgType = self.ui.vsgWorkflow_vsaMeas.currentIndex()
	if currentTab == 0 or currentTab == 2:
		self.setMinimumSize(1265,528)
		self.resize(1265,528)
		self.center()
		self.ui.calAdviceText.setVisible(False)
	elif currentTab == 1:
		if downStack == 1:
			self.setMinimumSize(1265,950)
			self.resize(1265,950)
			self.center()
			self.ui.calAdviceText.setVisible(True)
			if vsaDownChecked == False or vsaDownRunChecked == False:
				if vsaChecked or vsaChecked_2:
					self.ui.vsaMeasNextStack.setCurrentIndex(2)
		else:
			self.setMinimumSize(1265,528)
			self.resize(1265,528)
			self.center()
			self.ui.calAdviceText.setVisible(False)
			if vsgType == 3: # vsg
				self.ui.vsaMeasNextStack.setCurrentIndex(6)
			else:
				self.ui.vsaMeasNextStack.setCurrentIndex(5)

def switchAlgoTab(self):
	currentTab = self.ui.algoTabs.currentIndex()
	if currentTab == 2:
		self.ui.rfButton.setVisible(True)
	else:
		self.ui.rfButton.setVisible(False)